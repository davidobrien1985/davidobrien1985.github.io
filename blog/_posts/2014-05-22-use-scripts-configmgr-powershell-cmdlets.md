---
id: 1826
title: How to use scripts with ConfigMgr Powershell cmdlets
date: 2014-05-22T21:46:40+00:00

layout: single

permalink: /2014/05/use-scripts-configmgr-powershell-cmdlets/
categories:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Orchestrator
  - PowerShell
  - SCCM
tags:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Orchestrator
  - Powershell
  - SCCM
---
This is a short note to everybody using my scripts for ConfigMgr or who plans on using any automation (Powershell, Orchestrator runbooks, whatever) based on the native Powershell cmdlets for ConfigMgr.

Up until now I always thought it is “common knowledge”, but here you go:

The account that executes your automation and has to run the SCCM cmdlets needs to install the signing certificate with which the ConfigMgr Powershell module was signed. **This needs to be done manually!!!**

Before doing any automation, log on to the machine which has the admin console installed and against which your scripts, runbooks or whatever are being executed and do the following:

![image](/media/2014/05/image17.png)

If that account, on that machine, has never before tried to load the ConfigMgr Powershell module, then the following message will appear:

![image](/media/2014/05/image18.png)

Accept this and after that you can run all the automation you want.

Unfortunately, I haven’t found out how to automate that easily (or at all). I will test the “Import-Certificate” cmdlet soon and have a look if that can be leveraged for that.


