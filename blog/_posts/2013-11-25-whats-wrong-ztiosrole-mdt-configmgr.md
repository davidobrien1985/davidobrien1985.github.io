---
id: 1480
title: 'What&rsquo;s wrong with ZTIOSRole in MDT / ConfigMgr ?'
date: 2013-11-25T10:04:48+00:00
author: "David O'Brien"
layout: single

permalink: /2013/11/whats-wrong-ztiosrole-mdt-configmgr/
categories:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - GPO
  - MDT
  - PowerShell
  - Windows Server 2012 R2
tags:
  - Configuration Manager
  - GPO
  - MDT 2013
  - Powershell
  - SCCM
  - Windows Server 2012 R2
---
# Adding OS Roles via MDT step / Script ZTIOSRole.wsf

While doing a new Windows Build for my Lab I came across an issue which I at first was unable to solve and I’m still not certain as to why this issue occured.

![ZTIosrole](/media/2013/11/image2.png)

I wanted to add some OS features to a Windows Server 2012 R2 installation and was pretty surprised when I saw that none of them got installed.

This is a snippet of ZTIOSRole.log:

```
Microsoft Deployment Toolkit version: 6.2.5019.0    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)

The task sequencer log is located at C:\Users\ADMINI~1\AppData\Local\Temp\1\SMSTSLog\SMSTS.LOG.  For task sequence failures, please consult this log.    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)

Roles will be installed.    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)

No items were specified in variable OSRoles.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

No items were specified in variable OSRoleServices.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

Features specified in Feature:    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

  NET-Framework-Core    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

No items were specified in variable OptionalOSRoles.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

No items were specified in variable OptionalOSRoleServices.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

No items were specified in variable OptionalOSFeatures.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

ZTI Heartbeat: Processing roles (0% complete    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

Property Parameters is now = -FeatureName NET-Framework-Core    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

Using a local or mapped drive, no connection is required.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

Copying source files locally from E:\Deploy\Operating Systems\WS2012R2\sources\sxs    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)

Property Parameters is now = -FeatureName NET-Framework-Core -Source "C:\MININT\sources\X64"    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)

PowerShell version detected: 4.0    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)

About to run: "E:\Deploy\Tools\Modules\Microsoft.BDD.TaskSequenceModule\Microsoft.BDD.TaskSequencePSHost40.exe" "E:\Deploy\Scripts\ZTIOSRolePS.ps1" "C:\MININT\SMSOSD\OSDLOGS" -FeatureName NET-Framework-Core -Source "C:\MININT\sources\X64"    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)

Property Parameters is now =     ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)

ERROR - NET-Framework-Core role processing via PowerShell failed, rc = 10904    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)

Property InstalledRoles001 is now = NET-FRAMEWORK-CORE    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)

One or more roles were not processed successfully    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)

FAILURE: 1: Server Blue Role Processing    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)

ZTIOSRole processing completed successfully.    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)
```

Also ZTIOSRolePS.log wasn’t being created which I found weird.

So what was the problem? No MDT script which used Powershell executed successfully.

## Setting Powershell ExecutionPolicy via GPO

I usually set my Powershell ExecutionPolicy via GPO for my users in my Lab, because I sometimes forget to set it during script runtime. The user I used for auto logon for this Task Sequence also had this GPO applied to him and it was set to “Bypass”.

![GPO PowerShell](/media/2013/11/image3.png)


It looks like this is not a good idea when using MDT with Server 2012 R2 (I didn’t test it with any other OS).

This is a snippet from ZTIOSRole.wsf:

```
iRetVal = RunPowerShellScript("ZTIOSRolePS.ps1", true)
oEnvironment.Item("Parameters") = ""
```

I reset that Policy to “not defined” and re-executed my Task Sequence and now all is fine. No idea why these lines should have a problem when ExecutionPolicy has been previously set via GPO.

![ZTIOsRolePS](/media/2013/11/image4.png)

Both logs get created and all my roles and features are installed.

Anyone else came across this problem and knows why setting an ExecutionPolicy via GPO is a problem?


