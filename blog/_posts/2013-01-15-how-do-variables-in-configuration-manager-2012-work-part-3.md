---
id: 682
title: 'How do variables in Configuration Manager 2012 work? &ndash; Part 3'
date: 2013-01-15T15:32:00+00:00
author: "David O'Brien"
layout: single

permalink: /2013/01/how-do-variables-in-configuration-manager-2012-work-part-3/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - Collections
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
---
# Script to automate Collection creation and variable priority in SCCM 2012

For part 1 read here ["How do variables in Configuration Manager 2012 work? – Part 1"](/2013/01/how-do-variables-in-configuration-manager-2012-work-part-1/) and part 2 read here ["How do variables in Configuration Manager 2012 work? – Part 2"](/2013/01/how-do-variables-in-configuration-manager-2012-work-part-2/).

I promised you to post the script to create the device collections with a configurable variable priority.

Here’s the script:

```
<######

Functionality: creates a ConfigMgr collection
Author: David O'Brien
date: 25.02.2012
History:
    - 15.01.2013, David O'Brien, david.obrien@gmx.de, added function Set-CollectionVariablePriority
######>

param (
[string]$SiteCode,
[string]$CollectionName,
[string]$CollectionVariablePrecedence
)

Function Create-Collection($CollectionName)

{
    $CollectionArgs = @{
    Name = $CollectionName;
    CollectionType = "2";         # 2 means Collection_Device, 1 means Collection_User
    LimitToCollectionID = "SMS00001"
    }
    Set-WmiInstance -Class SMS_Collection -arguments $CollectionArgs -namespace "root\SMS\Site_$SiteCode" | Out-Null
}

Function Set-CollectionVariablePriority($CollectionName)

{
    $CollectionID = (Get-WmiObject -Class SMS_Collection -Namespace "root\SMS\Site_$SiteCode" | where {$_.Name -eq "$($CollectionName)"}).CollectionID
    $SMS_CollectionSettings = "SMS_CollectionSettings"
    $class_SMS_CollectionSettings = [wmiclass]""
    $class_SMS_CollectionSettings.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_CollectionSettings)"
    $SMS_CollectionSettings = $class_SMS_CollectionSettings.CreateInstance()
    $SMS_CollectionSettings.CollectionID = "$($CollectionID)"
    $SMS_CollectionSettings.CollectionVariablePrecedence = "$($CollectionVariablePrecedence)"
    $SMS_CollectionSettings.Put()
}

Create-Collection $CollectionName

Set-CollectionVariablePriority $CollectionName
```

Save the script as “create-collection.ps1” and run it with this command on the Configuration Manager server:

```
.\create-collection.ps1 –SiteCode LAB –CollectionName TestCollection –CollectionVariablePrecedence 5
```

Here is the article where I talk about the former script to create Collections: [How to create collections in ConfigMgr 2012 -video](http://www.david-obrien.net/?p=570)



