---
id: 1644
title: How to remove machines from ConfigMgr Collection
date: 2014-02-22T00:13:00+00:00

layout: single

permalink: /2014/02/remove-machines-configmgr-collection/
categories:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Orchestrator
  - PowerShell
  - SCCM
  - System Center
tags:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Orchestrator
  - Powershell
  - SCCM
  - SCOJobRunner
  - System Center
---
A customer of mine had a little workflow / network / process related problem regarding staging of machines.

What they wanted to achieve was just to remove the client from the staging Collection at the end of installation. Not too complicated you might think. This article will show you some alternatives you can use around your OS Deployment by using the example of removing devices from a collection after successful installation.

# Maik Koster’s OSDWebService for SCCM

I am sure you all already know Maik Koster’s OSDWebService available on Codeplex? [https://mdtcustomizations.codeplex.com/](https://mdtcustomizations.codeplex.com/)
It’s a really fine piece of tech and helps automate stuff that otherwise would have been scripted. Using Webservices also brings other advantages like easier authentication against a webservice than the SMSProvider and so on.

This customer wanted to use this web service, implemented it and integrated it at the end of the Task Sequence to remove the machine from the Collection, in order to prevent users from accidently pressing F12 when booting, pressing next, next and enter and then wondering why their machines get reinstalled 😉

One day they realized that none of their machines were being removed from the collections and that was because the clients were unable to access the Webservice. For whatever reason, that’s the customer’s network design. Good example for people not talking to each other 😉

# Orchestrator runbook to remove client membership

What’s the alternative to using a 3rd party Web Service? Use Orchestrator! Orchestrator gives you SO MUCH MORE!!! Ok, enough 😉
With the help of System Center 2012 R2 Orchestrator you would be able to trigger the removal of the client with only just a few simple steps.

The Orchestrator runbook, if we would want to keep it REALLY simple, could look like this:

![image](/media/2015/01/1422177636_full.png)

![image](/media/2014/02/image6.png)

Configure it like this:
![image](/media/2014/02/image7.png)

![image](/media/2014/02/image8.png)

![image](/media/2015/01/1422177721_full.png)

![image](/media/2015/01/1422177764_full.png)

Check in the runbook and go back to the ConfigMgr console and edit your Task Sequence. The following will only work if you have MDT integrated into your ConfigMgr console, otherwise you won’t have access to the step I’m going to show you next.
![image](/media/2014/02/image9.png)

![image](/media/2015/01/1422177838_full.png)

Near the end of my Win 8.1 deployment Task Sequence I add a step which will execute an Orchestrator Runbook. Again, you will only be able to select that step if you integrated the MDT Task Sequence extensions to your console. You only need to provide your Orchestrator server and select the appropriate Runbook. I select to specify the parameters myself that are needed for the “Initialize Data” Runbook activity. The ClientName will use the built-in OSD variable %OSDComputerName% and the CollectionID I set as a collection variable.

I don’t need the Task Sequence to wait for runbook completion, so I just uncheck that box.

There is the advantage that the client in this scenario does not need any direct access to the SMSProvider and you don’t have to rely on any third party tools.

Downside might be that you either don’t have Orchestrator implemented or just don’t allow your clients to access the Orchestrator infrastructure, for whatever reason (untrusted domain, security concerns, licensing, …)

# Using Powershell to remove client from SCCM Collection

So maybe you just don’t want to or can’t allow your clients to communicate with your ConfigMgr environment in that way that they somehow would be able to remove themselves from a collection.

Here are two alternatives what you could do by using Powershell.

## Scheduled Task to remove Client from Collection

I wrote a little Powershell script that will remove all clients (that means ALL clients) from a given Collection that have a client installed.

Before deploying or re-deploying a device you would usually put it into a “staging collection” or “deployment collection” in order for it to receive the OSD policy. At this stage it is either a new client (recently added) and doesn’t have a client installed or an existing one which already has a client.

This is the Powershell Script:

```PowerShell
$SMSProvider = 'localhost'

Function Get-SiteCode
{
    $wqlQuery = 'SELECT * FROM SMS_ProviderLocation'
    $a = Get-WmiObject -Query $wqlQuery -Namespace 'root\sms' -ComputerName $SMSProvider
    $a | ForEach-Object {
        if($_.ProviderForLocalSite)
        {
            $script:SiteCode = $_.SiteCode
        }
    }
}

Get-SiteCode

#Import the CM12 Powershell cmdlets
if (-not (Test-Path -Path $SiteCode))
{
    Write-Verbose "$(Get-Date):   CM12 module has not been imported yet, will import it now."
    Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length – 5) + '\ConfigurationManager.psd1') | Out-Null
}
#CM12 cmdlets need to be run from the CM12 drive
Set-Location "$($SiteCode):" | Out-Null
if (-not (Get-PSDrive -Name $SiteCode))
{
    Write-Error "There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive."
    exit 1
}
$Collection = Get-CMDeviceCollection -Name 'Deploy Client OS'
Get-WmiObject -Class SMS_FullCollectionMembership -Namespace root\SMS\Site_$SiteCode -Filter "CollectionID = '$($Collection.CollectionID)' AND IsClient = '1'" | Remove-CMDeviceCollectionDirectMembershipRule -CollectionId $Collection.CollectionID –Force
```

This script will run on a server with an installed Admin Console (because of the ConfigMgr cmdlets). Change line 31 to reflect the name of your deployment collection.
Now create a new scheduled task that runs every night and thus clean up your staging collection.

Do you already have Windows PowerShell 4.0? Then do this:

* Save the script for example as “C:\Scripts\CleanUpCollection.ps1”

Run this to create the scheduled task configured to run daily at 3am in the context of User “do\!jd”. Make sure you use an account that has permissions to remove devices from the collection.

```
$ScheduledTaskAction = New-ScheduledTaskAction -Execute "powershell.exe -ExecutionPolicy Bypass -file 'C:\Temp\CM12RemoveDirectMembersFromCollection.ps1'"
$ScheduledTaskTrigger = New-ScheduledTaskTrigger -Daily -At 3am
$ScheduledTaskSettingsSet = New-ScheduledTaskSettingsSet
$D = New-ScheduledTask -Action $ScheduledTaskAction -Trigger $ScheduledTaskTrigger -Settings $ScheduledTaskSettingsSet
Register-ScheduledTask "Cleanup Collection" -InputObject $D -User "do\!jd" -Password 'P@ssw0rd'
```

Downside to above script running as a scheduled task is that it **might** remove devices from your collection that you put there knowingly for restaging. The script will remove all devices that have the Property “IsClient = ‘1’”. You might want to check if that’s ok for you.

## Orchestrator runbook run via ConfigMgr Status Filter Rule {.}

The last alternative is pretty cool. I came up with this while thinking about what could be done, but then after searching the internet a bit I came across a blog post from Peter van der Woude: [http://www.petervanderwoude.nl/post/using-a-status-filter-rule-to-delete-a-collection-membership-via-orchestrator-and-configmgr-2012/](http://www.petervanderwoude.nl/post/using-a-status-filter-rule-to-delete-a-collection-membership-via-orchestrator-and-configmgr-2012/)

Here he demonstrates how to remove a client from a collection based on the Status Messages the client is sending up to the Management Point after Task Sequence completion.

A bit more on Status Filter Rules can be found here: [http://technet.microsoft.com/en-us/library/gg712680.aspx](http://technet.microsoft.com/en-us/library/gg712680.aspx)

If you don’t want to use Orchestrator, you could still modify my script a bit and use the same Status Filter Rule and instead of executing the SCOJobRunner.exe use the Powershell Script.

Have fun!

-[David](http://www.twitter.com/david_obrien)


