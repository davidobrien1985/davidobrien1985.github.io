---
id: 1671
title: Why you shouldn't use the Powershell pipe when using ConfigMgr
date: 2014-04-02T21:05:52+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1671
permalink: /2014/04/filter-faster-piping-using-configmgr/
categories:
  - automation
  - CM12
  - ConfigMgr
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
  - Uncategorized
tags:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - Powershell
  - SCCM
---
The other day I was asked why I used the -filter parameter in one of my Powershell scripts with Get-WmiObject instead of just doing a pipe to Where-Object.

When writing scripts for Configuration Manager you quite often have to use the Get-WmiObject cmdlet (or the gwmi alias) to get certain objects. But how do you manage to do it as performant as possible?

The answer to that is best shown with a quick example.

# Find ConfigMgr device with Powershell

My ConfigMgr demo environment consists of approximately 2500 demo machines in one domain. I now want to find a certain machine and I only know its name. As the Admin Console won't show more than 1,000 devices at first search by default I reckon it's faster to use Powershell.

Using the built-in ConfigMgr cmdlet would look like this:

`Get-CMDevice -Name "CON-LAP-01"`

This will give me the machine I'm looking for.

Here are some other ways to get one machine, they all work, but which is the most performant of them?

```
Get-WmiObject –Class SMS_R_System –Namespace root\sms\site_HQ1 | Where-Object {$_.Name –eq „DO-LAP-0“}
Get-WmiObject -Namespace root\sms\site_HQ1 -Query "SELECT * FROM SMS_R_System where name='DO-LAP-0'"
Get-CMDevice –Name "DO-LAP-0"
```

Measuring how long each of these commands will take in my environment is pretty self-explaining and should convince you of not using the pipe with Where-Object if possible.

```
Measure-Command -Expression {Get-CMDevice –Name "DO-LAP-0"}
Measure-Command -Expression {Get-WmiObject –Class SMS_R_System –Namespace root\sms\site_HQ1  | where {$_.Name –eq „DO-LAP-0“}}
Measure-Command -Expression {Get-WmiObject -Namespace root\SMS\site_HQ1 -Query "SELECT * FROM SMS_R_System where name='DO-LAP-0'"}
Measure-Command -Expression {Get-CMDevice | Where-Object {$_.Name -eq "DO-LAP-0"}}
Measure-Command -Expression {Get-WmiObject -Namespace root\sms\site_HQ1 -Class SMS_R_System -Filter "name='DO-LAP-0'"}
```

Here are the results:

![image](/media/2014/04/query_results.jpg)

# Why is the pipe so slow in Powershell?

What happens when you use the pipe?

Using the pipe tells Powershell to first execute the left side of the pipe and then take all those results over to the right side of the pipe and go through them again and find the result.Means: The first time it's getting ALL devices, even those not necessary and then the where-object searches through ALL those devices again. Why do it twice when you can get it right the first time around?

# Results

The results are obvious: Don't use the 'Where-Object' cmdlet. If possible use Get-WmiObject with -filter or even better -Query parameter.