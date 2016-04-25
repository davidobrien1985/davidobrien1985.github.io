---
id: 1392
title: How to configure Full Update on Collection in ConfigMgr with Powershell
date: 2013-10-12T09:37:10+00:00

layout: single

permalink: /2013/10/how-to-configure-full-update-collection-in-configmgr-with-powershell/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - Collections
  - ConfigMgr2012R2
  - Microsoft
  - Powershell
  - SCCM
  - System Center
---
I did a little cleanup of my ConfigMgr collections and came across a problem I already had before but did not solve properly and someone on Niall’s forum also had ([http://www.windows-noob.com/forums/index.php?/topic/8770-powershell-to-set-full-device-schedule-in-sccm-2012/](http://www.windows-noob.com/forums/index.php?/topic/8770-powershell-to-set-full-device-schedule-in-sccm-2012/)).

How do you configure “Schedule a full Update on this collection” on already existing collections?

## How to create a new collection in ConfigMgr with a Schedule

It’s fairly easy to create this schedule for collections while creating them, this is already built into the native cmdlets.

```
$schedule = New-CMSchedule -RecurInterval Hours -RecurCount 2
New-CMDeviceCollection -Name "Collection with Schedule" -LimitingCollectionName "All Systems" -RefreshSchedule $schedule
```

## How to configure existing Collections with a Schedule

By default a collection does a full update every 7 days. But what if that’s not enough? Do “Incremental Updates.

Well, that’s also what I usually do. Microsoft says, though, to not enable this option on more than round about 200 collections. This number all depends on your environment. It might be that 1000 collections with incremental updates works for you or only 150, I don’t know and that’s not really the point here 😉

Lets just assume that you have some collections where you want to have a full update every 4 hours.

I want to do that configuration on all my Software Update Management collections and I know that their names all start with “SUM”. (Please, use naming schemes!!!”")

At first I had a look at the cmdlet [Set-CMDeviceCollection](http://technet.microsoft.com/en-us/library/jj821878(v=sc.10).aspx) but that won’t do anything about the schedules. After that I remembered that I already did something similar to packages and the above forum post on [www.windows-noob.com](http://www.windows-noob.com) shows it: [/2013/07/23/how-to-edit-configmgr-packages-update-on-schedule/](/2013/07/23/how-to-edit-configmgr-packages-update-on-schedule/)

I didn’t need to do much change to this script, just a bit of renaming and such:

```
[CmdletBinding()]
param ([string]$SMSProvider)

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
        $scheduleToken.DaySpan = 0
        $scheduleToken.HourDuration = 0
        $scheduleToken.HourSpan = 4
        $scheduleToken.IsGMT = $false
        $scheduleToken.MinuteDuration = 0
        $scheduleToken.MinuteSpan = 0
        $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)
        }
}

[datetime]$startTime = [datetime]::Today
$SiteCode = Get-SiteCode
create-ScheduleToken

$Collections = Get-WmiObject -Class SMS_Collection -Namespace root\sms\site_$SiteCode -Filter "CollectionType = '2' AND Name like 'SUM%'"

foreach ($Collection in $Collections)
    {
        try
            {
                $Coll = Get-WmiObject -Class SMS_Collection -Namespace root\sms\site_$SiteCode -ComputerName $SMSProvider -Filter "CollectionID ='$($Collection.CollectionID)'"
                $Coll = [wmi]$Coll.__PATH
                $Coll.RefreshSchedule = $scheduletoken
                $Coll.put() | Out-Null
                Write-Verbose "Successfully edited Collection $($Coll.Name)."
            }
        catch
            {
                Write-Verbose "$($Coll.Name) could not be edited."
            }
    }
```

If you have a look at line 53 in that code, you’ll see my query for those collections I’d like to reconfigure.

```
$Collections = Get-WmiObject -Class SMS\_Collection -Namespace root\sms\site\_$SiteCode -Filter "CollectionType = '2' AND Name like 'SUM%'"
CollectionType = ‘2’ means it’s a device collection, 1 would be user collection.
```

Name like ‘SUM%’ means all collections which name starts with SUM and continue with any string.

Execute the script like this:

`Set-FullUpdateCollectionBySchedule.ps1 –SMSProvider %YourSMSProvider% -Verbose`

Before the script:

![Collection Properties](/media/2013/10/image6.png)

After the script:
![PowerShell script](/media/2013/10/image7.png)

![Collection properties](/media/2013/10/image8.png)



