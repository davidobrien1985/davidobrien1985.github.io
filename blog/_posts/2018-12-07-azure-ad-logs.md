---
title: Azure AD Logs in Log Analytics - lots of flaws
date: 2018-12-20T12:01:30
layout: single
permalink: /2018/12/azure-ad-api-logs-flaws
categories:
  - Azure
  - Microsoft
  - Active Directory
tags:
  - azure
  - cloud
  - devops
  - automation
---

If you haven't heard, Azure Active Directory (AAD) can now route logs to places like Storage Accounts, Event Hubs and Azure Log Analytics.<br>
Right now this is [still in preview](https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics), but in my experience it works very well, except for one flaw! The only way to configure this feature is via the Azure Portal. :-( <br>
Not necessarily the end of the world, as you will likely only be doing this once per tenant (Azure Active Directory), but I definitely prefer to have everything documented in code.<br> 
Especially if you are a consultant and are being asked to build lots of Azure environments for different customers, yes, you need to automate your work!

## PowerShell and Azure API

Unfortunately, at this time, there is no PowerShell or other CLI command that I could find that will configure AAD diagnostic settings. However, that doesn't mean we can't automate it to some degree.<br>
With a bit of help from [Fiddler](https://www.telerik.com/fiddler) I managed to find the API endpoint that is being called to configure these settings.<br>
`https://management.azure.com/providers/microsoft.aadiam/diagnosticSettings/${SETTINGS_NAME}?api-version=2017-04-01-preview`
Oh, I also wanted to mention one other flaw, you need to have the Azure PowerShell module installed.<br> 
I haven't tested my code with the new `Az` module yet, but that will follow at some point. Reason for this is because of another flaw in this process, and yes, to me it's a flaw.<br>
This specific API that we are going to call requires a particular user claim in the token that we are going to use to authenticate against the API which is called `user_impersonation`. This claim can only be acquired by a real user actually logging in. So be prepared to be prompted during this process.<br>
Short:

> We cannot use a fully silent workflow, unless we want to use an AAD user without MFA. Nobody wants that, so I won't be showing that.

I also assume that you have already created a Log Analytics workspace. If not, go and do that now with the tool of your choice. Check [here](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-powershell-workspace-configuration#create-and-configure-a-log-analytics-workspace) for an example of how to do it in PowerShell.<br>

## PowerShell "hack" to the rescue

Below script will do the following things, and **obvious disclaimer**, you will run this at your own risk:

- configure a "Diagnostics Settings" setting on your AAD tenant storing all your
  - AuditLogs
  - SignInLogs
- in your Log Analytics Workspace so that you can then query your logs from Log Analytics

We are leveraging a built-in service principal (client_id) for this, which essentially mimics the "Azure PowerShell" login workflow and then maps your user's permissions onto that application.

Replace the first five variables with your specific values. <br>
My tests have shown that the user you need to log in as requires the following permissions:

- Global Administrator on your AAD tenant
- Read permissions on the Log Analytics workspace

```powershell
Import-Module AzureRm -Force

$TENANTID = '<REPLACE WITH YOUR AAD TENANT ID'
$SUBSCRIPTION_ID = '<REPLACE WITH YOUR SUBSCRIPTION ID>'
$SETTINGS_NAME = '<REPLACE WITH RANDOM NAME FOR DIAGNOSTIC SETTINGS NAME>'
$LA_RESOURCEGROUP_NAME = '<REPLACE WITH YOUR LOG ANALYTICS RESOURCE GROUP>'
$LA_WORKSPACE_NAME = '<REPLACE WITH YOUR LOG ANALYTICS WORKSPACE NAME>'

$LA_WORKSPACE_ID ='/subscriptions/{0}/resourcegroups/{1}/providers/microsoft.operationalinsights/workspaces/{2}' -f $SUBSCRIPTION_ID, $LA_RESOURCEGROUP_NAME, $LA_WORKSPACE_NAME

$clientId = '1b730954-1685-4b74-9bfd-dac224a7b894' #built-in client id for "azure powershell"
$redirectUri = 'urn:ietf:wg:oauth:2.0:oob' #redirectUri for built-in client
$graphUri = 'https://management.core.windows.net'
$authority = 'https://login.microsoftonline.com/{0}' -f $TENANTID
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $authority

$authResult = $authContext.AcquireToken($graphUri, $clientId, $redirectUri, "Always")
$token = $authResult.AccessToken

$uri = 'https://management.azure.com/providers/microsoft.aadiam/diagnosticSettings/{0}?api-version=2017-04-01-preview' -f $SETTINGS_NAME

$body = @{
  id = "/providers/microsoft.aadiam/providers/microsoft.insights/diagnosticSettings/{0}" -f $SETTINGS_NAME
  name = $SETTINGS_NAME
  properties = @{
    logs = @(
      @{
        category = "AuditLogs"
        enabled = $true
        retentionPolicy = @{
          days = 0
          enabled = $false
        }
      },
      @{
        category = "SignInLogs"
        enabled = $true
        retentionPolicy = @{
          days = 0
          enabled = $false
        }
      }
    )
    metrics = @()
    workspaceId = $LA_WORKSPACE_ID
  }
}

Invoke-WebRequest -Uri $uri -Body $(ConvertTo-Json $body -Depth 4) -Headers @{Authorization = "Bearer $token"} -Method Put -ContentType 'application/json'
```

The result of running this script can be seen here in the following two images.

![azure ad diagnostics](/media/2018/12/aad-diag.png)
![azure ad diagnostics settings](/media/2018/12/aad-settings.png)

## Looking ahead

So far Microsoft doesn't seem to see it as a problem that there is no built-in PowerShell cmdlet to create this setting or a fully silent way of running this, like we get with almost all other things where we can request a Bearer token for a Service Principal and then execute tasks.<br>
Let's see if this will change in the near future. I sure hope so.