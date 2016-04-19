---
id: 1107
title: How to sync the Software Update Point (ConfigMgr) via Powershell
date: 2013-07-21T10:58:56+00:00
author: "David O'Brien"
layout: post
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

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/SUP_settings.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/SUP_settings.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Software Update Point configuration" alt="Software Update Point configuration" src="http://www.david-obrien.net/wp-content/uploads/2013/07/SUP_settings_thumb.jpg" width="244" height="150" border="0" /></a>

In there you can configure the SUP to synchronize on a schedule or not. If you don't use a schedule, you'll have to sync manually.

Sometimes you want to do both. Maybe one schedule is so far apart from the next and you want to sync manually in-between?

Two ways to do that aswell 😉

Synchronizing the SUP manually means log on to the console, go to your Software Library, choose the Software Updates node and then "All Software Updates". You'll then see a "Synchronize Software Updates" button in the upper ribbon.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/SYNC_SUP.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/SYNC_SUP.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="synchronize SUP manually" alt="synchronize SUP manually" src="http://www.david-obrien.net/wp-content/uploads/2013/07/SYNC_SUP_thumb.jpg" width="244" height="157" border="0" /></a>Hit that button to synchronize the SUP.

# How to use Powershell to sync SUP

You can also use this sript to sync your SUP without logging into your console or even your admin server. This script can also be used inside an Orchestrator Runbook (will show that at a later point).

It basically calls a method (SyncNow) from the SMS_SoftwareUpdate class.

Execute the script like this:

> .\sync-SUP.ps1 -SMSProvider %NameOfSMSProvider% -verbose

The verbose switch is optional and will give you a bit of output in the end.

Here's the script, you can also download it here: <a href="https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1', 'https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1']);" >https://davidobrien.codeplex.com/SourceControl/latest#sync-SUP.ps1</a>

<div class="wlWriterEditableSmartContent" id="scid:812469c5-0cb0-4c63-8c15-c81123a09de7:5d58620b-c683-4e80-865a-23ccece25274" style="float: none; margin: 0px; display: inline; padding: 0px;">
  <pre class="vb">[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" )]

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
    }</pre>
</div>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr2012R2,Configuration+Manager,Powershell,SCCM,scripting" data-count="vertical" data-url="http://www.david-obrien.net/2013/07/how-to-sync-the-software-update-point-configmgr-via-powershell/">Tweet</a>
</div>

