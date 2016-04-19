---
id: 1409
title: 'Findings in System Center 2012 R2 ConfigMgr, what is really new?'
date: 2013-10-18T22:11:43+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1409
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

If you want to read about this from an older article of mine, look here: [ConfigMgr 2012 R2 Preview - what's new?](http://www.david-obrien.net/2013/06/25/configmgr-2012-r2-whats-new/)

Here are my first few findings (article will probably get some updates over time!). This is just a summary of what I’ve found. I will post explanations later…

## New features in ConfigMgr 2012 R2

Add new Site System Role – Distribution Point

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Add new Distribution Point" alt="Add new Distribution Point" src="http://www.david-obrien.net/wp-content/uploads/2013/10/image_thumb9.png" width="244" height="213" border="0" />]("Add new Distribution Point" http://www.david-obrien.net/wp-content/uploads/2013/10/image9.png)

There’s now a new tickbox available which “Enable and configure this Distribution Point for BranchCache”.

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Extensions for Windows Intune" alt="Extensions for Windows Intune" src="http://www.david-obrien.net/wp-content/uploads/2013/10/image_thumb10.png" width="219" height="244" border="0" />]("Extensions for Windows Intune" http://www.david-obrien.net/wp-content/uploads/2013/10/image10.png)We get a new node for Windows Intune – Extensions.

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Boot Images" alt="Boot Images" src="http://www.david-obrien.net/wp-content/uploads/2013/10/image_thumb11.png" width="281" height="63" border="0" />]("Boot Images" http://www.david-obrien.net/wp-content/uploads/2013/10/image11.png)

With Windows ADK (Assessment and Deployment Toolkit) 8.1 we now have WinPE 5 Boot Images available.

If you want to know how to import WinPE 5 into ConfigMgr 2012 SP1 CU3 (which now supports Server 2012 R2 and Win8.1), look here: [www.niallbrady.com/2013/10/09/how-can-i-manually-add-winpe-5-boot-images-to-system-center-2012-configuration-manager-sp1-cu3/](http://www.niallbrady.com/2013/10/09/how-can-i-manually-add-winpe-5-boot-images-to-system-center-2012-configuration-manager-sp1-cu3/)

&nbsp;

That’s the three ones I found are new to the RTM release compared to Preview, but there’s much more under the hood. For example new Powershell cmdlets (look at my post here: [Powershell - What's new in ConfigMgr 2012 R2](http://www.david-obrien.net/?p=1397)

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


