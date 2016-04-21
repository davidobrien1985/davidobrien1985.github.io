---
id: 1253
title: How to execute ConfigMgr 2012 Task Sequence from Powershell
date: 2013-09-05T16:21:46+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1253
permalink: /2013/09/execute-configmgr-2012-task-sequence-powershell/
categories:
  - automation
  - CM12
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Microsoft
  - Orchestrator
  - PowerShell
  - SCCM
  - scripting
tags:
  - CM12
  - Orchestrator
  - Powershell
  - SCCM
  - scripting
  - SCSM
  - SysCtr
  - System Center
---
# Execution of a ConfigMgr task sequence from Powershell

This little script or function I wrote because I saw a question on the german TechNet forums about it.

An user asked if it was possible to execute a Task Sequence from a script (Powershell in this case). There are some VBS around, but as I'm not too fluent in VBS and I like writing Powershell I thought, why not?!

I did come across some customers running Task Sequence after Task Sequence.
  
For example:

Department A builds the OS and deploys it with Task Sequence A. When successful department B takes over. They check the OS and if they think it's ok they somehow deploy Task Sequence B to that machine. Some have an available deployment to that machine or some put the machine into the next collection with either a required or available deployment and fire off the Task Sequence.

Using the methods described here, we could use for example Orchestrator or even System Center Service Manager (with some nice review activities) to automate the whole process. Can you come up with more scenarios? I'm interested to hear them!

## UIResourceMgr class - ComObject

In order to communicate with our ConfigMgr Agent (locally) we need to create a new instance of the Agent's ComObject. There is no documentation on that ComObject for CM12, only for 2007. ([http://msdn.microsoft.com/en-us/library/cc145211.aspx](http://msdn.microsoft.com/en-us/library/cc145211.aspx))
  
As far as I could see all the methods described in that MSDN article are still valid for 2012.

> $UI = New-Object -ComObject "UIResource.UIResourceMgr"

We are now able to use a few quite interesting methods. Just take a look at the "GetCacheInfo" method or the "RebootSystem" 😉

What we need to execute a deployed Task Sequence is ExecuteProgram .

## ExecuteProgram to run Task Sequence

This method is described as follows:

> The UIResourceMgr.ExecuteProgram method, in Configuration Manager, sends a rquest to the software distribution advertised programs client agent to initiate the execution of a program.

That method would like to have three parameters, all fairly easy to find:

  * ProgramID
  * PackageID
  * RunOnCompletion

Now, we would like to execute a Task Sequence and in this case the only thing we need to know is the Task Sequence's PackageID and we can find that inside our Admin Console.
  
As we are going to execute a Task Sequence we are able to put an asterisk "*" into our "ProgramID" variable. That's it!

<div class="wlWriterEditableSmartContent" id="scid:812469c5-0cb0-4c63-8c15-c81123a09de7:18b69a5f-6d64-49ec-9ed1-765912598076" style="float: none; margin: 0px; display: inline; padding: 0px;">
  <pre class="php:nogutter:nocontrols">$UI = New-Object -ComObject "UIResource.UIResourceMgr"

$ProgramID = "*"
$PackageID = "%PutInYourPackageID%"

$UI.ExecuteProgram($ProgramID, $PackageID, $true)
</div>

## Alternative : GetAvailableApplications

If you want to check which TS / Apps are deployed / advertised to your machine, then you could also use the UIResourceMgr.GetAvailableApplications() method. This method would also show you the PackageID you need to run the ExecuteProgram method.

> $UI.GetAvailableApplications()

I hope this little article helps you solve some situations.

## Online Resources

Just released the article, here the first update 😉
  
Ryan Ephgrave's Powershell Right Click Tools for ConfigMgr are able to do exactly this from the Admin Console. (https://psrightclicktools.codeplex.com/)
  
This helps you if you have access to the console, if not or if you'd like to use Orchestrator or Service Manager or any other Automation Framework, look at the above. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


