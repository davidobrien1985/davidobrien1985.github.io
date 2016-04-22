---
id: 553
title: 'What&rsquo;s new in ConfigMgr SP1?'
date: 2012-12-20T23:55:07+00:00
author: "David O'Brien"
layout: single
guid: http://david-obrien.de/?p=553
permalink: /2012/12/whats-new-in-configmgr-sp1/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - SCCM
  - SP1
  - System Center Configuration Manager
  - update
---
# Overview of what’s new in System Center 2012 Configuration Manager

This is a short overview of what I found new in ConfigMgr SP1 update:

* I am able to **update my pre-release SP1 to RTM** (Thanks [@pvanderwoude](http://twitter.com/pvanderwoude))
  * although I doubt MS will support that for anyone but TAP customers
* There are 56 prerequisites for this new release
  * SQL Express 2012
  * SQL Native Client 2012
  * Silverlight 5
  * all in all **624MB** of data
* SQL Server 2012 officially supported for site database
* Deployment of Windows 8 and Windows Server 2012 supported
* support for Win8 apps
* WinPE 4.0 is being used for boot images
* Powershell is now available in WinPE phase
* Bitlocker
  * much faster encryption due to only encrypting what’s written on disk
  * preprovisioning in WinPE
* Powershell cmdlets for Site Server (see my previous blog [ConfigMgr 2012 SP1 Powershell](/2012/09/15/ms-system-center-configuration-manager-2012-sp1-beta-powershell/))

