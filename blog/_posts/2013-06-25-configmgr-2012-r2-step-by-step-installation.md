---
id: 1015
title: 'ConfigMgr 2012 R2 - Step by Step installation'
date: 2013-06-25T06:59:57+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1015
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

Download the bits here: [System Center 2012 R2 available](http://www.david-obrien.net/?p=971)

Download the Windows 8.1 ADK here: [http://go.microsoft.com/fwlink/?LinkId=301570](http://go.microsoft.com/fwlink/?LinkId=301570)

## Before you install –> uninstall

Before you install ConfigMgr 2012 R2, go ahead and uninstall your Windows 8 ADK.
  
ConfigMgr 2012 R2 requires you to install the Windows 8.1 ADK. So uninstall the 8ADK and install 8.1.

## Install Windows 8.1 ADK Preview

Step 1: Specify install location

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb3.png" width="244" height="179" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image3.png)

Step 2: Join CEIP!

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb4.png" width="244" height="181" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image4.png)

Step 3: License Agreement

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb5.png" width="244" height="181" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image5.png)

Step 4: Select the features you want to install

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb6.png" width="244" height="181" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image6.png)

You only need WinPE, USMT and Deployment Tools.

Step 5: Installation

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb7.png" width="244" height="180" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image7.png)

## Install ConfigMgr 2012 R2

Step 1: Run the installer

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb8.png" width="244" height="184" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image8.png)

Step 2: Before you begin

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb9.png" width="244" height="184" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image9.png)

Here are the release notes for ConfigMgr 2012 R2: [http://technet.microsoft.com/library/dn236347.aspx]("http://technet.microsoft.com/library/dn236347.aspx" http://technet.microsoft.com/library/dn236347.aspx)

> This prerelease version does not support an upgrade from previous versions of System Center 2012 Configuration Manager. Install this prerelease version as a new installation of Configuration Manager.

It still worked upgrading my site.

Step 3: Available setup options

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb10.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image10.png)

Step 4: Product Key

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb11.png" width="244" height="186" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image11.png)

Step 5a: Accept the license terms

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb12.png" width="244" height="186" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image12.png)

Step 5b: Prereq licenses

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb13.png" width="244" height="186" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image13.png)

Step 6: Prerequisite downloads

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb14.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image14.png)

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb15.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image15.png)

The downloader will download a new 352MB of prereqs for R2.

Step 7: Server language selection

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb16.png" width="244" height="184" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image16.png)

Step 8: Client language selection

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb17.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image17.png)

Step 9: Settings summary

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb18.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image18.png)

Step 10: Prerequisite check

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb19.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image19.png)

Well, I’m just going to ignore these warnings. I didn’t get them installing SP1 and I just guess that those warnings are false. My AD schema is extended, WSUS is in the correct version (Windows Server 2012), I didn’t mess with the built-in collections and so on <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" alt="Zwinkerndes Smiley" src="http://www.david-obrien.net/wp-content/uploads/2013/06/wlEmoticon-winkingsmile1.png" />

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb20.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image20.png)

23minutes later my upgrade was complete…

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb21.png" width="244" height="185" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image21.png)

## Build number 7884

All build numbers have now been updated to 7884.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb22.png" width="244" height="79" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image22.png)

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="CMtrace" alt="CMtrace" src="http://www.david-obrien.net/wp-content/uploads/2013/06/CMtrace_thumb.jpg" width="244" height="118" border="0" />]("CMtrace" http://www.david-obrien.net/wp-content/uploads/2013/06/CMtrace.jpg)

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/06/image_thumb23.png" width="229" height="186" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/06/image23.png) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


