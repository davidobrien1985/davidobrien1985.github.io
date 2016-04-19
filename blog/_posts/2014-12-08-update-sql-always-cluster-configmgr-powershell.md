---
id: 2768
title: 'Update SQL Always On Cluster with ConfigMgr &amp; Powershell'
date: 2014-12-08T22:00:08+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2768
permalink: /2014/12/update-sql-always-cluster-configmgr-powershell/
categories:
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
  - SQL
tags:
  - AlwaysOn
  - automation
  - ConfigMgr
  - hotfixes
  - Powershell
  - SCCM
  - scripting
  - SQL
  - SQLPS
  - Updates
  - WSUS
---
# How to update a cluster with a cluster-ignorant tool

I’ve recently been tasked to create a process to patch SQL Always On Availability Groups (I guess calling it a cluster is not really accurate?!) with just the tools I had available, no new implementation of stuff. This meant to do a proper patching cycle (Operating System AND SQL) with graceful failovers of SQL roles from one node to the other, no data loss.

So, quick inventory; what did I have?

  * ConfigMgr 2012 R2
  * PowerShell

Phew, PowerShell, you can do a lot with PowerShell.
  
ConfigMgr, mhhh, ConfigMgr can do Software Updates and execute stuff on machines when it is told to do so. Very unfortunate though, it doesn’t really know what a cluster is.
  
Sidenote: No, I can’t use Cluster-Aware Updating (CAU), because a SQL Always On Availability Group is not really a cluster role, so the Cluster Aware Updating feature is not aware of the SQL Always On feature being installed. The complete opposite of a SQL failover Cluster.

So, I had to script the whole CAU logic myself and use ConfigMgr to execute the whole update procedure.

## High-level overview

First: I am not a DBA, I can find my way around SQL, but I’m not an expert. If you find something I could’ve done differently or better, don’t hesitate to comment down below.
  
I mainly used PowerShell cmdlets from the SQLPS module, which ships with SQL Server 2012, and also some self-written functions to handle ConfigMgr.

This is a screenshots of the functions I am using in my script to first do a SQL AlwaysOn Availability Group health-check (is everything synchronised?Does everything report back as healthy? Do a backup…) and after that I’m moving on to ConfigMgr.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb7.png" alt="image" width="347" height="157" border="0" />]("image" /media/2014/12/image7.png)

The idea is to put each node of an Availability Group, as soon as the script deems it healthy, into a pre-created ConfigMgr collection which has the appropriate updates/patches/hotfixes deployed to it and then execute all required deployments.

We thus have a couple of prerequisites on the ConfigMgr side:

  * Device collection 
      * all updates deployed to that collection with a required deployment
  * all SQL nodes need to have the ConfigMgr client installed and functional

Other prerequisites:

  * access to SQLPS PowerShell module
  * permissions to administrate all SQL nodes

The script will handle one SQL node after the other by walking through the following process:

  * add the node to the device Collection
  * force the new machine policy download
  * Trigger Software Update Scan cycle
  * Trigger Software Update Deployment Evaluation Cycle
  * if machine is not compliant, it will execute the deployments and the script will check for pending reboots 
      * if it detects a pending reboot, it reboots the machine via the ConfigMgr client SDK
      * after reboot it will do all over again until the machine reports that it is compliant
  * in the end the former Primary SQL node should again be the Primary node and all nodes be patched

## The PowerShell Script

For several reasons I can’t give you the whole script, but I can give you the ConfigMgr stuff. You should be able to come up with the rest by yourself or ask here if you get stuck.

I might turn this whole thing into a workflow in the future so that one can use it in SMA or Azure Automation.

