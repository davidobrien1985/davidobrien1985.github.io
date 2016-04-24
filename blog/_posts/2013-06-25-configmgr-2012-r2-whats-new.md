---
id: 1048
title: 'ConfigMgr 2012 R2 - what&rsquo;s new?'
date: 2013-06-25T07:53:38+00:00
author: "David O'Brien"
layout: single

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

An overview of new features are available at Henk Hoogendoorn’s blog: [http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw](http://henkhoogendoorn.blogspot.de/2013/06/updates-and-new-features-in-configmgr.html?spref=tw)

But how do these new features look like?

## Powershell cmdlets now x64

Up until ConfigMgr 2012 SP1 CU2 the Powershell module was x86 (32bit) only. This was sometimes a bit annoying when writing scripts and you needed to access 64bit resources and then 32bit stuff again. But now these problems are gone, Microsoft blessed us with a 64bit Powershell module.

![PSCmdlets](/media/2013/06/PScmdlets.jpg)

Now all these problems are gone, we can script in 64bit Powershell… or can we?!?!

These are the cmdlets that (at this stage of tech preview!) are not available in 64bit, we still need to run these from a 32bit Powershell:

* Add-CMDistributionPoint
* Export-AntiMalwarePolicy
* Get-CMAntiMalwarePolicy
* Get-CMClientSettings
* New-CMSecondarySite
* New-CMTaskSequenceMedia
* New-CMVhd
* Publish-CMPrestageContent
* Publish-CMPrestageContentTaskSequence
* Set-CMAntiMalwarePolicy
* Set-CMClientSettings
* Set-CMDistributionPoint
* Set-CMVhd
* Start-CMDistributionPointUpgrade

## Task Sequences

There are quite some new options available inside the Task sequences.

![image](/media/2013/06/image24.png)

We can now install previously captured images into VHDs. Those then can be imported into SCVMM and deployed from there.

Here are the new options inside the TS:

![image](/media/2013/06/image25.png)

It’s been already said that some MDT features have been put natively into ConfigMgr. And here they are!

### Run Powershell Script

We are now able to run powershell scripts directly from the TS without MDT and without using the ‘run commandline’ step.

![image](/media/2013/06/image26.png)

This will be used most of the time by me!

### Set dynamic variables

Another MDT step put into ConfigMgr. ‘Set dynamic variables’ during the Task Sequence depending on dynamic rules and variables you configure. If any of it are true, the variables wil be set.

![image](/media/2013/06/image27.png)

You can even chose from the existing TS variables that are available during TS execution.

![image](/media/2013/06/image28.png)

### Check readiness

Another powerful step for your Task Sequence. You can now check the readiness of the client the TS is running on and then decide if the client is suitable to go any further with the installation.

![image](/media/2013/06/image29.png)

## Client Settings

What Client Settings are actually applied to this or that client? Ever asked yourself that question? If you had a few Client Settings configured and your devices were in more than one collection with settings deployed to, then it was either a lot of work clicking around and figuring out which settings were applied or you had to script a bit.

Now we have a resultant set of client settings:

![image](/media/2013/06/image30.png)

![image](/media/2013/06/image31.png)

## Boot images

As we now moved to R2 and also the new OSes are coming out, also the Boot Images got updated from Windows 8 to Windows 8.1

![image](/media/2013/06/image32.png)

The two at the top are the new ones, the one below is the WinPE of Windows 8.

It is now again possible to import and deploy WinPE 3.1, there was a problem on certain hardware with WinPE 4 (see here: [http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html](http://henkhoogendoorn.blogspot.nl/2013/05/bsod-in-vmware-41-when-booting-with.html)).

## Virtual Hard Disks

There is this node ‘Virtual Hard Disks’ where I suppose one can create a new VHD, but it is greyed out in my console.

![image](/media/2013/06/image33.png)

I will update this post with more info in the future.


