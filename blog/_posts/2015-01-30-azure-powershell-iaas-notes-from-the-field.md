---
id: 2944
title: 'Azure PowerShell IaaS - Notes from the field'
date: 2015-01-30T12:18:47+00:00
author: "David O'Brien"
layout: single

permalink: /2015/01/azure-powershell-iaas-notes-from-the-field/
categories:
  - automation
  - Azure
  - Microsoft
  - PowerShell
  - SDK
tags:
  - Azure
  - Microsoft
  - Powershell
  - SDK
---
I was tasked to write a bunch of PowerShell scripts to deploy a new Active Directory Domain Services (ADDS) Server onto Azure.

The end goal would be to have some kind of synchronisation running between the off-premises and the on-premises environment, the off-prem basically being the Test/Dev environment for that customer.

Over the last couple of days I wrote down some notes on about what I did and what curiosities I found.

If you haven’t yet started using the Azure PowerShell SDK, go check out [http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/](http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/) . This will help you get started.

# PowerShell SDK for Azure

* as with everything you are trying to automate, it **helps a lot** to have a basic idea of how stuff works.
* there are 509 cmdlets in the Azure module. That’s a lot!

![image](/media/2015/01/1422578282_full.png)

* the whole SDK is likely to change over time, the documentation clearly says so. So, after you go and updated your SDK version, go check if everything still works as expected!

![image](/media/2015/01/1422434319_full.png)

* you can and should do as much yourself as you can, don’t rely on built-in logic that creates everything for you if not specified, like creating storage accounts (New-AzureStorageAccount) , Cloud Services (New-AzureService) and such if you run New-AzureVM without having anything created beforehand
* New-AzureStorageAccount only accepts a name parameter that is between 3 and 24 characters long, lowercase and only letters and numbers. Why only lowercase?
* In order to run New-AzureStorageAccount you first need to run [Set-AzureSubscription](https://msdn.microsoft.com/en-us/library/dn495189.aspx) with the CurrentStorageAccountName parameter
* [Remove-AzureVM](https://msdn.microsoft.com/en-us/library/azure/dn495264.aspx) is a good example of “bad” / old documentation, it’s missing the parameter -DeleteVHD. The article states that the cmdlet doesn’t remove the underlying VHD. Using the DeleteVHD param it now does. Strangely enough, “Get-Help Remove-AzureVM -Full” kind of contradicts itself here.

![image](/media/2015/01/1422492443_full.png)

I will continue to update this article over time. These are just my first findings (and personal notes for me to remember in the future) on this topic.

Do you have something to add to this list?

Until then, have fun automating.


