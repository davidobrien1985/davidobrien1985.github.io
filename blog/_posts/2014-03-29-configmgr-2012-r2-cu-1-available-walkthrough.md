---
id: 1673
title: 'ConfigMgr 2012 R2 CU 1 available - walkthrough'
date: 2014-03-29T08:54:16+00:00

layout: single

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

Here you will find what they fixed in this CU1 release (it's a lot!): [http://support.microsoft.com/kb/2938441/en-gb](http://support.microsoft.com/kb/2938441/en-gb)

# Changes to Powershell cmdlets

They did really well with this new release and what I'm really happy about is the fixes they made to the Powershell cmdlets.

Read here to see which cmdlets they changed: [http://support.microsoft.com/kb/2932274](http://support.microsoft.com/kb/2932274)

# How to install the CU1 for ConfigMgr 2012 R2

Here's a quick walkthrough of how to install the CU1. After downloading the about 82MB large CU1, you first need to extract it to get to the CM12-R2CU1-KB2938441-X64-ENU.EXE file.
![image](/media/2014/03/pic1.jpg)
Execute and accept the EULA.
![image](/media/2014/03/pic2.jpg)
The pre-req check runs and shows you if there is anything preventing the update from running. I don't know why it detected a pending restart, I just rebooted that machine.

![image](/media/2014/03/pic3.jpg)After this the installer will ask you if you want to also install the update for the Admin Console (which will also have the update to the Powershell cmdlets), tick that box!

![image](/media/2014/03/pic4.jpg)
This update also contains an update to the database. You can chose not to do this, if for example you don't have any permissions on the DB. Then you'll need to provide your DBA with the SQL file to update the DB, otherwise the CU1 update will not be complete! You will find the update.sql file in a folder similar to this: C:\Program Files\Microsoft Configuration Manager\hotfix\KB2938441

![image](/media/2014/03/pic5.jpg)
You will also want to have the update packages created for the console, the clients and Site Servers / Systems.

![image](/media/2014/03/pic6.jpg)
You can now chose to specify your own names for the update packages and then get an overview of the update process.

![image](/media/2014/03/pic7.jpg)

Fire the installation off and watch it go all the way through.

![image](/media/2014/03/pic8.jpg)
![image](/media/2014/03/pic9.jpg)

The hotfix will have created the following packages, it is now your responsibility to deploy them to the correct machines. Remember, you can't use the 'Automatic Upgrade Client feature' for Cumulative Updates!

![image](/media/2014/03/pic10.jpg)

Your clients and consoles will show the new version of 5.0.7958.1203 after successful installation of the CU1 update. Furthermore on your Site Server you can check the following registry location:

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Setup
```

![image]](/media/2014/03/pic11.jpg)

Good luck with your update!


