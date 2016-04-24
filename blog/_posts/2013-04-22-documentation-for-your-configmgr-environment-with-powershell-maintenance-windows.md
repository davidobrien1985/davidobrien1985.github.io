---
id: 919
title: 'Documentation for your ConfigMgr environment with Powershell - maintenance windows'
date: 2013-04-22T23:40:11+00:00
author: "David O'Brien"
layout: single

permalink: /2013/04/documentation-for-your-configmgr-environment-with-powershell-maintenance-windows/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - ConfigMgr
  - Configuration Manager
  - documentation
  - maintenance windows
  - Powershell
  - SCCM
  - System Center
---
After writing my previous script which creates new maintenance windows via Powershell on your ConfigMgr / SCCM 2012 device collections ([look here](/2013/04/how-to-create-configmgr-collection-maintenance-windows-powershell/)) I had quite a few dummy maintenance windows all over my test environment.

What does the lazy consultant do instead of looking for every single one of those dummies? He lets someone else do it… in this case, I wrote a script which creates a little logfile including all the collections that have a maintenance window configured.

This script can also be helpful if you’re an consultant being asked to review an existing environment.

# Script to report all maintenance windows in your ConfigMgr environment

This script does exactly what it’s supposed to do.

It goes through all collections existing in your environment and shows you all the maintenance windows for each of those collections with all details configured.

The logfile is no beauty, I know, but it suits its purpose! For now.

In the end I could have saved me some work by using the maintenance window’s description, which is actually automatically created if you create a new maintenance window via the GUI, but my way was more fun ;-)

## Using the reporting services for maintenance windows

A colleague just asked me why I didn’t use the built-in report for maintenance windows?! WTF?!?!?

He asks me that after 2 hours of scripting… Good for me, that reports requires you to enter a device name and then it will show you only those maintenance windows only for that device.

EXTREMELY helpful for troubleshooting, but not what I was aiming at.

![image]/2013/04/image5.png)

## Script usage and output

This script only needs to be run on the site’s management point and requires two parameters:

```
.\Get-MaintenanceWindows.ps1 -SiteCode PR1 -FilePath C:\temp\maintenancewindows.log
```

The script will create a file in the filepath which will look a bit like this:

![image](/media/2013/04/image6.png)

