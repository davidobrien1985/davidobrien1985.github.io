---
id: 176
title: Microsoft ConfigMgr 2012 – Client Log Files
date: 2011-12-23T12:19:43+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=176
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
<p align="left">
  A lot of things changed with the coming of ConfigMgr2012 (for now it’s in the state of RC1). Loads of people already wrote articles about what cool new features and goodies came with ConfigMgr2012, I instead want to have a closer look on troubleshooting, as I am in the middle of a RC1 deployment at a customer’s site.
</p>

<h2 align="left">
  Log Files
</h2>

<p align="left">
  If you’ve already worked with System Center Configuration Manager (SCCM) 2007, you most likely know that, if something goes wrong, then there are a lot of Log Files to look into.
</p>

<p align="left">
  To tell you now: The client log folder didn’t get any less crowded!
</p>

<p align="left">
  Here’s an overview of all the log files present on my Windows7-x64 client after OS installation and one installed application and one package.
</p>

<p align="left">
  [<img class="img-responsive lightbox" style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-image: initial;" title="logfiles_1" src="http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_1_thumb.jpg" alt="logfiles_1" width="229" height="285" />]("logfiles_1" http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_1.jpg)
</p>

<p align="left">
  [<img class="img-responsive lightbox" style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-image: initial;" title="logfiles_2" src="http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_2_thumb.jpg" alt="logfiles_2" width="225" height="259" />]("logfiles_2" http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_2.jpg)
</p>

<p align="left">
  [<img class="img-responsive lightbox" style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-image: initial;" title="logfiles_3" src="http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_3_thumb.jpg" alt="logfiles_3" width="233" height="110" />]("logfiles_3" http://www.david-obrien.de/wp-content/uploads/2011/12/logfiles_3.jpg)
</p>

<p align="left">
  In total 78 log files, where some few are doubles.
</p>

<p align="left">
  For the beginning I will focus on the most important log files (in my opinion). Lets start alphabetically (no guarantee on anything <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2011/12/wlEmoticon-winkingsmile.png" alt="Winking smile" /> ):
</p>

<div align="left">
  <table width="665" border="2" cellspacing="1" cellpadding="1" align="center" bgcolor="white">
    <tr>
      <td width="233">
        AppDiscovery.log
      </td>
      
      <td width="425">
        Detects installed Application Deployment Types and if deployed Deployment Types are not installed, this log file will show you why (only for the new style ConfigMgr Applications)
      </td>
    </tr>
    
    <tr>
      <td width="235">
        AppEnforce.log
      </td>
      
      <td width="423">
        will show you the actual command-line executed and the resulting exit code for each Deployment Type (only for the new style ConfigMgr Applications)
      </td>
    </tr>
    
    <tr>
      <td width="237">
        AppIntentEval.log
      </td>
      
      <td width="422">
        evaluates each Deployment Type’s dependencies and policies (only for the new style ConfigMgr Applications)
      </td>
    </tr>
    
    <tr>
      <td width="238">
        AssetAdvisor.log
      </td>
      
      <td width="421">
        inventories all installed software (not 100% sure)
      </td>
    </tr>
    
    <tr>
      <td width="239">
        CAS.log
      </td>
      
      <td width="420">
        Content access service, discovers DPs, download sources and maintains local cache
      </td>
    </tr>
    
    <tr>
      <td width="240">
        CCM32BitLauncher.log
      </td>
      
      <td width="419">
        logs all command-lines for executed packages (old style ConfigMgr)
      </td>
    </tr>
    
    <tr>
      <td width="241">
        CCMEval.log
      </td>
      
      <td width="418">
        depends on %windir%ccmccmeval.xml and checks the CCM client’s health
      </td>
    </tr>
    
    <tr>
      <td width="242">
        CCMEvalTask.log
      </td>
      
      <td width="418">
        checks if the CCMEval Task has run
      </td>
    </tr>
    
    <tr>
      <td width="242">
        CCMExec.log
      </td>
      
      <td width="418">
        monitors the client and CCMExec service
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ClientIDManagerStartUp.log
      </td>
      
      <td width="418">
        creates and maintains the client’s GUID
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ClientLocation.log
      </td>
      
      <td width="418">
        determines the assigned ConfigMgr site
      </td>
    </tr>
    
    <tr>
      <td width="242">
        CMRcService.log
      </td>
      
      <td width="418">
        ConfigMgr Remote Control Service
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ContentTransferManager.log
      </td>
      
      <td width="418">
        controls BITS or SMB download of ConfigMgr packages
      </td>
    </tr>
    
    <tr>
      <td width="242">
        DataTransferService.log
      </td>
      
      <td width="418">
        monitors all package downloads
      </td>
    </tr>
    
    <tr>
      <td width="242">
        dism.log
      </td>
      
      <td width="418">
        monitors dism.exe process during OSD (e.g. driver injection)
      </td>
    </tr>
    
    <tr>
      <td width="242">
        EndpointProtectionAgent.log
      </td>
      
      <td width="418">
        System Center Endpoint Protection is now integrated into ConfigMgr 2012 and this is its log
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ExecMgr.log
      </td>
      
      <td width="418">
        logs all deployed packages (old-style) and associated programs and policies
      </td>
    </tr>
    
    <tr>
      <td width="242">
        FileSystemFile.log
      </td>
      
      <td width="418">
        log for software inventory and file collection
      </td>
    </tr>
    
    <tr>
      <td width="242">
        InventoryAgent.log
      </td>
      
      <td width="418">
        logs DDRs (Discovery Data Records) for hardware and software
      </td>
    </tr>
    
    <tr>
      <td width="242">
        LocationServices.log
      </td>
      
      <td width="418">
        finds Management Points, Distribution Points, Software Update Points
      </td>
    </tr>
    
    <tr>
      <td width="242">
        MaintenanceCoordinator.log
      </td>
      
      <td width="418">
        is in control of all the ConfigMgr client’s maintenance tasks
      </td>
    </tr>
    
    <tr>
      <td width="242">
        mtrmgr.log
      </td>
      
      <td width="418">
        software metering
      </td>
    </tr>
    
    <tr>
      <td width="242">
        oobmgmt.log
      </td>
      
      <td width="418">
        Out of Band management, for internet-based clients
      </td>
    </tr>
    
    <tr>
      <td width="242">
        PolicyAgent.log
      </td>
      
      <td width="418">
        requests policies assigned to machine or user
      </td>
    </tr>
    
    <tr>
      <td width="242">
        PolicyAgentProvider.log
      </td>
      
      <td width="418">
        monitors any changes to policies
      </td>
    </tr>
    
    <tr>
      <td width="242">
        PolicyEvaluator.log
      </td>
      
      <td width="418">
        keeps track of new policies
      </td>
    </tr>
    
    <tr>
      <td width="242">
        pwrmgmt.log
      </td>
      
      <td width="418">
        monitors power management activities on the client
      </td>
    </tr>
    
    <tr>
      <td width="242">
        RebootCoordinator.log
      </td>
      
      <td width="418">
        collects information about reboots after software update installations
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ScanAgent.log
      </td>
      
      <td width="418">
        scans the client for need of software updates
      </td>
    </tr>
    
    <tr>
      <td width="242">
        SCClient_%domain%@%user%1.log
      </td>
      
      <td width="418">
        Software Center Client for a specific domain and user, deployments will show up in here
      </td>
    </tr>
    
    <tr>
      <td width="242">
        Scheduler.log
      </td>
      
      <td width="418">
        records scheduled ConfigMgr tasks
      </td>
    </tr>
    
    <tr>
      <td width="242">
        SCNotify_%domain%@%user%1.log
      </td>
      
      <td width="418">
        Software Center Client for a specific domain and user, logs notifications regarding deployments
      </td>
    </tr>
    
    <tr>
      <td width="242">
        ServiceWindowManager.log
      </td>
      
      <td width="418">
        monitors existing service windows for the client in which for example software is allowed to be installed
      </td>
    </tr>
    
    <tr>
      <td width="242">
        smscliui.log
      </td>
      
      <td width="418">
        records usage of ConfigMgr UI in system panel
      </td>
    </tr>
    
    <tr>
      <td width="242">
        smssha.log
      </td>
      
      <td width="418">
        log file for Network Access Protection Agent
      </td>
    </tr>
    
    <tr>
      <td width="242">
        smsts.log
      </td>
      
      <td width="418">
        Task Sequence log
      </td>
    </tr>
    
    <tr>
      <td width="242">
        SoftwareCenterSystemTasks.log
      </td>
      
      <td width="418">
        logs Software Center’s process (startup, end)
      </td>
    </tr>
    
    <tr>
      <td width="242">
        StateMessage.log
      </td>
      
      <td width="418">
        sends software update states to MP
      </td>
    </tr>
    
    <tr>
      <td width="242">
        StatusAgent.log
      </td>
      
      <td width="418">
        logs events created by ConfigMgr Agent components
      </td>
    </tr>
    
    <tr>
      <td width="242">
        SWMTRReportGen.log
      </td>
      
      <td width="418">
        generates usage data report
      </td>
    </tr>
    
    <tr>
      <td width="242">
        TSAgent.log
      </td>
      
      <td width="418">
        logs the process before a TaskSequence starts up, e.g. download of policies
      </td>
    </tr>
    
    <tr>
      <td width="242">
        UpdatesDeployment.log
      </td>
      
      <td width="418">
        shows information regarding Software Updates, if for example updates are enforced or assigned
      </td>
    </tr>
    
    <tr>
      <td width="242">
        UserAffinity.log
      </td>
      
      <td width="418">
        new model of “User Device Affinity” (UDA), checks if there is an existing UDA for the machine or creates/sends a new UDA to the MP
      </td>
    </tr>
  </table>
</div>

<h2 align="left">
  Site Server log files
</h2>

<p align="left">
  The next article will cover an overview of ConfigMgr 2012 Site Server logfiles.
</p>

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

