---
id: 2768
title: 'Update SQL Always On Cluster with ConfigMgr &amp; Powershell'
date: 2014-12-08T22:00:08+00:00

layout: single

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

![image](/media/2014/12/image7.png)

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

```
Function Get-SiteCode {
  [cmdletBinding()]
  param (
    $SMSProvider
  )
  $wqlQuery = 'SELECT * FROM SMS_ProviderLocation'
  $a = Get-WmiObject -Query $wqlQuery -Namespace 'root\sms' -ComputerName $SMSProvider
  $a | ForEach-Object {
    if($_.ProviderForLocalSite)
    {
      $SiteCode = $_.SiteCode
    }
  }
  return $SiteCode
}
Function Add-NodeToConfigMgrCollection {
  [cmdletBinding()]

  param (
    $Node,
    $CollectionID,
    $SiteCode,
    $SMSProvider
  )

  $Device = Get-WmiObject -ComputerName $SMSProvider -Class SMS_R_SYSTEM -Namespace root\sms\site_$SiteCode -Filter "Name = '$Node'"
  $objColRuledirect = [WmiClass]"\\$SMSProvider\ROOT\SMS\site_$($SiteCode):SMS_CollectionRuleDirect"
  $objColRuleDirect.psbase.properties['ResourceClassName'].value = 'SMS_R_System'
  $objColRuleDirect.psbase.properties['ResourceID'].value = $Device.ResourceID

  $MC = Get-WmiObject -Class SMS_Collection -ComputerName $SMSProvider -Namespace "ROOT\SMS\site_$SiteCode" -Filter "CollectionID = '$CollectionID'"
  $InParams = $mc.psbase.GetMethodParameters('AddMembershipRule')
  $InParams.collectionRule = $objColRuledirect
  $R = $mc.PSBase.InvokeMethod('AddMembershipRule', $inParams, $Null)
}
Function Invoke-PolicyDownload {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,ValueFromPipeline=$true)]
    [System.String]
    $ComputerName=(get-content env:computername) #defaults to local computer name
  )
  Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule '{00000000-0000-0000-0000-000000000021}' -ComputerName $ComputerName -ErrorAction SilentlyContinue | Out-Null
  #Trigger machine policy download
  Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule '{00000000-0000-0000-0000-000000000022}' -ComputerName $ComputerName -ErrorAction SilentlyContinue | Out-Null
  #Trigger Software Update Scane cycle
  Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule '{00000000-0000-0000-0000-000000000113}' -ComputerName $ComputerName -ErrorAction SilentlyContinue | Out-Null
  #Trigger Software Update Deployment Evaluation Cycle
  Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule '{00000000-0000-0000-0000-000000000114}' -ComputerName $ComputerName -ErrorAction SilentlyContinue | Out-Null

}
Function Get-ConfigMgrSoftwareUpdateCompliance {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,ValueFromPipeline=$true)]
    [System.String]
    $ComputerName=(get-content env:computername) #defaults to local computer name
  )
  Invoke-PolicyDownload -ComputerName $ComputerName;
  do {
    Start-Sleep -Seconds 30
    Write-Output "Checking Software Updates Compliance on [$ComputerName]"

    #check if the machine has an update assignment targeted at it
    $global:UpdateAssigment = Get-WmiObject -Query 'Select * from CCM_AssignmentCompliance' -Namespace root\ccm\SoftwareUpdates\DeploymentAgent -ComputerName $ComputerName -ErrorAction SilentlyContinue ;

    Write-Output $UpdateAssigment

    #if update assignments were returned check to see if any are non-compliant
    $IsCompliant = $true

    $UpdateAssigment | ForEach-Object{
      #mark the compliance as false
      if($_.IsCompliant -eq $false -and $IsCompliant -eq $true){$IsCompliant = $false}
    }
    #Check for pending reboot to finish compliance
    $rebootPending = (Invoke-WmiMethod -Namespace root\ccm\clientsdk -Class CCM_ClientUtilities -Name DetermineIfRebootPending -ComputerName $ComputerName).RebootPending

    if ($rebootPending)
    {
      Invoke-WmiMethod -Namespace root\ccm\clientsdk -Class CCM_ClientUtilities -Name RestartComputer -ComputerName $ComputerName
      do {'waiting...';start-sleep -Seconds 5}
      while (-not ((get-service -name 'SMS Agent Host' -ComputerName $ComputerName).Status -eq 'Running'))

    }
    else {
      Write-Output 'No pending reboot. Continue...'
    }
  }
  while (-not $IsCompliant)
}

#Start Updating one Secondary Node at a time

$SiteCode = Get-SiteCode -SMSProvider $SMSProvider
$i = 0
foreach ($SecondaryReplica in $SecondaryReplicaServer) {
  if (-not ($AlreadyPatched -contains $SecondaryReplica.Split('\')[0])) {
    try {
      $i++
      Write-Verbose "Patching Server round $i = $($SecondaryReplica.Split('\')[0])"

      #Add current secondary node to ConfigMgr collection to receive its updates
      Add-NodeToConfigMgrCollection -Node $SecondaryReplica.Split('\')[0] -SiteCode $SiteCode -SMSProvider $SMSProvider -CollectionID $CollectionID -Verbose

      Start-Sleep -Seconds 60
      Invoke-policydownload -computername $SecondaryReplica.Split('\')[0]

      Start-Sleep -Seconds 120
      Invoke-policydownload -computername $SecondaryReplica.Split('\')[0]

      Start-Sleep -Seconds 120
      #Check if all updates have been installed and server finished rebooting
      Write-Output 'Applying updates now'
      Get-ConfigMgrSoftwareUpdateCompliance -ComputerName $SecondaryReplica.Split('\')[0]

      $AlreadyPatched += $SecondaryReplica.Split('\')[0]
    }
    catch {
      Write-Error $_
    }
  }
  else {
    Write-Verbose "$($SecondaryReplica.Split('\')[0]) has already been patched. Skipping."
  }
}

# fail over to one of the secondary nodes and update the primary node, after that, fail over again to the original primary node

Switch-SqlAvailabilityGroup -Path SQLSERVER:\Sql\$(Get-Random -InputObject $SecondaryReplicaServer)\Default\AvailabilityGroups\$AvailabilityGroupName -Verbose
Add-NodeToConfigMgrCollection -Node $PrimaryReplicaServer.Split('\')[0] -SiteCode $SiteCode -SMSProvider $SMSProvider -CollectionID $CollectionID -Verbose

Start-Sleep -Seconds 60
Invoke-PolicyDownload -computername $PrimaryReplicaServer.Split('\')[0]

Start-Sleep -Seconds 90
Invoke-PolicyDownload -computername $PrimaryReplicaServer.Split('\')[0]

Start-Sleep -Seconds 90
#Check if all updates have been installed and server finished rebooting
Write-Output 'Applying updates now'
Get-ConfigMgrSoftwareUpdateCompliance -ComputerName $PrimaryReplicaServer.Split('\')[0]


#If the primary node is finished updating, fail over again to the Primary
Switch-SqlAvailabilityGroup -Path SQLSERVER:\Sql\$PrimaryReplicaServer\Default\AvailabilityGroups\$AvailabilityGroupName -Verbose
```

Have fun automating!


