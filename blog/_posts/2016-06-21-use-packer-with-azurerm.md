---
title: Preparing Microsoft Azure for Packer
date: 2016-06-21T01:30:30
layout: single
permalink: /2016/06/use-packer-with-azurerm/
categories:
  - Azure
tags:
  - Azure
  - ARM
  - Microsoft
  - PowerShell
  - Packer
---

Looking at my blog one might think that I'm not doing any Microsoft work anymore, or at least I'm off Azure, I'm not.
Even though during day I'm almost completely on AWS, at night I am still working quite a bit on my Azure environment.

I just gave back my MacBook Pro and swapped it for a Microsoft SurfaceBook which means that I also have to go and set up all my dev environment again.
What better opportunity could there be to start fresh and apply some learnings from the last months?

## Packer - tl;dr

[Packer](https://www.packer.io) makes it easy to create custom OS images. It has several [builders](https://www.packer.io/docs/basics/terminology.html#Builders) built-in to support a range of environments that it knows how to interact with. One of these environments is Azure.
There's also obviously an AWS EC2 builder and also one for Docker or VirtualBox.
Packer will spin up a new instance / VM and execute whatever [provisioners](https://www.packer.io/docs/basics/terminology.html#Provisioners) you have configured to run.

Packer for quite a while now has supported Azure, however, only Azure Service Manager, not Azure Resource Manager (ARM), as the Azure RM [SDK for go](https://github.com/Azure/azure-sdk-for-go) has only been released recently.

## Authentication to Azure Resource Manager

Authentication to Azure is a bit more complicated than authentication to AWS, where you just go and create a personalised key and store it in your profile. 
Azure requires you to use the OAuth protocol to authenticate packer against the Azure Active Directory. Packer has a really good documentation online on how to do this with the [azure cli](https://www.packer.io/docs/builders/azure-setup.html), but I prefer to use PowerShell.
If you want you can absolutely use the `azure cli` on Windows as well.

This gist here does all the steps for you to create the Azure AD application, an Azure RM Storage Account where Packer later will save the custom VHD files and then output the information you need to feed into the Packer json file.

<script src="https://gist.github.com/davidobrien1985/56a8d83ff742e70aafa242e54e75c7f3.js"></script>

This script generally only needs to be executed once per subscription.

You might want to adapt [line 14](https://gist.github.com/davidobrien1985/56a8d83ff742e70aafa242e54e75c7f3#file-prepare-azurermforpacker-ps1-L14) to adhere to your own naming convention for Storage Accounts.

Check <https://github.com/mitchellh/packer/blob/master/examples/azure/windows.json> for a good example that should get you started with Packer after executing above PowerShell script. 