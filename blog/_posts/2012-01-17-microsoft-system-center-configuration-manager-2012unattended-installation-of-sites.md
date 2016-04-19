---
id: 238
title: Microsoft System Center Configuration Manager 2012–unattended installation of Sites
date: 2012-01-17T18:25:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=238
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
There’s a lot that changed in ConfigMgr2012 (e.g. [Client Log Files](http://www.david-obrien.de/?p=176) ), but also inter-site communication. Most of it is now done via SQL replication and not only via inbox/outbox replication.

According to Microsoft, also the way we now have to install ConfigMgr sites has changed. In SCCM 2007 one could use an ini file to install primary and secondary sites (earlier article: Install Secondary Site unattended).

I asked a lot of Microsoft guys and they all said that it’s not possible anymore to script anything in ConfigMgr2012.

## Script to install

Thanks to Rod Trent ([ConfigMgr 2012 tip: grab the Unattended Installation file during setup](http://myitforum.com/myitforumwp/2012/01/13/configmgr-2012-tip-grab-the-unattended-installation-file-during-setup)) I came upon the “ConfigMgrAutoSave.ini” which has some valuable information regarding the installation process of ConfigMgr sites.

As in 2007, the /script switch of setup.exe still works in ConfigMgr2012. 

The command-line would look like this:

<pre class="csharpcode">%installsourcefolder%setup.exe /script "%PathToINI% /NoUserInput</pre></p> 

The ini looks like this:

<div class="csharpcode">
  <pre><span class="lnum">   1:  </span>[Identification]</pre>
  
  <pre><span class="lnum">   2:  </span>Action=InstallSecondarySite</pre>
  
  <pre><span class="lnum">   3:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">   4:  </span>[Options]</pre>
  
  <pre><span class="lnum">   5:  </span>SiteCode=BLA</pre>
  
  <pre><span class="lnum">   6:  </span>SiteName=BLA</pre>
  
  <pre><span class="lnum">   7:  </span>SMSInstallDir=C:Microsoft Configuration Manager</pre>
  
  <pre><span class="lnum">   8:  </span>ParentSiteCode=011</pre>
  
  <pre><span class="lnum">   9:  </span>ParentSiteServer=test.osd.local</pre>
  
  <pre><span class="lnum">  10:  </span>AddressType=MS_LAN</pre>
  
  <pre><span class="lnum">  11:  </span>UseFQDN=1</pre>
  
  <pre><span class="lnum">  12:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">  13:  </span>[SQLConfigOptions]</pre>
  
  <pre><span class="lnum">  14:  </span>SQLServerName=test2.osd.local</pre>
  
  <pre><span class="lnum">  15:  </span>DatabaseName=CONFIGMGRSECCM_BLA</pre>
  
  <pre><span class="lnum">  16:  </span>InstallSQLExpress=1</pre>
  
  <pre><span class="lnum">  17:  </span>SQLExpressCollation=Latin1_General_CI_AS</pre>
  
  <pre><span class="lnum">  18:  </span>SQLServicePort=1433</pre>
  
  <pre><span class="lnum">  19:  </span>SQLSSBPort=4022</pre>
  
  <pre><span class="lnum">  20:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">  21:  </span>[HierarchyExpansionOption]</pre>
  
  <pre><span class="lnum">  22:  </span>ParentSiteNumber=1</pre>
  
  <pre><span class="lnum">  23:  </span>ParentSQLServerName=test.osd.local</pre>
  
  <pre><span class="lnum">  24:  </span>ParentDatabaseName=CM_BLO</pre>
  
  <pre><span class="lnum">  25:  </span>ParentSQLServerSerializedCertificate= *deleted for privacy*</pre>
  
  <pre><span class="lnum">  26:  </span>ParentSQLServerMachineSerializedCertificate= *deleted for privacy*</pre>
  
  <pre><span class="lnum">  27:  </span>ParentSiteServiceExchangeKey= *deleted for privacy*</pre>
  
  <pre><span class="lnum">  28:  </span>ParentSQLServerSSBPort=4022</pre>
  
  <pre><span class="lnum">  29:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">  30:  </span>[Bootstrap]</pre>
  
  <pre><span class="lnum">  31:  </span>Action=Install</pre>
  
  <pre><span class="lnum">  32:  </span>SetupPath=SMSSETUPbinx64SetupWPF.exe</pre>
  
  <pre><span class="lnum">  33:  </span>BuildNumber=7678</pre>
  
  <pre><span class="lnum">  34:  </span>InstallMapPath=SMSSETUPinstall.map</pre>
  
  <pre><span class="lnum">  35:  </span>SecurityMode=Advanced</pre>
  
  <pre><span class="lnum">  36:  </span>SetupSourcePath=C:ConfigMgr2012_DEU</pre>
  
  <pre><span class="lnum">  37:  </span>State=Looking <span class="kwrd">for</span> the SMS CD...</pre>
  
  <pre><span class="lnum">  38:  </span>StartTime=1326713845</pre>
  
  <pre><span class="lnum">  39:  </span>WorkingDir=</pre>
</div>

This installation runs through until trying to communicate with the parent primary site. This fails and such the whole installation fails.   
I believe this is because the primary site doesn’t know that there is a new secondary site being installed.

The same kind of *.ini file can be used to install primary sites, but I didn’t test that as the customer wants to install secondary sites (up to 150) unattended.

I would love to get your ideas on this topic and see if anyone can figure this out.

## [Update] 

## Primary Site script installation

Installing a primary site would work with this “ConfigMgrAutoSave.ini”:

<div class="csharpcode">
  <pre><span class="lnum">   1:  </span>[Identification]</pre>
  
  <pre><span class="lnum">   2:  </span>Action=InstallPrimarySite</pre>
  
  <pre><span class="lnum">   3:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">   4:  </span>[Options]</pre>
  
  <pre><span class="lnum">   5:  </span>ProductID=%ProductKey%</pre>
  
  <pre><span class="lnum">   6:  </span>SiteCode=011</pre>
  
  <pre><span class="lnum">   7:  </span>SiteName=011</pre>
  
  <pre><span class="lnum">   8:  </span>SMSInstallDir=D:Microsoft Configuration Manager</pre>
  
  <pre><span class="lnum">   9:  </span>SDKServer=test.osd.local</pre>
  
  <pre><span class="lnum">  10:  </span>RoleCommunicationProtocol=HTTPorHTTPS</pre>
  
  <pre><span class="lnum">  11:  </span>ClientsUsePKICertificate=0</pre>
  
  <pre><span class="lnum">  12:  </span>PrerequisiteComp=1</pre>
  
  <pre><span class="lnum">  13:  </span>PrerequisitePath=\testConfigMgrUpdates</pre>
  
  <pre><span class="lnum">  14:  </span>AddServerLanguages=DEU</pre>
  
  <pre><span class="lnum">  15:  </span>AddClientLanguages=DEU</pre>
  
  <pre><span class="lnum">  16:  </span>MobileDeviceLanguage=0</pre>
  
  <pre><span class="lnum">  17:  </span>ManagementPoint=test.osd.local</pre>
  
  <pre><span class="lnum">  18:  </span>ManagementPointProtocol=HTTP</pre>
  
  <pre><span class="lnum">  19:  </span>DistributionPoint=test.osd.local</pre>
  
  <pre><span class="lnum">  20:  </span>DistributionPointProtocol=HTTP</pre>
  
  <pre><span class="lnum">  21:  </span>DistributionPointInstallIIS=0</pre>
  
  <pre><span class="lnum">  22:  </span>AdminConsole=1</pre>
  
  <pre><span class="lnum">  23:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">  24:  </span>[SQLConfigOptions]</pre>
  
  <pre><span class="lnum">  25:  </span>SQLServerName=test.osd.local</pre>
  
  <pre><span class="lnum">  26:  </span>DatabaseName=CM_011</pre>
  
  <pre><span class="lnum">  27:  </span>SQLSSBPort=4022</pre>
  
  <pre><span class="lnum">  28:  </span>&nbsp;</pre>
  
  <pre><span class="lnum">  29:  </span>[HierarchyExpansionOption]</pre>
  
  <pre><span class="lnum">  30:  </span>CCARSiteServer=test0.osd.local</pre>
</div>

I didn’t test this script, but I believe it should work, as I’ve already seen other articles around doing this. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

