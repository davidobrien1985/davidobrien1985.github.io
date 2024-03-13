---
title: Azure Policy to Allow Only Known Images
date: 2024-03-13T00:01:30
layout: single-github
permalink: /2024/03/azure-policy-only-known-images
categories:
  - azure
tags:
  - azure
  - policy
  - security
  - governance
github_comments_issueid: 34
---

Managing cloud resources effectively and securely is a top priority for any organisation leveraging cloud services. With Azure's massive ecosystem, it's easy to find yourself navigating through a myriad of resources, particularly virtual machines (VMs) and virtual machine scale sets (VMSS). One area that often poses a challenge is ensuring that only approved and secure images are used for deploying these resources. This is where Azure Policy comes into play, offering a powerful tool to enforce organisational standards and compliance across your Azure resources.

## The Need for Azure Policy

Azure Policy acts as a guardian of your Azure environment. It lets you define and enforce rules that your resources need to comply with. By evaluating resources against these rules, Azure Policy ensures they stay within the boundaries of your corporate and regulatory standards.

## The Challenge: Keeping Deployments in Check

Without oversight, deploying VMs and VMSS from unverified Azure marketplace images can open the door to security risks and compliance nightmares. The freedom to deploy any image, while flexible, can lead to the unintentional use of non-compliant or vulnerable images.

## A Solution: Tailoring Azure Policy for Controlled Deployments

To counter this, the Azure Policy highlighted here provides a straightforward yet effective strategy to limit VM and VMSS deployments to trusted and verified images only.

```json
{
    "properties": {
        "displayName": "Only allow VMs and VMSS from known image publishers" ,
        "description": "This policy enables you to restrict the set of images that can be used to create virtual machines and virtual machine scale sets. It allows you to exclude images from specific publishers, such as third-party vendors, and to exclude images from the Azure Marketplace.",
        "mode": "Indexed",
        "metadata": {
            "version": "1.0.0",
            "category": "Compute"
        },
        "parameters": {
            "publishersToExcludeFromPolicy": {
                 "type": "Array",
                 "metadata": {
                      "displayName": "Excluded Publishers",
                      "description": "An array of publishers to exclude from evaluation, such as Microsoft"
                 },
                 "defaultValue": [
                    "microsoft-ads",
                    "AzureDatabricks",
                    "microsoft-aks"                   
               ]
            }
         },
        "policyRule": {
            "if": {
                "allOf": [
                    {
                       "field": "type",
                       "in": [
                           "Microsoft.Compute/VirtualMachineScaleSets",
                            "Microsoft.Compute/virtualMachines"
                        ]
                    },
                    {
                       "field": "Microsoft.Compute/imagePublisher",
                       "notIn": "[parameters('publishersToExcludeFromPolicy')]"
                    },
                    {
                    "not" : {
                        "anyOf": [
                         {
                           "field": "Microsoft.Compute/virtualMachines/storageProfile.imageReference.id",
                           "contains": "Microsoft.Compute/galleries"
                         }
                       ]
                    }
                  }
                ]
            },        
            "then": {
                "effect": "deny"
            }
        }
    }
}
```

### How Does It Work?

The policy focuses on VM and VMSS resources, aiming to restrict the usage of images to those that are explicitly allowed:

- **Exclusions:** It enables you to allow-list images from specific publishers that you deem trustworthy or compliant, including certain third-party vendors or Azure Marketplace images.
- **Customisation:** You have the flexibility to exclude images from Azure Shared Image Galleries, tailoring the allowed images to fit your organization's unique requirements.

### Breaking Down the Policy

- **`publishersToExcludeFromPolicy` Parameter:** This is where you specify which publishers' images are always allowed. The policy template excludes some by default (like `microsoft-ads`, `AzureDatabricks`, and `microsoft-aks`), but it's designed for you to adjust this list to meet your specific needs.

### The Policy Logic

The policy employs a conditional approach to evaluate whether a deployment should proceed:

- If
  - The resource type is either a VM or VMSS, and
  - The image's publisher isn't on the allow-list, and
  - The image isn't sourced from an Azure Shared Image Gallery.
- Then
  - Deny the deployment.

## Why This Matters

Adopting this policy brings several key benefits to your organisation:

- **Enhanced Security:** It reduces the risk of deploying vulnerable or non-compliant images.
- **Regulatory Compliance:** It helps ensure that deployments adhere to your organisation’s guidelines and external regulations.
- **Cost Control:** It prevents the potential financial surprises associated with using non-standard images.

Apply the policy by following these steps here as documented by Microsoft: [Create and manage policies to enforce compliance](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage#implement-a-new-custom-policy).<br>
Once applied you can test the policy by deploying a VM or VMSS using an image from a publisher that is not excluded from the policy. The deployment should be denied, and you'll receive a message explaining the policy violation as seen in the image below.
[![Policy violation](/media/2024/03/policy-block.png)](/media/2024/03/policy-block.png)

## Wrapping Up

Incorporating this Azure Policy into your governance toolkit is a smart move towards securing and streamlining your Azure environment. It's about making sure that every VM and VMSS deployment aligns with your security and compliance standards. As your cloud footprint grows, keeping these deployments under control becomes not just beneficial but essential.<br>
Adjust and review your policies regularly to stay ahead of new threats and compliance shifts.
