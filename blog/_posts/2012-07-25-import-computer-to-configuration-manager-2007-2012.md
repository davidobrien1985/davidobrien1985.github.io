---
id: 413
title: Import Computer to Configuration Manager 2007 / 2012
date: 2012-07-25T21:51:05+00:00
author: "David O'Brien"
layout: single
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
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1: #####
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2: # Function: Import-ConfigMgr
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3: # This function imports a given client into a defined collection.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4: # Ersteller: David O<span style="color: #008000;">'Brien
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5: # Erstellt am: 14.07.2011
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6: #####
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7: Function Import-ConfigMgr
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8: {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9: ### Define variables to import the client to ConfigMgr
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10: $strTargetComputer = $computername
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11: $strTargetMac = $computerMAC
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13: ### Which collection should the client be imported to?
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14: $strTargetCollection = <span style="color: #008000;">'Install ' + $computerOS # in my environment a Client automatically gets a machine variable $computerOS
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16: ### Load Variables
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17: $strSite = "Site_LAB"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19: # Create computer in ConfigMgr
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20: $strColon = ":"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21: $Class = "SMS_Site"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22: $Method = "ImportMachineEntry"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23: $MC = [WmiClass]"\.ROOTSMS$strSite$strColon$Class"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24: $InParams = $mc.psbase.GetMethodParameters($Method)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25: $InParams.MACAddress = $strTargetMac
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26: $InParams.NetbiosName = $strTargetComputer
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27: $InParams.OverwriteExistingRecord = $true
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28: $inparams.PSBase.properties | select name,Value | Format-Table
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29: $objCMComputer = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;"> 30:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"> 31:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;"> 32: # Create Collection Rule Direct
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;"> 33: $Class = "SMS_CollectionRuleDirect"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;"> 34: $objColRuledirect = [WmiClass]"\$ComputerROOTSMS$strSite$strColon$Class"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;"> 35: $objColRuleDirect.psbase.properties["ResourceClassName"].value = "SMS_R_System"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"> 36: $objColRuleDirect.psbase.properties["ResourceID"].value = $objCMComputer.resourceID
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;"> 37:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;"> 38:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;"> 39: # Target Collection connection
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;"> 40: $Collection = gwmi -computer $computer -namespace "rootsms$strSite" -class "SMS_Collection"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;"> 41: $PoshCollec = $collection | where{$_.Name -eq "$strTargetCollection"}
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"> 42:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;"> 43:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;"> 44: # Add Computer to Target Collection
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;"> 45: $Class = "SMS_Collection"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;"> 46: $Method = "AddMembershipRule"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;"> 47: $CollectionID = $PoshCollec.CollectionID
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;"> 48: $filter="CollectionID = '$CollectionID'"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"> 49: $MC = Get-WmiObject $class -computer $Computer -Namespace "ROOTSMS$strSite" -filter $filter
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;"> 50: $InParams = $mc.psbase.GetMethodParameters($Method)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;"> 51: $InParams.collectionRule = $objColRuledirect
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;"> 52:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;"> 53: $inparams.PSBase.properties | select name,Value | Format-Table
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"> 54: $R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;"> 55: }
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

The script needs to run on a ConfigMgr management point.

Questions? Just ask… (Twitter: @david_obrien) or comment here. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

