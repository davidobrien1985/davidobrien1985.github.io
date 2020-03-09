---
title: Cloud Governance - The Best Way
date: 2020-03-09T00:01:30
layout: single-github
permalink: /2020/03/cloud-governance-pulumi
categories:
  - azure
  - governance
  - devops
tags:
  - cloud
  - pulumi
  - governance
  - security
  - infrastructure
github_comments_issueid: 14
---

Just recently I was tasked to find a product that, amongst others, does the following things:

- check infrastructure code for compliance
- be multi cloud capable
- have a great inner feedback loop / [developer feedback loop](https://dzone.com/articles/the-developer-feedback-loop){:target="_blank"} (whatever you want to call it)

It is fair to say that pretty much all claims by large commercial vendors around "single pane of glass", "great developer feedback", "multi cloud", "automation" have been debunked after just a tiny amount of prodding. See my recent Tweet-rant with #enterprise.

## Cloud Governance

In every environment it is important to have guardrails, policies that make sure that whatever happens, it happens in a controlled fashion, following internal and external regulations.<br>
Microsoft Azure has [Azure Policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview){:target="_blank"} that are deployed to your environments and control to an extent how your infrastructure is supposed to be configured. Immensely powerful and a must-have in every environment.<br>
One big downside to Policies is that these are evaluated only at deployment time. This means I have spent hours writing my infrastructure as code, made it to the deployment step, I kick off the deployment, go get a tea, come back and see errors all over the place because Azure Policy blocked the deployment.<br>
It is good that it does, but would it not be great if there was a way to know about this while we are writing our infracode?<br>
Rhetorical question. **YES.** The answer is, yes.

## Pulumi CrossGuard

You should know by now that I am a fan of [Pulumi](https://pulumi.com){:target="_blank"}. At [XIRUS](https://xirus.com.au){:target="_blank"} we use it as often as possible to write infrastructure as real code for our customers.<br>
Just recently Pulumi released a new feature called _CrossGuard_ or just "Policy As Code". Right now, in March of 2020, it is still in preview, but is already very powerful.<br>
CrossGuard enables us to create policies in code (NodeJS / Typescript) and subsequently test our pulumi infrastructure code against these policies.<br>
I will not go into the basics in this article, they are covered off [here](https://www.pulumi.com/docs/get-started/crossguard/){:target="_blank"} on the official documentation, but using one example show the power of it.

### Free - with a caveat

CrossGuard is a feature available to users of the free pulumi edition and also users of the paid service. It works the same way either way, however, it comes with one operational caveat for the free edition which I will explain next.

## Organisational Cloud Compliance

Typically organisations will have a central team that will define what the cloud (or clouds) must look like. This might be the CloudOps team, infra team, DevOps team, CCoE (Cloud Centre of Excellence), the Security team, or some other team. Which ever it is, they will set rules like

- infrastructure must not be deployed outside specific regions
- only certain VM sizes are allowed
- storage accounts must enforce https

and many others, maybe even following compliance standards like CIS, PCI-DSS or others.<br>
Other teams might not necessarily care too much about "why" these policies are in place (they should though) but they will need to follow them.<br>
The central team will create the organisational policy pack and publish it in the pulumi service at an organisational level. Now every time a user executes `pulumi preview` in one of their stacks inside of this organisation pulumi will check the stack against the policies and will report violations. A great experience. No need to commit any code, no need to wait for code to go through a pipeline. This can be tested from a laptop and if there are violations they will be fixed straight away.<br>
The drawback for the free pulumi version, where you are hosting your [pulumi state on your Azure Storage Account](/2019/10/pulumi-azure-storage){:target="_blank"} for example, there is no organisation, so policies cannot be applied "globally" and must be available to the pulumi CLI in file format when executing `pulumi preview`.<br>
I expect a lot of paying Enterprise customers will be very glad to see such a feature available in the upcoming 2.0 release of pulumi in order to tighten their cloud compliance posture.

## Policy as Code Example

Very common scenarios for Azure Policies are mentioned above and these are easily done with pulumi CrossGuard.

```typescript
import * as azure from "@pulumi/azure";
import { PolicyPack, validateResourceOfType } from "@pulumi/policy";

var regions: Array<string> = ['Australia East', 'australiaeast', 'Australia Southeast', 'australiasoutheast'];
var vmSizes: Array<string> = ['Standard_D1_v2', 'Standard_D2_v2', 'Standard_D3_v2', 'Standard_F2s_v2'];

new PolicyPack("azure-generic", {
    policies: [
        {
            name: "enforce-storage-https",
            description: "Storage Accounts must enforce https",
            enforcementLevel: "mandatory",
            validateResource: validateResourceOfType(azure.storage.Account, (account, args, reportViolation) => {
                if (!account.enableHttpsTrafficOnly) {
                    reportViolation(
                        "Azure Storage Accounts must be set to enforce only HTTPS connections.");
                }
            })
        },
        {
            name: "only-aue-ause",
            description: "only allow resources to be deployed in Australia",
            enforcementLevel: "mandatory",
            validateResource: (args, reportViolation) => {
                if (args.props.hasOwnProperty('location')) {
                    if (!regions.includes(args.props.location)) {
                        reportViolation("Deployment of services outside Australia is prohibited. Region found: " +
                        args.props.location
                        );
                    }
                };
            }
        },
        {
            name: "allowed-vm-size",
            description: "VM Size must be one of allowed values",
            enforcementLevel: "advisory",
            validateResource: validateResourceOfType(azure.compute.VirtualMachine, (vm, args, reportViolation) => {
                if (!vmSizes.includes(vm.vmSize)) {
                    reportViolation(
                        "Virtual Machine Size not allowed. Use one of " +
                        vmSizes
                    )
                };
            })
        }
    ],
});
```

Executing local code against these policies could result in this nice output.

[![Pulumi Policy CrossGuard violation](/media/2020/03/pulumi-policy-crossguard.png)](/media/2020/03/pulumi-policy-crossguard.png)

No more surprises when deploying your infrastructure code.

## Call To Action

What other policies can you think of? Can you see this being used in your environment? Let me know in the comments.