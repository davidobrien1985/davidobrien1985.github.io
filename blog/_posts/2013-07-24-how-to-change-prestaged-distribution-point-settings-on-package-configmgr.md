---
id: 1132
title: 'How to change prestaged Distribution Point settings on Package - ConfigMgr'
date: 2013-07-24T09:23:18+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1132
permalink: /2013/07/how-to-change-prestaged-distribution-point-settings-on-package-configmgr/
categories:
  - CM12
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
  - System Center
  - System Center Configuration Manager
tags:
  - automation
  - CM12
  - ConfigMgr2012R2
  - Powershell
  - scripting
  - System Center Configuration Manager
---
This is a quick one. A user on the [ConfigMgr SDK technet forums](http://social.technet.microsoft.com/Forums/en-US/9528f907-08a3-4fca-9dc4-e35575b490d4/need-a-script-to-change-package-distribution-settings) asked this question on how to change the package's option "Prestaged distribution point settings".<figure class="wp-caption aligncenter" style="max-width: 244px">

[<img style="margin-left: auto; display: block; margin-right: auto; border: 0px;" title="prestaged_app" alt="Configure prestaged distribution point settings" src="http://www.david-obrien.net/wp-content/uploads/2013/07/prestaged_app_thumb.jpg" width="244" height="224" border="0" />]("prestaged_app" http://www.david-obrien.net/wp-content/uploads/2013/07/prestaged_app.jpg)<figcaption class="wp-caption-text">Configure prestaged distribution point settings</figcaption></figure> 

These three options all configure how a distribution point, that is enabled for prestaged content will behave regarding content download. The DP can either automatically download content, that's distributed to it, or only download content changes (so the initial replication of files needs to be 'offline') or it only accepts manually copied content.

# SMS_Package and PkgFlags

This option is again configured on the SMS_Package WMI class and lies inside the PkgFlags property. More info here: [http://msdn.microsoft.com/en-us/library/cc144959.aspx](http://msdn.microsoft.com/en-us/library/cc144959.aspx)

These three integer values can be set:

  * 16777216 for 'Manually copy content'
  * 32 for 'Automatically download content'
  * 16 for 'Download only changes'

# Applications

The same configuration can be done for Applications, but haven't found the time to do that with them. Will update the script as soon as it's done.

You can download the script here: [https://davidobrien.codeplex.com/SourceControl/latest#set-PackagePrestageDownloadBehaviour.ps1](https://davidobrien.codeplex.com/SourceControl/latest#set-PackagePrestageDownloadBehaviour.ps1)

And here it is:

<div class="wlWriterEditableSmartContent" id="scid:812469c5-0cb0-4c63-8c15-c81123a09de7:c7855446-96fd-478d-bbbf-4d1a09e3b7d4" style="float: none; margin: 0px; display: inline; padding: 0px;">
  <pre class="vb">&lt;#
.SYNOPSIS
	Script to set the "prestaged distribution point settings" option for every package in a folder
.DESCRIPTION
	Script to set the "prestaged distribution point settings" option for every package in a folder
.PARAMETER SMSProvider
    Hostname or FQDN of a SMSProvider in the Hierarchy 
    This parameter is mandatory!
    This parameter has an alias of SMS.
.PARAMETER FolderName
    This parameter expects the name to the folder UNDER which you want to configure ALL packages.
    This parameter is mandatory!
    This parameter has an alias of FN.
.EXAMPLE
	PS C:\PSScript &gt; .\set-PackagePrestageDownloadBehaviour.ps1 -SMSProvider cm12 -FolderName test -verbose

    This will use CM12 as SMS Provider.
    This will use "Test" as the folder in which you want all packages to get edited.
    Will give you some verbose output.
.INPUTS
	None.  You cannot pipe objects to this script.
.OUTPUTS
	No objects are output from this script.  This script creates a Word document.
.LINK
	http://www.david-obrien.net
.NOTES
	NAME: set-PackagePrestageDownloadBehaviour.ps1
	VERSION: 1.0
	AUTHOR: David O'Brien
	LASTEDIT: July 24, 2013
    Change history:
.REMARKS
	To see the examples, type: "Get-Help .\set-PackagePrestageDownloadBehaviour.ps1 -examples".
	For more information, type: "Get-Help .\set-PackagePrestageDownloadBehaviour.ps1 -detailed".
    This script will only work with Powershell 3.0.
#&gt;

[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" )]

param(
    [parameter(
	Position = 1, 
	Mandatory=$true )
	] 
	[Alias("SMS")]
	[ValidateNotNullOrEmpty()]
    [string]$SMSProvider = "",

    [parameter(
	Position = 2, 
	Mandatory=$true )
	] 
	[Alias("FN")]
	[ValidateNotNullOrEmpty()]
    [string]$FolderName = ""
)

Function Get-SiteCode
{
    $wqlQuery = “SELECT * FROM SMS_ProviderLocation”
    $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider
    $a | ForEach-Object {
        if($_.ProviderForLocalSite)
            {
                $script:SiteCode = $_.SiteCode
            }
    }
return $SiteCode
}

$SiteCode = Get-SiteCode

$FolderID = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "Name = '$($FolderName)'").ContainerNodeID
$Packages = (Get-WmiObject -Class SMS_ObjectContainerItem -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "ContainerNodeID = '$($FolderID)'").InstanceKey

foreach ($Pkg in $Packages)
    {
        try 
            {
                $Pkg = Get-WmiObject -Class SMS_Package -Namespace root\sms\site_$SiteCode -ComputerName $SMSProvider -Filter "PackageID ='$($Pkg)'"
                $Pkg = [wmi]$Pkg.__PATH
                $Pkg.PkgFlags = 32         # 16777216 for 'Manually copy content', 32 for 'Automatically download content', 16 for 'Download only changes'
                $Pkg.put() | Out-Null
                Write-Verbose "Successfully edited package $($Pkg.Name)."
            }
        catch
            {
                Write-Verbose "$($Pkg.Name) could not be edited."
            }
    }</pre>
</div>

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


