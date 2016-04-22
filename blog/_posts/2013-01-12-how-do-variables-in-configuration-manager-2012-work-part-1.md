---
id: 660
title: 'How do variables in Configuration Manager 2012 work? &ndash; Part 1'
date: 2013-01-12T12:18:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=660
permalink: /2013/01/how-do-variables-in-configuration-manager-2012-work-part-1/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center Configuration Manager
tags:
  - collection
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - SCCM
  - SCCM 2012
  - variables
---
# Using Variables in SCCM 2012

While working with Configuration Manager 2012 you most likely also came across collections and Task Sequences. You deploy a Task Sequence to a collection which has machines as members and then those machines execute the deployed Task Sequence.

Maybe you have one generic Task Sequence and want to deploy it to many different collections, e.g. you have one Client OSD Task Sequence and three Collections, WinXP, Win7 and Win8.

The easiest way to achieve something like that is by variables.

## How to define variables?

How and where do I set a variable you might ask. Quite easy. Open up the collection properties and look at “Collection variables”:

![image](/media/2013/01/image.png "image")

Here you can add new variables to the collection.

![image](/media/2013/01/image1.png "image")

You need to give the new variable a name and a value (although the value is optional). You can also mask a value (e.g. a password) by ticking the box “Do not display this value in the Configuration Manager console”.

Of course the same is also possible directly on the machine. Machine variables always take higher priority than collection variables. This way it’s possible to set certain default values on the collection and overwrite them per machine.

Example:

Collection sets the variable “ServerFeatures” to “AS-NET-Framework”, because I want this feature to be installed on every machine in this collection and I wrote a script which is executed in the task sequence which queries this variable.

I also added a machine to my example collection where I want another feature installed, but only on this machine, in my case this is “WDS” (Windows Deployment Services). I add the variable “ServerFeatures” to this machine and set it to “AS-NET-Framework,WDS”.

I must not forget “AS-NET-Framework”, because otherwise only “WDS” would be the content of the variable. Sadly the process is not additive, but destructive, so the machine variable overwrites the collection variable.

## Variables read during Task Sequence

The variable we just set will only be available during a task sequence, for that matter, in any task sequence. An example for that can be seen in this article I wrote: [Easy versioning of Images–Configuration Manager and Powershell](/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/)

If you want to know which other variables are available during a Task Sequence, have a look at this site: [Technet: Task Sequence variables (Action and Built-In)](http://technet.microsoft.com/en-us/library/gg682064.aspx)

You can also run this code in a script during a Task Sequence to write all the variables into for example your registry.

```PowerShell
New-Item -Path "HKLM:\Software\David\Variables" -Force
$MS_ConfigMgr_Env = New-Object -ComObject Microsoft.SMS.TSEnvironment
foreach ($MS_ConfigMgr_Var in $MS_ConfigMgr_Env.GetVariables())
{
  New-Itemproperty -Path "HKLM:\Software\David\Variables" -Name "$($MS_ConfigMgr_Var)" -Value "$($MS_ConfigMgr_Env.Value($MS_ConfigMgr_Var))" -Force
}
```

You’ll be surprised how many internal variables ConfigMgr uses.

In the next part I’ll be talking about another way of setting variables to simulate different scenarios like deploying multiple OSs or just configuring machines differently.

Part 2: [How do variables in Configuration Manager 2012 work?]("How do variables in Configuration Manager 2012 work? – Part 2" /2013/01/13/how-do-variables-in-configuration-manager-2012-work-part-2/)
