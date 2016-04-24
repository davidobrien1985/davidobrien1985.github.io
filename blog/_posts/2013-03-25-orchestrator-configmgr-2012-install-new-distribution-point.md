---
id: 865
title: 'Orchestrator &amp; ConfigMgr 2012 Install new Distribution Point'
date: 2013-03-25T11:31:38+00:00
author: "David O'Brien"
layout: single

permalink: /2013/03/orchestrator-configmgr-2012-install-new-distribution-point/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Orchestrator
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Distribution Point
  - Orchestrator
  - runbooks
  - SCCM
  - System Center
---
The new ConfigMgr 2012 SP1 CU1 has given us new Powershell cmdlets ( see [here](/2013/03/found-where-are-my-new-configmgr-2012-sp1-cu1-cmdlets/) and [here](2013/03/23/cumulative-update-1-for-configuration-manager-2012/)), one of these is the Add-CMDistributionPoint cmdlet.

Well, I don’t like it, but that’s just me. I still use my own script to install a Distribution Point in SCCM 2012. (look here: [How to install a Distribution Point via Powershell](/2013/03/how-to-install-new-distribution-point-sccm-2012/))

# ConfigMgr / SCCM and Orchestrator combined

Because that is not enough, I went and implemented this script into an Orchestrator runbook, which you can download here: [http://davidobrien.codeplex.com/releases/view/103984](http://davidobrien.codeplex.com/releases/view/103984) or view the code here [http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export]( http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export)

As usual with my runbooks, you’ll need to define your variables in the runbook and globally:

![image](/media/2013/03/image25.png)

![image](/media/2013/03/image26.png)


