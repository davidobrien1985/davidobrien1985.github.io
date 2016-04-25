---
id: 1409
title: Findings in System Center 2012 R2 ConfigMgr, what is really new
date: 2013-10-18T22:11:43+00:00

layout: single

permalink: /2013/10/findings-system-center-2012-r2-configmgr-whats-really-new/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
tags:
  - CM12
  - CM12R2
  - ConfigMgr
  - ConfigMgr2012R2
  - Microsoft
  - SysCtr
  - System Center
---
I have finally deployed a Configuration Manager Site on Windows Azure. Quite an experience! I now can finally put a lot of my Lab workloads from my notebook into the cloud!

But that’s not what I wanted to tell you.

I already worked extensively with the R2 Preview of ConfigMgr and certainly all of you have read about the new features and gimmicks we can now use in R2.

If you want to read about this from an older article of mine, look here: [ConfigMgr 2012 R2 Preview - what's new?](/2013/06/25/configmgr-2012-r2-whats-new/)

Here are my first few findings (article will probably get some updates over time!). This is just a summary of what I’ve found. I will post explanations later…

## New features in ConfigMgr 2012 R2

Add new Site System Role – Distribution Point

![Add new Distribution Point](/media/2013/10/image9.png)

There’s now a new tickbox available which “Enable and configure this Distribution Point for BranchCache”.

![Extensions for Windows Intune](/media/2013/10/image10.png)

We get a new node for Windows Intune – Extensions.

![Boot images](/media/2013/10/image11.png)

With Windows ADK (Assessment and Deployment Toolkit) 8.1 we now have WinPE 5 Boot Images available.

If you want to know how to import WinPE 5 into ConfigMgr 2012 SP1 CU3 (which now supports Server 2012 R2 and Win8.1), look here: [www.niallbrady.com/2013/10/09/how-can-i-manually-add-winpe-5-boot-images-to-system-center-2012-configuration-manager-sp1-cu3/](http://www.niallbrady.com/2013/10/09/how-can-i-manually-add-winpe-5-boot-images-to-system-center-2012-configuration-manager-sp1-cu3/)

That’s the three ones I found are new to the RTM release compared to Preview, but there’s much more under the hood. For example new Powershell cmdlets (look at my post here: [Powershell - What's new in ConfigMgr 2012 R2](/2013/10/powershell-whats-new-in-configmgr2012r2/)



