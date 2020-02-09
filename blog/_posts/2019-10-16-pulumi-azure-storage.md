---
title: Using Pulumi on Azure Storage Accounts
date: 2019-10-16T00:01:30
layout: single-github
permalink: /2019/10/pulumi-azure-storage
categories:
  - azure
  - devops
tags:
  - cloud
  - azure
  - pulumi
  - infrastructure-as-code
  - devops
github_comments_issueid: 8
---

If you have never heard of [Pulumi](https://pulumi.com) then do yourself a favour and read up on their official website and then check out my article [here](/2019/03/azure-pulumi-getting-started).<br>
Caught up on Pulumi and now you're a fan? Yeah, happens to pretty much everybody I show Pulumi to.

## Pulumi Open Source on Azure

Pulumi comes in several variations, free and [paid](https://www.pulumi.com/pricing/) both using the Pulumi SaaS service for things like hosted state management, change tracking, secrets management, RBAC to the stacks amongst many more, and also for those that do not need the Pulumi service you can self-manage the state on cloud storage and then use the Pulumi framework to describe your infrastructure as real code (general purpose languages).<br>

> In this article I am going to show you how to store your Pulumi state file on Azure Storage Containers.

## Why using Azure Storage for Pulumi is a good idea

In cases where you are all-in on Microsoft Azure and also use [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops&WT.mc_id=DOP-MVP-5000267) for your CI/CD pipelines and services like [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/?WT.mc_id=AZ-MVP-5000267) for secrets management for example, using the paid Pulumi service **MIGHT** be duplication of services where you already get all the required features from Azure. Nobody wants to pay double, right?<br>
This said, do your own research and make sure that not using the Pulumi service you are not missing out on features.

## Creating the Azure State Backend for Pulumi

Pulumi stores its infrastructure state file in json format by default inside the Pulumi service. Here I am going to show you how to deploy the backend on Azure Storage Services.<br>
The examples will be both Azure PowerShell and the Azure CLI, pick whatever works for you.<br>

> **Prerequisites**<br>
> Either Azure PowerShell module or Azure CLI (TIP: Use the [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview?WT.mc_id=AZ-MVP-5000267))<br>
> Latest Pulumi CLI installed in your environment: <https://www.pulumi.com/docs/get-started/install/> <br>
> If you are going to use the CLI, make sure you have the `jq` command installed

Once you are authenticated to Azure, follow these steps, making sure that resource names and locations work for you:

### Create the Azure Resource Group

```powershell
New-AzResourceGroup -Name pulumistate -Location australiasoutheast
```

or

```bash
az group create --name pulumistate --location australiasoutheast
```

### Create the Azure Storage Account

> Storage Account names **MUST** be globally unique. So you most likely won't be able to use a name without a random string appended to the name. Check the [documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-storage-account-name-errors?WT.mc_id=DOP-MVP-5000267) for more information on errors around naming.

```powershell
$sa = New-AzStorageAccount -ResourceGroupName pulumistate -Name pulumistate -Location australiasoutheast -SkuName Standard_LRS -Kind StorageV2 -AccessTier Hot -EnableHttpsTrafficOnly $true

New-AzStorageContainer -Name state -Context $sa.Context -Permission blob
```

or

```bash
SA=$(az storage account create --name pulumistate --resource-group pulumistate --location australiasoutheast --sku Standard_LRS --access-tier Hot --https-only true --kind StorageV2)
KEYS=$(az storage account keys list --account-name pulumistate --resource-group pulumistate --output json)
export AZURE_STORAGE_ACCOUNT="pulumistate"
export AZURE_STORAGE_KEY=$(echo $KEYS | jq -r .[0].value)
az storage container create --name state
```

Once you executed either the PowerShell or CLI you should be able to find an Azure Storage Container in your subscription.

![azure storage container](/media/2019/10/pulumi-container.png)

## Logging Pulumi in to Azure backend

Most of the work is done now and you will soon be able to continue writing your infracode in Pulumi.<br>
Pulumi will use the azure environment variables (your user tokens) to authenticate to Azure Storage when executing the following command:

```bash
pulumi login azblob://state
```

This will configure Pulumi's backend to the Azure Storage Container.<br>
For more information about the `pulumi login` command, read the [official documentation](https://www.pulumi.com/docs/reference/cli/pulumi_login/).

## Creating a Pulumi Stack

Creating a Pulumi stack works just the same way as it did before, with one exception, you now need to provide a passphrase that secrets will be protected with.<br>
Running `pulumi new` in an **empty** directory will walk you through the stack creation experience as can be seen in this screenshot here.

[![pulumi new stack](/media/2019/10/pulumi-new-stack.png)](/media/2019/10/pulumi-new-stack.png)

Once completed we can go over to our Azure Storage Account and check the contents of our container. You should see a folder structure similar to the one in the following screenshot. Something like `.pulumi/stacks` and a json file in there.

[![pulumi state on azure](/media/2019/10/pulumi-azure-state.png)](/media/2019/10/pulumi-azure-state.png)

## Security Considerations

Pulumi does store secrets securely inside their state files (unlike [terraform](/2019/03/managing-terraform-state)), however, I would still recommend to make sure that access to the Azure Storage Account is strictly audited and controlled.

Will you be using a self-managed state backend? Or are you going to use the Pulumi service? Let me know in the comments.