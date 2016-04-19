---
id: 486
title: 'How to backup &#038; restore your TaskSequence–Configuration Manager 2012 and Powershell'
date: 2012-09-29T14:41:18+00:00
author: "David O'Brien"
layout: post
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
And here’s another quick one for the weekend, before the wife wants to go shopping <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/09/wlEmoticon-winkingsmile1.png" alt="Winking smile" />

This is a quick way of “backing up” and restoring your Task Sequences, just in case you’re not doing it another way.

# Backup of Task Sequence

I already showed you how to use the new Powershell module for ConfigMgr 2012 SP1 beta ([Powershell module for ConfigMgr 2012](http://www.david-obrien.de/?p=442)) and today I will show you how to use a bit of it.

In order to access the cmdlets you need to open a 32-bit Powershell and add the module like I showed you in the previous article.
  
A little reminder:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1:</span> Import-Module <span style="color: #006080;">"C:Program Files (x86)Microsoft Configuration ManagerAdminConsolebinConfigurationManager.psd1"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Now you can use all the nice cmdlets there are for ConfigMgr, for example

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">(<span style="color: #0000ff;">Get</span>-CMTaskSequence | Where-<span style="color: #0000ff;">Object</span> {$_.Name -eq <span style="color: #006080;">"TEST_TS"</span>}).Sequence | Out-File c:tempTSsequence.txt</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I now extracted all of the Task Sequence Steps of the Task Sequence with the name “TEST_TS” and put it into a textfile. If you take a look at the file you see that it’s actually in xml format, just like with ConfigMgr 2007.

# Restore of Task Sequence

I now want to restore this Task Sequence, maybe because someone messed up with the Task Sequence, maybe because it’s corrupted (had that at one customer a few weeks ago) or maybe because of some other reason…

This is the script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">param (</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[<span style="color: #0000ff;">string</span>]$SiteCode,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">[<span style="color: #0000ff;">string</span>]$TaskSequenceName,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[<span style="color: #0000ff;">string</span>]$InputFile</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#########</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"># What does it <span style="color: #0000ff;">do</span>?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># Script <span style="color: #0000ff;">imports</span> a previously <span style="color: #006080;">"exported"</span> TaskSequence from CM12 <span style="color: #0000ff;">to</span> CM12</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># Howto: Extract the TaskSequence <span style="color: #0000ff;">with</span> the following command:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"># (<span style="color: #0000ff;">Get</span>-CMTaskSequence | where-<span style="color: #0000ff;">object</span> {$_.Name -eq $NameOfTaskSequence}).Sequence | Out-File $PathToExportFile</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># This will be your $InputFile</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># Author: David O<span style="color: #008000;">'Brien, david.obrien@sepago.de</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"># Created: 28.09.2012</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># Prerequisites:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#               - Microsoft System Center Configuration Manager 2012 SP1 (beta)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#               - ConfigMgr Powershell <span style="color: #0000ff;">to</span> <span style="color: #0000ff;">get</span> your existing TaskSequence</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#########</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$<span style="color: #0000ff;">Class</span> = <span style="color: #006080;">"SMS_TaskSequencePackage"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$Instance = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$TS = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$NewSequence = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$TS = [wmiclass]<span style="color: #006080;">"\.rootsmssite_$($SiteCode):$($Class)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$Instance = $TS.CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SequenceFile = <span style="color: #0000ff;">Get</span>-Content $InputFile</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$NewSequence = $Ts.ImportSequence($SequenceFile).TaskSequence</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$Instance.Name = <span style="color: #006080;">"$TaskSequenceName"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$NewTSPackageID = $TS.SetSequence($Instance, $NewSequence).SavedTaskSequencePackagePath</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

## What does it NOT do?

It won’t check if any of the package references are wrong, this might come in a later release and it doesn’t “export/extract” anything else than the steps inside the Task Sequence.
  
So if you configured anything inside the Task Sequence’s properties, for example that it should use a boot image to boot from, then you will have to do that again.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/09/image_thumb7.png" alt="image" width="287" height="302" border="0" />]("image" http://www.david-obrien.de/wp-content/uploads/2012/09/image7.png)

It seems odd that Microsoft should have forgotten to give us a tool to export Task Sequences. Well this is a first step to do it without direct access to the Admin Console.

Comments? Does anybody need this or is it just fun to know it works? 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


