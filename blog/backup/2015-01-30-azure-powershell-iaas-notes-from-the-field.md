---
id: 2944
title: 'Azure PowerShell IaaS - Notes from the field'
date: 2015-01-30T12:18:47+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2944
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

If you haven’t yet started using the Azure PowerShell SDK, go check out <a href="http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/', 'http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/']);" title=""  target="_blank">http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/</a> . This will help you get started.

# PowerShell SDK for Azure {.}

  * as with everything you are trying to automate, it **helps a lot** to have a basic idea of how stuff works.
  * there are 509 cmdlets in the Azure module. That’s a lot!

<a href="/media/2015/01/1422578282_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/01/1422578282_full.png', '']);" target="_blank"><img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422578282_thumb.png" alt="" align="middle" /></a>

  * the whole SDK is likely to change over time, the documentation clearly says so. So, after you go and updated your SDK version, go check if everything still works as expected!

<p class="">
  <a href="/media/2015/01/1422434319_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/01/1422434319_full.png', '']);" target="_blank"><img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422434319_thumb.png" alt="" align="middle" /></a>
</p>

  * you can and should do as much yourself as you can, don’t rely on built-in logic that creates everything for you if not specified, like creating storage accounts (New-AzureStorageAccount) , Cloud Services (New-AzureService) and such if you run New-AzureVM without having anything created beforehand
  * <a href="https://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://www.twitter.com/david_obrien', 'New-AzureStorageAccount']);" title=""  target="_blank">New-AzureStorageAccount</a> only accepts a name parameter that is between 3 and 24 characters long, lowercase and only letters and numbers. Why only lowercase?
  * In order to run New-AzureStorageAccount you first need to run <a href="https://msdn.microsoft.com/en-us/library/dn495189.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://msdn.microsoft.com/en-us/library/dn495189.aspx', 'Set-AzureSubscription']);" title=""  target="_blank">Set-AzureSubscription</a> with the CurrentStorageAccountName parameter
  * <a href="https://msdn.microsoft.com/en-us/library/azure/dn495264.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://msdn.microsoft.com/en-us/library/azure/dn495264.aspx', 'Remove-AzureVM']);" title=""  target="_blank">Remove-AzureVM</a> is a good example of “bad” / old documentation, it’s missing the parameter -DeleteVHD. The article states that the cmdlet doesn’t remove the underlying VHD. Using the DeleteVHD param it now does. Strangely enough, “Get-Help Remove-AzureVM -Full” kind of contradicts itself here.

<a href="/media/2015/01/1422492443_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/01/1422492443_full.png', '']);" target="_blank"><img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422492443_thumb.png" alt="" align="middle" /></a>

<p class="">
  <p>
    I will continue to update this article over time. These are just my first findings (and personal notes for me to remember in the future) on this topic.
  </p>
  
  <p>
    Do you have something to add to this list?
  </p>
  
  <p>
    Until then, have fun automating.
  </p>
  
  <p>
    - <a id="current_selection" href="#">David</a> 
    
    <div style="float: right; margin-left: 10px;">
      <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Azure,Microsoft,Powershell,SDK" data-count="vertical" data-url="http://www.david-obrien.net/2015/01/azure-powershell-iaas-notes-from-the-field/">Tweet</a>
    </div>

