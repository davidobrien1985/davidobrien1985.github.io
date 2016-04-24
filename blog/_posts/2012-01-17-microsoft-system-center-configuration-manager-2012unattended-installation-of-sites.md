---
id: 238
title: Microsoft System Center Configuration Manager 2012–unattended installation of Sites
date: 2012-01-17T18:25:00+00:00
author: "David O'Brien"
layout: single

permalink: /2012/01/microsoft-system-center-configuration-manager-2012unattended-installation-of-sites/
if_slider_image:
  -
categories:
  - Applications
  - Common
  - ConfigMgr 2012
  - Microsoft
  - Operating System
  - SCCM
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - Installation
  - Microsoft
  - SCCM
  - SCCM 2012
  - Script
  - unattended
---
There’s a lot that changed in ConfigMgr2012 (e.g. [Client Log Files](/2011/12/microsoft-configmgr-2012-client-log-files/) ), but also inter-site communication. Most of it is now done via SQL replication and not only via inbox/outbox replication.

According to Microsoft, also the way we now have to install ConfigMgr sites has changed. In SCCM 2007 one could use an ini file to install primary and secondary sites (earlier article: Install Secondary Site unattended).

I asked a lot of Microsoft guys and they all said that it’s not possible anymore to script anything in ConfigMgr2012.

## Script to install

Thanks to Rod Trent ([ConfigMgr 2012 tip: grab the Unattended Installation file during setup](http://myitforum.com/myitforumwp/2012/01/13/configmgr-2012-tip-grab-the-unattended-installation-file-during-setup)) I came upon the “ConfigMgrAutoSave.ini” which has some valuable information regarding the installation process of ConfigMgr sites.

As in 2007, the /script switch of setup.exe still works in ConfigMgr2012.

The command-line would look like this:

`%installsourcefolder%setup.exe /script "%PathToINI% /NoUserInput`

```PowerShell
The ini looks like this:
[Identification]
Action=InstallSecondarySite
[Options]
SiteCode=BLA
SiteName=BLA
SMSInstallDir=C:Microsoft Configuration Manager
ParentSiteCode=011
ParentSiteServer=test.osd.local
AddressType=MS_LAN
UseFQDN=1
[SQLConfigOptions]
SQLServerName=test2.osd.local
DatabaseName=CONFIGMGRSECCM_BLA
InstallSQLExpress=1
SQLExpressCollation=Latin1_General_CI_AS
SQLServicePort=1433
SQLSSBPort=4022
[HierarchyExpansionOption]
ParentSiteNumber=1
ParentSQLServerName=test.osd.local
ParentDatabaseName=CM_BLO
ParentSQLServerSerializedCertificate= *deleted for privacy*
ParentSQLServerMachineSerializedCertificate= *deleted for privacy*
ParentSiteServiceExchangeKey= *deleted for privacy*
ParentSQLServerSSBPort=4022
[Bootstrap]
Action=Install
SetupPath=SMSSETUPbinx64SetupWPF.exe
BuildNumber=7678
InstallMapPath=SMSSETUPinstall.map
SecurityMode=Advanced
SetupSourcePath=C:\ConfigMgr2012_DEU
State=Looking for the SMS CD...
StartTime=1326713845
WorkingDir=
```

This installation runs through until trying to communicate with the parent primary site. This fails and such the whole installation fails.
I believe this is because the primary site doesn’t know that there is a new secondary site being installed.

The same kind of *.ini file can be used to install primary sites, but I didn’t test that as the customer wants to install secondary sites (up to 150) unattended.

I would love to get your ideas on this topic and see if anyone can figure this out.

## [Update]

## Primary Site script installation

Installing a primary site would work with this “ConfigMgrAutoSave.ini”:

```PowerShell
[Identification]
Action=InstallPrimarySite
[Options]
ProductID=%ProductKey%
SiteCode=011
SiteName=011
SMSInstallDir=D:Microsoft Configuration Manager
SDKServer=test.osd.local
RoleCommunicationProtocol=HTTPorHTTPS
ClientsUsePKICertificate=0
PrerequisiteComp=1
PrerequisitePath=\testConfigMgrUpdates
AddServerLanguages=DEU
AddClientLanguages=DEU
MobileDeviceLanguage=0
ManagementPoint=test.osd.local
ManagementPointProtocol=HTTP
DistributionPoint=test.osd.local
DistributionPointProtocol=HTTP
DistributionPointInstallIIS=0
AdminConsole=1
[SQLConfigOptions]
SQLServerName=test.osd.local
DatabaseName=CM_011
SQLSSBPort=4022
[HierarchyExpansionOption]
CCARSiteServer=test0.osd.local
```

I didn’t test this script, but I believe it should work, as I’ve already seen other articles around doing this.


