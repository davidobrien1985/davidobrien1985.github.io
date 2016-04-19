---
id: 413
title: Import Computer to Configuration Manager 2007 / 2012
date: 2012-07-25T21:51:05+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=413
permalink: /2012/07/import-computer-to-configuration-manager-2007-2012/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2007
  - SCCM 2012
  - System Center
---
This is a really quick one…

With this script you are able to import a computer into your Microsoft System Center Configuration Manager environment. No matter if it’s 2007 or 2012.

&nbsp;

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1:</span> #####</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2:</span> # <span style="color: #0000ff;">Function</span>: Import-ConfigMgr</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3:</span> # This <span style="color: #0000ff;">function</span> <span style="color: #0000ff;">imports</span> a given client into a defined collection.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4:</span> # Ersteller: David O<span style="color: #008000;">'Brien</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5:</span> # Erstellt am: 14.07.2011</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6:</span> #####</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7:</span> <span style="color: #0000ff;">Function</span> Import-ConfigMgr</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9:</span> ### Define variables <span style="color: #0000ff;">to</span> import the client <span style="color: #0000ff;">to</span> ConfigMgr</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10:</span> $strTargetComputer = $computername</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11:</span> $strTargetMac = $computerMAC</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13:</span> ### Which collection should the client be imported <span style="color: #0000ff;">to</span>?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14:</span> $strTargetCollection = <span style="color: #008000;">'Install ' + $computerOS # in my environment a Client automatically gets a machine variable $computerOS</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16:</span> ### Load Variables</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17:</span> $strSite = <span style="color: #006080;">"Site_LAB"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19:</span> # Create computer <span style="color: #0000ff;">in</span> ConfigMgr</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20:</span> $strColon = <span style="color: #006080;">":"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21:</span> $<span style="color: #0000ff;">Class</span> = <span style="color: #006080;">"SMS_Site"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22:</span> $Method = <span style="color: #006080;">"ImportMachineEntry"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23:</span> $MC = [WmiClass]<span style="color: #006080;">"\.ROOTSMS$strSite$strColon$Class"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24:</span> $InParams = $mc.psbase.GetMethodParameters($Method)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25:</span> $InParams.MACAddress = $strTargetMac</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26:</span> $InParams.NetbiosName = $strTargetComputer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27:</span> $InParams.OverwriteExistingRecord = $<span style="color: #0000ff;">true</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28:</span> $inparams.PSBase.properties | <span style="color: #0000ff;">select</span> name,Value | Format-Table</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29:</span> $objCMComputer = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;"> 30:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"> 31:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;"> 32:</span> # Create Collection Rule Direct</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;"> 33:</span> $<span style="color: #0000ff;">Class</span> = <span style="color: #006080;">"SMS_CollectionRuleDirect"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;"> 34:</span> $objColRuledirect = [WmiClass]<span style="color: #006080;">"\$ComputerROOTSMS$strSite$strColon$Class"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;"> 35:</span> $objColRuleDirect.psbase.properties[<span style="color: #006080;">"ResourceClassName"</span>].value = <span style="color: #006080;">"SMS_R_System"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"> 36:</span> $objColRuleDirect.psbase.properties[<span style="color: #006080;">"ResourceID"</span>].value = $objCMComputer.resourceID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;"> 37:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;"> 38:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;"> 39:</span> # Target Collection connection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;"> 40:</span> $Collection = gwmi -computer $computer -<span style="color: #0000ff;">namespace</span> <span style="color: #006080;">"rootsms$strSite"</span> -<span style="color: #0000ff;">class</span> <span style="color: #006080;">"SMS_Collection"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;"> 41:</span> $PoshCollec = $collection | where{$_.Name -eq <span style="color: #006080;">"$strTargetCollection"</span>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"> 42:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;"> 43:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;"> 44:</span> # Add Computer <span style="color: #0000ff;">to</span> Target Collection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;"> 45:</span> $<span style="color: #0000ff;">Class</span> = <span style="color: #006080;">"SMS_Collection"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;"> 46:</span> $Method = <span style="color: #006080;">"AddMembershipRule"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;"> 47:</span> $CollectionID = $PoshCollec.CollectionID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;"> 48:</span> $filter=<span style="color: #006080;">"CollectionID = '$CollectionID'"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"> 49:</span> $MC = <span style="color: #0000ff;">Get</span>-WmiObject $<span style="color: #0000ff;">class</span> -computer $Computer -<span style="color: #0000ff;">Namespace</span> <span style="color: #006080;">"ROOTSMS$strSite"</span> -filter $filter</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;"> 50:</span> $InParams = $mc.psbase.GetMethodParameters($Method)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;"> 51:</span> $InParams.collectionRule = $objColRuledirect</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;"> 52:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;"> 53:</span> $inparams.PSBase.properties | <span style="color: #0000ff;">select</span> name,Value | Format-Table</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"> 54:</span> $R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;"> 55:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

The script needs to run on a ConfigMgr management point.

Questions? Just ask… (Twitter: @david_obrien) or comment here. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,ConfigMgr+2012,ConfigMgr2012,Configuration+Manager,Microsoft,Powershell,SCCM,SCCM+2007,SCCM+2012,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2012/07/import-computer-to-configuration-manager-2007-2012/">Tweet</a>
</div>
