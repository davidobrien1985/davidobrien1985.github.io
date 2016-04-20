---
id: 854
title: 'Found! - Where are my new ConfigMgr 2012 SP1 CU1 cmdlets?'
date: 2013-03-23T13:05:48+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=854
permalink: /2013/03/found-where-are-my-new-configmgr-2012-sp1-cu1-cmdlets/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - cmdlet
  - ConfigMgr
  - Configuration Manager
  - CU1
  - Microsoft
  - module
  - Powershell
  - SCCM
  - update
---
If you take a look at my [recent post about the new CU1 for SCCM 2012 SP1]("Cumulative Update 1 for Configuration Manager 2012" http://www.david-obrien.net/2013/03/23/cumulative-update-1-for-configuration-manager-2012/), you’ll notice that I say that the promised new cmdlets are missing from the powershell module.

Well, I found them. <img class="img-responsive wlEmoticon wlEmoticon-smile" style="border-style: none;" alt="Smiley" src="http://www.david-obrien.net/wp-content/uploads/2013/03/wlEmoticon-smile.png" />

The CU1 setup will update your site and database, if you like, but it won’t update your Admin console. That’s up to you!

# Update the Admin console

The CU1 setup will create some new update packages for you.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="Update packages for SCCM 2012 SP1 CU1" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb23.png" width="244" height="64" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image23.png)

One of those is the update for the admin console.

Alternative 1:

Deploy this package onto all servers with an admin console.

Alternative 2:

In [\\{siteserver}\SMS_{SiteCode}\hotfix\](file://\\{siteserver}\SMS_{SiteCode}\hotfix\) you’ll find some folders for every KB you installed. Look for KB2817245\AdminConsole\i386 and run the MSP with the following command:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">msiexec.exe /p configmgr2012adminui-sp1-kb2817245-i386.msp /L*v %TEMP%\configmgr2012adminui-sp1-kb2817245-i386.msp.LOG /q REINSTALL=ALL REINSTALLMODE=mous</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

The logfile will show you the progress.

## Where are my new ConfigMgr cmdlets?

If you now take a look at your AdminConsole install folder and the configurationmanager.psd1 you’ll see that it got updated.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="updated configurationmanager.psd1" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb24.png" width="244" height="49" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image24.png)

Would have been nice for the CU1 to tell us that it won’t update the locally installed console.

Well, all good now. Testing the cmdlets next! 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


