---
title: Managing Terraform State on Azure
date: 2019-03-25T00:01:30
layout: single-github
permalink: /2019/03/managing-terraform-state
categories:
  - azure
  - terraform
  - devops
tags:
  - terraform
  - azure
  - automation
  - devops
  - open source
github_comments_issueid: 3
---

When choosing terraform as your [infrastructure as code](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-infrastructure-as-code) tool it is important to understand that it is really easy to get going when it is just you and your laptop, but that there are a lot of things to consider when there are suddenly lots of other people working on the same code base as you.<br>
One of those things is terraform's [state file](https://www.terraform.io/docs/state/).

## Terraform remote backend

Whenever you run `terraform apply` it creates a file in your working directory called `terraform.tfstate`. This might be okay if you are running a demo, just quickly trying something out or just getting started with terraform. However, in an actual environment this is less than ideal, because your laptop is now the source of truth for terraform.<br>
If a colleague now ran `terraform plan` against the same code base from their laptop the output would most likely be incorrect. Terraform also creates a file lock on the state file when running `terraform apply` which prevents other terraform executions to take place against this state file. With local state this will not work, potentially resulting in multiple processes executing at the same time.<br>
Terraform supports remote backends which are remote file storage locations where the state file can be saved. For Azure the Azure Storage Account service can be used out of the box.<br>
This is how you would configure the remote Azure Storage backend:

```hcl
terraform {
  backend "azurerm" {
    storage_account_name = "terraformstate"
    container_name       = "tfstate"
    key                  = "terraform.dev.tfstate"
  }
}
```

This configuration assumes that the runtime has run `az login` or `Connect-AzAccount` prior to terraform being run. For more configuration options, check the [official documentation](https://www.terraform.io/docs/backends/types/azurerm.html).<br>
Adding this snippet to your terraform script is pretty much it. The next time you run `terraform plan` or `terraform apply` you will be prompted to run `terraform init` again as the backend configuration has changed. Terraform will attempt to initialise the backend and might even prompt to copy the existing local state up to the remote backend (very handy!).<br>
Can you already spot the issue?<br>
If you executed the above and it did **not** error out, then you did one of two things:<br>

1) you manually created the storage account or
2) you already knew what was happening and hacked the code together until it worked.

Our infracode requires infrastructure to begin with. Mhh. An Azure Storage Account requires an Azure Resource Group and the Storage Account itself of course. So now we are in a bit of a pickle. What creates the infrastructure that we require to be in place before we create our infrastructure?<br>
Some people might say that it is okay for this tiny bit of the overall infrastructure to be created "manually" during bootstrap of the Azure subscription, some people require all infrastructure to be managed by terraform. It is important to make this a conscious decision and understand what either decision means.<br>
If it is managed outside of terraform then what will create it? What is the process to recreate it in case it gets deleted or during an outage?<br>
It is possible to have it all managed by terraform though, even if it feels a bit hacky. Here is a really good example of bootstrapping the backend. It uses AWS S3 as a backend, but the process will be identical for Azure Storage:

- https://github.com/monterail/terraform-bootstrap-example/

## Securing the backend

Okay, we created the backend with Azure Storage Account. Happy days!<br>
Actually, have you looked at a terraform state file before? No, here's an example I prepared earlier:

![terraform state file](/media/2019/03/tf-state.png)

Do you notice something? It's all in plain text, everything, even our super secret domain admin password. This is by design, but not super. Using managed backends like Azure Storage blobs reduces the risk somewhat, but it does not remove the risk of password leakage altogether. Azure Storage Accounts are also encrypted at rest by default, which is a big plus.<br>
Hashicorp's official docs on this topic can be found [here](https://www.terraform.io/docs/state/sensitive-data.html).
This is not just a technical problem, it is also a process question you need to answer.

- What IAM permissions will be set on the Azure Storage Account?
  - Reduce the number of accounts to the bare minimum.
  - Remember, denying access to a blob does not mean anything if somebody has IAM permissions on the account and then can grant themselves access again.
- What is the process to follow in case a human does require access to the state file?
  - There are realistic scenarios, even if they are not great, where one might need to edit the state file.
- How is the state file backed up and restored?
- Is auditing enabled on the Storage Account?
- Are changes to the state file tracked?
  - If I have access to the state file then I can also change / edit the state file to my liking and could cause terraform to delete or redeploy resources the next time terraform runs even if the terraform code does not intent that.

These are just some of the questions you need to address in your implementation of terraform.