---
id: 1397
title: Powershell , what is new in ConfigMgr 2012 R2 RTM
date: 2013-10-18T13:21:52+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1397
permalink: /2013/10/powershell-whats-new-in-configmgr2012r2/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - ConfigMgr2012R2
  - Configuration Manager
  - Microsoft
  - Powershell
  - System Center
---
I just did the upgrade of my local ConfigMgr Lab from 2012 R2 PREVIEW (!) to RTM.

> **THIS IS NOT SUPPORTED!!!**

## What changed with regards to Powershell?

This is a comparison of the number of cmdlets we had in R2 Preview to the number we have now:

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border-width: 0px;" title="cmdlets_before_after" alt="cmdlets_before_after" src="http://www.david-obrien.net/wp-content/uploads/2013/10/cmdlets_before_after_thumb.jpg" width="358" height="29" border="0" />]("cmdlets_before_after" http://www.david-obrien.net/wp-content/uploads/2013/10/cmdlets_before_after.jpg)

And here’s a list of the cmdlets that are new for us in R2 RTM:

> Copy-CMClientAuthCertificateProfileConfigurationItem

> Copy-CMTrustedRootCertificateProfileConfigurationItem

> Copy-CMVpnProfileConfigurationItem

> Copy-CMWirelessProfileConfigurationItem

> Get-CMClientAuthCertificateProfileConfigurationItem

> Get-CMClientOperations

> Get-CMMaintenanceWindow

> Get-CMTrustedRootCertificateProfileConfigurationItem

> Get-CMVpnProfileConfigurationItem

> Get-CMWirelessProfileConfigurationItem

> Invoke-CMContentValidation

> Invoke-CMDeviceRetire

> Invoke-CMDeviceWipe

> New-CMClientAuthCertificateProfileConfigurationItem

> New-CMMaintenanceWindow

> New-CMTrustedRootCertificateProfileConfigurationItem

> New-CMVpnProfileConfigurationItem

> New-CMWirelessProfileConfigurationItem

> Remove-CMClientAuthCertificateProfileConfigurationItem

> Remove-CMMaintenanceWindow

> Remove-CMTrustedRootCertificateProfileConfigurationItem

> Remove-CMVpnProfileConfigurationItem

> Remove-CMWirelessProfileConfigurationItem

> Set-CMClientAuthCertificateProfileConfigurationItem

> Set-CMMaintenanceWindow

> Set-CMTrustedRootCertificateProfileConfigurationItem

> Set-CMVpnProfileConfigurationItem

> Set-CMWirelessProfileConfigurationItem
>
> &nbsp;

As you can see, these are mostly cmdlets around the topic of “Mobile Device Management”.

We can now work with Certificates, WiFi Profiles and also do Device Wiping via Powershell.

This list is only valid though, if you’re already on R2 preview.

&nbsp;

This is a list of those cmdlets you can now enjoy if you’re coming from SP1 CU2 and go to R2:

> Copy-CMWirelessProfileConfigurationItem

> Get-CMAccessLicense

> Get-CMClientAuthCertificateProfileConfigurationItem

> Get-CMClientOperations

> Get-CMDeviceVariable

> Get-CMInitialModifiableSecuredCategory

> Get-CMMaintenanceWindow

> Get-CMRemoteConnectionProfileConfigurationItem

> Get-CMRemoteConnectionProfileConfigurationItemXmlDefinition

> Get-CMTrustedRootCertificateProfileConfigurationItem

> Get-CMVhd

> Get-CMVpnProfileConfigurationItem

> Get-CMWirelessProfileConfigurationItem

> Invoke-CMClientNotification

> Invoke-CMContentValidation

> Invoke-CMDeviceRetire

> Invoke-CMDeviceWipe

> Move-CMObject

> New-CMClientAuthCertificateProfileConfigurationItem

> New-CMDeviceVariable

> New-CMMaintenanceWindow

> New-CMRemoteConnectionProfileConfigurationItem

> New-CMTrustedRootCertificateProfileConfigurationItem

> New-CMVhd

> New-CMVpnProfileConfigurationItem

> New-CMWirelessProfileConfigurationItem

> Publish-CMPrestageContentTaskSequence

> Remove-CMClientAuthCertificateProfileConfigurationItem

> Remove-CMContentDistribution

> Remove-CMDeviceVariable

> Remove-CMMaintenanceWindow

> Remove-CMRemoteConnectionProfileConfigurationItem

> Remove-CMTrustedRootCertificateProfileConfigurationItem

> Remove-CMVhd

> Remove-CMVpnProfileConfigurationItem

> Remove-CMWirelessProfileConfigurationItem

> Set-CMAssignedSite

> Set-CMClientAuthCertificateProfileConfigurationItem

> Set-CMDeviceOwnership

> Set-CMDeviceVariable

> Set-CMMaintenanceWindow

> Set-CMRemoteConnectionProfileConfigurationItem

> Set-CMTrustedRootCertificateProfileConfigurationItem

> Set-CMVhd

> Set-CMVpnProfileConfigurationItem

> Set-CMWirelessProfileConfigurationItem

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


