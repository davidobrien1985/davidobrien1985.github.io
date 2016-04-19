---
id: 660
title: 'How do variables in Configuration Manager 2012 work? &ndash; Part 1'
date: 2013-01-12T12:18:00+00:00
author: "David O'Brien"
layout: post
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

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb.png" alt="image" width="302" height="319" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image.png)

Here you can add new variables to the collection.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb1.png" alt="image" width="309" height="324" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image1.png)

You need to give the new variable a name and a value (although the value is optional). You can also mask a value (e.g. a password) by ticking the box “Do not display this value in the Configuration Manager console”.

Of course the same is also possible directly on the machine. Machine variables always take higher priority than collection variables. This way it’s possible to set certain default values on the collection and overwrite them per machine.

Example:
  
Collection sets the variable “ServerFeatures” to “AS-NET-Framework”, because I want this feature to be installed on every machine in this collection and I wrote a script which is executed in the task sequence which queries this variable.
  
I also added a machine to my example collection where I want another feature installed, but only on this machine, in my case this is “WDS” (Windows Deployment Services). I add the variable “ServerFeatures” to this machine and set it to “AS-NET-Framework,WDS”.

I must not forget “AS-NET-Framework”, because otherwise only “WDS” would be the content of the variable. Sadly the process is not additive, but destructive, so the machine variable overwrites the collection variable.

## Variables read during Task Sequence

The variable we just set will only be available during a task sequence, for that matter, in any task sequence. An example for that can be seen in this article I wrote: [Easy versioning of Images–Configuration Manager and Powershell](http://www.david-obrien.net/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/)

If you want to know which other variables are available during a Task Sequence, have a look at this site: [Technet: Task Sequence variables (Action and Built-In)](http://technet.microsoft.com/en-us/library/gg682064.aspx)

You can also run this code in a script during a Task Sequence to write all the variables into for example your registry.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">New</span>-Item -Path <span style="color: #006080;">"HKLM:\Software\David\Variables"</span> -Force</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$MS_ConfigMgr_Env = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> -ComObject Microsoft.SMS.TSEnvironment</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    foreach ($MS_ConfigMgr_Var <span style="color: #0000ff;">in</span> $MS_ConfigMgr_Env.GetVariables())</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        <span style="color: #0000ff;">New</span>-Itemproperty -Path <span style="color: #006080;">"HKLM:\Software\David\Variables"</span> -Name <span style="color: #006080;">"$($MS_ConfigMgr_Var)"</span> -Value <span style="color: #006080;">"$($MS_ConfigMgr_Env.Value($MS_ConfigMgr_Var))"</span> -Force</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

You’ll be surprised how many internal variables ConfigMgr uses.

In the next part I’ll be talking about another way of setting variables to simulate different scenarios like deploying multiple OSs or just configuring machines differently.

Part 2: [How do variables in Configuration Manager 2012 work?]("How do variables in Configuration Manager 2012 work? – Part 2" http://www.david-obrien.net/2013/01/13/how-do-variables-in-configuration-manager-2012-work-part-2/) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

