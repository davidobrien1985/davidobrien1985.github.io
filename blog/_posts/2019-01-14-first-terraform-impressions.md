---
title: First steps with terraform
date: 2019-01-14T00:01:30
layout: single
permalink: /2019/01/first-terraform-impressions
categories:
  - azure
  - terraform
  - devops
tags:
  - terraform
  - azure
  - automation
  - devops
github_comments_issueid: 1
---

Microsoft and terraform seems to be THE thing that everybody is talking about lately when it comes to Infrastructure as Code on Microsoft Azure.<br>
I have recently been in the situation where I could take my theoretical I-have-run-terraform-apply-once-on-my-laptop knowledge and apply it to a real customer project and with this **limited** exposure to deploying some basic Azure foundational infrastructure I wanted to write down some of my first impressions of using it for reals.

## Terraform basics

If you are new to terraform then here are some basics that you should know about and instead of writing them all down here I'll just link to them:

- [terraform documentation](https://www.terraform.io/docs/index.html)
- [terraform GitHub main repo](https://github.com/hashicorp/terraform)
- [terraform Azure provider documentation](https://www.terraform.io/docs/providers/azurerm/)
- [terraform Azure provider GitHub repo](https://github.com/terraform-providers/terraform-provider-azurerm/)

In true Hashicorp fashion this sums it up to terraform being open source and available in a free version. It's written almost entirely in [golang](https://golang.org/) and is obviously still quite a few releases away from a version 1.0 currently sitting at 0.11.11 in `master` branch for the main terraform binary.<br>
The AzureRM provider itself is currently at version 1.21 and is developed in isolation to the main binary.<br>
Expect a few things that I mention in this article to change going forward with new releases of terraform, including probably some very breaking changes. At least this is what a lot of people keep telling me.

## First terraform impressions

Going forward I will assume some terraform knowledge. So if you don't know what I'm talking about then either go read the documentation and come back to this article or just take my word for it ;-) <br>

### Terraform vs Azure ARM templates

I've done quite a bit of work with Azure ARM templates. The native way on Azure to write Infrastructure as Code. ARM templates are written in JSON and that's terrible. I don't like JSON. Even a good IDE (like VS Code) won't change this fact. JSON is for machines and fortunately I'm not a machine.<br>
Terraform changes this with introducing something which is a bit more plain text like called HCL ([Hashicorp Configuration Language](https://github.com/hashicorp/hcl)). To the untrained eye it looks a bit like YAML but makes away with things like "your whitespace is wrong" errors.
<br>
Creating an Azure Resource Group with a virtual network can be achieved with just a few lines of code:

```HCL
provider "azurerm" {
  subscription_id = "<subscription_id>"
  client_id       = "<client_id>"
  client_secret   = "<client_secret>"
  tenant_id       = "<tenant_id>"
}

resource "azurerm_resource_group" "logical-terraform-name-for-my-rg" {
  name     = "my-first-terraform-rg"
  location = "Australia Southeast"
}

resource "azurerm_virtual_network" "logical-terraform-name-for-my-vnet" {
  name                = "my-first-terraform-vnet"
  resource_group_name = "${azurerm_resource_group.logical-terraform-name-for-my-rg.name}"
  location            = "Australia Southeast"
  address_space       = ["10.0.0.0/8"]
}
```

This is super easy and straight forward. Compare this to an ARM template and until recently this wouldn't even have worked because ARM templates just learned how to create Resource Groups.<br>
So, HCL is really simple and in my opinion, and not just mine, too simple. ARM templates come with all these nice built-in [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-functions) that one can use to loop, create resources based on conditions, calculate things or get rich information about other resources.<br>
HCL lacks pretty much all of these niceties. (at the moment) <br>
Consider this. You want to deploy a resource conditionally on a variable. Essentially you want to do something like `if $var then <do something>`. Well, HCL doesn't know what that means. Instead, they make you use the `count` property on a resource. Here is an example deploying a key vault resource only into the `prod` environment by checking if a variable `ENVIRONMENT_NAME` has a value of `prod`:

```HCL
resource "azurerm_key_vault" "keyvault-prod" {
  name                = "keyvault"
  count               = "${var.ENVIRONMENT_NAME == "prod" ? 1 : 0}"
  resource_group_name = "${azurerm_resource_group.logical-terraform-name-for-my-rg.name}"
  location            = "Australia Southeast"

  sku {
    name = "standard"
  }
}
```

You'd expect some sort of `if` logic, but no, you are essentially saying `if variable equals this then deploy ONE resource otherwise deploy ZERO resources`. Very strange and I'm still very irritated by this.<br>
I received feedback that the `count` should really ideally be (mis)used for feature toggling (which I'm kind of doing in this example) and not for environmental differences. Environment specific configuration should obviously come in to the system via environment variables or other `tfvar` files that are environment specific.

### IDE support for terraform

You definitely want to get yourself a good IDE, something like [VS Code](https://code.visualstudio.com/) which supports plugins for terraform. It is super handy to be able to use tab completion on resources with lots of properties, references to variables or other values used in your terraform scripts. The terraform plugin also uses shortcuts to the official documentation for each resource. Just click on the resource type in your script and voila, there's your documentation.<br>
Reading the documentation however is necessary, as I have already found a lot of inconsistencies with the tab completion where properties that were required wouldn't show up in the tab completion menu or were marked as optional.<br>
It's definitely a great help though when writing terraform for Azure from scratch.<br>
Comparing it to the VS Code plugin for ARM though, I thought that plugin was more accurate in what it did around tab completion, being up to date with child properties and just helping me get the templates right.

### Terraform remembers

One big issue with ARM templates is that they're very unpredictable. Without actually deploying them it's difficult to understand what is going to happen if you were to deploy the template. Especially when making changes to an ARM template and wanting to deploy it again over already existing infrastructure.<br>
There is no stored state anywhere with ARM templates, at least not out of the box. State that stores what resources this template has deployed and with which settings and so on, so that on a subsequent deployment you could do a "diff" against that existing infrastructure and know exactly what will happen.<br>
Having also worked a lot on AWS with CloudFormation and its change sets this was something I personally really missed with ARM.<br>
Not having a good idea of what will happen on deployment of a template makes a review process very difficult. It means to be sure of what will happen you actually need to deploy your full template and then have a review process that checks the deployed infrastructure. This is very time consuming and creates other issues for example around additive deployments for example to simulate deployments to existing infrastructure.<br>
Terraform stores state which is great. We can now, without deploying anything, run `terraform plan` and terraform give us a list of actions it will execute.

![terraform plan](/media/2019/01/terraform-plan.png)

This is great. We can add this step into a pipeline and before anything gets deployed even an "untrained" person can review what is going to happen.<br>
Some really weird things however do also sometimes happen, where `terraform plan` will show you changes to resources you didn't tell it to make changes to. In quite a lot of those cases it just happened to be that terraform thought it had to change something and told me about it, but in the end no changes were made. These call-outs by terraform were very confusing and kind of lowered our confidence in `terraform plan` for a little while. These false-alerts happened especially on Network Security Groups and Subnets.<br>
The downside here with having state is that this state needs to be stored somewhere. It's now something we need to manage. Terraform natively supports storing state in Azure Storage Accounts. The thing with this state file is it's plain text and depending on what you are doing secrets **can** end up in that state file and then they would also be in plain text. Not an issue you think? This [search](https://github.com/search?utf8=%E2%9C%93&q=terraform.tfstate%20in%3Apath&type=Code&ref=searchresults) on GitHub here yields over 9,000 public terraform state files with lots of them having secrets or other sensitive data in them. Two things you **MUST** do in my opinion:

- add the `terraform.tfstate` files to your `.gitignore` file so that you don't commit them to your repo
- use remote backends as recommended by [Hashicorp](https://www.terraform.io/docs/state/sensitive-data.html#recommendations). Make sure the Azure Storage Account's access policies are locked down so that (almost) nobody can access the file. The file will still be in plain text, but Azure Storage Accounts are encrypted at rest by default, so at least there's that.

One other thing I noticed when it comes to the state file. Terraform will lock the file on execution, which makes sense, because you don't want multiple processes write to the same state file at the same time. However, this also means that if terraform dies unexpectedly then this lock will still be applied to the file and you need to manually remove the lock (in Azure Storage Account terminology you need to break the lease on the file) in order for any subsequent execution to work. This will also happen if you run terraform from your laptop and your laptop dies or you just shut it down while forgetting that you are still executing a long running deployment. This can be quite annoying especially in a bigger and very active team.<br>
Overall I do think that the state file is very handy, if only it was encrypted and not plain text or at least I had the ability to say that certain values are sensitive and terraform would encrypt those only.

### Plans never work

How often do we make plans in our daily life and once we try to implement them we find out they fail because we missed that one thing?<br>
`terraform plan` promises to make away with this by telling you exactly what it would do. This is great, as I mentioned above, but in quite a lot of cases the actual input validation happens only once you do a `terraform apply`. This is because `terraform plan` doesn't actually hit the Microsoft Azure APIs but relies on its own built-in validation and depending on the implementation of a resource it might not do any validation but only tell you "I will do this" which won't always mean "and it will work".<br>
One example for this was when I tried to create an Azure Log Analytics workspace. To create one I have to provide the terraform resource with a SKU parameter and the documentation also tells you which values are accepted. I used an allowed value, ran my plan, checked it, deployed it and it failed complaining about the SKU.<br>
It took me a while to realise that the SKU I was using wasn't allowed in my particular subscription (Microsoft changed the Log Analytics SKUs a while ago), but that only became an issue once `terraform apply` actually hit the Azure APIs and tried to deploy something.<br>
The reason for `plan` not being 100% accurate is, as I explained, because it doesn't validate against the actual Azure APIs. Why not? Because those APIs don't support "simulated deployments", something like a `-whatif` in PowerShell for example. It would also potentially just take too long to validate everything online.<br>
Terraform plan is "good enough" in my opinion to be run during a CI build and create output that a human can verify and approve, if required. I haven't found too many instances where a plan gave me the thumbs up and Azure then the thumbs down.

## Terraform or Azure ARM templates

So, what do I think?<br>
Terraform's development experience is a lot nicer than ARM's is. The HCL language has a lot of weird things in it that I'm still not used to though. I'm hoping that the next version will remove some of those.<br>
Overall I'm still not 100% sold on terraform if all you are doing is Azure infrastructure. In my opinion knowing the native way of doing things (API and ARM templates) helped me write the terraform scripts for Azure. I think I might have struggled in a few places had I not already known Azure ARM templates at least a bit.<br>
By selecting terraform as your Infrastructure as Code (IaC) tool you gain functionality but you also now need to consider things that with Azure's native tooling you wouldn't need to consider.
I'd love to see Microsoft do some more work on shipping some "state-like" feature on ARM so that we can natively create "plans" or "changesets" and overall put more work into the ARM engine itself.<br>
As with always on this blog, this is my opinion, in your own case it's important to make an informed decision when choosing a tool and some of the issues that I personally had might not be a big deal for you and totally acceptable.<br>