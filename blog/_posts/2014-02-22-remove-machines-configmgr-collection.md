---
id: 1644
title: How to remove machines from ConfigMgr Collection
date: 2014-02-22T00:13:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1644
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

# Maik Koster’s OSDWebService for SCCM {.}

I am sure you all already know Maik Koster’s OSDWebService available on Codeplex? [https://mdtcustomizations.codeplex.com/]("https://mdtcustomizations.codeplex.com/" https://mdtcustomizations.codeplex.com/)  
It’s a really fine piece of tech and helps automate stuff that otherwise would have been scripted. Using Webservices also brings other advantages like easier authentication against a webservice than the SMSProvider and so on.

This customer wanted to use this web service, implemented it and integrated it at the end of the Task Sequence to remove the machine from the Collection, in order to prevent users from accidently pressing F12 when booting, pressing next, next and enter and then wondering why their machines get reinstalled 😉

One day they realized that none of their machines were being removed from the collections and that was because the clients were unable to access the Webservice. For whatever reason, that’s the customer’s network design. Good example for people not talking to each other 😉

# Orchestrator runbook to remove client membership {.}

What’s the alternative to using a 3rd party Web Service? Use Orchestrator! Orchestrator gives you SO MUCH MORE!!! Ok, enough 😉  
With the help of System Center 2012 R2 Orchestrator you would be able to trigger the removal of the client with only just a few simple steps.

The Orchestrator runbook, if we would want to keep it REALLY simple, could look like this:  
[<img src="/media/2015/01/1422177636_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/01/1422177636_full.png)

[](http://www.david-obrien.net/wp-content/uploads/2014/02/image6.png) Configure it like this:[](http://www.david-obrien.net/wp-content/uploads/2014/02/image7.png) 

<p class="wrapped">
</p>

[](http://www.david-obrien.net/wp-content/uploads/2014/02/image8.png)[<img src="/media/2015/01/1422177721_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/01/1422177721_full.png) 

[<img src="/media/2015/01/1422177764_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/01/1422177764_full.png)

Check in the runbook and go back to the ConfigMgr console and edit your Task Sequence. The following will only work if you have MDT integrated into your ConfigMgr console, otherwise you won’t have access to the step I’m going to show you next.  
[](http://www.david-obrien.net/wp-content/uploads/2014/02/image9.png)[<img src="/media/2015/01/1422177838_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/01/1422177838_full.png)  
Near the end of my Win 8.1 deployment Task Sequence I add a step which will execute an Orchestrator Runbook. Again, you will only be able to select that step if you integrated the MDT Task Sequence extensions to your console. You only need to provide your Orchestrator server and select the appropriate Runbook. I select to specify the parameters myself that are needed for the “Initialize Data” Runbook activity. The ClientName will use the built-in OSD variable %OSDComputerName% and the CollectionID I set as a collection variable.
  
I don’t need the Task Sequence to wait for runbook completion, so I just uncheck that box.

There is the advantage that the client in this scenario does not need any direct access to the SMSProvider and you don’t have to rely on any third party tools.

Downside might be that you either don’t have Orchestrator implemented or just don’t allow your clients to access the Orchestrator infrastructure, for whatever reason (untrusted domain, security concerns, licensing, …)

&nbsp;

# Using Powershell to remove client from SCCM Collection {.}

So maybe you just don’t want to or can’t allow your clients to communicate with your ConfigMgr environment in that way that they somehow would be able to remove themselves from a collection.

Here are two alternatives what you could do by using Powershell.

##  {.}

## Scheduled Task to remove Client from Collection {.}

I wrote a little Powershell script that will remove all clients (that means ALL clients) from a given Collection that have a client installed.

Before deploying or re-deploying a device you would usually put it into a “staging collection” or “deployment collection” in order for it to receive the OSD policy. At this stage it is either a new client (recently added) and doesn’t have a client installed or an existing one which already has a client.

This is the Powershell Script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> $SMSProvider = <span style="color: #006080;">"localhost"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3:</span> Function Get-SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:</span>     $wqlQuery = “SELECT * FROM SMS_ProviderLocation”</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6:</span>     $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;">   7:</span>     $a | ForEach-Object {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;">   8:</span>         <span style="color: #0000ff;">if</span>($_.ProviderForLocalSite)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;">   9:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;">  10:</span>                 $script:SiteCode = $_.SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;">  11:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;">  12:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;">  13:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;">  14:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;">  15:</span> Get-SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;">  16:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;">  17:</span> #Import the CM12 Powershell cmdlets</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;">  18:</span> <span style="color: #0000ff;">if</span> (-not (Test-Path -Path $SiteCode))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;">  19:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;">  20:</span>         Write-Verbose <span style="color: #006080;">"$(Get-Date):   CM12 module has not been imported yet, will import it now."</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;">  21:</span>         Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length – 5) + <span style="color: #006080;">'\ConfigurationManager.psd1'</span>) | Out-Null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;">  22:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;">  23:</span> #CM12 cmdlets need to be run from the CM12 drive</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;">  24:</span> Set-Location <span style="color: #006080;">"$($SiteCode):"</span> | Out-Null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;">  25:</span> <span style="color: #0000ff;">if</span> (-not (Get-PSDrive -Name $SiteCode))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;">  26:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;">  27:</span>         Write-Error <span style="color: #006080;">"There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive."</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;">  28:</span>         exit 1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;">  29:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;">  30:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;">  31:</span> $Collection = Get-CMDeviceCollection -Name <span style="color: #006080;">"Deploy Client OS"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;">  32:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;">  33:</span> Get-WmiObject -Class SMS_FullCollectionMembership -Namespace root\SMS\Site_$SiteCode -Filter <span style="color: #006080;">"CollectionID = '$($Collection.CollectionID)' AND IsClient = '1'"</span> | Remove-CMDeviceCollectionDirectMembershipRule -CollectionId $Collection.CollectionID –Force</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

This script will run on a server with an installed Admin Console (because of the ConfigMgr cmdlets). Change line 31 to reflect the name of your deployment collection.  
Now create a new scheduled task that runs every night and thus clean up your staging collection.

Do you already have Windows PowerShell 4.0? Then do this:

  * Save the script for example as “C:\Scripts\CleanUpCollection.ps1”

Run this to create the scheduled task configured to run daily at 3am in the context of User “do\!jd”. Make sure you use an account that has permissions to remove devices from the collection.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> $ScheduledTaskAction = New-ScheduledTaskAction -Execute <span style="color: #006080;">"powershell.exe -ExecutionPolicy Bypass -file 'C:\Temp\CM12RemoveDirectMembersFromCollection.ps1'"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2:</span> $ScheduledTaskTrigger = New-ScheduledTaskTrigger -Daily -At 3am</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3:</span> $ScheduledTaskSettingsSet = New-ScheduledTaskSettingsSet</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:</span> $D = New-ScheduledTask -Action $ScheduledTaskAction -Trigger $ScheduledTaskTrigger -Settings $ScheduledTaskSettingsSet</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:</span> Register-ScheduledTask <span style="color: #006080;">"Cleanup Collection"</span> -InputObject $D -User <span style="color: #006080;">"do\!jd"</span> -Password <span style="color: #006080;">'P@ssw0rd'</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Downside to above script running as a scheduled task is that it **might** remove devices from your collection that you put there knowingly for restaging. The script will remove all devices that have the Property “IsClient = ‘1’”. You might want to check if that’s ok for you.

## Orchestrator runbook run via ConfigMgr Status Filter Rule {.}

The last alternative is pretty cool. I came up with this while thinking about what could be done, but then after searching the internet a bit I came across a blog post from Peter van der Woude: [http://www.petervanderwoude.nl/post/using-a-status-filter-rule-to-delete-a-collection-membership-via-orchestrator-and-configmgr-2012/]("http://www.petervanderwoude.nl/post/using-a-status-filter-rule-to-delete-a-collection-membership-via-orchestrator-and-configmgr-2012/" http://www.petervanderwoude.nl/post/using-a-status-filter-rule-to-delete-a-collection-membership-via-orchestrator-and-configmgr-2012/)

Here he demonstrates how to remove a client from a collection based on the Status Messages the client is sending up to the Management Point after Task Sequence completion.

A bit more on Status Filter Rules can be found here: [http://technet.microsoft.com/en-us/library/gg712680.aspx]("http://technet.microsoft.com/en-us/library/gg712680.aspx" http://technet.microsoft.com/en-us/library/gg712680.aspx)

If you don’t want to use Orchestrator, you could still modify my script a bit and use the same Status Filter Rule and instead of executing the SCOJobRunner.exe use the Powershell Script.

Have fun! <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

-&nbsp;[David]("David on Twitter" http://www.twitter.com/david_obrien)

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


