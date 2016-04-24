---
id: 176
title: Microsoft ConfigMgr 2012 – Client Log Files
date: 2011-12-23T12:19:43+00:00
author: "David O'Brien"
layout: single

permalink: /2011/12/microsoft-configmgr-2012-client-log-files/
if_slider_image:
  -
categories:
  - Applications
  - Common
  - ConfigMgr 2012
  - MDT
  - Microsoft
  - Operating System
  - SCCM
  - Windows 7
tags:
  - ConfigMgr
  - ConfigMgr2012
  - Configuration Manager
  - log files
  - logfiles
  - logs
  - Microsoft
  - SCCM
  - System Center
---

A lot of things changed with the coming of ConfigMgr2012 (for now it’s in the state of RC1). Loads of people already wrote articles about what cool new features and goodies came with ConfigMgr2012, I instead want to have a closer look on troubleshooting, as I am in the middle of a RC1 deployment at a customer’s site.

* Log Files

If you’ve already worked with System Center Configuration Manager (SCCM) 2007, you most likely know that, if something goes wrong, then there are a lot of Log Files to look into.

To tell you now: The client log folder didn’t get any less crowded!

Here’s an overview of all the log files present on my Windows7-x64 client after OS installation and one installed application and one package.

![logfiles](/media/2011/12/logfiles_1.jpg "logfiles_1")

![logfiles2](/media/2011/12/logfiles_2.jpg "logfiles_2")
![logfiles3](/media/2011/12/logfiles_3.jpg "logfiles_3")

In total 78 log files, where some few are doubles.

For the beginning I will focus on the most important log files (in my opinion). Lets start alphabetically (no guarantee on anything)

* AppDiscovery.log

** Detects installed Application Deployment Types and if deployed Deployment Types are not installed, this log file will show you why (only for the new style ConfigMgr Applications)

* AppEnforce.log

** will show you the actual command-line executed and the resulting exit code for each Deployment Type (only for the new style ConfigMgr Applications)

* AppIntentEval.log

** evaluates each Deployment Type’s dependencies and policies (only for the new style ConfigMgr Applications)

* AssetAdvisor.log

** inventories all installed software (not 100% sure)

* CAS.log

** Content access service, discovers DPs, download sources and maintains local cache

* CCM32BitLauncher.log

** logs all command-lines for executed packages (old style ConfigMgr)

* CCMEval.log

** depends on %windir%ccmccmeval.xml and checks the CCM client’s health

* CCMEvalTask.log

** checks if the CCMEval Task has run

* CCMExec.log

** monitors the client and CCMExec service

* ClientIDManagerStartUp.log

** creates and maintains the client’s GUID

* ClientLocation.log

** determines the assigned ConfigMgr site

* CMRcService.log

** ConfigMgr Remote Control Service

* ContentTransferManager.log

** controls BITS or SMB download of ConfigMgr packages

* DataTransferService.log

** monitors all package downloads

* dism.log

** monitors dism.exe process during OSD (e.g. driver injection)

* EndpointProtectionAgent.log

** System Center Endpoint Protection is now integrated into ConfigMgr 2012 and this is its log

* ExecMgr.log

** logs all deployed packages (old-style) and associated programs and policies

* FileSystemFile.log

** log for software inventory and file collection

* InventoryAgent.log

** logs DDRs (Discovery Data Records) for hardware and software

* LocationServices.log

** finds Management Points, Distribution Points, Software Update Points

* MaintenanceCoordinator.log

** is in control of all the ConfigMgr client’s maintenance tasks

* mtrmgr.log

** software metering

* oobmgmt.log

** Out of Band management, for internet-based clients

* PolicyAgent.log

** requests policies assigned to machine or user

* PolicyAgentProvider.log

** monitors any changes to policies

* PolicyEvaluator.log

** keeps track of new policies

* pwrmgmt.log

** monitors power management activities on the client

* RebootCoordinator.log

** collects information about reboots after software update installations

* ScanAgent.log

** scans the client for need of software updates

* SCClient_%domain%@%user%1.log

** Software Center Client for a specific domain and user, deployments will show up in here

* Scheduler.log

** records scheduled ConfigMgr tasks

* SCNotify_%domain%@%user%1.log

** Software Center Client for a specific domain and user, logs notifications regarding deployments

* ServiceWindowManager.log

** monitors existing service windows for the client in which for example software is allowed to be installed

* smscliui.log

** records usage of ConfigMgr UI in system panel

* smssha.log

** log file for Network Access Protection Agent

* smsts.log

** Task Sequence log

* SoftwareCenterSystemTasks.log

** logs Software Center’s process (startup, end)

* StateMessage.log

** sends software update states to MP

* StatusAgent.log

** logs events created by ConfigMgr Agent components

* SWMTRReportGen.log

** generates usage data report

* TSAgent.log

** logs the process before a TaskSequence starts up, e.g. download of policies

* UpdatesDeployment.log

** shows information regarding Software Updates, if for example updates are enforced or assigned

* UserAffinity.log

** new model of “User Device Affinity” (UDA), checks if there is an existing UDA for the machine or creates/sends a new UDA to the MP

# Site Server log files
 The next article will cover an overview of ConfigMgr 2012 Site Server logfiles.


