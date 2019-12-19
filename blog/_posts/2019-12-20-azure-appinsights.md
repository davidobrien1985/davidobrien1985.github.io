---
title: Installing Azure AppInsights Extension
date: 2019-12-19T00:01:30
layout: single-github
permalink: /2019/12/azure-appinsights
categories:
  - azure
  - applicationinsights
tags:
  - cloud
  - azure
  - appinsights
  - applicationinsights
  - monitoring
  - iaas
github_comments_issueid: 10
---

Without insights into your environment you are lost guessing what is happening with no data to back up your guesses.<br>
One out of the box way to gain insights into what your applications are doing on Azure is to use [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview?WT.mc_id=DOP-MVP-5000267), a feature of Azure Monitor, as your Application Performance Management (APM) service.

## Create Application Insights Resource

Creating the Application Insights Resource is fairly straight forward and can be achieved through multiple ways as documented [here](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-new-resource#creating-a-resource-automatically?WT.mc_id=DOP-MVP-5000267).<br>
Examples:
Azure PowerShell:

```powershell
New-AzApplicationInsights -Kind java -ResourceGroupName testgroup -Name test1027 -location eastus
```

Azure CLI:

```bash
az monitor app-insights component create --app demoApp --location westus2 --kind web -g demoRg --application-type web
```

Terraform:

```hcl
resource "azurerm_application_insights" "appinsights" {
  name                = "appinsights"
  location            = "australiaeast"
  resource_group_name = "demoRg"
  application_type    = "other"
}
```

## Installing the Application Insights VM Extension

If your application is running on a VM or VM Scale Set on IIS then it is trivial enough to get the platform to send information about the application's performance to Application Insights, even without changing any application code (even though this would gain you even better insights).<br>
Azure VMs allow you to install extensions and one of them is the `ApplicationMonitoringWindows` extension, a similar exists for Linux. Installing the extension will cause it to send information to Application Insights.<br>
There is one gotcha though that makes sense in hindsight but isn't documented.<br>
The extension installation will fail on Windows if the extension is configured to "listen for" IIS applications but IIS has not been installed yet. The error you will receive will be along the following lines:

```text
EventId: 102. Message: {0}. Payload: VmExtensionHandler failed: System.IO.FileNotFoundException: Cannot find applicationHost.config at C:\windows\System32\inetsrv\config\applicationHost.config
File name: 'C:\windows\System32\inetsrv\config\applicationHost.config'
```

The extension fails if there is no .net application installed.<br>
In our case we install the application via an Azure VM Custom Script Extension and this happened to occur after the Application Insights extension got installed.

## Azure VM Extension Installation Order

To fix this issue Microsoft allows us to specify dependencies / order amongst VM extensions. For VM Scale Sets you can find the information about this [here](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-extension-sequencing?WT.mc_id=DOP-MVP-5000267). The important property to configure is `provisionAfterExtensions`.<br>
If you are using PowerShell:

```powershell
$publicCfgJsonString = '
{
  "redfieldConfiguration": {
    "instrumentationKeyMap": {
      "filters": [
        {
          "appFilter": ".*",
          "machineFilter": ".*",
          "virtualPathFilter": ".*",
          "instrumentationSettings" : {
            "connectionString": "InstrumentationKey=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
          }
        }
      ]
    }
  }
}
'

$privateCfgJsonString = '{}'
Add-AzVmssExtension -VirtualMachineScaleSet $VMSS -Name "applicationmonitoring" -Publisher "Microsoft.Azure.Diagnostics" -Type "ApplicationMonitoringWindows" -TypeHandlerVersion "2.8" -AutoUpgradeMinorVersion $True -ProvisionAfterExtension @("nameOfCustomScriptExtension") -SettingString $publicCfgJsonString -ProtectedSettingString $privateCfgJsonString
```

If you are using Terraform:

```hcl
    extension {
    name                       = "applicationmonitoring"
    provision_after_extensions = [
      "nameOfCustomScriptExtension"
    ]
    publisher                  = "Microsoft.Azure.Diagnostics"
    auto_upgrade_minor_version = true
    type                       = "ApplicationMonitoringWindows"
    type_handler_version       = "2.8"
    settings                   = <<SETTINGS
    {
      "RedfieldConfiguration": {
        "InstrumentationKeyMap": {
          "Filters": [
            {
              "AppFilter": ".*",
              "MachineFilter": ".*",
              "InstrumentationSettings" : {
                "InstrumentationKey": "appInsightsInstrumentationKey"
              }
            }
          ]
        }
      }
    }
    SETTINGS
  }
```

Once we configured that the Application Insights extension got installed last everything started working.