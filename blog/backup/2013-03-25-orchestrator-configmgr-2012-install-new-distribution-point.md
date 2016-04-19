---
id: 865
title: 'Orchestrator &amp; ConfigMgr 2012 Install new Distribution Point'
date: 2013-03-25T11:31:38+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=865
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
The new ConfigMgr 2012 SP1 CU1 has given us new Powershell cmdlets ( see <a href="http://www.david-obrien.net/?p=854" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/?p=854', 'here']);" target="_blank">here</a> and <a href="http://www.david-obrien.net/2013/03/23/cumulative-update-1-for-configuration-manager-2012/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2013/03/23/cumulative-update-1-for-configuration-manager-2012/', 'here']);" target="_blank">here</a>), one of these is the Add-CMDistributionPoint cmdlet.

Well, I don’t like it, but that’s just me. I still use my own script to install a Distribution Point in SCCM 2012. (look here: <a href="http://www.david-obrien.net/?p=809" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/?p=809', 'How to install a Distribution Point via Powershell']);" target="_blank">How to install a Distribution Point via Powershell</a>)

# ConfigMgr / SCCM and Orchestrator combined

Because that is not enough, I went and implemented this script into an Orchestrator runbook, which you can download here: <a href="http://davidobrien.codeplex.com/releases/view/103984" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://davidobrien.codeplex.com/releases/view/103984', 'http://davidobrien.codeplex.com/releases/view/103984']);" title="http://davidobrien.codeplex.com/releases/view/103984">http://davidobrien.codeplex.com/releases/view/103984</a> or view the code here <a href="http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export', 'http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export']);" title="http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export">http://davidobrien.codeplex.com/SourceControl/changeset/view/f97015e3f140#Install_DistributionPoint_CM12.ois_export</a>

As usual with my runbooks, you’ll need to define your variables in the runbook and globally:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/03/image25.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/03/image25.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="Orchestrator global variables" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb25.png" width="272" height="61" border="0" /></a>

<a href="http://www.david-obrien.net/wp-content/uploads/2013/03/image26.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/03/image26.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="Runbook variables" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb26.png" width="244" height="131" border="0" /></a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,ConfigMgr,Configuration+Manager,Distribution+Point,Orchestrator,runbooks,SCCM,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2013/03/orchestrator-configmgr-2012-install-new-distribution-point/">Tweet</a>
</div>
