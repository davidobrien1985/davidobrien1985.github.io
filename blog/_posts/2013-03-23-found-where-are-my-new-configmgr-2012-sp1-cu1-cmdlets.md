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
If you take a look at my [recent post about the new CU1 for SCCM 2012 SP1](/2013/03/23/cumulative-update-1-for-configuration-manager-2012/), you’ll notice that I say that the promised new cmdlets are missing from the powershell module.

Well, I found them. :-)

The CU1 setup will update your site and database, if you like, but it won’t update your Admin console. That’s up to you!

# Update the Admin console

The CU1 setup will create some new update packages for you.

![image](/media/2013/03/image23.png)

One of those is the update for the admin console.

Alternative 1:

Deploy this package onto all servers with an admin console.

Alternative 2:

In [\\{siteserver}\SMS_{SiteCode}\hotfix\](file://\\{siteserver}\SMS_{SiteCode}\hotfix\) you’ll find some folders for every KB you installed. Look for KB2817245\AdminConsole\i386 and run the MSP with the following command:

```
msiexec.exe /p configmgr2012adminui-sp1-kb2817245-i386.msp /L*v %TEMP%\configmgr2012adminui-sp1-kb2817245-i386.msp.LOG /q REINSTALL=ALL REINSTALLMODE=mous
```

The logfile will show you the progress.

## Where are my new ConfigMgr cmdlets?

If you now take a look at your AdminConsole install folder and the configurationmanager.psd1 you’ll see that it got updated.

![image](/media/2013/03/image24.png)

Would have been nice for the CU1 to tell us that it won’t update the locally installed console.

Well, all good now. Testing the cmdlets next!