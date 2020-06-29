---
title: What if I deployed this Azure ARM Template
date: 2020-06-29T00:01:30
layout: single-github
permalink: /2020/06/azure-arm-template-whatif
categories:
  - azure
  - devops
tags:
  - azure
  - azure resource manager
  - devops
  - cloud
github_comments_issueid: 20
---

> "What happens if you deploy this change?"

Sounds familiar? I guess every person that has written some sort of code has been asked this question before.<br>
When making changes to infrastructure code at some point we need to validate that what we were thinking what will happen is actually what is going to happen. "Fingers crossed" and hitting the "deploy" button is usually not a great recipe for success.

# History of ARM Templates

Since the beginning of the Azure Resource Manager (ARM) model the "what happens if" question could only be answered by actually deploying a template or by having somebody on the team that has the deepest and most extensive and intimate knowledge of every Azure Resource Provider that can tell you what will happen by looking at the code and comparing that to what is currently deployed. (Hint: I don't believe that person exists.)<br>
Azure always had the ability to [test/validate a template](https://docs.microsoft.com/en-us/rest/api/resources/deployments/validate){:target="_blank"}, however, this didn't actually do much beside checking if the template was syntactically valid and would be accepted by the API. It did not check what would happen or if what you intended to happen would actually work.
This shortcoming of Azure templates for the longest time was one reason why I advocated for my customers and community members in general to learn about the ARM platform, but use other infrastructure as code tools like [terraform](https://www.terraform.io/){:target="_blank"} or [pulumi](https://www.pulumi.com/){:target="_blank"} as they support a plan / preview of what will happen out of the box.

# Azure ARM WhatIf

At the previous Microsoft Ignite conference the ARM team finally officially announced the `WhatIf` API, the definition can be found [here](https://docs.microsoft.com/en-us/rest/api/resources/deployments/whatif){:target="_blank"}.<br>
If you are familiar with PowerShell's `whatif` [switch](https://techcommunity.microsoft.com/t5/itops-talk-blog/powershell-basics-don-t-fear-hitting-enter-with-whatif/ba-p/353579){:target="_blank"} or other languages "dry run" capabilities then this might all make a lot of sense to you now.<br>
ARM templates (in preview) can now support a `whatif` parameter that returns a lot of very valuable output useful for "manual" deployments (from someone's laptop) and even more so for deployment pipelines where one could use this functionality as a gate on Pull Requests (PR) into your main (deployment) branch. GitHub Actions are easily set up to run a template against the `whatif` API every time someone creates a PR so that you automatically have information at hand about what the code would change. Handy!

## Executing ARM WhatIf via PowerShell

As a simple example you will use the following template as the base: [https://github.com/davidobrien1985/azure-examples/blob/main/arm/basic-vnet-with-subnets.json](https://github.com/davidobrien1985/azure-examples/blob/main/arm/basic-vnet-with-subnets.json) <br>
You first create a Resource Group.

```python
New-AzResourceGroup -Name azwhatif -Location australiasoutheast
```

Then you can do the first whatif check.

```powershell
New-AzResourceGroupDeployment -Name azwhatif1 -ResourceGroupName azwhatif -TemplateFile .\template.json -Mode Complete -WhatIf
```

That `-WhatIf` is equivalent to the usual PowerShell whatif but in the most recent `Az` PowerShell module it executes some new cloud magic which returns the following when you run the template against an empty Resource Group.

[![azure powershell arm template whatif](/media/2020/06/arm-whatif-1.png)](/media/2020/06/arm-whatif-1.png)

Doesn't this look nice? The green colour shows us that something will be created / added.<br>
Next step we remove the `-whatif` and actually deploy the template to create a Virtual Network and two Subnets. This will be done in seconds.<br>
Now, let's run the above cmdlet with one change. Let's force a pretty big change by reconfiguring the vnet's CIDR.

```powershell
New-AzResourceGroupDeployment -Name azwhatif1 -ResourceGroupName azwhatif -TemplateFile .\template.json -Mode Complete -WhatIf -addressPrefix 10.0.0.0/8
```

Can you tell what will happen without running it?

[![azure powershell arm template whatif change](/media/2020/06/arm-whatif-2.png)](/media/2020/06/arm-whatif-2.png)

Interesting. So ARM tells us that due to us changing the `addressPrefix` for the vnet it will modify the configuration for the vnet.

## Executing ARM WhatIf via Azure CLI

The WhatIf API is not only available in PowerShell. The same can be achieved via the [Azure CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-deploy-what-if?tabs=azure-powershell#azure-cli){:target="_blank"} for example.<br>
The commands themselves can also be applied for Resource Group and Subscription Level deployments. I expect that eventually this will also follow for Management Group scoped deployments.

# Azure ARM Template Gotcha

Now, as before, let's remove the `whatif` and actually apply the template. It said it will modify the vnet resource, nothing else. As you are deploying in `-Mode Complete` you will have to accept the warning that resources not referenced in the template but present in the Resource Group will be deleted. Be careful.

```powershell
New-AzResourceGroupDeployment -Name azwhatif1 -ResourceGroupName azwhatif -TemplateFile .\template.json -Mode Complete -addressPrefix 10.0.0.0/8
```

[![azure powershell arm template error](/media/2020/06/arm-whatif-3.png)](/media/2020/06/arm-whatif-3.png)

What happened? Well, infrastructure happened and unfortunately, in almost all cases, to know if an Infrastructure as Code template (ARM, Terraform, Pulumi) will actually **work**, you will have to deploy it. (This is not even an Azure thing, this applies to all clouds)<br>
In this case, Azure wanted to update the address prefix for the vnet, as instructed and as `whatif` confirmed, however, it did not catch that the subnets, that depend on the vnet's configuration, would end up being outside the configured address range. That's why the deployment still failed.<br>
ARM WhatIf is an awesome new feature and I'm super happy that it finally released to the public and customers can start using it.<br>
What do you think of it?