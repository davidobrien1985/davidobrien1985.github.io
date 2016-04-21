---
id: 285
title: Microsoft Configuration Manager 2012 and Powershell–Part 2
date: 2012-02-25T16:42:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=285
permalink: /2012/02/microsoft-configuration-manager-2012-and-powershellpart-2/
categories:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - Configuration Manager
  - Configuration Manager 2012
  - Microsoft
  - Powershell
  - System Center
---
Just wanted to keep you up-to-date regarding my task to automatically build a folder-collection structure in a customer’s Configuration Manager 2012 environment. (see also article [http://www.david-obrien.de/?p=275](http://www.david-obrien.de/?p=275))

## Create Configuration Manager device collections

We already know how to create folders underneath the collections node. Now we need to create the collections our clients will one day be members of.

This isn’t too hard a task, so here’s my script:

```PowerShell
#Functionality: creates a ConfigMgr collection
#Author: David O'Brien
#date: 25.02.2012
#####

Function Create-Collection($CollectionName)
{
  $CollectionArgs = @{
    Name = $CollectionName;
    CollectionType = '2';         # 2 means Collection_Device, 1 means Collection_User
    LimitToCollectionID = 'SMS00001'
  }

  Set-WmiInstance -Class SMS_Collection -arguments $CollectionArgs -namespace 'root\SMS\Site_$sitename' | Out-Null
}

$CollectionName = Get-Random   # creates a random number for testing

$sitename = 'PRI'
Create-Collection $CollectionName
```

You all know that we’ve got “Limiting collections” now in Configuration Manager 2012, so we need to provide our script with the limiting collection’s ID. In this example it’s the “All Systems” device collection.

## Move Configuration Manager device collections
The thing with collections and folders is a bit tricky. While creating a collection it always gets created in the collection node’s root. This is why we can’t provide our target folder during collection creation.
It’s a two-step process!
* After creation we can now move our collection away from the root into a known folder. Either hardcode the “ObjectContainerNodeID” of your target folder into the script, or better, evaluate it during script execution depending on your collection and folder name. The latter will be very easy when you stick to a naming convention like `$Folder name = %abbreviation for remote site%` like “CGN” for Cologne `$Collection Name = $Folder name_Clients`

Just go ahead and split your collection name until it matches your folder name and go ahead like this:

```PowerShell
﻿param (
[string]$sitename,
[string]$CollectionName
)

#####
#Functionality: creates a ConfigMgr collection
#Author: David O'Brien
date: 25.02.2012
#####

Function Create-Collection($CollectionName)
{
  $CollectionArgs = @{
    Name = $CollectionName;
    CollectionType = '2';         # 2 means Collection_Device, 1 means Collection_User
    LimitToCollectionID = 'SMS00001'
  }
  Set-WmiInstance -Class SMS_Collection -arguments $CollectionArgs -namespace 'root\SMS\Site_$sitename' | Out-Null
}
#####
#Functionality: moves a ConfigMgr collection from one folder to an other
#Author: David O'Brien
#date: 25.02.2012
#####

function move-Collection($SourceContainerNodeID,$collID,$TargetContainerNodeID)
{
  $Computer = '.'
  $Class = 'SMS_ObjectContainerItem'
  $Method = 'MoveMembers'
  $MC = [WmiClass]"\\$Computer\ROOT\SMS\site_$($sitename):$Class"
  $InParams = $mc.psbase.GetMethodParameters($Method)
  $InParams.ContainerNodeID = $SourceContainerNodeID #usually 0 when> newly created Collection
  $InParams.InstanceKeys = $collID
  $InParams.ObjectType = '5000' #5000 for Collection_Device, 5001 for> Collection_User
  $InParams.TargetContainerNodeID = $TargetContainerNodeID #needs to be evaluated
  "Calling SMS_ObjectContainerItem. : MoveMembers with Parameters :"
  $inparams.PSBase.properties | select name,Value | format-Table
  $R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)
}

create-collection $CollectionName # $_.CollectionID is sufficient
$collection = gwmi -Namespace root\sms\site_$sitename -Class SMS_Collection | where {$_.Name -eq "$collectionName"}

$collID = $collection.CollectionID
$SourceContainerNodeID = '0' #usually 0 when newly created Collection
$TargetContainerNodeID =  #Needs to be evaluated, depending on where you want to put the collection!

move-collection $SourceContainerNodeID $collID $TargetContainerNodeID
```

Now you’ve got two independent functions and need to combine them into one script.
Any questions? Just comment here, send me a mail or contact me on twitter (@david_obrien)
