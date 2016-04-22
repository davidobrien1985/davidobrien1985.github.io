---
id: 842
title: Cumulative Update 1 for Configuration Manager 2012
date: 2013-03-23T10:19:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=842
permalink: /2013/03/cumulative-update-1-for-configuration-manager-2012/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - CU1
  - Microsoft
  - SCCM
  - System Center
  - update
---
This night the CU1 for SCCM 2012 got released and I just want to share with you the process of update. The download is available here: [http://support.microsoft.com/kb/2817245/en-us](http://support.microsoft.com/kb/2817245/en-us) Before updating your site, please do a **backup** of your site and verify that it was successful!

# Step-by-step installation of CU1 for ConfigMgr 2012 SP1

For those of you who like reading logfiles, the whole update is logged under C:\windows\temp\configmgr2012-sp1-cu1-kb2817245-x64-enu.log

Step 1: ![step1](/media/2013/03/image10.png)
Step 2: Accept the EULA
![accept_eula](/media/2013/03/image11.png)
Step 3: Prerequisite check
![prereq check](/media/2013/03/image12.png)
Step 4: Update the Site database Here you’re asked whether you want setup to update the site database automatically or if you want to update it manually later on. If you are not allowed to update the database remotely or just don’t like doing it that way, you can chose “No, I will update the site database later.” and then will find a sql script (just a bit over 2000lines long) in the following location to update the site database: **\\<Server Name>\SMS_<Site Code>\Hotfix\<KB Number>\update.sql**

![update site database](/media/2013/03/image13.png)

Step 5: Creating other update packages
![creating other packages](/media/2013/03/image14.png)
![creating other packages](/media/2013/03/image15.png)
![creating other packages](/media/2013/03/image16.png)
![creating other packages](/media/2013/03/image17.png)

Step 6: Summary
![summary](/media/2013/03/image18.png)

Step 7: Installation progress
![install progress](/media/2013/03/image19.png)
4 minutes later:
![setup complete](/media/2013/03/image20.png)
Step 8: Installation completed

![complete](/media/2013/03/image21.png)

First thing I’ll try are the new and updated Powershell cmdlets!

# [Update] These are the new cmdlets for ConfigMgr 2012 SP1 CU1

As I wanted to check the new cmdlets that were promised before and in the KB, I had a look at the module.

These are supposed to now be included. For more information have a look at my other article [Found! – Where are my new ConfigMgr 2012 SP1 CU1 cmdlets?] /2013/03/23/found-where-are-my-new-configmgr-2012-sp1-cu1-cmdlets/).

<table width="400" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="400">
      <ul>
        <li>
          <b>Add-CMDistributionPoint</b>
        </li>
        <li>
          <b>Import-CMAntiMalwarePolicy</b>
        </li>
        <li>
          <b>Import-CMDriver</b>
        </li>
        <li>
          <b>New-CMAppVVirtualEnvironment</b>
        </li>
        <li>
          <b>New-CMMigrationJob</b>
        </li>
        <li>
          <b>New-CMPackage</b>
        </li>
        <li>
          <b>New-CMSoftwareUpdateAutoDeploymentRule</b>
        </li>
        <li>
          <b>New-CMTaskSequence</b>
        </li>
        <li>
          <b>New-CMTaskSequenceInstallUpdateAction</b>
        </li>
        <li>
          <b>New-CMTaskSequenceMedia</b>
        </li>
        <li>
          <b>New-CMUserDataAndProfileConfigurationItem</b>
        </li>
        <li>
          <b>Remove-CMTaskSequenceInstallUpdateAction</b>
        </li>
        <li>
          <b>Set-CMTaskSequenceGroup</b>
        </li>
        <li>
          <b>New-CMTaskSequenceGroup</b>
        </li>
        <li>
          <b>Remove-CMTaskSequenceGroup</b>
        </li>
        <li>
          <b>Set-CMApplicationCatalogWebsitePoint</b>
        </li>
        <li>
          <b>Set-CMAppVVirtualEnvironment</b>
        </li>
        <li>
          <b>Set-CMClientPushInstallation</b>
        </li>
        <li>
          <b>Set-CMClientSetting</b>
        </li>
        <li>
          <b>Set-CMDistributionPoint</b>
        </li>
        <li>
          <b>Set-CMDriver</b>
        </li>
        <li>
          <b>Set-CMEndpointProtectionPoint</b>
        </li>
        <li>
          <b>Set-CMEnrollmentPoint</b>
        </li>
        <li>
          <b>Set-CMEnrollmentProxyPoint</b>
        </li>
        <li>
          <b>Set-CMHierarchySetting</b>
        </li>
        <li>
          <b>Set-CMManagementPointComponent</b>
        </li>
        <li>
          <b>Set-CMOperatingSystemImageUpdateSchedule</b>
        </li>
        <li>
          <b>Set-CMOutOfBandManagementComponent</b>
        </li>
        <li>
          <b>Set-CMReportingServicePoint</b>
        </li>
        <li>
          <b>Set-CMSite</b>
        </li>
        <li>
          <b>Set-CMSoftwareUpdateAutoDeploymentRule</b>
        </li>
        <li>
          <b>Set-CMSoftwareUpdatePointComponent</b>
        </li>
        <li>
          <b>Set-CMStateMigrationPoint</b>
        </li>
        <li>
          <b>Set-CMStatusSummarizer</b>
        </li>
        <li>
          <b>Set-CMSystemHealthValidatorPointComponent</b>
        </li>
        <li>
          <b>Set-CMTaskSequence</b>
        </li>
        <li>
          <b>Set-CMTaskSequenceInstallUpdateAction</b>
        </li>
        <li>
          <b>Set-CMUserDataAndProfileConfigurationItem</b>
        </li>
        <li>
          <b>Start-CMDistributionPointUpgrade</b>
        </li>
      </ul>
    </td>
  </tr>
</table>
