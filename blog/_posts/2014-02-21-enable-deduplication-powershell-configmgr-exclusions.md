---
id: 1658
title: Enable Deduplication with Powershell for ConfigMgr exclusions
date: 2014-02-21T15:58:43+00:00
author: "David O'Brien"
layout: single

permalink: /2014/02/enable-deduplication-powershell-configmgr-exclusions/
categories:
  - ConfigMgr
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Deduplication
  - Powershell
  - SCCM
  - Server 2012
---
Microsoft just released the following blog post on the support of Data Deduplication on Windows Server 2012 R2 in combination with System Center 2012 R2 Configuration Manager.

[http://blogs.technet.com/b/configmgrteam/archive/2014/02/18/configuration-manager-distribution-points-and-windows-server-2012-data-deduplication.aspx](http://blogs.technet.com/b/configmgrteam/archive/2014/02/18/configuration-manager-distribution-points-and-windows-server-2012-data-deduplication.aspx)

Then Johan (@Jarwidmark) published his post on how to actually configure deduplication and a small summary on the support statement:

[http://www.deploymentresearch.com/Research/tabid/62/EntryId/151/Using-Data-DeDuplication-with-ConfigMgr-2012-R2.aspx](http://www.deploymentresearch.com/Research/tabid/62/EntryId/151/Using-Data-DeDuplication-with-ConfigMgr-2012-R2.aspx)

# Enable Data Deduplication for ConfigMgr with Powershell

If you don’t want to enable it all manually, then just use this code snippet inside an administrative Powershell.

Just change line 6 and enter the Volume you like to enable Deduplication on and do the same in line 9.

In line 9 you should also add any exclusions you want. Like Johan and the MS article stated, don’t enable dedup for your Content Source!

```PowerShell
#Install the feature
Import-Module ServerManager
Add-WindowsFeature -Name FS-Data-Deduplication
#Enable on volume
Enable-DedupVolume D:
# Set exclusions
Set-DedupVolume –Volume D: -ExcludeFolder 'D:\ContentSource'
```

Have fun saving space!


