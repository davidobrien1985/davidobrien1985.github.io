---
id: 1051
title: Move ConfigMgr Task Sequences with Powershell
date: 2013-06-27T10:07:23+00:00
author: "David O'Brien"
layout: single

permalink: /2013/06/move-configmgr-task-sequences-with-powershell/
categories:
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - scripting
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - scripting
  - Task Sequence
---
This is another quick one…

## Move a Task Sequence

A customer just asked me if it’s possible to simulate a kind of staging of Task Sequences inside the console and that’s when I started thinking about security roles, scopes and moving stuff around.

I started by writing this tiny little script which moves task sequences from one folder to another.

Execute the script like this:

```
.\move-TaskSequence.ps1 -TaskSequenceName  "Deploy_Win8" -TargetFolderName Win8 -SiteCode PR1 -CMProvider cm12
```

```
param (
  [string]$TaskSequenceName,
  [string]$TargetFolderName,
  [string]$SiteCode,
  [string]$CMProvider
)
    [int]$ObjectID = 20
    [string]$TaskSequence = ""
    $TaskSequence = (Get-WmiObject -Class SMS_TaskSequencePackage -Namespace root\sms\site_$SiteCode -Filter "Name = '$($TaskSequenceName)'" -ComputerName $CMProvider).PackageID
    [int]$SourceFolder = (Get-WmiObject -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode -Filter "InstanceKey = '$($TaskSequence)'" -ComputerName $CMProvider).ContainerNodeID
    [int]$TargetFolder = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode -Filter "ObjectType = '20' and Name = '$($TargetFolderName)'" -ComputerName $CMProvider).ContainerNodeID
    $Parameters = ([wmiclass]"\\$($CMProvider)\root\SMS\Site_$($SiteCode):SMS_ObjectContainerItem").psbase.GetMethodParameters("MoveMembers")

    $Parameters.ObjectType = $ObjectID
    $Parameters.ContainerNodeID = $SourceFolder
    $Parameters.TargetContainerNodeID = $TargetFolder
    $Parameters.InstanceKeys = $TaskSequence
    try {
      $Output = ([wmiclass]"\\$($CMProvider)\root\SMS\Site_$($SiteCode):SMS_ObjectContainerItem").psbase.InvokeMethod("MoveMembers",$Parameters,$null)
      if ($Output.ReturnValue -eq "0")
      {
        Write-Host "Task Sequence $($TaskSequence) successfully moved to Folder $($TargetFolderName)."
      }
    }
    catch [Exception]
    {
      Write-Error -Message "Something went wrong."
    }
```

The script can also be downloaded here: [https://davidobrien.codeplex.com/SourceControl/latest#move-TaskSequence.ps1](https://davidobrien.codeplex.com/SourceControl/latest#move-TaskSequence.ps1)


