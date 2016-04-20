---
id: 941
title: Renaming Configuration Manager 2012 Task Sequences via Powershell
date: 2013-05-30T23:03:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=941
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

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="Get-CMTaskSequence" alt="Get-CMTaskSequence output objects" src="http://www.david-obrien.net/wp-content/uploads/2013/05/image_thumb2.png" width="301" height="133" border="0" />]("Get-CMTaskSequence" http://www.david-obrien.net/wp-content/uploads/2013/05/image2.png)

Whereas if we use WMI we get wonderful output objects like strings!

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="Gwmi SMS_TaskSequencePackage" alt="Gwmi SMS_TaskSequencePackage" src="http://www.david-obrien.net/wp-content/uploads/2013/05/image_thumb3.png" width="244" height="195" border="0" />]("Gwmi SMS_TaskSequencePackage" http://www.david-obrien.net/wp-content/uploads/2013/05/image3.png)

As it’s usually the case, I’ll go with WMI!

### Scenario 1 – rename a single ConfigMgr TS

I have a given Task Sequence and I want to rename it to something else, but I don’t like using the GUI.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$TS = <span style="color: #0000ff;">Get</span>-WmiObject -<span style="color: #0000ff;">Class</span> SMS_TaskSequencePackage -<span style="color: #0000ff;">Namespace</span> root\sms\site_$SiteCode | Where-<span style="color: #0000ff;">Object</span> {$_.Name -eq <span style="color: #006080;">"TaskSequenceName"</span>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$TS.Name = <span style="color: #006080;">"NewTaskSequenceName"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$TS.Put()</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

That’s it! Task Sequence is renamed.

### Scenario 2 – rename lots of Task Sequences (add a Suffix)

Lets pretend you have different stages for your Task Sequences from development to production and every stage has its own suffix.

  * “_DEV” for development
  * “_PROD for production

You want to still let the developer copy the Task Sequence from the DEV folder to the PROD folder, but you want to rename Task Sequences with the \_DEV suffix automatically to \_PROD.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$TSs = <span style="color: #0000ff;">Get</span>-WmiObject -<span style="color: #0000ff;">Class</span> SMS_TaskSequencePackage -<span style="color: #0000ff;">Namespace</span> root\sms\site_$SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">foreach ($TS <span style="color: #0000ff;">in</span> $TSs)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        <span style="color: #0000ff;">if</span> ($TS.Name.Substring($TS.Name.Length-3) -eq <span style="color: #006080;">"DEV"</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">            {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">                $TS.Name = <span style="color: #006080;">"$($TS.Name.Substring(0,$TS.Name.Length-3))_PROD"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">                $TS.put()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">            }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

&nbsp;

I bet there are lots more scenarios you can think of, but I guess these two short scripts will get you on your way! 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

