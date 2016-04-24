---
id: 543
title: How to automate Offline Servicing in Configuration Manager 2012
date: 2012-12-17T10:55:00+00:00
author: "David O'Brien"
layout: single

permalink: /2012/12/how-to-automate-offline-servicing-in-configuration-manager-2012/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Powershell
  - SCCM
  - SCCM 2012
  - System Center Configuration Manager
---

# Image Offline Servicing in SCCM 2012

In my last post ([Create a new Software Update Group in ConfigMgr](/2012/12/create-a-new-software-update-group-in-configmgr/) I showed you how to create a new Software Update Group, e.g. when the latest Microsoft updates are available. By the way, there will be an upgrade to that post!

Today I’m going to show you how to automate the process called Image Offline Servicing by script.


## What’s Offline Servicing?

Offline Servicing is the process of updating/patching an already captured image with Software Updates without actually applying the image and installing the updates.

This process is now built-in to ConfigMgr 2012.

You can configure the process inside the GUI:

![image](/2012/12/image.png "image")

Doing this you can apply any Software Updates that haven’t already been applied to the image without recapturing the image.

I know that people have probably done this stuff for many years now, for example like this: [http://blogs.technet.com/b/configmgrdogs/archive/2012/02/15/applying-windows-updates-to-a-base-wim-using-dism-and-powershell.aspx]("http://blogs.technet.com/b/configmgrdogs/archive/2012/02/15/applying-windows-updates-to-a-base-wim-using-dism-and-powershell.aspx" http://blogs.technet.com/b/configmgrdogs/archive/2012/02/15/applying-windows-updates-to-a-base-wim-using-dism-and-powershell.aspx)

But now we’re able to do this inside of our ConfigMgr console and with one click can see which updates are inside of an Image Package.

## Building the workflow – behind the scenes

What are the steps to successfully scheduling a new Offline Servicing task?

If you click it in the console it’s just three steps:

1. Select the image you want to update
2. You’ll be presented with the updates found in your database that match the images OS and architecture
3. When shall it happen? ASAP or at a specific time?

Unfortunately, I had to do a bit more in my script. Again, lots of it isn’t documented in the SDK, so the infamous SMSProv.log was a really good friend during the last two weeks.

My script contains five steps, or better, functions.

1. Get the ID of the image that’s going to be updated. This is done via its name.
2. Create a Schedule Token, so that the process knows when to run. This is a bit cryptic.
3. Tell the image that there’ll be a new schedule and apply the image to the token created in step 2.
4. Get all the updates that shall be applied to the image and glue them to the schedule.
5. Start the Offline Servicing Manager process.

The command line to execute the script will look like this:

```
.\create-OfflineImageServicingSchedule.ps1 -SiteCode LAB -UpdateGroupName "Windows 7" -ImageName "Windows 7 Enterprise" -UpdateDP
```

## How to find the Software Update CI_ID

The parameter ‘UpdateGroupName’ is mandatory. By providing a Software Update Group containing those updates, that need to be applied to the image, the script is able to find the necessary CI_IDs, by which ConfigMgr internally refers the updates to. (see function `add-UpdateToOfflineServicingSchedule` lines 84 to 96 in the script)

I can’t think of an other way of selecting the Updates without asking the user to input every single update on the command line or via an input file, other than putting them all in a single Software Update Group and get the information I need out of those.

You’re welcome to share any idea you have!

## How to create a Schedule Token

As we’re about to create an event which needs to be scheduled, we have to also create a Schedule Token to tell ConfigMgr when to run the event, for example once, daily, weekly or monthly.

Our event is going to run only once. We therefore need a subclass of the SMS\_ScheduleToken WMI class. That’ll be the SMS\_ST_NonRecurring class. (MSDN: [http://msdn.microsoft.com/en-us/library/hh948302.aspx]("http://msdn.microsoft.com/en-us/library/hh948302.aspx" http://msdn.microsoft.com/en-us/library/hh948302.aspx))

For more info on all this, look at Jeff Huston’s article about these SMS Schedule Tokens: [http://jeff.squarecontrol.com/archives/92]("http://jeff.squarecontrol.com/archives/92" http://jeff.squarecontrol.com/archives/92)

## How to run the Offline Servicing Manager process

This one was quite tricky to find, as it seems to be complete undocumented. I wondered why the Schedule wouldn’t fire off and start the Offline Servicing process, until I had a look at the SMSProv.log file and saw that at the very end of the whole adding of updates to the schedule there was a method run called RunOfflineServicingManager, which is part of the WMI class SMS_Imagepackage. I wasn’t able to find this method in the SDK and MSDN ([http://msdn.microsoft.com/en-us/library/hh948758.aspx]("http://msdn.microsoft.com/en-us/library/hh948758.aspx" http://msdn.microsoft.com/en-us/library/hh948758.aspx)).

With the help of the WMIExplorer I was able to write a small function to execute the process.

### The Script

```
param (
[parameter(Mandatory=$true)]
[string]$SiteCode,
[parameter(Mandatory=$true)]
[string]$UpdateGroupName,
[parameter(Mandatory=$true)]
[string]$ImageName,
[parameter(Mandatory=$true)]
[switch]$UpdateDP
)

Function Convert-NormalDateToConfigMgrDate {
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$starttime
  )
  [System.Management.ManagementDateTimeconverter]::ToDMTFDateTime($starttime)
}

Function create-ScheduleToken {
  ##Create a SMS_ST_NonRecurring object to use as schedule token
  $SMS_ST_NonRecurring = "SMS_ST_NonRecurring"
  $class_SMS_ST_NonRecurring = [wmiclass]""
  $class_SMS_ST_NonRecurring.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ST_NonRecurring)"
  $scheduleToken = $class_SMS_ST_NonRecurring.CreateInstance()

  if($scheduleToken)
  {
    $scheduleToken.DayDuration = 0
    $scheduleToken.HourDuration = 0
    $scheduleToken.IsGMT = FALSE
    $scheduleToken.MinuteDuration = 0
    $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)
    $SMS_ScheduleMethods = "SMS_ScheduleMethods"
    $class_SMS_ScheduleMethods = [wmiclass]""
    $class_SMS_ScheduleMethods.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ScheduleMethods)"
    $script:ScheduleString = $class_SMS_ScheduleMethods.WriteToString($scheduleToken)
  }
}##### end function

#### begin function

Function create-ImageServicingSchedule {
  $SMS_ImageServicingSchedule = "SMS_ImageServicingSchedule"
  $class_SMS_ImageServicingSchedule = [wmiclass]""
  $class_SMS_ImageServicingSchedule.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingSchedule)"
  $SMS_ImageServicingSchedule = $class_SMS_ImageServicingSchedule.CreateInstance()
  $SMS_ImageServicingSchedule.Action = 1
  $SMS_ImageServicingSchedule.Schedule = "$($ScheduleString.StringData)"
  # Update the Distribution Point afterwards?

  if ($UpdateDP) {
    $SMS_ImageServicingSchedule.UpdateDP = $true
  }
  else {
    $SMS_ImageServicingSchedule.UpdateDP = $false
  }

  $schedule = $SMS_ImageServicingSchedule.Put()
  $script:scheduleID = $schedule.RelativePath.Split("=")[1]
  # apply Schedule to Image
  $SMS_ImageServicingScheduledImage = "SMS_ImageServicingScheduledImage"
  $class_SMS_ImageServicingScheduledImage = [wmiclass]""
  $class_SMS_ImageServicingScheduledImage.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingScheduledImage)"
  $SMS_ImageServicingScheduledImage = $class_SMS_ImageServicingScheduledImage.CreateInstance()
  $SMS_ImageServicingScheduledImage.ImagePackageID = "$($ImagePackageID)"
  $SMS_ImageServicingScheduledImage.ScheduleID = $scheduleID
  $SMS_ImageServicingScheduledImage.Put() | Out-Null
} ##### end function

#### begin function

Function add-UpdateToOfflineServicingSchedule {
  $UpdateGroup = Get-WmiObject -Namespace root\sms\site_$SiteCode -Class SMS_AuthorizationList | where {$_.LocalizedDisplayName -eq "$($UpdateGroupName)"}
  #direct reference to the Update Group
  $UpdateGroup = [wmi]"$($UpdateGroup.__PATH)"

  # get every CI_ID in the Update Group
  foreach ($Update in $UpdateGroup.Updates)
  {
    $Update = Get-WmiObject -Namespace root\sms\site_$SiteCode -class SMS_SoftwareUpdate | where {$_.CI_ID -eq "$($Update)"}
    [array]$CIIDs += $Update.CI_ID
  }
  foreach ($CIID in $CIIDs) {
    $SMS_ImageServicingScheduledUpdate = "SMS_ImageServicingScheduledUpdate"
    $class_SMS_ImageServicingScheduledUpdate = [wmiclass]""
    $class_SMS_ImageServicingScheduledUpdate.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingScheduledUpdate)"
    $SMS_ImageServicingScheduledUpdate = $class_SMS_ImageServicingScheduledUpdate.CreateInstance()
    $SMS_ImageServicingScheduledUpdate.ScheduleID = $scheduleID
    $SMS_ImageServicingScheduledUpdate.UpdateID = $CIID
    $SMS_ImageServicingScheduledUpdate.Put() | Out-Null
  }
} #### end function

#### begin function

Function run-OfflineServicingManager {

  $Class = "SMS_ImagePackage"
  $Method = "RunOfflineServicingManager"
  $WMIClass = [WmiClass]"ROOT\sms\site_$($SiteCode):$Class"
  $Props = $WMIClass.psbase.GetMethodParameters($Method)
  $Props.PackageID = "$($ImagePackageID)"
  $Props.ServerName = "$(([System.Net.Dns]::GetHostByName(($env:computerName))).Hostname)"
  $Props.SiteCode = "$($SiteCode)"
  $WMIClass.PSBase.InvokeMethod($Method, $Props, $Null) | Out-Null
} #end function

#### begin Function

Function get-ImagePackageID {
  $script:ImagePackageID = (Get-WmiObject -Class SMS_ImagePackage -Namespace Root\SMS\site_$SiteCode | where {$_.name -eq "$($Imagename)"}).PackageID
}

############ Main Script starts here!

$schedule = $null

$ScheduleID = $null

[array]$script:CIIDs = @()

$CIID = $null

$ImagePackageID = $null

[datetime]$script:StartTime = Get-Date

get-ImagePackageID

create-ScheduleToken

create-ImageServicingSchedule

add-UpdateToOfflineServicingSchedule

run-OfflineServicingManager
```

Combining this script with my previous one to create a Software Update Group, you are able to automate the whole stuff!

Comments are welcome and looked forward to  ;-) Either here or via Twitter (@david_obrien).


