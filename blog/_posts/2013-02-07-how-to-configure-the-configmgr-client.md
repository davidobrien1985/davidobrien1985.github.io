---
id: 718
title: How to configure the ConfigMgr Client cache
date: 2013-02-07T16:42:04+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=718
permalink: /2013/02/how-to-configure-the-configmgr-client/
categories:
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
tags:
  - automation
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
---
# Setting the Cache Size and Location and clear the Cache for SCCM Agent

Today a colleague of mine asked me about an issue he has in one of his projects regarding the ConfigMgr client cache. He’s having a situation where already deployed agents fill up their cache to a point where software distribution isn’t possible anymore. This is kind of the same issue as I already stated on connect and others did on technet ([Application cache not purging when pushed via OSD TS](http://social.technet.microsoft.com/Forums/en-US/configmanagerosd/thread/84f2f3fe-5626-454a-9d3a-6fb16ff784d7)). This article on technet describes how to set these settings during client push or installation during OSD. ([About Client Installation Properties in Configuration Manager](http://technet.microsoft.com/en-us/library/gg699356.aspx))

## Setting the Cache Size in CM12

I found two ways to configure the cache size for an already deployed ConfigMgr Agent. The first is via the ConfigMgr Agent ComObject ([Software Distribution Client Control Panel Automation](http://msdn.microsoft.com/en-us/library/cc143521.aspx)) and looks like this:

```
<#
.SYNOPSIS
    Sets the Configuration Manager Client Cache Size to a specified value.
.DESCRIPTION
    Sets the Configuration Manager Client Cache Size to a specified value.
.PARAMETER CacheSize
    Integer value in MB
.EXAMPLE
    .\set-CacheSize.ps1 -CacheSize 10000
.EXAMPLE
    .\set-CacheSize.ps1 -CacheSize 10000 -Verbose
.NOTES
    Author: David O'Brien, david.obrien@sepago.de
    Version: 1.0
    Change history
        07.02.2013 - first release
        Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
param(
[parameter(Mandatory=$true)][int]$CacheSize
)

$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.TotalSize = $CacheSize

Write-Verbose "The new CacheSize is $($Cache.TotalSize) MB"
```

The other way is via WMI and goes like this:

```
<#
.SYNOPSIS
    Sets the Configuration Manager Client Cache Size to a specified value.
.DESCRIPTION
    Sets the Configuration Manager Client Cache Size to a specified value.
.PARAMETER CacheSize
    Integer value in MB
.EXAMPLE
    .\set-CacheSize.ps1 -CacheSize 10000
.EXAMPLE
    .\set-CacheSize.ps1 -CacheSize 10000 -Verbose
.NOTES
    Author: David O'Brien, david.obrien@sepago.de
    Version: 1.0
    Change history
        07.02.2013 - first release
        Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
param(
[parameter(Mandatory=$true)][int]$CacheSize
)

$Cache = gwmi -class CacheConfig -Namespace root\ccm\SoftMgmtAgent
$Cache.Size = $CacheSize
$Cache.InUse = $true
$Cache.Put() | Out-Null
Restart-Service -DisplayName 'SMS Agent Host'

Write-Verbose -Message "The new CacheSize is $($Cache.Size) MB"
```

The latter needs a restart of the SMS Agent Host in order to work, but this shouldn’t be too much of a problem.

## Change the Cache Location

If you want to change the Cache Location you can also chose between above mentioned ways. As I’m still having some issues with the COM way, for the moment you’ll have to make due with the WMI way:

```
<#
.SYNOPSIS
    Sets the Configuration Manager Client Cache Location to a specified path.
.DESCRIPTION
    Sets the Configuration Manager Client Cache Location to a specified path.
.PARAMETER CacheLocation
    String to new path location
.EXAMPLE
    .\set-CacheLocation.ps1 -CacheLocation "C:\temp\ccmcache"
.NOTES
    Author: David O'Brien, david.obrien@sepago.de
    Version: 1.0
    Change history
        07.02.2013 - first release
        Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
param(
[parameter(Mandatory=$true)][string]$CacheLocation
)

$Cache = gwmi -class CacheConfig -Namespace root\ccm\SoftMgmtAgent
$Cache.Location = $CacheLocation
$Cache.Put() | Out-Null

Restart-Service -DisplayName 'SMS Agent Host'
```

And here comes the way to do this via COM. Thanks to Andy Morgan ([www.thinkiosk.ie](http://www.thinkiosk.ie) or @andyjmorgan) for your help, although it looks like MSDN documentation misled me and I didn’t need the “basic string”. Anyway, thanks!

```
<#
.SYNOPSIS
    Sets the Configuration Manager Client Cache Location to a specified path.
.DESCRIPTION
    Sets the Configuration Manager Client Cache Location to a specified path.
.PARAMETER CacheLocation
    String to new path location
.EXAMPLE
    .\set-CacheLocation.ps1 -CacheLocation "C:\temp\"
.NOTES
    Author: David O'Brien, david.obrien@sepago.de
    Version: 1.0
    Change history
        07.02.2013 - first release
        Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
param(
[parameter(Mandatory=$true)]$CacheLocation
)
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.Location = $CacheLocation

Write-Verbose -Message "The new CacheLocation is $($Cache.Location)"
```

**DO NOT DELETE THE OLD CACHE MANUALLY IN THE FILE SYSTEM!!! If you need to re-run previously cached software the Agent will remember that it has already downloaded the files in the old cache and will try to execute them from there. It won’t try to re-download them and installation fails. Use the script below instead!**

Fun fact: It’s possible to assign a UNC path to the client cache location. But after doing so, the client isn’t working too well ;-)

## [Update] Clear the cache

This issue wouldn’t let me go to bed so I sat down and quickly wrote this few lines which do a cleanup of the client’s cache in a –I believe so- supported way! There’s nothing being logged in smscliui.log, so I guess the GUI is doing a bit more than just telling the COM Object to clear the cache, but I tested in on two clients in my environment and both seem to still be working correctly.

Here’s the script:

```PowerShell
<#
.SYNOPSIS
    Clears all Packages from the Configuration Manager Client Cache.
.DESCRIPTION
    Clears all Packages from the Configuration Manager Client Cache.
.EXAMPLE
    .\clear-ClientCache.ps1
.NOTES
    Author: David O'Brien, david.obrien@sepago.de
    Version: 1.0
    Change history
        07.02.2013 - first release
        Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$CacheElements = $Cache.GetCacheElements()
foreach ($Element in $CacheElements)
    {
        Write-Verbose "Deleting CacheElement with PackageID $($Element.ContentID)"
        Write-Verbose "in folder location $($Element.Location)"
        $Cache.DeleteCacheElement($Element.CacheElementID)

    }
```

This script doesn’t need any parameters and clears all downloaded packages/bits from the cache.

You could now go ahead and use the script above and move the cache to a different location (like second partition) and enlarge it at the same time.

## Configuring the client – sum up

I spent the day configuring a lot of properties of the client and came to the conclusion, that it’s not too easily done. Some things aren’t documented and then I guess also not supported. The thing with the cache location is most probably not supported the way I’m doing it, so beware when testing it in your LAB! I’m still testing it and will tell you when it’s kind of safe to use.

**TEST THE SCRIPTS IN YOUR LAB FIRST!!! I take NO responsibility for any issues!**
