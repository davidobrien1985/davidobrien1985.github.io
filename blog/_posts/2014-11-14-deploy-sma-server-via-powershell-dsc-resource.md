---
id: 2651
title: Deploy SMA Server via Powershell DSC resource
date: 2014-11-14T11:52:39+00:00

layout: single

permalink: /2014/11/deploy-sma-server-via-powershell-dsc-resource/
categories:
  - DSC
  - PowerShell
  - Uncategorized
tags:
  - Desired State Configuration
  - DSC
  - Powershell
  - Service Management Automation
  - SMA
  - System Center
---
Hi,

I'm currently sitting on my plane from Minneapolis to Dallas. I love technology, WiFi on a plane, awesome!!!

After two weeks of conferences (MVP Summit and MMS) I'm pretty exhausted and looking forward to get back home.

I already wrote about how to deploy a SMA (Service Management Automation) runbook worker with the help of Powershell DSC (Desired State Configuration) [here , ](/2014/07/deploy-sma-worker-via-powershell-dsc/)but Microsoft has just the other day released the DSC Resource Kit Wave 8 with now in total more than 100 custom resources. Some of those are for System Center components, for example for SMA.

# DSC Resource for SMA (xSCSMA)

The custom module released by Microsoft to be used to install a new SMA environment is actually pretty awesome. It already comes with six ready-to-go examples.

![image](/media/2014/11/xSCSMA_Examples.png)

It doesn't matter if you'd like to deploy to only one server or multiple servers, if your SQL is a standalone machine or on the same box or even if you would like to a deployment on Server Technical Preview, you can use these examples and get your SMA environment up and running in no time.

## SMA Runbook Worker installation

If you go and read my article (linked above) you will see that I struggled a bit with the installation, because DSC runs in the system's context and the MSI installing the Worker doesn't like that. I only got it working by applying an MST during installation, because Microsoft are adding the install user to a local group on that machine and use the Domain Name as a prefix ($DomainName\Local System), which doesn't work.

The resource however ships its own Powershell module xPDT.psm1 which comes with some custom cmdlets working around that issue. They also apply a custom MST, which I wasn't able to check yet. (as I'm still on the plane)

## Requirements

The module requires Powershell version 5, which is currently still in Preview. All example configuration scripts have the following line in the beginning of the scripts:

`#requires -Version 5`

This tells Powershell that it can only execute it if the local major Powershell version is 5. A reason for that is because in order to get the distributed SMA environment installed, DSC needs to check installations on multiple nodes and depends on configurations on remote nodes. This is only achievable through Powershell 5 with the _WaitFor*_ resources.

You can also provision yourself a new Windows Server 2012 R2 VM on Azure, if you don't have an on-premises VM satisfying this requirement, because they already come with Powershell 5.

The examples cover pretty much everything you need in order to get a SMA environment up and running. All you need to do is download all the sources (SQL Server and Orchestrator) and put them into an accessible path for the systems you are deploying to.

You also need to download a couple of more resources/modules in order to get everything working. It is probably easiest setting up a DSC Pull Server ([http://blogs.msdn.com/b/powershell/archive/2013/11/21/powershell-dsc-resource-for-configuring-pull-server-environment.aspx](http://blogs.msdn.com/b/powershell/archive/2013/11/21/powershell-dsc-resource-for-configuring-pull-server-environment.aspx)) and make all modules from the DSC Resource Kit available on that server. This way clients can download resources if necessary.

Otherwise you can just copy the xSQLServer and xSCSMA modules to the machine's PSModulePath (please use C:\Program Files\WindowsPowershell\Modules), this way the configuration will be able to find and use the modules and their containing resources.

The only remaining question now is: How much easier should Microsoft make it to deploy and get started with SMA? This is as easy as it gets.

Have fun automating!

-[David](http://twitter.com/david_obrien)



