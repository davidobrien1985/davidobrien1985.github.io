---
id: 1673
title: 'ConfigMgr 2012 R2 CU 1 available - walkthrough'
date: 2014-03-29T08:54:16+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1673
permalink: /2014/03/configmgr-2012-r2-cu-1-available-walkthrough/
categories:
  - CM12
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - Uncategorized
tags:
  - CM12
  - ConfigMgr
  - ConfigMgr2012R2
  - Configuration Manager
  - Powershell
  - SCCM
  - scripting
---
Microsoft just released the Cumulative Update 1 for Configuration Manager 2012 R2.

Here you will find what they fixed in this CU1 release (it's a lot!): [http://support.microsoft.com/kb/2938441/en-gb]("http://support.microsoft.com/kb/2938441/en-gb" http://support.microsoft.com/kb/2938441/en-gb)

# Changes to Powershell cmdlets

They did really well with this new release and what I'm really happy about is the fixes they made to the Powershell cmdlets.
  
Read here to see which cmdlets they changed: [http://support.microsoft.com/kb/2932274]("http://support.microsoft.com/kb/2932274" http://support.microsoft.com/kb/2932274)

# How to install the CU1 for ConfigMgr 2012 R2

<p style="text-align: left;">
  Here's a quick walkthrough of how to install the CU1. After downloading the about 82MB large CU1, you first need to extract it to get to the CM12-R2CU1-KB2938441-X64-ENU.EXE file.[<img class="img-responsive aligncenter size-medium wp-image-1674" alt="pic1" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic1-300x201.jpg" width="300" height="201" srcset="/media/2014/03/pic1-300x201.jpg 300w, /media/2014/03/pic1.jpg 908w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic1.jpg)Execute and accept the EULA.[<img class="img-responsive aligncenter  wp-image-1675" alt="pic2" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic2.jpg" width="450" height="300" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic2.jpg)The pre-req check runs and shows you if there is anything preventing the update from running. I don't know why it detected a pending restart, I just rebooted that machine.
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1677" alt="pic3" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic3-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic3-300x192.jpg 300w, /media/2014/03/pic3-150x96.jpg 150w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic3.jpg)After this the installer will ask you if you want to also install the update for the Admin Console (which will also have the update to the Powershell cmdlets), tick that box!
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1678" alt="pic4" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic4-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic4-300x192.jpg 300w, /media/2014/03/pic4-150x96.jpg 150w, /media/2014/03/pic4.jpg 941w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic4.jpg)This update also contains an update to the database. You can chose not to do this, if for example you don't have any permissions on the DB. Then you'll need to provide your DBA with the SQL file to update the DB, otherwise the CU1 update will not be complete! You will find the update.sql file in a folder similar to this: C:\Program Files\Microsoft Configuration Manager\hotfix\KB2938441
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1679" alt="pic5" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic5-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic5-300x193.jpg 300w, /media/2014/03/pic5.jpg 941w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic5.jpg)You will also want to have the update packages created for the console, the clients and Site Servers / Systems.
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1680" alt="pic6" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic6-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic6-300x193.jpg 300w, /media/2014/03/pic6.jpg 938w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic6.jpg)You can now chose to specify your own names for the update packages and then get an overview of the update process.
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1681" alt="pic7" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic7-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic7-300x192.jpg 300w, /media/2014/03/pic7-150x96.jpg 150w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic7.jpg)Fire the installation off and watch it go all the way through.
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1682" alt="pic8" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic8-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic8-300x193.jpg 300w, /media/2014/03/pic8-233x150.jpg 233w, /media/2014/03/pic8.jpg 937w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic8.jpg)[<img class="img-responsive aligncenter size-medium wp-image-1683" alt="pic9" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic9-300x193.jpg" width="300" height="193" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic9.jpg)The hotfix will have created the following packages, it is now your responsibility to deploy them to the correct machines.<br /> Remember, you can't use the 'Automatic Upgrade Client feature' for Cumulative Updates!
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1684" alt="pic10" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic10-300x71.jpg" width="300" height="71" srcset="/media/2014/03/pic10-300x71.jpg 300w, /media/2014/03/pic10-250x59.jpg 250w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic10.jpg)Your clients and consoles will show the new version of 5.0.7958.1203 after successful installation of the CU1 update.<br /> Furthermore on your Site Server you can check the following registry location:<br /> HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Setup
</p>

<p style="text-align: left;">
  [<img class="img-responsive aligncenter size-medium wp-image-1685" alt="pic11" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic11-300x162.jpg" width="300" height="162" srcset="/media/2014/03/pic11-300x162.jpg 300w, /media/2014/03/pic11-250x135.jpg 250w, /media/2014/03/pic11-150x81.jpg 150w, /media/2014/03/pic11.jpg 945w" sizes="(max-width: 300px) 100vw, 300px" />](http://www.david-obrien.net/wp-content/uploads/2014/03/pic11.jpg)Good luck with your update!
</p>

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


