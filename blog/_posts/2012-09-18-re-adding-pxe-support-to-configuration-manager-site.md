---
id: 464
title: Re-adding PXE support to Configuration Manager Site
date: 2012-09-18T14:27:39+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=464
permalink: /2012/09/re-adding-pxe-support-to-configuration-manager-site/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - System Center
  - System Center Configuration Manager
  - Technet
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - error
  - Microsoft
  - Service Manager
  - System Center
  - System Center Configuration Manager
  - Technet
---
I already tweeted about that, but I thought this is worth a blog post, although I don’t have a solution yet.

When I try to add PXE support (or re-add it) to my Distribution Point, the following happens:

The SMS\_DISTRIBUTION\_MANAGER process starts the installation of all the components needed for PXE support.

  1. The vcredist are being installed
  2. WDS Server role gets installed
  3. PXE Provider is initialized
  4. WDS Service gets started and configured

# Event ID 7000 : not a valid Win32 application

After all that I have a look at my fancy Server Manager in Windows Server 2012 and see that some services couldn’t be started (e.g. WDS services, WSUS service). The error in the eventlog is EventID 7000, stating that the application is not a valid Win32 application.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb1.png" alt="image" width="387" height="106" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image1.png)

During my search for a problem I also booted my server and after reboot I was greeted with this message, which was totally new to me:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb2.png" alt="image" width="291" height="116" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image2.png)

At first I chose to ignore this error and have a look myself and the message wasn’t wrong, there IS a file called program (no extension) on my Systemdrive. How could that happen?

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb3.png" alt="image" width="270" height="113" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image3.png)I opened this file in Notepad and saw that this file is actually a log file of the vcredist installation. How did that happen?

# 

# 

# Digging for errors

A clue to why the log file was named “Program” is in the distmgr.log of ConfigMgr.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb4.png" alt="image" width="345" height="22" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image4.png)

It looks like if the “” (quotation marks) were missing in the command line for the logfile path. Windows would then go and interpret the logfile as “C:Program”. The proof is in the “Program” file:
  
[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb5.png" alt="image" width="289" height="97" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image5.png)

It clearly says: PROPERTY CHANGE: Adding MsiLogFileLocation property. Its value is 'c:program'.

I don’t know if this is a bug or has something to do with my environment, but it’s annoying <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/09/wlEmoticon-winkingsmile.png" alt="Winking smile" />

One can resolve this error by renaming the file to any other name you like. After that all the services are able to start like before.

Searching for this EventID 7000 I found the following Technet article: [http://support.microsoft.com/default.aspx?scid=kb;en-us;Q325680](http://support.microsoft.com/default.aspx?scid=kb;en-us;Q325680) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


