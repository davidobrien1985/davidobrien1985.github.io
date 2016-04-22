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

```PowerShell
#####
# Function: Import-ConfigMgr
# This function imports a given client into a defined collection.
# Ersteller: David O'Brien
# Erstellt am: 14.07.2011
#####
Function Import-ConfigMgr
{
  ### Define variables to import the client to ConfigMgr
  $strTargetComputer = $computername
  $strTargetMac = $computerMAC
  ### Which collection should the client be imported to?
  $strTargetCollection = 'Install ' + $computerOS # in my environment a Client automatically gets a machine variable $computerOS
  ### Load Variables
  $strSite = "Site_LAB"
  # Create computer in ConfigMgr
  $strColon = ":"
  $Class = "SMS_Site"
  $Method = "ImportMachineEntry"
  $MC = [WmiClass]"\.ROOTSMS$strSite$strColon$Class"
  $InParams = $mc.psbase.GetMethodParameters($Method)
  $InParams.MACAddress = $strTargetMac
  $InParams.NetbiosName = $strTargetComputer
  $InParams.OverwriteExistingRecord = $true
  $inparams.PSBase.properties | select name,Value | Format-Table
  $objCMComputer = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)
  # Create Collection Rule Direct
  $Class = "SMS_CollectionRuleDirect"
  $objColRuledirect = [WmiClass]"\$ComputerROOTSMS$strSite$strColon$Class"
  $objColRuleDirect.psbase.properties["ResourceClassName"].value = "SMS_R_System"
  $objColRuleDirect.psbase.properties["ResourceID"].value = $objCMComputer.resourceID
  # Target Collection connection
  $Collection = gwmi -computer $computer -namespace "rootsms$strSite" -class "SMS_Collection"
  $PoshCollec = $collection | where{$_.Name -eq "$strTargetCollection"}
  # Add Computer to Target Collection
  $Class = "SMS_Collection"
  $Method = "AddMembershipRule"
  $CollectionID = $PoshCollec.CollectionID
  $filter="CollectionID = '$CollectionID'"
  $MC = Get-WmiObject $class -computer $Computer -Namespace "ROOTSMS$strSite" -filter $filter
  $InParams = $mc.psbase.GetMethodParameters($Method)
  $InParams.collectionRule = $objColRuledirect
  $inparams.PSBase.properties | select name,Value | Format-Table
  $R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)
}
```

The script needs to run on a ConfigMgr management point.

Questions? Just ask… (Twitter: @david_obrien) or comment here.
