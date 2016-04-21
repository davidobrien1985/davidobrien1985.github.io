---
id: 1450
title: Hotfix available for Configuration Manager 2012 R2
date: 2013-11-11T15:35:58+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1450
permalink: /2013/11/hotfix-available-configuration-manager-2012-r2/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - hotfix
  - Microsoft
  - SCCM
  - System Center
tags:
  - ConfigMgr
  - Configuration Manager
  - Hotfix
  - Microsoft
  - System Center
---
Last Friday Microsoft released the ‘not-so-long-but-even-more’-awaited hotfix for two issues that came with Microsoft System Center 2012 R2 Configuration Manager.

That download is available here: [http://support.microsoft.com/kb/2905002](http://support.microsoft.com/kb/2905002)

It fixes the following two issues: (source Support.microsoft.com)

**Issue 1**

After you enable the PXE Service Point role on an instance of a specific distribution point, or you select the **Deploy this boot image from the PXE-enabled distribution point** property of a boot image, the Windows Deployment Service (WDS) stops running. Additionally, entries that resemble the following are logged in the Windows Application log:

<pre>Faulting application name: svchost.exe_WDSServer, version: 6.3.9600.16384, time stamp: 0x5215dfe3
Faulting module name: MSVCR100.dll, version: 10.0.40219.1, time stamp: 0x4d5f034a
Exception code: 0xc0000005
Fault offset: 0x000000000005f61a
Faulting process id: 0xae4
Faulting application start time: 0x01cec5d767184634
Faulting application path: C:\Windows\system32\svchost.exe
Faulting module path: C:\Program Files\Microsoft Configuration Manager\bin\x64\MSVCR100.dll

**Note** This problem affects only distribution points that are installed on site servers.

**Issue 2**

When operating system image files are downloaded to Configuration Manager 2012 R2 clients, you may find that the download takes longer than it did in previous versions of Configuration Manager 2012 clients. You may see this behavior when the target client is running Windows PE or a full Windows operating system.

&nbsp;

## Background Information on these issues

Fellow **MVP Johan Arwidmark** ([www.deploymentresearch.com](http://www.deploymentresearch.com) ) wrote a nice guide on how to Upgrade from ConfigMgr 2012 SP1 to R2 and also highlighted those two issues and some workarounds.

[http://www.deploymentresearch.com/Research/tabid/62/EntryId/117/A-Geeks-Guide-for-upgrading-to-ConfigMgr-2012-R2-and-MDT-2013.aspx](http://www.deploymentresearch.com/Research/tabid/62/EntryId/117/A-Geeks-Guide-for-upgrading-to-ConfigMgr-2012-R2-and-MDT-2013.aspx)

Please go to his site for more information.

I already installed that hotfix in my Lab and it went without an issue. Up until now I have only seen one feedback mail by another MVP who was affected by Issue No. 2 and that hotfix dramatically increased his download speed from 55MB/s to 1,2GB/s!

Now is the time to do your backups again, test them and then upgrade your Labs and see if all goes well.

## New Update Packages

With this hotfix KB2905002 come 4 new update packages that need to be deployed in your environment:

[<img class="img-responsive aligncenter size-full wp-image-1458" alt="KB2905002" src="http://www.david-obrien.net/wp-content/uploads/2013/11/updates_console.jpg" width="905" height="210" srcset="/media/2013/11/updates_console-250x58.jpg 250w, /media/2013/11/updates_console.jpg 905w" sizes="(max-width: 905px) 100vw, 905px" />](http://www.david-obrien.net/wp-content/uploads/2013/11/updates_console.jpg)

&nbsp;

[<img class="img-responsive aligncenter size-full wp-image-1459" alt="KB2905002" src="http://www.david-obrien.net/wp-content/uploads/2013/11/updates_filesystem.jpg" width="496" height="180" />](http://www.david-obrien.net/wp-content/uploads/2013/11/updates_filesystem.jpg)

Take special care deploying those Client updates during Task Sequences. I usually use this technique: [http://deploymentramblings.wordpress.com/2013/08/22/installing-configmgr-2012-sp1-cu2-during-osd/](http://deploymentramblings.wordpress.com/2013/08/22/installing-configmgr-2012-sp1-cu2-during-osd/)

Good luck! 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

