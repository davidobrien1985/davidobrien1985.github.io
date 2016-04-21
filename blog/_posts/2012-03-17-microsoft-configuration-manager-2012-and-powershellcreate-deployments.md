---
id: 287
title: Microsoft Configuration Manager 2012 and Powershell–Create Deployments
date: 2012-03-17T11:11:21+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=287
permalink: /2012/03/microsoft-configuration-manager-2012-and-powershellcreate-deployments/
categories:
  - Common
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
  - Powershell
  - SCCM
  - SCCM 2012
  - scripting
  - System Center
---
Hi all,

here another quick script I wrote to deploy a specified Task Sequence to a given collection.

This was a real quick one, as I could find out all the required values through WMIExplorer (thanks to [http://thepowershellguy.com/blogs/posh/archive/2007/03/22/powershell-wmi-explorer-part-1.aspx](http://thepowershellguy.com/blogs/posh/archive/2007/03/22/powershell-wmi-explorer-part-1.aspx) ), some self-made WMI queries and SMSProv.log (always look in here for help!!!)

So here’s my script:

```PowerShell
$sitename = "PRI"

function create-TSDeployment{

  $targetcoll = gwmi -ns "rootSMSSite_$sitename" -class SMS_Collection | WHERE {$_.Name -eq 'Install WinXP'} #if you want to deploy to multiple collections, you'll need to replace the name here

  $collID = $targetcoll.CollectionID
  $collName = $targetcoll.Name
  $TS = Gwmi -ns "rootSMSSite_$sitename" -class SMS_TaskSequencePackage | WHERE {$_.Name -eq 'Install XP'} #place TS Name in here
  $TSID = $TS.PackageID
  $TSName = $TS.Name
  $AdvName = $TSName+"_"+$TSID+"_"+$collName
  $AdvArgs =  @{
    AdvertFlags = 42860576;
    AdvertisementName = "$AdvName";
    CollectionID = $collID;
    PackageID = $TSID;
    ProgramName = "*";
    RemoteClientFlags = 8480;
    SourceSite = $sitename;
    TimeFlags = 8193
  }

  Set-WmiInstance -Class SMS_Advertisement -arguments $AdvArgs -namespace "rootSMSSite_$sitename" | Out-Null
}

create-TSDeployment
```

As my customer would like to deploy one Task Sequence to round about 150 collections, I will have to build a for-each loop to fill in the correct target collection name.

# SMS_Advertisement

For more information on the SMS_Advertisement WMI class, see [http://msdn.microsoft.com/en-us/library/cc146108.aspx](http://msdn.microsoft.com/en-us/library/cc146108.aspx)

There you’ll find more about the AdvertFlags, RemoteClientFlags and TimeFlags, as you will configure your deployment via these values, e.g “Deployment is available” or “Deployment is required and allowed to PXE”.

Any questions? Contact me here or via Twitter @david_obrien
