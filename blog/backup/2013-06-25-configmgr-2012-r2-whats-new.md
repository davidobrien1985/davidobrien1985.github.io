---
id: 1048
title: 'ConfigMgr 2012 R2 - what&rsquo;s new?'
date: 2013-06-25T07:53:38+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1048
permalink: /2013/06/configmgr-2012-r2-whats-new/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Microsoft
  - System Center
tags:
  - ConfigMgr2012R2
  - Configuration Manager
  - Microsoft
  - System Center
---
Here are a first few glimpses at my new Configuration Manager 2012 R2 site, before I have to go and work …

An overview of new features are available at Henk Hoogendoorn’s blog: <a href="http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw', 'http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw']);" >http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw</a>

But how do these new features look like?

## Powershell cmdlets now x64

Up until ConfigMgr 2012 SP1 CU2 the Powershell module was x86 (32bit) only. This was sometimes a bit annoying when writing scripts and you needed to access 64bit resources and then 32bit stuff again. But now these problems are gone, Microsoft blessed us with a 64bit Powershell module.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/PScmdlets.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/PScmdlets.jpg', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="PScmdlets" alt="64bit Powershell" src="http://www.david-obrien.net/wp-content/uploads/2013/06/PScmdlets_thumb.jpg" width="270" height="39" border="0" /></a>

Now all these problems are gone, we can script in 64bit Powershell… or can we?!?!

These are the cmdlets that (at this stage of tech preview!) are not available in 64bit, we still need to run these from a 32bit Powershell:

>   * Add-CMDistributionPoint
>   * Export-AntiMalwarePolicy
>   * Get-CMAntiMalwarePolicy
>   * Get-CMClientSettings
>   * New-CMSecondarySite
>   * New-CMTaskSequenceMedia
>   * New-CMVhd
>   * Publish-CMPrestageContent
>   * Publish-CMPrestageContentTaskSequence
>   * Set-CMAntiMalwarePolicy
>   * Set-CMClientSettings
>   * Set-CMDistributionPoint
>   * Set-CMVhd
>   * Start-CMDistributionPointUpgrade

## Task Sequences

There are quite some new options available inside the Task sequences.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image24.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image24.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb24.png" width="244" height="158" border="0" /></a>

We can now install previously captured images into VHDs. Those then can be imported into SCVMM and deployed from there.

Here are the new options inside the TS:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image25.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image25.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb25.png" width="244" height="170" border="0" /></a>

It’s been already said that some MDT features have been put natively into ConfigMgr. And here they are!

### Run Powershell Script

We are now able to run powershell scripts directly from the TS without MDT and without using the ‘run commandline’ step.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image26.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image26.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb26.png" width="244" height="132" border="0" /></a>

This will be used most of the time by me!

### Set dynamic variables

Another MDT step put into ConfigMgr. ‘Set dynamic variables’ during the Task Sequence depending on dynamic rules and variables you configure. If any of it are true, the variables wil be set.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image27.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image27.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb27.png" width="244" height="189" border="0" /></a>

You can even chose from the existing TS variables that are available during TS execution.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image28.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image28.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb28.png" width="219" height="244" border="0" /></a>

### Check readiness

Another powerful step for your Task Sequence. You can now check the readiness of the client the TS is running on and then decide if the client is suitable to go any further with the installation.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image29.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image29.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb29.png" width="244" height="109" border="0" /></a>

## Client Settings

What Client Settings are actually applied to this or that client? Ever asked yourself that question? If you had a few Client Settings configured and your devices were in more than one collection with settings deployed to, then it was either a lot of work clicking around and figuring out which settings were applied or you had to script a bit.

Now we have a resultant set of client settings:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image30.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image30.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb30.png" width="244" height="50" border="0" /></a>

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image31.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image31.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb31.png" width="244" height="188" border="0" /></a>

## Boot images

As we now moved to R2 and also the new OSes are coming out, also the Boot Images got updated from Windows 8 to Windows 8.1

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image32.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image32.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb32.png" width="244" height="34" border="0" /></a>

The two at the top are the new ones, the one below is the WinPE of Windows 8.

It is now again possible to import and deploy WinPE 3.1, there was a problem on certain hardware with WinPE 4 (see here: <a href="http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html', 'http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html']);" title="http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html">http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html</a>).

## Virtual Hard Disks

There is this node ‘Virtual Hard Disks’ where I suppose one can create a new VHD, but it is greyed out in my console.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/06/image33.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/06/image33.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb33.png" width="244" height="227" border="0" /></a>

&nbsp;

I will update this post with more info in the future. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr2012R2,Configuration+Manager,Microsoft,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2013/06/configmgr-2012-r2-whats-new/">Tweet</a>
</div>

