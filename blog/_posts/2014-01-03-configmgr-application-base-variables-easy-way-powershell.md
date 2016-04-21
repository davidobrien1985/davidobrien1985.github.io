---
id: 1537
title: 'ConfigMgr - Application Base variables the easy way with Powershell'
date: 2014-01-03T23:28:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1537
permalink: /2014/01/configmgr-application-base-variables-easy-way-powershell/
categories:
  - ConfigMgr 2012
  - Configuration Manager
  - MDT
  - PowerShell
  - SCCM
  - System Center
tags:
  - automation
  - ConfigMgr
  - MDT
  - Microsoft Deployment Toolkit
  - Powershell
  - SCCM
  - scripting
---
This article I planned on writing for some time now (as a lot of others) but didn’t find the time yet. The topic itself isn’t new, it’s the solution that’s cool (although itself also not too new).

# Install Applications according to dynamic variable list {.}

There is more than one way of how you can install applications (and packages) during a Task Sequence and each of them has its pros and cons.

There is the “Install Application” step which lets you chose the applications you want to have installed:
  
[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422405870_thumb.png" alt="" align="middle" />](/media/2015/01/1422405870_full.png)

This is really easy, as long as you don’t want to install more than nine (9) applications in one step.
  
[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422405911_thumb.png" alt="" align="middle" />](/media/2015/01/1422405911_full.png)

The tenth application you want to install needs to be put into a second “Install Application” step.
  
[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422405952_thumb.png" alt="" align="middle" />](/media/2015/01/1422405952_full.png)

Not too handy I would say.

The alternative?

Use a dynamic list to define which applications need to be installed. This concept is far from new, you might have already seen it being used with Packages in CM07. Here is a TechNet description of it: [http://technet.microsoft.com/en-us/library/hh846237.aspx#BKMK_InstallApplication]("http://technet.microsoft.com/en-us/library/hh846237.aspx#BKMK_InstallApplication" http://technet.microsoft.com/en-us/library/hh846237.aspx#BKMK_InstallApplication)

[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422405995_thumb.png" alt="" align="middle" />](/media/2015/01/1422405995_full.png)

I here now told the Task Sequence to install all Applications that are members of the dynamic variable list named “BasisVariable”. You can pick any name you like here.
  
In order for this to work now I need to deploy that Task Sequence to a collection and build that dynamic list. This is done via Collection variables.

If you don’t know how to work with Collection Variables, have a look at some previous articles of mine on that topic: [How do Variables in ConfigMgr work? Part 1](http://www.david-obrien.net/2013/01/12/how-do-variables-in-configuration-manager-2012-work-part-1/) , [Part 2](http://www.david-obrien.net/2013/01/13/how-do-variables-in-configuration-manager-2012-work-part-2/), [Part 3](http://www.david-obrien.net/2013/01/15/how-do-variables-in-configuration-manager-2012-work-part-3/)

My collection now looks like this:
  
[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422406032_thumb.png" alt="" align="middle" />](/media/2015/01/1422406032_full.png)

I could continue this list up to 99 as long as I don’t break the count – and that’s the tricky bit. The list might be good enough for some time, but what if you have to remove PDFCreator from that deployment?
  
PDFCreator is the value of the variable “BasisVariable03” and if you go ahead and just delete that variable then nothing else after “GoogleChrome” or “BasisVariable02” would be installed, regardless of how many variables would follow. All because the count is interrupted.
  
Then you say, well I just go and edit the variable names. Not possible 😉 You can’t edit the names of existing variables! Why? Don’t know. Stupid, right?
  
Only way to fix that is to delete ALL VARIABLES and rebuild the count from scratch. If you hate somebody really much, then give him or her that task 😉

So, what now?

## ZTICoalesce.wsf from MDT {.}

Microsoft is aware of this problem. In fact, they already gave you a script to workaround this problem. The Microsoft Deployment Toolkit (MDT) offers you a script called [ZTICoalesce.wsf](http://systemscenter.ru/mdt2012.en/zticoalescewsf.htm) which takes the name of the Dynamic Variable List and repairs any gaps in the count.
  
That script is written in VBScript and I think VBScript is legacy and I’m really, I mean really, not good at it. That’s why I wanted to rebuild that whole “repair my dynamic variable list” into Powershell.

## Correct Dynamic Variable List via Powershell {.}

I wrote a script called Correct-BaseVars.ps1 which will accept two arguments on the commandline.

Argument 1: $NameOfBaseVariable
  
Argument 2: $LengthSuffix

The second argument should, for now (maybe forever) be 2. That’s because if you want to use a dynamic variable list with Applications, then you need to use a suffix with the length of 2. For Packages, which I ignored, that suffix has a length of 3. For the time being it’s always 2.
  
[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422406070_thumb.png" alt="" align="middle" />](/media/2015/01/1422406070_full.png)

I copied my script into my MDT Package in the Scripts folder, that way it will always be copied down to the client and I can call it via the %ScriptRoot% variable. If you are not using MDT (why not?), you can still call that script from any other package.

The script will also write a Logfile to the CCM Client Log path called CorrectBaseVars.Log
  
If anything goes wrong during install, have a look here if the variable screwed up.

Here’s an example of the Log:

[<img class="img-responsive full aligncenter" title="" src="/media/2015/01/1422406104_thumb.png" alt="" align="middle" />](/media/2015/01/1422406104_full.png)

### Issues with the script {.}

I didn’t find a way to delete the Base Variables from the client’s WMI namespace. It’s no problem at all to add new variables, but how do I delete them?
  
In my example the list will end up with orphaned entries at the end of the list. These shouldn’t cause any problems or multiple content download as each application will check, because that’s the way they work, if it needs to be installed (Detection Methods). In this case, if there is more than one entry for an application, the second entry won’t fire off.
  
Anyway, it feels nicer if one could delete the entry entirely. Any ideas?

Download the script here: [correct-BaseVars](/media/2014/01/correct-BaseVars.zip)

Here’s the script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1: &lt;#
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2: Function: This script will fix any issues with gaps in a dynamic variable list used to install ConfigMgr / SCCM applications.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3: Usage: .\correct-BaseVars.ps1 $NameOfBaseVariable $LengthSuffix
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4: $LengthSuffix should usually be 2 if you use Applications
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6: Author: David O'Brien, david.obrien@gmx.de , Microsoft Enterprise Client Management MVP 2013
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;">   7: Date: 02.01.2014
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;">   8: #&gt;
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;">   9:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;">  10: if ($args.Count -eq 1)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;">  11:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;">  12:         $BaseVariableName = $args[0]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;">  13:     }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;">  14: elseif ($args.Count -eq 2)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;">  15:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;">  16:         $BaseVariableName = $args[0]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;">  17:         $LengthSuffix = $args[1]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;">  18:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;">  19:     }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;">  20:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;">  21: Function Write-Message(
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;">  22:     [parameter(Mandatory=$true)]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;">  23:     [ValidateSet("Info", "Warning", "Error", "Verbose")]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;">  24:     [String] $Severity,
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;">  25:     [parameter(Mandatory=$true)]
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;">  26:     [String] $Message
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;">  27: )
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;">  28: {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;">  29:     if((Test-Path -Path  $LogFile))
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;">  30:         {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;">  31:             Add-Content -Path "$($LogFile)" -Value "$(([System.DateTime]::Now).ToString()) $Severity - $Message"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;">  32:         }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;">  33:     else
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;">  34:         {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;">  35:             New-Item -Path $LogFile -ItemType File
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;">  36:         }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;">  37:     Switch ($Severity)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;">  38:         {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;">  39:             "Info"        {$FColor="gray"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;">  40:             "Warning"    {$FColor="yellow"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;">  41:             "Error"        {$FColor="red"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;">  42:             "Verbose"    {$FColor="green"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;">  43:             Default        {$FColor="gray"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;">  44:         }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;">  45:     Write-Output "$(([System.DateTime]::Now).ToString()) $Severity - $Message" -fore $FColor
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;">  46: }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;">  47:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;">  48: $BaseVariableList = @()
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;">  49: #$BaseVariableName = "BasisVariable"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;">  50: #$LengthSuffix = 2
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;">  51:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;">  52:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;">  53: $objSMSTS = New-Object -ComObject Microsoft.SMS.TSEnvironment
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;">  54:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;">  55: $SMSTSVars = $objSMSTS.GetVariables()
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum56" style="color: #606060;">  56:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum57" style="color: #606060;">  57: $SMSTSLogPath = $objSMSTS.Value("_SMSTSLogPath")
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum58" style="color: #606060;">  58:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum59" style="color: #606060;">  59: if (Test-Path $SMSTSLogPath)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum60" style="color: #606060;">  60:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum61" style="color: #606060;">  61:         $LogFile = $(Join-Path $SMSTSLogPath CorrectBaseVars.log)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum62" style="color: #606060;">  62:     }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum63" style="color: #606060;">  63:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum64" style="color: #606060;">  64: #Writing the Variables to Logfile
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum65" style="color: #606060;">  65: Write-Message -Severity Info -Message "This is the Dynamic Variable List BEFORE rebuilding it."
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum66" style="color: #606060;">  66:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum67" style="color: #606060;">  67: foreach ($Var in $objSMSTS.GetVariables())
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum68" style="color: #606060;">  68:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum69" style="color: #606060;">  69:         if ( $Var.ToUpper().Substring(0,$var.Length-$LengthSuffix) -eq $BaseVariableName)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum70" style="color: #606060;">  70:             {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum71" style="color: #606060;">  71:                 Write-Message -Severity Info -Message "$($Var) = $($objSMSTS.Value($Var))"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum72" style="color: #606060;">  72:                 $BaseVariableList += @{$Var=$objSMSTS.Value($Var)}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum73" style="color: #606060;">  73:             }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum74" style="color: #606060;">  74:     }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum75" style="color: #606060;">  75:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum76" style="color: #606060;">  76: $objects = @()
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum77" style="color: #606060;">  77: $fixed = @()
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum78" style="color: #606060;">  78: $objects = $BaseVariableList
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum79" style="color: #606060;">  79:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum80" style="color: #606060;">  80: [int]$x = 1
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum81" style="color: #606060;">  81: # Writing the variables to Logfile after being reordered
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum82" style="color: #606060;">  82: Write-Message -Severity Info -Message "------------------------------------------------------"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum83" style="color: #606060;">  83: Write-Message -Severity Info -Message ""
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum84" style="color: #606060;">  84: Write-Message -Severity Info -Message "This is the Dynamic Variable List AFTER rebuilding it."
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum85" style="color: #606060;">  85:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum86" style="color: #606060;">  86: foreach ($i in $objects)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum87" style="color: #606060;">  87: {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum88" style="color: #606060;">  88:     $Name = "$($BaseVariableName){0:00}" -f $x
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum89" style="color: #606060;">  89:     $Value = "$($i.Values)"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum90" style="color: #606060;">  90:     $fixed += @{$Name=$Value}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum91" style="color: #606060;">  91:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum92" style="color: #606060;">  92:     Write-Message -Severity Info -Message "$($Name) = $($Value)"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum93" style="color: #606060;">  93:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum94" style="color: #606060;">  94:     $x++
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum95" style="color: #606060;">  95:     $Name = ""
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum96" style="color: #606060;">  96:     $Value = ""
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum97" style="color: #606060;">  97:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum98" style="color: #606060;">  98: }
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum99" style="color: #606060;">  99:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum100" style="color: #606060;"> 100: $BaseVariableListFixed = @()
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum101" style="color: #606060;"> 101: $BaseVariableListFixed += $fixed
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum102" style="color: #606060;"> 102:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum103" style="color: #606060;"> 103:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum104" style="color: #606060;"> 104:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum105" style="color: #606060;"> 105: foreach ($BaseVariable in $BaseVariableListFixed)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum106" style="color: #606060;"> 106:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum107" style="color: #606060;"> 107:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum108" style="color: #606060;"> 108:         ""
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum109" style="color: #606060;"> 109:         $objSMSTS.Value("$($BaseVariable.Keys)") = "$($BaseVariable.Values)"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum110" style="color: #606060;"> 110:     }
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


