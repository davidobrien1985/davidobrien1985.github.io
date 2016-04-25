---
id: 442
title: MS System Center Configuration Manager 2012 SP1 (beta) – Powershell
date: 2012-09-15T09:28:51+00:00

layout: single

permalink: /2012/09/ms-system-center-configuration-manager-2012-sp1-beta-powershell/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2012
  - SCCM2012
  - scripting
  - SP1
  - update
---
I was looking forward to the recent release of the latest beta of System Center 2012 SP1, because one big part (at least for me), which has been announced before, wasn’t in the CTP1.

With the release of the latest Service Pack 1 beta of System Center 2012, Configuration Manager **FINALLY** has its own Powershell module.

# Powershell 3.0 and Configuration Manager

Now how do you get the Powershell module to work? You need Powershell 3.0, that’s it!

Configuration Manager 2012 SP1 will support Windows Server 2012 as an underlying OS and the new server OS already ships with Powershell 3.0. As I already have updated my whole virtual Lab to Server 2012, I had to do nothing.

![image](/media/2012/09/image.png "image")

If you are still working with the legacy OS aka Windows Server 2008 R2 go download the correct version of the Windows Management Framework 3.0 from the Microsoft Download Center: [http://www.microsoft.com/en-us/download/details.aspx?id=34595](http://www.microsoft.com/en-us/download/details.aspx?id=34595)

# Update to System Center Configuration Manager 2012 SP1 beta

I won’t go into detail, that’s for other articles of other people. Just upgrade your ConfigMgr 2012 site to SP1 beta. According to Microsoft it’s not possible to upgrade from SP1 CTP to beta and it’s not supported, at least they don’t recommend it, to upgrade your existing, configured 2012 site to SP1. They seem to want a clean install of a site.

Side note: I just upgraded my existing site with no problem. A colleague of mine upgraded his site and had problems with his PXE certificate afterwards.

If you want to read more about the general upgrading process, have a look at my recent article about the upgrade to CTP2: [How to update Configuration Manager 2012 to SP1 CTP2](http://www.david-obrien.de/?p=399)

Be aware that you do not need to do an update from RTM to SP1 beta. The beta source is a full installer only without the ADK/WAIK. If you want to have a "supported" beta environment (is that possible?!), take a clean server, install the ADK and then install CM12 from the beta sources.

# How to find the module

The default location of the Configuration Manager module manifest is `C:\\Program Files (x86)\\Microsoft Configuration Manager\\AdminConsole\\bin` or wherever you installed your AdminConsole.

The module file is called “ConfigurationManager.psd1” and you import it like this:

`Import-Module "C:\\Program Files (x86)\\Microsoft Configuration Manager\\AdminConsole\\bin\\ConfigurationManager.psd1`


After doing that you get a whopping **338** extra cmdlets.

# What’s in the module?

Here’s an overview of all the cmdlets:

```PowerShell
Add-CMBoundaryToGroup

Add-CMDeviceAffinityToUser

Add-CMDeviceCollectionDirectMembershipRule

Add-CMDeviceCollectionExcludeMembershipRule

Add-CMDeviceCollectionIncludeMembershipRule

Add-CMDeviceCollectionQueryMembershipRule

Add-CMDeviceCollectionToDistributionPointGroup

Add-CMDistributionPointToGroup

Add-CMSoftwareUpdateToGroup

Add-CMUserAffinityToDevice

Add-CMUserCollectionDirectMembershipRule

Add-CMUserCollectionExcludeMembershipRule

Add-CMUserCollectionIncludeMembershipRule

Add-CMUserCollectionQueryMembershipRule

Add-CMUserCollectionToDistributionPointGroup

Approve-CMApprovalRequest

Approve-CMDevice

Approve-CMUserDeviceAffinityRequest

Block-CMCertificate

Block-CMConflictingRecord

Block-CMDevice

Clear-CMAmtAuditLog

Clear-CMComponentStatusMessage

Clear-CMOperatingSystemImageUpdateSchedule

Clear-CMPxeDeployment

Clear-CMSiteStatusMessage

Copy-CMSecurityRole

Copy-CMUserDataAndProfileConfigurationItem

Deny-CMApprovalRequest

Deny-CMUserDeviceAffinityRequest

Disable-CMAlert

Disable-CMAmtAuditLog

Disable-CMBaseline

Disable-CMDriver

Disable-CMPackage

Disable-CMSoftwareMeteringRule

Disable-CMSoftwareUpdateAutoDeploymentRule

Disable-CMStatusFilterRule

Disable-CMTaskSequence

Enable-CMAlert

Enable-CMAmtAuditLog

Enable-CMBaseline

Enable-CMDriver

Enable-CMPackage

Enable-CMSoftwareMeteringRule

Enable-CMSoftwareUpdateAutoDeploymentRule

Enable-CMStatusFilterRule

Enable-CMTaskSequence

Export-CMApplication

Export-CMBaseline

Export-CMConfigurationItem

Export-CMSecurityRole

Get-CMAccessAccount

Get-CMAccount

Get-CMActiveDirectoryForest

Get-CMActiveDirectorySite

Get-CMAddress

Get-CMAdministrativeUser

Get-CMAlert

Get-CMAlertSubscription

Get-CMAntimalwarePolicy

Get-CMApplication

Get-CMApplicationCatalogWebServicePoint

Get-CMApplicationCatalogWebsitePoint

Get-CMApplicationRevisionHistory

Get-CMApprovalRequest

Get-CMAppVVirtualEnvironment

Get-CMAssetIntelligenceCatalogItem

Get-CMAssetIntelligenceSynchronizationPoint

Get-CMBaseline

Get-CMBaselineSummarizationSchedule

Get-CMBaselineXMLDefinition

Get-CMBootImage

Get-CMBoundary

Get-CMBoundaryGroup

Get-CMClientPushInstallation

Get-CMClientSetting

Get-CMClientStatusSetting

Get-CMClientStatusUpdateSchedule

Get-CMCloudDistributionPoint

Get-CMCollectionMembershipEvaluationComponent

Get-CMComponentStatusMessage

Get-CMComponentStatusSetting

Get-CMConfigurationItem

Get-CMConfigurationItemHistory

Get-CMConfigurationItemXMLDefinition

Get-CMConflictingRecord

Get-CMDatabaseReplicationStatus

Get-CMDeployment

Get-CMDeploymentPackage

Get-CMDeploymentStatus

Get-CMDeploymentType

Get-CMDevice

Get-CMDeviceCollection

Get-CMDeviceCollectionDirectMembershipRule

Get-CMDeviceCollectionExcludeMembershipRule

Get-CMDeviceCollectionIncludeMembershipRule

Get-CMDeviceCollectionQueryMembershipRule

Get-CMDeviceCollectionVariable

Get-CMDiscoveryMethod

Get-CMDistributionPoint

Get-CMDistributionPointGroup

Get-CMDriver

Get-CMDriverPackage

Get-CMEndpointProtectionPoint

Get-CMEndpointProtectionSummarizationSchedule

Get-CMEnrollmentPoint

Get-CMEnrollmentProxyPoint

Get-CMExchangeServer

Get-CMFallbackStatusPoint

Get-CMGlobalCondition

Get-CMHardwareRequirement

Get-CMInventoriedSoftware

Get-CMIPSubnet

Get-CMManagementPoint

Get-CMManagementPointComponent

Get-CMOperatingSystemImage

Get-CMOperatingSystemInstaller

Get-CMOutOfBandManagementComponent

Get-CMOutOfBandServicePoint

Get-CMPackage

Get-CMProgram

Get-CMReportingServicePoint

Get-CMSecurityRole

Get-CMSecurityScope

Get-CMSite

Get-CMSiteInstallStatus

Get-CMSiteMaintenanceTask

Get-CMSoftwareMeteringRule

Get-CMSoftwareMeteringSetting

Get-CMSoftwareUpdate

Get-CMSoftwareUpdateAutoDeploymentRule

Get-CMSoftwareUpdateBasedClientInstallation

Get-CMSoftwareUpdateDeploymentPackage

Get-CMSoftwareUpdateGroup

Get-CMSoftwareUpdateLicense

Get-CMSoftwareUpdatePoint

Get-CMSoftwareUpdatePointComponent

Get-CMSoftwareUpdateSummarizationSchedule

Get-CMStateMigrationPoint

Get-CMStatusFilterRule

Get-CMStatusMessageQuery

Get-CMSystemHealthValidationPoint

Get-CMSystemHealthValidatorPointComponent

Get-CMTaskSequence

Get-CMUser

Get-CMUserCollection

Get-CMUserCollectionDirectMembershipRule

Get-CMUserCollectionExcludeMembershipRule

Get-CMUserCollectionIncludeMembershipRule

Get-CMUserCollectionQueryMembershipRule

Get-CMUserDataAndProfileConfigurationItem

Get-CMUserDataAndProfileConfigurationItemXmlDefinition

Get-CMUserDeviceAffinity

Get-CMUserDeviceAffinityRequest

Get-CMWindowsFirewallPolicy

Import-CMCertificate

Import-CMSecurityRole

Install-CMClient

Invoke-CMAmtProvisioningDiscovery

Invoke-CMBaselineSummarization

Invoke-CMDeploymentSummarization

Invoke-CMDeviceCollectionUpdate

Invoke-CMEndpointProtectionScan

Invoke-CMEndpointProtectionSummarization

Invoke-CMForestDiscovery

Invoke-CMRemoteControl

Invoke-CMSecondarySiteUpgrade

Invoke-CMSoftwareUpdateAutoDeploymentRule

Invoke-CMSoftwareUpdateSummarization

Invoke-CMUserCollectionUpdate

New-CMAccessAccount

New-CMActiveDirectoryForest

New-CMAlertSubscription

New-CMAssetIntelligenceCatalogItem

New-CMBootImage

New-CMBoundary

New-CMBoundaryGroup

New-CMClientSetting

New-CMDeviceCollection

New-CMDeviceCollectionVariable

New-CMDistributionPointGroup

New-CMDriverPackage

New-CMHardwareRequirement

New-CMOperatingSystemImage

New-CMOperatingSystemInstaller

New-CMPackage

New-CMSecurityScope

New-CMSoftwareMeteringRule

New-CMSoftwareUpdateGroup

New-CMUserCollection

Remove-CMAccessAccount

Remove-CMAccount

Remove-CMActiveDirectoryForest

Remove-CMAddress

Remove-CMAdministrativeUser

Remove-CMAlert

Remove-CMAlertSubscription

Remove-CMAmtProvisioningData

Remove-CMAntimalwarePolicy

Remove-CMApplication

Remove-CMApplicationCatalogWebServicePoint

Remove-CMApplicationRevisionHistory

Remove-CMAppVVirtualEnvironment

Remove-CMAssetIntelligenceCatalogItem

Remove-CMAssetIntelligenceSynchronizationPoint

Remove-CMBaseline

Remove-CMBootImage

Remove-CMBoundary

Remove-CMBoundaryFromGroup

Remove-CMBoundaryGroup

Remove-CMClientSetting

Remove-CMCloudDistributionPoint

Remove-CMConfigurationItem

Remove-CMDeployment

Remove-CMDeploymentType

Remove-CMDevice

Remove-CMDeviceAffinityFromUser

Remove-CMDeviceCollection

Remove-CMDeviceCollectionDirectMembershipRule

Remove-CMDeviceCollectionExcludeMembershipRule

Remove-CMDeviceCollectionFromAdministrativeUser

Remove-CMDeviceCollectionFromDistributionPointGroup

Remove-CMDeviceCollectionIncludeMembershipRule

Remove-CMDeviceCollectionQueryMembershipRule

Remove-CMDeviceCollectionVariable

Remove-CMDistributionPoint

Remove-CMDistributionPointFromGroup

Remove-CMDistributionPointGroup

Remove-CMDriver

Remove-CMDriverPackage

Remove-CMEndpointProtectionPoint

Remove-CMEnrollmentPoint

Remove-CMEnrollmentProxyPoint

Remove-CMExchangeServer

Remove-CMFallbackStatusPoint

Remove-CMGlobalCondition

Remove-CMHardwareRequirement

Remove-CMManagementPoint

Remove-CMOperatingSystemImage

Remove-CMOperatingSystemInstaller

Remove-CMOutOfBandServicePoint

Remove-CMPackage

Remove-CMProgram

Remove-CMReportingServicePoint

Remove-CMSecondarySite

Remove-CMSecurityRole

Remove-CMSecurityRoleFromAdministrativeUser

Remove-CMSecurityScope

Remove-CMSecurityScopeFromAdministrativeUser

Remove-CMSoftwareMeteringRule

Remove-CMSoftwareUpdateAutoDeploymentRule

Remove-CMSoftwareUpdateDeploymentPackage

Remove-CMSoftwareUpdateGroup

Remove-CMSoftwareUpdatePoint

Remove-CMStateMigrationPoint

Remove-CMStatusFilterRule

Remove-CMStatusMessageQuery

Remove-CMSystemHealthValidationPoint

Remove-CMTaskSequence

Remove-CMUser

Remove-CMUserAffinityFromDevice

Remove-CMUserCollection

Remove-CMUserCollectionDirectMembershipRule

Remove-CMUserCollectionExcludeMembershipRule

Remove-CMUserCollectionFromAdministrativeUser

Remove-CMUserCollectionFromDistributionPointGroup

Remove-CMUserCollectionIncludeMembershipRule

Remove-CMUserCollectionQueryMembershipRule

Remove-CMUserDataAndProfileConfigurationItem

Remove-CMWindowsFirewallPolicy

Restore-CMApplicationRevisionHistory

Resume-CMApplication

Save-CMEndpointProtectionDefinition

Set-CMAccessAccount

Set-CMActiveDirectoryForest

Set-CMAlert

Set-CMAlertSubscription

Set-CMAntimalwarePolicy

Set-CMApplication

Set-CMApprovalRequest

Set-CMAppVVirtualEnvironment

Set-CMAssetIntelligenceCatalogItem

Set-CMAssetIntelligenceSynchronizationPoint

Set-CMBaseline

Set-CMBaselineSummarizationSchedule

Set-CMBootImage

Set-CMBoundary

Set-CMBoundaryGroup

Set-CMClientSetting

Set-CMClientStatusSetting

Set-CMClientStatusUpdateSchedule

Set-CMCloudDistributionPoint

Set-CMCollectionMembershipEvaluationComponent

Set-CMConfigurationItem

Set-CMDeploymentType

Set-CMDeviceCollection

Set-CMDeviceCollectionVariable

Set-CMDistributionPoint

Set-CMDistributionPointGroup

Set-CMDriverPackage

Set-CMEndpointProtectionSummarizationSchedule

Set-CMFallbackStatusPoint

Set-CMGlobalCondition

Set-CMHardwareRequirement

Set-CMInventoriedSoftware

Set-CMOperatingSystemImage

Set-CMOperatingSystemInstaller

Set-CMOutOfBandServicePoint

Set-CMPackage

Set-CMSecurityRole

Set-CMSecurityScope

Set-CMSite

Set-CMSoftwareMeteringRule

Set-CMSoftwareMeteringSetting

Set-CMSoftwareUpdate

Set-CMSoftwareUpdateDeploymentPackage

Set-CMSoftwareUpdateGroup

Set-CMSoftwareUpdateSummarizationSchedule

Set-CMStatusFilterRule

Set-CMStatusMessageQuery

Set-CMTaskSequence

Set-CMUserCollection

Set-CMWindowsFirewallPolicy

Start-CMCloudDistributionPoint

Start-CMDeployment

Stop-CMCloudDistributionPoint

Suspend-CMAlert

Suspend-CMApplication

Sync-CMExchangeServer

Sync-CMSoftwareUpdate

Unblock-CMCertificate

Unblock-CMDevice

Undo-CMInventoriedSoftware

Update-CMApplicationStatistic

Update-CMCertificate

Update-CMClientStatus

Update-CMDistributionPoint
```


Lucky for us, every cmdlet comes with its own help. A “get-help Update-CMDistributionPoint” will thus get you some syntax help on it.

On my system the get-help command wanted to download some get-help updates before allowing me to see any help on CM cmdlets, so check if you have got an internet connection.

If you want to see all the cmdlets for yourself, type

`Get-Command -Module ConfigurationManager`


I have already written lots of scripts/functions for Configuration Manager 2012 and with the new Powershell module I’m looking forward on continuing that.

[How to import a new Computer](/2012/07/import-computer-to-configuration-manager-2007-2012/)

[How to install a Distribution Point](/2012/06/install-distribution-point-for-configuration-manager-2012/)

[My small Admin GUI for ConfigMgr](/2012/04/release-of-my-configuration-manager-admin-gui/)

[How to create Folders in ConfigMgr Console](/2012/02/create-folders-in-microsoft-system-center-configuration-manager-with-powershell/)

In the next couple of days/weeks I’ll try to update my scripts to the new commands and have a look at how powerful they really are!

So stay tuned!





