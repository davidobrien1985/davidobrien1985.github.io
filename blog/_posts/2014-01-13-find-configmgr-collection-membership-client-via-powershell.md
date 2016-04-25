---
id: 1567
title: How to find ConfigMgr Collection membership of client via Powershell?
date: 2014-01-13T15:47:52+00:00

layout: single

permalink: /2014/01/find-configmgr-collection-membership-client-via-powershell/
categories:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
---
During my session today at the ConfigMgr User Group in Zurich / CH I demoed a little Powershell function which will output all the Collection Names a device is a member of. Unfortunately, this cannot be done by default from the Admin Console.

I know there are Console extensions doing EXACTLY the same, but I know of people who don’t want to install any extensions not made available by the vendor. This is why I wrote this little snippet which in turn can easily be turned into a function.

```PowerShell
$ResID = (Get-CMDevice -Name "CLTwin7").ResourceID
$Collections = (Get-WmiObject -Class sms_fullcollectionmembership -Namespace root\sms\site_HQ1 -Filter "ResourceID = '$($ResID)'").CollectionID
    foreach ($Collection in $Collections)
    {
      Get-CMDeviceCollection -CollectionId $Collection | select Name, CollectionID
    }
```

In line 1 just change the Name of the Client you want to check and in line 2 change the SiteCode (mine is HQ1).
Because of lines 1 and 5 you need to import the ConfigMgr Powershell module first.

![SCCM Collection Membership](/media/2014/01/image10.png)


