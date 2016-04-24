---
id: 1015
title: 'ConfigMgr 2012 R2 - Step by Step installation'
date: 2013-06-25T06:59:57+00:00
author: "David O'Brien"
layout: single

permalink: /2013/06/configmgr-2012-r2-step-by-step-installation/
categories:
  - ConfigMgr 2012
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
Here’s a step-by-step installation guide for ConfigMgr 2012 R2.

**DO NOT INSTALL THIS IN A PRODUCTION ENVIRONMENT!!!

DO BACKUPS BEFORE INSTALLING THIS TECH PREVIEW!!!**

Download the bits here: [System Center 2012 R2 available](/2013/06/system-center-2012-r2-preview-available/)

Download the Windows 8.1 ADK here: [http://go.microsoft.com/fwlink/?LinkId=301570](http://go.microsoft.com/fwlink/?LinkId=301570)

## Before you install –> uninstall

Before you install ConfigMgr 2012 R2, go ahead and uninstall your Windows 8 ADK.

ConfigMgr 2012 R2 requires you to install the Windows 8.1 ADK. So uninstall the 8ADK and install 8.1.

## Install Windows 8.1 ADK Preview

Step 1: Specify install location

![image](/media/2013/06/image3.png)

Step 2: Join CEIP!

![image](/media/2013/06/image4.png)

Step 3: License Agreement

![image](/media/2013/06/image5.png)

Step 4: Select the features you want to install

![image](/media/2013/06/image6.png)

You only need WinPE, USMT and Deployment Tools.

Step 5: Installation

![image](/media/2013/06/image7.png)

## Install ConfigMgr 2012 R2

Step 1: Run the installer

![image](/media/2013/06/image8.png)

Step 2: Before you begin

![image](/media/2013/06/image9.png)

Here are the release notes for ConfigMgr 2012 R2: [http://technet.microsoft.com/library/dn236347.aspx](http://technet.microsoft.com/library/dn236347.aspx)

> This prerelease version does not support an upgrade from previous versions of System Center 2012 Configuration Manager. Install this prerelease version as a new installation of Configuration Manager.

It still worked upgrading my site.

Step 3: Available setup options

![image](/media/2013/06/image10.png)

Step 4: Product Key

![image](/media/2013/06/image11.png)

Step 5a: Accept the license terms

![image](/media/2013/06/image12.png)

Step 5b: Prereq licenses

![image](/media/2013/06/image13.png)

Step 6: Prerequisite downloads

![image](/media/2013/06/image14.png)

![image](/media/2013/06/image15.png)

The downloader will download a new 352MB of prereqs for R2.

Step 7: Server language selection

![image](/media/2013/06/image16.png)

Step 8: Client language selection

![image](/media/2013/06/image17.png)

Step 9: Settings summary

![image](/media/2013/06/image18.png)

Step 10: Prerequisite check

![image](/media/2013/06/image19.png)

Well, I’m just going to ignore these warnings. I didn’t get them installing SP1 and I just guess that those warnings are false. My AD schema is extended, WSUS is in the correct version (Windows Server 2012), I didn’t mess with the built-in collections and so on ;-)

![image](/media/2013/06/image20.png)

23minutes later my upgrade was complete…

![image](/media/2013/06/image21.png)

## Build number 7884

All build numbers have now been updated to 7884.

![image](/media/2013/06/image22.png)

![CMTrace](/media/2013/06/CMtrace.jpg)

![image](/media/2013/06/image23.png)

