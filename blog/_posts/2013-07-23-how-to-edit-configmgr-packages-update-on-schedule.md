---
id: 1117
title: 'How to edit ConfigMgr packages - update on schedule'
date: 2013-07-23T22:41:51+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1117
permalink: /2013/07/how-to-edit-configmgr-packages-update-on-schedule/
categories:
  - automation
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - automation
  - ConfigMgr
  - ConfigMgr2012R2
  - Powershell
  - SCCM
---
A few days back I asked for some ideas about what you need to get automated / scripted inside of Microsoft ConfigMgr and I actually got some nice feedback on that.
  
One of that was from a colleague of mine at sepago who needs to update packages on a distribution point by a daily schedule. I believe the package source gets updated daily and so they need to update the distribution point every night.

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Update Distribution Points on a schedule" alt="Update Distribution Points on a schedule" src="http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_before_thumb.jpg" width="241" height="244" border="0" />]("Update Distribution Points on a schedule" http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_before.jpg)

# Get SMS_Package

The option I'm talking about is found in the package's properties on the "Data Source" tab and is called "Update distribution points on a schedule".
  
By default this option is disabled, which makes sense! You don't want to enable this option for every package.

This option is represented by a WMI property of the SMS_Package class and it's called RefreshSchedule.
  
By having a look at [http://msdn.microsoft.com/en-us/library/cc144959.aspx](http://msdn.microsoft.com/en-us/library/cc144959.aspx) we can see that RefreshSchedule is from the type SMS_ScheduleToken and it's lazy. (Here I describe what lazy WMI properties are: [http://www.david-obrien.net/2012/12/02/create-a-new-software-update-group-in-configmgr/](http://www.david-obrien.net/2012/12/02/create-a-new-software-update-group-in-configmgr/))

> <figure class="wp-caption aligncenter" style="max-width: 244px">[<img style="display: inline; border: 0px;" title="SMS_Package" alt="SMS_Package" src="http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_refreshschedule_lazy_thumb1.jpg" width="244" height="208" border="0" />]("SMS_Package" http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_refreshschedule_lazy.jpg)<figcaption class="wp-caption-text">SMS_Package WMI - before script ran</figcaption></figure> <figure class="wp-caption aligncenter" style="max-width: 244px">[<img style="display: inline; border: 0px;" title="SMS_Package" alt="SMS_Package" src="http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_after_thumb.jpg" width="244" height="211" border="0" />]("SMS_Package" http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_after.jpg)<figcaption class="wp-caption-text">SMS_Package WMI - after script ran</figcaption></figure> 
> 
> <p align="center">
>   <p align="center">
>     </blockquote> 
>     
>     <p>
>       So in order to access this property we'll have to make a direct reference to this WMI instance and we can then see a bit more, at least we can if someone has manually configured that above option or you already ran my script 😉
>     </p>
>     
>     <h1>
>       Create a SMS_ScheduleToken and apply it
>     </h1>
>     
>     <p>
>       We now know that we need to create an object from the class SMS_ScheduleToken and need to apply it to our SMS_Package object. Easily done. I already had a function to create that ScheduleToken.<br /> In this example I create a ScheduleToken which will create a schedule which runs every night at midnight from "today" on. Unfortunately the script can't be as flexible as the GUI, so I kind of had to hard-code it into the script.
>     </p>
>     
>     <p>
>       To furthermore get something like a mass configuration going I'm doing this configuration on a "per-folder" base. You tell the script that you want to configure ALL packages inside a folder with this option and the script will do so. If you rather want to do it on a "per-package" base then the script should give you an idea of how to do it.
>     </p>
>     
>     <p>
>       This is how it looks like after the script ran:
>     </p>
>     
>     <p>
>       [<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Package properties" alt="Package properties" src="http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_after2_thumb.jpg" width="242" height="244" border="0" />]("Package properties" http://www.david-obrien.net/wp-content/uploads/2013/07/pkg_update_after2.jpg)
>     </p>
>     
>     <p>
>       Execute the script like that:
>     </p>
>     
>     <blockquote>
>       <p>
>         .\set-UpdatePkgOnDPBySchedule.ps1 -SMSProvider %NameOfSMSProvider% -FolderName %FolderWithPackages% -verbose
>       </p>
>     </blockquote>
>     
>     <p>
>       Download the script on codeplex: [https://davidobrien.codeplex.com/SourceControl/latest#set-UpdatePkgOnDPBySchedule.ps1](https://davidobrien.codeplex.com/SourceControl/latest#set-UpdatePkgOnDPBySchedule.ps1)
>     </p>
>     
>     <p>
>       All feedback welcome and asked for <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />
>     </p>
>     
>     <p>
>       Here's the script:
>     </p>
>     
>     <div class="wlWriterEditableSmartContent" id="scid:812469c5-0cb0-4c63-8c15-c81123a09de7:5f1d8258-9949-4143-abc2-10d73d28f3ec" style="float: none; margin: 0px; display: inline; padding: 0px;">
>       <pre class="vb:collapse">&lt;#
.SYNOPSIS
	Script to set the "Update Distribution Point on a schedule" option for every package in a folder to "occur every night at 12PM"
.DESCRIPTION
	Script to set the "Update Distribution Point on a schedule" option for every package in a folder to "occur every night at 12PM"
.PARAMETER SMSProvider
    Hostname or FQDN of a SMSProvider in the Hierarchy 
    This parameter is mandatory!
    This parameter has an alias of SMS.
.PARAMETER FolderName
    This parameter expects the name to the folder UNDER which you want to configure ALL packages.
    This parameter is mandatory!
    This parameter has an alias of FN.
.EXAMPLE
	PS C:\PSScript &gt; .\set-UpdatePkgOnDPBySchedule.ps1 -SMSProvider cm12 -FolderName test -verbose

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
	NAME: set-UpdatePkgOnDPBySchedule.ps1
	VERSION: 1.0
	AUTHOR: David O'Brien
	LASTEDIT: July 23, 2013
    Change history:
.REMARKS
	To see the examples, type: "Get-Help .\set-UpdatePkgOnDPBySchedule.ps1 -examples".
	For more information, type: "Get-Help .\set-UpdatePkgOnDPBySchedule.ps1 -detailed".
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

Function Convert-NormalDateToConfigMgrDate {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$starttime
    )

    return [System.Management.ManagementDateTimeconverter]::ToDMTFDateTime($starttime)
}

Function create-ScheduleToken {

$SMS_ST_RecurInterval = "SMS_ST_RecurInterval"
$class_SMS_ST_RecurInterval = [wmiclass]""
$class_SMS_ST_RecurInterval.psbase.Path ="\\$($SMSProvider)\ROOT\SMS\Site_$($SiteCode):$($SMS_ST_RecurInterval)"

$script:scheduleToken = $class_SMS_ST_RecurInterval.CreateInstance()   
    if($scheduleToken) 
        {
        $scheduleToken.DayDuration = 0
        $scheduleToken.DaySpan = 1
        $scheduleToken.HourDuration = 0
        $scheduleToken.HourSpan = 0
        $scheduleToken.IsGMT = $false
        $scheduleToken.MinuteDuration = 0
        $scheduleToken.MinuteSpan = 0
        $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)
        }
}

[datetime]$startTime = [datetime]::Today

$SiteCode = Get-SiteCode

create-ScheduleToken

$FolderID = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "Name = '$($FolderName)'").ContainerNodeID
$Packages = (Get-WmiObject -Class SMS_ObjectContainerItem -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "ContainerNodeID = '$($FolderID)'").InstanceKey

foreach ($Pkg in $Packages)
    {
        try 
            {
                $Pkg = Get-WmiObject -Class SMS_Package -Namespace root\sms\site_$SiteCode -ComputerName $SMSProvider -Filter "PackageID ='$($Pkg)'"
                $Pkg = [wmi]$Pkg.__PATH
                $Pkg.RefreshSchedule = $scheduletoken
                $Pkg.put() | Out-Null
                Write-Verbose "Successfully edited package $($Pkg.Name)."
            }
        catch
            {
                Write-Verbose "$($Pkg.Name) could not be edited."
            }
    }
>     </div>
>     
>     <div style="float: right; margin-left: 10px;">
>       [Tweet](https://twitter.com/share)
>     </div>