You can also download the code here: [https://davidobrien.codeplex.com/SourceControl/changeset/view/5e8367118d7e06f92b0d42780ac2486acb4bd01f#Get-MaintenanceWindows.ps1](https://davidobrien.codeplex.com/SourceControl/changeset/view/5e8367118d7e06f92b0d42780ac2486acb4bd01f#Get-MaintenanceWindows.ps1)

```
param (

[string]$SiteCode,

[string]$FilePath

)

$CollSettings = ""

[array]$CollIDs = @()

Function Convert-NormalDateToConfigMgrDate {

    [CmdletBinding()]

    param (

        [parameter(Mandatory=$true, ValueFromPipeline=$true)]

        [string]$starttime

    )

    return [System.Management.ManagementDateTimeconverter]::ToDateTime($starttime)

}

Function Read-ScheduleToken {

$SMS_ScheduleMethods = "SMS_ScheduleMethods"

$class_SMS_ScheduleMethods = [wmiclass]""

$class_SMS_ScheduleMethods.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ScheduleMethods)"

$script:ScheduleString = $class_SMS_ScheduleMethods.ReadFromString($ServiceWindow.ServiceWindowSchedules)

return $ScheduleString

}

############### Main script starts here ######################

#Collecting all collections with Maintenance windows configured

$Collections = Get-WmiObject -Class SMS_Collection -Namespace root\SMS\Site_$($SiteCode) | Where-Object {$_.ServiceWindowsCount -gt 0}

#get the collection IDs of these collections

foreach ($Collection in $Collections)

    {

        $CollIDs += $Collection.CollectionID

    }

#get the maintenance window information

foreach ($CollectionID in $CollIDs)

    {

        $CollName = (Get-WmiObject -Class SMS_Collection -Namespace root\sms\Site_$($SiteCode) | Where-Object {$_.CollectionID -eq "$($CollectionID)"}).Name

        "Working on Collection $($CollName)" | Out-File -FilePath $FilePath -Append

        "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\" | Out-File -FilePath $FilePath -Append

        $CollSettings = Get-WmiObject -class sms_collectionsettings -Namespace root\sms\site_$($SiteCode) | Where-Object {$_.CollectionID -eq "$($CollectionID)"}

        $CollSettings = [wmi]$CollSettings.__PATH

        #$CollSettings.Get() | Out-Null

        $ServiceWindows = $($CollSettings.ServiceWindows)

        $ServiceWindows = [wmi]$ServiceWindows.__PATH

        foreach ($ServiceWindow in $ServiceWindows)

            {

                $ScheduleString = Read-ScheduleToken

                "Working on maintenance window $($ServiceWindow.Name)" | Out-File -FilePath $FilePath -Append

                #$ServiceWindow.Description

                #$starttime = (Convert-NormalDateToConfigMgrDate $ScheduleString.TokenData.starttime)

                switch ($ServiceWindow.ServiceWindowType)

                    {

                        0 {"This is a Task Sequence maintenance window" | Out-File -FilePath $FilePath -Append}

                        1 {"This is a general maintenance window" | Out-File -FilePath $FilePath -Append}

                    }

                switch ($ServiceWindow.RecurrenceType)

                    {

                        1 {"This maintenance window occurs only once on $($startTime) and lasts for $($ScheduleString.TokenData.HourDuration) hour(s) and $($ScheduleString.TokenData.MinuteDuration) minute(s)." | Out-File -FilePath $FilePath -Append}

                        2

                            {

                                if ($ScheduleString.TokenData.DaySpan -eq "1")

                                    {

                                        $daily = "daily"

                                    }

                                else

                                    {

                                        $daily = "every $($ScheduleString.TokenData.DaySpan) days"

                                    }

                                "This maintenance window occurs $($daily)." | Out-File -FilePath $FilePath -Append

                            }

                        3

                            {

                                switch ($ScheduleString.TokenData.Day)

                                    {

                                        1 {$weekday = "Sunday"}

                                        2 {$weekday = "Monday"}

                                        3 {$weekday = "Tuesday"}

                                        4 {$weekday = "Wednesday"}

                                        5 {$weekday = "Thursday"}

                                        6 {$weekday = "Friday"}

                                        7 {$weekday = "Saturday"}

                                    }

                                "This maintenance window occurs every $($ScheduleString.TokenData.ForNumberofWeeks) week(s) on $($weekday) and lasts $($ScheduleString.TokenData.HourDuration) hour(s) and $($ScheduleString.TokenData.MinuteDuration) minute(s) starting on $($startTime)." | Out-File -FilePath $FilePath -Append}

                        4

                            {

                                switch ($ScheduleString.TokenData.Day)

                                    {

                                        1 {$weekday = "Sunday"}

                                        2 {$weekday = "Monday"}

                                        3 {$weekday = "Tuesday"}

                                        4 {$weekday = "Wednesday"}

                                        5 {$weekday = "Thursday"}

                                        6 {$weekday = "Friday"}

                                        7 {$weekday = "Saturday"}

                                    }

                                switch ($ScheduleString.TokenData.weekorder)

                                    {

                                        0 {$order = "last"}

                                        1 {$order = "first"}

                                        2 {$order = "second"}

                                        3 {$order = "third"}

                                        4 {$order = "fourth"}

                                    }

                                "This maintenance window occurs every $($ScheduleString.TokenData.ForNumberofMonths) month(s) on every $($order) $($weekday)" | Out-File -FilePath $FilePath -Append

                            }

                        5

                            {

                                if ($ScheduleString.TokenData.MonthDay -eq "0")

                                    {

                                        $DayOfMonth = "the last day of the month"

                                    }

                                else

                                    {

                                        $DayOfMonth = "day $($ScheduleString.TokenData.MonthDay)"

                                    }

                                "This maintenance window occurs every $($ScheduleString.TokenData.ForNumberofMonths) month(s) on $($DayOfMonth)." | Out-File -FilePath $FilePath -Append

                                "It lasts $($ScheduleString.TokenData.HourDuration) hours and $($ScheduleString.TokenData.MinuteDuration) minutes." | Out-File -FilePath $FilePath -Append

                            }

                    }

                switch ($ServiceWindow.IsEnabled)

                    {

                        true {"The maintenance window is enabled" | Out-File -FilePath $FilePath -Append}

                        false {"The maintenance window is disabled" | Out-File -FilePath $FilePath -Append}

                    }

                "Going to next Maintenance window" | Out-File -FilePath $FilePath -Append

                "---------------------------------------------" | Out-File -FilePath $FilePath -Append

            }

        "No more maintenance windows present on this collection. Going to next collection." | Out-File -FilePath $FilePath -Append

        "###############################################" | Out-File -FilePath $FilePath -Append

    }

"No more maintenance windows present. Exiting documentation script"  | Out-File -FilePath $FilePath –Append
```

By the way, don’t worry if you’ll get an error on your commandline stating some invalid arguments in line 56. I’m working on it, but as far as I can see, it doesn’t affect functionality.

Looking forward to your comments!


