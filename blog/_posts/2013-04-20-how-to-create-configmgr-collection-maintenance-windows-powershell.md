---
id: 910
title: 'How to create ConfigMgr collection maintenance windows - Powershell'
date: 2013-04-20T00:08:31+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=910
permalink: /2013/04/how-to-create-configmgr-collection-maintenance-windows-powershell/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - automation
  - Collections
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
---
Here’s another one from my todo list (it’s getting shorter by the day…).

# What are Maintenance Windows in Microsoft ConfigMgr 2012 ?

A customer once asked me what those maintenance windows on collections are for and if he had to create them on every collection he has.

If you don’t know the answer to either of those two questions, read these articles:

[http://allthingsconfigmgr.wordpress.com/2012/06/13/configmgr-101-maintenance-windows/](http://allthingsconfigmgr.wordpress.com/2012/06/13/configmgr-101-maintenance-windows/)

[http://henkhoogendoorn.blogspot.de/2011/04/maintenance-windows-in-configmgr-2012.html](http://henkhoogendoorn.blogspot.de/2011/04/maintenance-windows-in-configmgr-2012.html)

[http://technet.microsoft.com/en-us/library/hh508762.aspx](http://technet.microsoft.com/en-us/library/hh508762.aspx)

[http://blogs.technet.com/b/server-cloud/archive/2012/03/28/business-hours-vs-maintenance-windows-with-system-center-2012-configuration-manager.aspx](http://blogs.technet.com/b/server-cloud/archive/2012/03/28/business-hours-vs-maintenance-windows-with-system-center-2012-configuration-manager.aspx)

I wouldn’t be me if I didn’t try to automate the creation of maintenance windows.

This article shows you an example of how to create a new maintenance window for a collection which is open 24hrs every day.

## SMS_ScheduleMethods

We’re going to use one of the WMI subclasses of SMS_ScheduleMethods again which we already know from my script to automate the Offline Servicing process for OS images. (here: [Automation of Offline Servicing](/2012/12/17/how-to-automate-offline-servicing-in-configuration-manager-2012/))

Today it’ll be the [SMS_ST_RecurInterval](http://msdn.microsoft.com/en-us/library/hh948339.aspx) class which will help us achieve our task.

## SMS_ServiceWindow

This class ([SMS_ServiceWindow](http://msdn.microsoft.com/en-us/library/cc143300.aspx)) will define our maintenance / service window and will be embedded into the SMS_CollectionSettings instance of that collection which we want to configure.

As usual, this is a lazy property and we need the WMI instance of our collection and in comparison to my earlier scripts I found a slightly easier way on doing so.

I obviously don’t need the “foreach loop” anymore if I already know that my variable only contains one instance of what I’m looking for, I’ll just do a $variable.Get().

Have a look at the script and you’ll know what I mean!

This script should help you create lots of different maintenance windows (only 12hrs a day, certain time of the day, …).

Comments or questions much appreciated!

Here’s the link to Codeplex: [https://davidobrien.codeplex.com/SourceControl/changeset/view/c473426cf644d97ecbdc602d55550b77a7c1f8ee#New-MaintenanceWindow.ps1](https://davidobrien.codeplex.com/SourceControl/changeset/view/c473426cf644d97ecbdc602d55550b77a7c1f8ee#New-MaintenanceWindow.ps1)

How to use it:

```
.\New-MaintenanceWindow.ps1 -SiteCode PR1 -ServiceWindowName "New Maintenance Window" -ServiceWindowDescription "24hrs maintenance window" -CollectionID PR10003A
```

![create new maintenance window](/media/2013/04/image4.png)

```
[CmdletBinding()]

param(

[string]$SiteCode,

[string]$ServiceWindowName,

[string]$ServiceWindowDescription,

[string]$CollectionID

)

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

$class_SMS_ST_RecurInterval.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ST_RecurInterval)"

$scheduleToken = $class_SMS_ST_RecurInterval.CreateInstance()

    if($scheduleToken)

        {

        $scheduleToken.DayDuration = 1

        $scheduleToken.HourDuration = 0

        $scheduleToken.IsGMT = $false

        $scheduleToken.MinuteDuration = 0

        $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)

        $SMS_ScheduleMethods = "SMS_ScheduleMethods"

        $class_SMS_ScheduleMethods = [wmiclass]""

        $class_SMS_ScheduleMethods.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ScheduleMethods)"

        $script:ScheduleString = $class_SMS_ScheduleMethods.WriteToString($scheduleToken)

        [string]$ScheduleString.StringData

        }

}

Function New-SMSServiceWindow {

$CollSettings = Get-WmiObject -class sms_collectionsettings -Namespace root\sms\site_$($SiteCode) | Where-Object {$_.CollectionID -eq "$($CollectionID)"}

$CollSettings = [wmi]$CollSettings.__PATH

$CollSettings.Get()

$SMS_ServiceWindow = "SMS_ServiceWindow"

$class_SMS_ServiceWindow = [wmiclass]""

$class_SMS_ServiceWindow.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ServiceWindow)"

$SMS_ServiceWindow = $class_SMS_ServiceWindow.CreateInstance()

$SMS_ServiceWindow.Name                     = "$($ServiceWindowName)"

$SMS_ServiceWindow.Description              = "$($ServiceWindowDescription)"

$SMS_ServiceWindow.IsEnabled                = $true

$SMS_ServiceWindow.ServiceWindowSchedules   = $scheduleString

$SMS_ServiceWindow.ServiceWindowType        = 1 #1 is General, 5 is for OSD

$SMS_ServiceWindow.StartTime                = "$(Get-Date -Format "yyyyMMddhhmmss.ffffff+***")"

$CollSettings.ServiceWindows += $SMS_ServiceWindow.psobject.baseobject

$CollSettings.Put() |Out-Null

}

##############################################

[datetime]$startTime = get-date

$schedulestring = create-ScheduleToken

try

    {

        New-SMSServiceWindow

    }

catch

    {

        Write-Error "There was an error creating the Maintenance Window $($ServiceWindowName) for Collection ID $($CollectionID)."

    }
```
