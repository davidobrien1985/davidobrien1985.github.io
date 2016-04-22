---
id: 486
title: 'How to backup &#038; restore your TaskSequence–Configuration Manager 2012 and Powershell'
date: 2012-09-29T14:41:18+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=486
permalink: /2012/09/how-to-backup-restore-your-tasksequenceconfiguration-manager-2012-and-powershell/
categories:
  - automation
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
tags:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2012
  - scripting
  - SysCtr
  - Task Sequence
---
And here’s another quick one for the weekend, before the wife wants to go shopping ;-)

This is a quick way of “backing up” and restoring your Task Sequences, just in case you’re not doing it another way.

# Backup of Task Sequence

I already showed you how to use the new Powershell module for ConfigMgr 2012 SP1 beta ([Powershell module for ConfigMgr 2012](http://www.david-obrien.de/?p=442)) and today I will show you how to use a bit of it.

In order to access the cmdlets you need to open a 32-bit Powershell and add the module like I showed you in the previous article.

A little reminder:

`Import-Module "C:\\Program Files (x86)\\Microsoft Configuration Manager\\AdminConsole\\bin\\ConfigurationManager.psd1"`

Now you can use all the nice cmdlets there are for ConfigMgr, for example

`(Get-CMTaskSequence | Where-Object {$_.Name -eq "TEST_TS"}).Sequence | Out-File c:\\temp\\TSsequence.txt`

I now extracted all of the Task Sequence Steps of the Task Sequence with the name “TEST_TS” and put it into a textfile. If you take a look at the file you see that it’s actually in xml format, just like with ConfigMgr 2007.

# Restore of Task Sequence

I now want to restore this Task Sequence, maybe because someone messed up with the Task Sequence, maybe because it’s corrupted (had that at one customer a few weeks ago) or maybe because of some other reason…

This is the script:

```PowerShell
param (
    [string]$SiteCode,
    [string]$TaskSequenceName,
    [string]$InputFile
    )

#########
# What does it do?
# Script imports a previously "exported" TaskSequence from CM12 to CM12
#
# Howto: Extract the TaskSequence with the following command:
# (Get-CMTaskSequence | where-object {$_.Name -eq $NameOfTaskSequence}).Sequence | Out-File $PathToExportFile
# This will be your $InputFile
#
# Author: David O'Brien, david.obrien@sepago.de
# Created: 28.09.2012
# Prerequisites:
#               - Microsoft System Center Configuration Manager 2012 SP1 (beta)
#               - ConfigMgr Powershell to get your existing TaskSequence
#
#########

$Class = "SMS_TaskSequencePackage"
$Instance = $null
$TS = $null
$NewSequence = $null
$TS = [wmiclass]"\.rootsmssite_$($SiteCode):$($Class)"
$Instance = $TS.CreateInstance()
$SequenceFile = Get-Content $InputFile
$NewSequence = $Ts.ImportSequence($SequenceFile).TaskSequence
$Instance.Name = "$TaskSequenceName"
$NewTSPackageID = $TS.SetSequence($Instance, $NewSequence).SavedTaskSequencePackagePath
```

## What does it NOT do?

It won’t check if any of the package references are wrong, this might come in a later release and it doesn’t “export/extract” anything else than the steps inside the Task Sequence.

So if you configured anything inside the Task Sequence’s properties, for example that it should use a boot image to boot from, then you will have to do that again.

![image](/media/2012/09/image7.png "image")

It seems odd that Microsoft should have forgotten to give us a tool to export Task Sequences. Well this is a first step to do it without direct access to the Admin Console.

Comments? Does anybody need this or is it just fun to know it works?
