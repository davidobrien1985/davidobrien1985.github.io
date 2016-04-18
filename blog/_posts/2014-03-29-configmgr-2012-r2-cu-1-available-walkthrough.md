---
id: 1673
title: 'ConfigMgr 2012 R2 CU 1 available &#8211; walkthrough'
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

Here you will find what they fixed in this CU1 release (it&#8217;s a lot!): <a href="http://support.microsoft.com/kb/2938441/en-gb" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://support.microsoft.com/kb/2938441/en-gb', 'http://support.microsoft.com/kb/2938441/en-gb']);" title="http://support.microsoft.com/kb/2938441/en-gb"  target="_blank">http://support.microsoft.com/kb/2938441/en-gb</a>

# Changes to Powershell cmdlets

They did really well with this new release and what I&#8217;m really happy about is the fixes they made to the Powershell cmdlets.
  
Read here to see which cmdlets they changed: <a href="http://support.microsoft.com/kb/2932274" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://support.microsoft.com/kb/2932274', 'http://support.microsoft.com/kb/2932274']);" title="http://support.microsoft.com/kb/2932274"  target="_blank">http://support.microsoft.com/kb/2932274</a>

# How to install the CU1 for ConfigMgr 2012 R2

<p style="text-align: left;">
  Here&#8217;s a quick walkthrough of how to install the CU1. After downloading the about 82MB large CU1, you first need to extract it to get to the CM12-R2CU1-KB2938441-X64-ENU.EXE file.<a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic1.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic1.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1674" alt="pic1" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic1-300x201.jpg" width="300" height="201" srcset="/media/2014/03/pic1-300x201.jpg 300w, /media/2014/03/pic1.jpg 908w" sizes="(max-width: 300px) 100vw, 300px" /></a>Execute and accept the EULA.<a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic2.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1675" alt="pic2" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic2.jpg" width="450" height="300" /></a>The pre-req check runs and shows you if there is anything preventing the update from running. I don&#8217;t know why it detected a pending restart, I just rebooted that machine.
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic3.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic3.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1677" alt="pic3" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic3-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic3-300x192.jpg 300w, /media/2014/03/pic3-150x96.jpg 150w" sizes="(max-width: 300px) 100vw, 300px" /></a>After this the installer will ask you if you want to also install the update for the Admin Console (which will also have the update to the Powershell cmdlets), tick that box!
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic4.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic4.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1678" alt="pic4" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic4-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic4-300x192.jpg 300w, /media/2014/03/pic4-150x96.jpg 150w, /media/2014/03/pic4.jpg 941w" sizes="(max-width: 300px) 100vw, 300px" /></a>This update also contains an update to the database. You can chose not to do this, if for example you don&#8217;t have any permissions on the DB. Then you&#8217;ll need to provide your DBA with the SQL file to update the DB, otherwise the CU1 update will not be complete! You will find the update.sql file in a folder similar to this: C:\Program Files\Microsoft Configuration Manager\hotfix\KB2938441
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic5.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic5.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1679" alt="pic5" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic5-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic5-300x193.jpg 300w, /media/2014/03/pic5.jpg 941w" sizes="(max-width: 300px) 100vw, 300px" /></a>You will also want to have the update packages created for the console, the clients and Site Servers / Systems.
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic6.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic6.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1680" alt="pic6" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic6-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic6-300x193.jpg 300w, /media/2014/03/pic6.jpg 938w" sizes="(max-width: 300px) 100vw, 300px" /></a>You can now chose to specify your own names for the update packages and then get an overview of the update process.
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic7.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic7.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1681" alt="pic7" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic7-300x192.jpg" width="300" height="192" srcset="/media/2014/03/pic7-300x192.jpg 300w, /media/2014/03/pic7-150x96.jpg 150w" sizes="(max-width: 300px) 100vw, 300px" /></a>Fire the installation off and watch it go all the way through.
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic8.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic8.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1682" alt="pic8" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic8-300x193.jpg" width="300" height="193" srcset="/media/2014/03/pic8-300x193.jpg 300w, /media/2014/03/pic8-233x150.jpg 233w, /media/2014/03/pic8.jpg 937w" sizes="(max-width: 300px) 100vw, 300px" /></a><a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic9.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic9.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1683" alt="pic9" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic9-300x193.jpg" width="300" height="193" /></a>The hotfix will have created the following packages, it is now your responsibility to deploy them to the correct machines.<br /> Remember, you can&#8217;t use the &#8216;Automatic Upgrade Client feature&#8217; for Cumulative Updates!
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic10.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic10.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1684" alt="pic10" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic10-300x71.jpg" width="300" height="71" srcset="/media/2014/03/pic10-300x71.jpg 300w, /media/2014/03/pic10-250x59.jpg 250w" sizes="(max-width: 300px) 100vw, 300px" /></a>Your clients and consoles will show the new version of 5.0.7958.1203 after successful installation of the CU1 update.<br /> Furthermore on your Site Server you can check the following registry location:<br /> HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Setup
</p>

<p style="text-align: left;">
  <a href="http://www.david-obrien.net/wp-content/uploads/2014/03/pic11.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/03/pic11.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1685" alt="pic11" src="http://www.david-obrien.net/wp-content/uploads/2014/03/pic11-300x162.jpg" width="300" height="162" srcset="/media/2014/03/pic11-300x162.jpg 300w, /media/2014/03/pic11-250x135.jpg 250w, /media/2014/03/pic11-150x81.jpg 150w, /media/2014/03/pic11.jpg 945w" sizes="(max-width: 300px) 100vw, 300px" /></a>Good luck with your update!
</p>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="CM12,ConfigMgr,ConfigMgr2012R2,Configuration+Manager,Powershell,SCCM,scripting" data-count="vertical" data-url="http://www.david-obrien.net/2014/03/configmgr-2012-r2-cu-1-available-walkthrough/">Tweet</a>
</div>
