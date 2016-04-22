---
id: 1107
title: How to sync the Software Update Point (ConfigMgr) via Powershell
date: 2013-07-21T10:58:56+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1107
permalink: /2013/07/how-to-sync-the-software-update-point-configmgr-via-powershell/
categories:
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - ConfigMgr2012R2
  - Configuration Manager
  - Powershell
  - SCCM
  - scripting
---
Here is another short script you can use on your way to automate every task in your ConfigMgr environment.

# Syncing the SUP in ConfigMgr 2012

Synchronizing the Software Update Point in a ConfigMgr environment can happen in two ways - automatically or manually.

This can be configured in your site component's configuration:

![Software Update Point configuration](/media/2013/07/SUP_settings.jpg)

In there you can configure the SUP to synchronize on a schedule or not. If you don't use a schedule, you'll have to sync manually.

Sometimes you want to do both. Maybe one schedule is so far apart from the next and you want to sync manually in-between?

Two ways to do that aswell 😉

Synchronizing the SUP manually means log on to the console, go to your Software Library, choose the Software Updates node and then "All Software Updates". You'll then see a "Synchronize Software Updates" button in the upper ribbon.

![synchronize SUP manually](/media/2013/07/SYNC_SUP.jpg)

Hit that button to synchronize the SUP.

# How to use Powershell to sync SUP

You can also use this sript to sync your SUP without logging into your console or even your admin server. This script can also be used inside an Orchestrator Runbook (will show that at a later point).

It basically calls a method (SyncNow) from the SMS_SoftwareUpdate class.

Execute the script like this:

```
.\sync-SUP.ps1 -SMSProvider %NameOfSMSProvider% -verbose
```

The verbose switch is optional and will give you a bit of output in the end.

Here's the script, you can also download it here: [https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1](https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1)

```
[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" )]

param(
[string]$SMSProvider
)

Function Get-SiteCode
{
    $wqlQuery = “SELECT * FROM SMS_ProviderLocation”
    $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider
    $a | ForEach-Object {
    if($_.ProviderForLocalSite)
        {
            $siteCode = $_.SiteCode
        }
}

return $sitecode | Out-Null
}

Get-SiteCode

$SUP = [wmiclass]("\\$SMSProvider\root\SMS\Site_$($SiteCode):SMS_SoftwareUpdate")
$Params = $SUP.GetMethodParameters("SyncNow")
$Params.fullSync = $true
$Return = $SUP.SyncNow($Params)

if ($Return.ReturnValue -eq "0")
    {
        Write-Verbose "Sync of SUP successful"
    }
else
    {
        Write-Verbose "There was an error syncing the SUP"
    }
```