<div id="wpshdo_22" class="wp-synhighlighter-outer">
  <div id="wpshdt_22" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_22"></a><a id="wpshat_22" class="wp-synhighlighter-title" href="#codesyntax_22"  onClick="javascript:wpsh_toggleBlock(22)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_22" onClick="javascript:wpsh_code(22)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_22" onClick="javascript:wpsh_print(22)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_22" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="kw3">Function</span> Get<span class="sy0">-</span>SiteCode <span class="br0">&#123;</span>
  <span class="br0">[</span>cmdletBinding<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
  <span class="kw3">param</span> <span class="br0">&#40;</span>
    <span class="re0">$SMSProvider</span>
  <span class="br0">&#41;</span>
  <span class="re0">$wqlQuery</span> <span class="sy0">=</span> <span class="st0">'SELECT * FROM SMS_ProviderLocation'</span>
  <span class="re0">$a</span> <span class="sy0">=</span> <span class="kw1">Get-WmiObject</span> <span class="kw5">-Query</span> <span class="re0">$wqlQuery</span> <span class="kw5">-Namespace</span> <span class="st0">'root\sms'</span> <span class="kw5">-ComputerName</span> <span class="re0">$SMSProvider</span>
  <span class="re0">$a</span> <span class="sy0">|</span> <span class="kw1">ForEach-Object</span> <span class="br0">&#123;</span>
    <span class="kw3">if</span><span class="br0">&#40;</span><a href="about:blank"><span class="kw6">$_</span></a>.ProviderForLocalSite<span class="br0">&#41;</span>
    <span class="br0">&#123;</span>
      <span class="re0">$SiteCode</span> <span class="sy0">=</span> <a href="about:blank"><span class="kw6">$_</span></a>.SiteCode
    <span class="br0">&#125;</span>
  <span class="br0">&#125;</span>
  <span class="kw3">return</span> <span class="re0">$SiteCode</span>
<span class="br0">&#125;</span>
<span class="kw3">Function</span> Add<span class="sy0">-</span>NodeToConfigMgrCollection <span class="br0">&#123;</span>
  <span class="br0">[</span>cmdletBinding<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
&nbsp;
  <span class="kw3">param</span> <span class="br0">&#40;</span>
    <span class="re0">$Node</span><span class="sy0">,</span>
    <span class="re0">$CollectionID</span><span class="sy0">,</span>
    <span class="re0">$SiteCode</span><span class="sy0">,</span>
    <span class="re0">$SMSProvider</span>
  <span class="br0">&#41;</span>
&nbsp;
  <span class="re0">$Device</span> <span class="sy0">=</span> <span class="kw1">Get-WmiObject</span> <span class="kw5">-ComputerName</span> <span class="re0">$SMSProvider</span> <span class="kw5">-Class</span> SMS_R_SYSTEM <span class="kw5">-Namespace</span> root\sms\site_<span class="re0">$SiteCode</span> <span class="sy0">-</span><span class="kw3">Filter</span> <span class="st0">"Name = '$Node'"</span>
  <span class="re0">$objColRuledirect</span> <span class="sy0">=</span> <span class="br0">[</span><span class="re3">WmiClass</span><span class="br0">]</span><span class="st0">"\\$SMSProvider\ROOT\SMS\site_$($SiteCode):SMS_CollectionRuleDirect"</span>
  <span class="re0">$objColRuleDirect</span>.psbase.properties<span class="br0">[</span><span class="st0">'ResourceClassName'</span><span class="br0">]</span>.value <span class="sy0">=</span> <span class="st0">'SMS_R_System'</span>
  <span class="re0">$objColRuleDirect</span>.psbase.properties<span class="br0">[</span><span class="st0">'ResourceID'</span><span class="br0">]</span>.value <span class="sy0">=</span> <span class="re0">$Device</span>.ResourceID
&nbsp;
  <span class="re0">$MC</span> <span class="sy0">=</span> <span class="kw1">Get-WmiObject</span> <span class="kw5">-Class</span> SMS_Collection <span class="kw5">-ComputerName</span> <span class="re0">$SMSProvider</span> <span class="kw5">-Namespace</span> <span class="st0">"ROOT\SMS\site_$SiteCode"</span> <span class="sy0">-</span><span class="kw3">Filter</span> <span class="st0">"CollectionID = '$CollectionID'"</span>
  <span class="re0">$InParams</span> <span class="sy0">=</span> <span class="re0">$mc</span>.psbase.GetMethodParameters<span class="br0">&#40;</span><span class="st0">'AddMembershipRule'</span><span class="br0">&#41;</span>
  <span class="re0">$InParams</span>.collectionRule <span class="sy0">=</span> <span class="re0">$objColRuledirect</span>
  <span class="re0">$R</span> <span class="sy0">=</span> <span class="re0">$mc</span>.PSBase.InvokeMethod<span class="br0">&#40;</span><span class="st0">'AddMembershipRule'</span><span class="sy0">,</span> <span class="re0">$inParams</span><span class="sy0">,</span> <span class="re0">$Null</span><span class="br0">&#41;</span>
<span class="br0">&#125;</span>
<span class="kw3">Function</span> Invoke<span class="sy0">-</span>PolicyDownload <span class="br0">&#123;</span>
  <span class="br0">[</span>CmdletBinding<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
  <span class="kw3">param</span><span class="br0">&#40;</span>
    <span class="br0">[</span>Parameter<span class="br0">&#40;</span>Position<span class="sy0">=</span><span class="sy0">,</span>ValueFromPipeline<span class="sy0">=</span><span class="re0">$true</span><span class="br0">&#41;</span><span class="br0">]</span>
    <span class="br0">[</span>System.String<span class="br0">]</span>        
    <span class="re0">$ComputerName</span><span class="sy0">=</span><span class="br0">&#40;</span><span class="kw1">get-content</span> env:computername<span class="br0">&#41;</span> <span class="co1">#defaults to local computer name        </span>
  <span class="br0">&#41;</span>
  Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm <span class="kw5">-Class</span> sms_client <span class="kw5">-Name</span> TriggerSchedule <span class="st0">'{00000000-0000-0000-0000-000000000021}'</span> <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span> <span class="kw5">-ErrorAction</span> SilentlyContinue <span class="sy0">|</span> <span class="kw1">Out-Null</span>
  <span class="co1">#Trigger machine policy download</span>
  Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm <span class="kw5">-Class</span> sms_client <span class="kw5">-Name</span> TriggerSchedule <span class="st0">'{00000000-0000-0000-0000-000000000022}'</span> <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span> <span class="kw5">-ErrorAction</span> SilentlyContinue <span class="sy0">|</span> <span class="kw1">Out-Null</span>
  <span class="co1">#Trigger Software Update Scane cycle</span>
  Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm <span class="kw5">-Class</span> sms_client <span class="kw5">-Name</span> TriggerSchedule <span class="st0">'{00000000-0000-0000-0000-000000000113}'</span> <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span> <span class="kw5">-ErrorAction</span> SilentlyContinue <span class="sy0">|</span> <span class="kw1">Out-Null</span>
  <span class="co1">#Trigger Software Update Deployment Evaluation Cycle</span>
  Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm <span class="kw5">-Class</span> sms_client <span class="kw5">-Name</span> TriggerSchedule <span class="st0">'{00000000-0000-0000-0000-000000000114}'</span> <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span> <span class="kw5">-ErrorAction</span> SilentlyContinue <span class="sy0">|</span> <span class="kw1">Out-Null</span>
&nbsp;
<span class="br0">&#125;</span>
<span class="kw3">Function</span> Get<span class="sy0">-</span>ConfigMgrSoftwareUpdateCompliance <span class="br0">&#123;</span>
  <span class="br0">[</span>CmdletBinding<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
  <span class="kw3">param</span><span class="br0">&#40;</span>
    <span class="br0">[</span>Parameter<span class="br0">&#40;</span>Position<span class="sy0">=</span><span class="sy0">,</span>ValueFromPipeline<span class="sy0">=</span><span class="re0">$true</span><span class="br0">&#41;</span><span class="br0">]</span>
    <span class="br0">[</span>System.String<span class="br0">]</span>        
    <span class="re0">$ComputerName</span><span class="sy0">=</span><span class="br0">&#40;</span><span class="kw1">get-content</span> env:computername<span class="br0">&#41;</span> <span class="co1">#defaults to local computer name        </span>
  <span class="br0">&#41;</span>
  Invoke<span class="sy0">-</span>PolicyDownload <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span>;
  <span class="kw3">do</span> <span class="br0">&#123;</span>
    <span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> 30
    <span class="kw1">Write-Output</span> <span class="st0">"Checking Software Updates Compliance on [$ComputerName]"</span>
&nbsp;
    <span class="co1">#check if the machine has an update assignment targeted at it</span>
    <span class="re0">$global</span>:UpdateAssigment <span class="sy0">=</span> <span class="kw1">Get-WmiObject</span> <span class="kw5">-Query</span> <span class="st0">'Select * from CCM_AssignmentCompliance'</span> <span class="kw5">-Namespace</span> root\ccm\SoftwareUpdates\DeploymentAgent <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span> <span class="kw5">-ErrorAction</span> SilentlyContinue ;
&nbsp;
    <span class="kw1">Write-Output</span> <span class="re0">$UpdateAssigment</span>
&nbsp;
    <span class="co1">#if update assignments were returned check to see if any are non-compliant</span>
    <span class="re0">$IsCompliant</span> <span class="sy0">=</span> <span class="re0">$true</span>                    
&nbsp;
    <span class="re0">$UpdateAssigment</span> <span class="sy0">|</span> <span class="kw1">ForEach-Object</span><span class="br0">&#123;</span>     
      <span class="co1">#mark the compliance as false</span>
      <span class="kw3">if</span><span class="br0">&#40;</span><a href="about:blank"><span class="kw6">$_</span></a>.IsCompliant <span class="kw4">-eq</span> <span class="re0">$false</span> <span class="kw4">-and</span> <span class="re0">$IsCompliant</span> <span class="kw4">-eq</span> <span class="re0">$true</span><span class="br0">&#41;</span><span class="br0">&#123;</span><span class="re0">$IsCompliant</span> <span class="sy0">=</span> <span class="re0">$false</span><span class="br0">&#125;</span>
    <span class="br0">&#125;</span>
    <span class="co1">#Check for pending reboot to finish compliance</span>
    <span class="re0">$rebootPending</span> <span class="sy0">=</span> <span class="br0">&#40;</span>Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm\clientsdk <span class="kw5">-Class</span> CCM_ClientUtilities <span class="kw5">-Name</span> DetermineIfRebootPending <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span><span class="br0">&#41;</span>.RebootPending
&nbsp;
    <span class="kw3">if</span> <span class="br0">&#40;</span><span class="re0">$rebootPending</span><span class="br0">&#41;</span>
    <span class="br0">&#123;</span>
      Invoke<span class="sy0">-</span>WmiMethod <span class="kw5">-Namespace</span> root\ccm\clientsdk <span class="kw5">-Class</span> CCM_ClientUtilities <span class="kw5">-Name</span> RestartComputer <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span>
      <span class="kw3">do</span> <span class="br0">&#123;</span><span class="st0">'waiting...'</span>;start<span class="sy0">-</span><span class="kw2">sleep</span> <span class="kw5">-Seconds</span> 5<span class="br0">&#125;</span> 
      <span class="kw3">while</span> <span class="br0">&#40;</span><span class="kw4">-not</span> <span class="br0">&#40;</span><span class="br0">&#40;</span><span class="kw1">get-service</span> <span class="kw5">-name</span> <span class="st0">'SMS Agent Host'</span> <span class="kw5">-ComputerName</span> <span class="re0">$ComputerName</span><span class="br0">&#41;</span>.Status <span class="kw4">-eq</span> <span class="st0">'Running'</span><span class="br0">&#41;</span><span class="br0">&#41;</span>
&nbsp;
    <span class="br0">&#125;</span> 
    <span class="kw3">else</span> <span class="br0">&#123;</span>
      <span class="kw1">Write-Output</span> <span class="st0">'No pending reboot. Continue...'</span>
    <span class="br0">&#125;</span>
  <span class="br0">&#125;</span>
  <span class="kw3">while</span> <span class="br0">&#40;</span><span class="kw4">-not</span> <span class="re0">$IsCompliant</span><span class="br0">&#41;</span>
<span class="br0">&#125;</span>
&nbsp;
<span class="co1">#Start Updating one Secondary Node at a time</span>
&nbsp;
<span class="re0">$SiteCode</span> <span class="sy0">=</span> Get<span class="sy0">-</span>SiteCode <span class="sy0">-</span>SMSProvider <span class="re0">$SMSProvider</span>
<span class="re0">$i</span> <span class="sy0">=</span> 0
<span class="kw3">foreach</span> <span class="br0">&#40;</span><span class="re0">$SecondaryReplica</span> <span class="kw3">in</span> <span class="re0">$SecondaryReplicaServer</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
  <span class="kw3">if</span> <span class="br0">&#40;</span><span class="kw4">-not</span> <span class="br0">&#40;</span><span class="re0">$AlreadyPatched</span> <span class="kw4">-contains</span> <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span><span class="br0">&#41;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
    try <span class="br0">&#123;</span>
      <span class="re0">$i</span><span class="sy0">++</span>
      <span class="kw1">Write-Verbose</span> <span class="st0">"Patching Server round $i = $($SecondaryReplica.Split('\')[0])"</span>
&nbsp;
      <span class="co1">#Add current secondary node to ConfigMgr collection to receive its updates</span>
      Add<span class="sy0">-</span>NodeToConfigMgrCollection <span class="sy0">-</span>Node <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span> <span class="sy0">-</span>SiteCode <span class="re0">$SiteCode</span> <span class="sy0">-</span>SMSProvider <span class="re0">$SMSProvider</span> <span class="sy0">-</span>CollectionID <span class="re0">$CollectionID</span> <span class="kw5">-Verbose</span>
&nbsp;
      <span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> 60
      Invoke<span class="sy0">-</span>policydownload <span class="kw5">-computername</span> <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
&nbsp;
      <span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> 120
      Invoke<span class="sy0">-</span>policydownload <span class="kw5">-computername</span> <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
&nbsp;
      <span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> <span class="nu0">120</span>
      <span class="co1">#Check if all updates have been installed and server finished rebooting</span>
      <span class="kw1">Write-Output</span> <span class="st0">'Applying updates now'</span>
      Get<span class="sy0">-</span>ConfigMgrSoftwareUpdateCompliance <span class="kw5">-ComputerName</span> <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
&nbsp;
      <span class="re0">$AlreadyPatched</span> <span class="sy0">+=</span> <span class="re0">$SecondaryReplica</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
    <span class="br0">&#125;</span>
    catch <span class="br0">&#123;</span>
      <span class="kw1">Write-Error</span> <a href="about:blank"><span class="kw6">$_</span></a>
    <span class="br0">&#125;</span>
  <span class="br0">&#125;</span>
  <span class="kw3">else</span> <span class="br0">&#123;</span>
    <span class="kw1">Write-Verbose</span> <span class="st0">"$($SecondaryReplica.Split('\')[0]) has already been patched. Skipping."</span>
  <span class="br0">&#125;</span>
<span class="br0">&#125;</span>
&nbsp;
<span class="co1"># fail over to one of the secondary nodes and update the primary node, after that, fail over again to the original primary node</span>
&nbsp;
Switch<span class="sy0">-</span>SqlAvailabilityGroup <span class="kw5">-Path</span> SQLSERVER:\Sql\$<span class="br0">&#40;</span>Get<span class="sy0">-</span>Random <span class="kw5">-InputObject</span> <span class="re0">$SecondaryReplicaServer</span><span class="br0">&#41;</span>\Default\AvailabilityGroups\<span class="re0">$AvailabilityGroupName</span> <span class="kw5">-Verbose</span>
Add<span class="sy0">-</span>NodeToConfigMgrCollection <span class="sy0">-</span>Node <span class="re0">$PrimaryReplicaServer</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span> <span class="sy0">-</span>SiteCode <span class="re0">$SiteCode</span> <span class="sy0">-</span>SMSProvider <span class="re0">$SMSProvider</span> <span class="sy0">-</span>CollectionID <span class="re0">$CollectionID</span> <span class="kw5">-Verbose</span>
&nbsp;
<span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> 60
Invoke<span class="sy0">-</span>PolicyDownload <span class="kw5">-computername</span> <span class="re0">$PrimaryReplicaServer</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
&nbsp;
<span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> 90
Invoke<span class="sy0">-</span>PolicyDownload <span class="kw5">-computername</span> <span class="re0">$PrimaryReplicaServer</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="br0">]</span>
&nbsp;
<span class="kw1">Start-Sleep</span> <span class="kw5">-Seconds</span> <span class="nu0">90</span>
<span class="co1">#Check if all updates have been installed and server finished rebooting</span>
<span class="kw1">Write-Output</span> <span class="st0">'Applying updates now'</span>
Get<span class="sy0">-</span>ConfigMgrSoftwareUpdateCompliance <span class="kw5">-ComputerName</span> <span class="re0">$PrimaryReplicaServer</span>.Split<span class="br0">&#40;</span><span class="st0">'\'</span><span class="br0">&#41;</span><span class="br0">[</span><span class="nu0"></span><span class="br0">]</span>
&nbsp;
&nbsp;
<span class="co1">#If the primary node is finished updating, fail over again to the Primary</span>
Switch<span class="sy0">-</span>SqlAvailabilityGroup <span class="kw5">-Path</span> SQLSERVER:\Sql\<span class="re0">$PrimaryReplicaServer</span>\Default\AvailabilityGroups\<span class="re0">$AvailabilityGroupName</span> <span class="kw5">-Verbose</span></pre>
  </div>
</div>

&nbsp;

Have fun automating!

- <a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="AlwaysOn,automation,ConfigMgr,hotfixes,Powershell,SCCM,scripting,SQL,SQLPS,Updates,WSUS" data-count="vertical" data-url="http://www.david-obrien.net/2014/12/update-sql-always-cluster-configmgr-powershell/">Tweet</a>
</div>


