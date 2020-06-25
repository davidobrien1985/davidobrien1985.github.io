---
title: Using Microsoft Graph in Python
date: 2020-06-26T00:01:30
layout: single-github
permalink: /2020/06/microsoft-graph-python
categories:
  - azure
  - python
tags:
  - azure
  - microsoft-graph
  - development
github_comments_issueid: 19
---

Microsoft announced that it was going to deprecate the "Azure Active Directory Graph" APIs eventually. This week (June 2020) they [announced](https://techcommunity.microsoft.com/t5/azure-active-directory-identity/update-your-applications-to-use-microsoft-authentication-library/ba-p/1257363){:target="_blank"} a date: 

> Starting, June 30th, 2020, we will no longer add any new features to ADAL and Azure AD Graph. We will continue to provide technical support and security updates but will no longer provide feature updates.
> 
> Starting June 30th, 2022, we will end support for ADAL and Azure AD Graph and will no longer provide technical support or security updates. Apps using Azure AD Graph after this time will no longer receive responses from the Azure AD Graph endpoint. Apps using ADAL on existing OS versions will continue to work after this time but will not get any technical support or security updates.

I was in the middle of writing some code for a customer where I was using the AAD Graph API when I saw the article and thought to myself "better not deliver the customer some dead code".

## Microsoft Graph API

The [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/overview?view=graph-rest-1.0){:target="_blank"} exposes APIs not just for Azure AD (like the now deprecated API) but also includes other products like 

- Microsoft 365 services: Delve, Excel, Microsoft Bookings, Microsoft Teams, OneDrive, OneNote, Outlook/Exchange, Planner, SharePoint, Workplace Analytics.
- Enterprise Mobility and Security services: Advanced Threat Analytics, Advanced Threat Protection, Azure Active Directory, Identity Manager, and Intune.
- Windows 10 services: activities, devices, notifications, Universal Print (preview).
- Dynamics 365 Business Central.

However, unlike the AAD Graph, the Microsoft Graph does not (yet?) have a Python SDK available for it. So that's where initially I stumbled a bit when I tried to get started.

## Microsoft Graph API SDK / Wrapper

Instead of a full SDK Microsoft opted to release a lightweight wrapper around the REST APIs that can be found [here](https://github.com/microsoftgraph/msgraph-sdk-python-core){:target="_blank"}. The documentation right now is just as lightweight though, so hopefully this will get you started.<br>

### Installing Microsoft Graph Python SDK

Make sure your `requirements.txt` looks like this:

```python
--index-url https://pypi.python.org/simple
azure-identity==1.3.1
--index-url https://test.pypi.org/simple
msgraphcore==0.0.2
```

And then execute `pip install -r requirements.txt` to install the dependencies. As a good practice I pinned the versions here. Depending on when you're reading this there will likely be a new version.

## Querying Azure AD Groups with MS Graph Python SDK

I have the following use case:

> Execute python script that queries for existence of Azure AD groups. The python script authenticates against AAD using an "AAD App Registration".

Prerequisites:<br>
- AAD App registration (also referred to as SPN) created. See [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app){:target="_blank"}
- We know the client_id and client_secret of the AAD App
- We know the tenant_id of the AAD we are running the code against
- AAD App has been granted `Directory.Read.All` and `Group.Read.All` permissions. See [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis#add-permissions-to-access-web-apis){:target="_blank"}

[![graph app permissions](/media/2020/06/graph_app_permissions.png)](/media/2020/06/graph_app_permissions.png)

We are now ready to execute the following script to get the AAD object ID of an AAD Group specified in line 26:

```python
import json
import os
from azure.identity import ClientSecretCredential
from msgraphcore import GraphSession

# AZURE_TENANT_ID: with your Azure Active Directory tenant id or domain
# AZURE_CLIENT_ID: with your Azure Active Directory Application Client ID
# AZURE_CLIENT_SECRET: with your Azure Active Directory Application Secret

def authenticate_graph_api():
  graph_credentials = ClientSecretCredential(
      client_id=os.environ["AZURE_CLIENT_ID"],
      client_secret=os.environ["AZURE_CLIENT_SECRET"],
      tenant_id=os.environ["AZURE_TENANT_ID"]
  )

  scopes = ['.default']
  return GraphSession(graph_credentials, scopes)

def get_aadgroup_object_id(group_display_name):
  aad_group = graphrbac_client.get(f"/groups?$filter=startswith(displayName, '{group_display_name}')").json()
  return aad_group['value'][0]['id']

graphrbac_client = authenticate_graph_api()

object_id = get_aadgroup_object_id("set_to_aad_group_name")
print(object_id)
```

For more info about running this code, check the repository [here](https://github.com/davidobrien1985/azure-examples/tree/main/python/msgraph){:target="_blank"} <br>
Some important notes:

- line 17 `scopes = ['.default']`, this is set because we are using a `ClientSecretCredential()` to authenticate. In this case the application cannot request different scopes at runtime and `.default` is the correct scope to set implying that the correct API permissions / scopes have been configured as mentioned above
- other ways of authenticating (as a console app in user context for example) are able to request permissions dynamically and we can set `scopes = ['Directory.Read.All', 'Group.Read.All']`
- line 21, using this `msgraphcore` wrapper allows us to easily send commands to the Graph API. Testing these queries is super simple as we can use the [Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer){:target="_blank"} to create the queries.

Hopefully these notes help others to get started with the Microsoft Graph API and Python.