---
title: Managing Deployment Secrets with Azure Key Vault
date: 2020-06-21T00:01:30
layout: single-github
permalink: /2020/06/pulumi-encrypt-secrets-azure-keyvault
categories:
  - azure
  - pulumi
tags:
  - azure
  - devops
  - pulumi
  - security
  - keyvault
github_comments_issueid: 18
---

Secrets (API keys, passwords, server names, access keys, user names, etc) are always part of any infrastructure / application deployment and always you get to a point where someone will ask "How do we manage these secrets?".<br>
Every company's security approach is different. Some companies are absolutely fine with having a company like Microsoft manage encryption keys for them (managed keys), others require everything to be encrypted with a customer managed key (CMK) where they bring their own key and import it to the platform or create a new key on the platform.<br>
When deploying infrastructure with [Pulumi](https://pulumi.com){:target="_blank"} similar situations come up and companies need to decide what approach to take.

## Secret Encryption with Pulumi

Pulumi supports the following methods when it comes to encrypting secrets:

- using the Pulumi service, essentially a PaaS where everything is managed end to end (state and secrets)
- using the Pulumi service but using your own encryption [passphrase](https://www.pulumi.com/blog/managing-secrets-with-pulumi/#configuring-your-secrets-provider){:target="_blank"}
- using your own self-managed state storage (like Azure Storage Blob) which by default uses a passphrase to encrypt secrets or
- bring your own key using Azure Key Vault encryption keys

In this article we will cover the last scenario and show how to set this up in just a few steps.

## Creating the Azure Key Vault Key

Prerequisites:

- `az` cli (I use the docker image provided by Microsoft)
  - `docker run -it mcr.microsoft.com/azure-cli`
- access to an Azure subscription (I will deploy resources that cost money, make sure you understand this, no matter how little the cost actually is)
- pulumi cli

Make sure you are authenticated to Azure first.

1. create an Azure Resource Group (make sure you replace the name and location with values that work for you)
`az group create --name rg-pulumi-encryption --location australiasoutheast`
2. create an Azure Key Vault (make sure you replace the key vault name and other values with values that work for you)
`az keyvault create --name cloudrightpulumi --resource-group rg-pulumi-encryption --location australiasoutheast`
3. Create the Azure Key Vault Key (make sure you replace these values with ones that work for you)
`az keyvault key create --name pulumiencryptionkey --vault-name cloudrightpulumi`
4. Retrieve your own users' object ID and assign a Key Vault Access Policy to yourself. `az` CLI will already create an access policy by default, however this policy does not grant all required permissions.

```bash
USER_OBJECT_ID=`az ad user show --id david@xirus.com.au | jq -r .objectId`
az keyvault set-policy --name cloudrightpulumi --object-id $USER_OBJECT_ID --key-permissions encrypt decrypt get create delete list update import backup restore recover
```

Congratulations. We have now created an Azure Key Vault with an Encryption Key.

[![create azure key vault key](/media/2020/06/pulumi-encryption-key.png)](/media/2020/06/pulumi-encryption-key.png)

## Configure Pulumi to use Azure Key Vault

We need to tell Pulumi that it needs to allow us to use a custom secrets provider. We do that by setting an environment variable. `AZURE_KEYVAULT_AUTH_VIA_CLI` needs to have a value of `true`. If you are using the above mentioned docker image then you can set this variable in Linux by running the following code snippet:

```bash
export AZURE_KEYVAULT_AUTH_VIA_CLI=true
```

> Before executing the next step, make sure you are either logged in to your Pulumi self-hosted backend or your Pulumi Organisation.

This step now creates a new pulumi project (`stack new`) and configures it to use the `azurekeyvault` provider. Replace `cloudrightpulumi` with the Key Vault Name that you created above, similar with `pulumiencryptionkey`.

```bash
pulumi stack new --secrets-provider="azurekeyvault://cloudrightpulumi.vault.azure.net/keys/pulumiencryptionkey"
```

We accept all the defaults here to make it easy and voila, our project has been created.
[![create pulumi project](/media/2020/06/create-pulumi-project.png)](/media/2020/06/create-pulumi-project.png)

We can verify that Pulumi has actually used our Key Vault Encryption Key by looking at the `Pulumi.dev.yaml` (replace `dev` with whatever stack name you chose).

[![read pulumi config](/media/2020/06/pulumi-yaml.png)](/media/2020/06/pulumi-yaml.png)

From now on all Pulumi stack configuration will be encrypted using the Azure Key Vault Encryption key.

## Cleanup

Don't forget to delete the Azure Resource Group after you're done testing.