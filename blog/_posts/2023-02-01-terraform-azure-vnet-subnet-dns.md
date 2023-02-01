---
title: How to use terraform to quickly deploy a decent Azure network
date: 2023-02-01T00:01:30
layout: single-github
permalink: /2023/02/terraform-azure-decent-network
categories:
  - azure
tags:
  - azure
  - terraform
  - devops
github_comments_issueid: 31
---

While I still #heart Pulumi, I still come across terraform in most engagements with customers. Here, I want to give you a quick way of deploying a decent "Getting started" virtual network that will allow you to test many different scenarios and keep iterating easily.<br>
Deploying this code will cost you a little bit, due to the VPN Gateway (to support P2S or S2S VPN). You can easily comment that out though.<br>
I know you just want to see the code, so if you do not want to read the rest, just hop over to https://github.com/davidobrien1985/decent-azure-vnet and see for yourself.

## Deploying the infrastructure with terraform

Still here? Cool. What will you get when you deployed this code?

- an Azure virtual network
- multiple subnets, defined in the root's `variables.tf`
- multiple private DNS zones to support a multitude of private endpoint scenarios
- a VPN Gateway deployed into the GatewaySubnet
- a Log Analytics workspace
- an Application Insights instance

You will find parameterised modules, the use of `for_each` concepts around terraform `map`s and `list`s, `lookup`s of data and some other terraform things.

## How to deploy with terraform

In the repo you will find an `install-terraform.sh` file you can execute and it will install terraform version `1.3.7`. That file is not by me, I found it in one of my many random repos locally. If you wrote it, let me know and I'll send you some money for a coffee as thanks.<br>
I use WSL on Windows 11 for this kind of work, so bash was very handy for me.<br>
Terraform is configured to use a local backend, so really all you need to do is:

- `./terraform/install-terraform.sh` - install terraform. Make sure you reload your shell.
- `cd infra/foundations`
- `terraform init` - initialise the terraform backend / code
- `az login` - log in to your Azure subscription
- `terraform plan` - see what will happen if you were to deploy this
- `terraform apply` - this will actually apply the code

Do not want the resources anymore? `terraform destroy` will remove all those resources for you.

## Making updates or changes to terraform

Want more or different subnets? Have a look at `infra/foundations/variables.tf`

```hcl
variable "subnet" {
  description = "Map of Azure VNET subnet configuration"
  type        = map(any)
  default = {
    bastion_subnet = {
      name                 = "AzureBastionSubnet"
      address_prefixes     = ["10.0.1.0/26"]
    },
    gateway_subnet = {
      name                 = "GatewaySubnet"
      address_prefixes     = ["10.0.1.64/26"]
    }
    appgateway_subnet = {
      name                 = "ApplicationGatewaySubnet"
      address_prefixes     = ["10.0.2.0/26"]
    }
    forensicregisterapi_subnet = {
      name                 = "app"
      address_prefixes     = ["10.0.3.0/27"]
    }
    data_subnet = {
      name                 = "data"
      address_prefixes     = ["10.0.3.32/27"]
    }
  }
}
```

Change CIDR, add or remove subnets. Easy. This will be picked up next time you run the steps above.<br>
Want to make changes or add other resources? Feel free to create a Pull Request on the repo and I will merge your resources / modules in to the repo.
