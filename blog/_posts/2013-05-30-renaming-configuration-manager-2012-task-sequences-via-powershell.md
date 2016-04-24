---
id: 941
title: Renaming Configuration Manager 2012 Task Sequences via Powershell
date: 2013-05-30T23:03:00+00:00
author: "David O'Brien"
layout: single

permalink: /2013/05/renaming-configuration-manager-2012-task-sequences-via-powershell/
categories:
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - scripting
  - Task Sequence
---
Quick and easy one.

If you want to rename a ConfigMgr 2012 Task Sequence then just go into its properties and rename it, but once you need to do that for a lot of Task Sequences (for whatever reason) it gets quite annoying.

Two scenarios:

Scenario 1 – rename only one Task Sequence

Scenario 2 – rename a lot of Task Sequences (add a Suffix)

## Difference between ConfigMgr cmdlets and WMI

There is a Powershell cmdlet Get-CMTaskSequence, but the problem with this one and with all the other built-in cmdlets is, it won’t output anything that you can use to go on working with.

![Get-CMTaskSequence](/media/2013/05/image2.png "Get-CMTaskSequence")

Whereas if we use WMI we get wonderful output objects like strings!

![image](/media/2013/05/image3.png)

As it’s usually the case, I’ll go with WMI!

### Scenario 1 – rename a single ConfigMgr TS

I have a given Task Sequence and I want to rename it to something else, but I don’t like using the GUI.

```
$TS = Get-WmiObject -Class SMS_TaskSequencePackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.Name -eq "TaskSequenceName"}
$TS.Name = "NewTaskSequenceName"
$TS.Put()
```

That’s it! Task Sequence is renamed.

### Scenario 2 – rename lots of Task Sequences (add a Suffix)

Lets pretend you have different stages for your Task Sequences from development to production and every stage has its own suffix.

* “_DEV” for development
* “_PROD for production

You want to still let the developer copy the Task Sequence from the DEV folder to the PROD folder, but you want to rename Task Sequences with the \_DEV suffix automatically to \_PROD.

```
$TSs = Get-WmiObject -Class SMS_TaskSequencePackage -Namespace root\sms\site_$SiteCode
foreach ($TS in $TSs)
{
  if ($TS.Name.Substring($TS.Name.Length-3) -eq "DEV")
  {
    $TS.Name = "$($TS.Name.Substring(0,$TS.Name.Length-3))_PROD"
    $TS.put()
  }
}
```

I bet there are lots more scenarios you can think of, but I guess these two short scripts will get you on your way!


