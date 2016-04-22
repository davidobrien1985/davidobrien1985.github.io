---
id: 930
title: Configuration Manager 2012 powershell environment variables
date: 2013-05-21T15:13:08+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=930
permalink: /2013/05/configuration-manager-2012-powershell-environment-variables/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - System Center
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - scripting
  - variables
---
# SMS\_ADMIN\_UI\_PATH and SMS\_LOG_PATH

This is a quick one, because I just stumbled upon these two Powershell environment variables on a Site System Server (with installed Admin console)

The following variable will resolve to the local path where the ConfigMgr 2012 Admin Console is installed to:

![SMS_ADMIN_UI_PATH](/media/2013/05/image.png)

This variable will resolve to the local path where the ConfigMgr 2012 logfiles are stored to:

![SMS_LOG_PATH](/media/2013/05/image1.png)

## Variables for automation in ConfigMgr 2012

These variables are great for automation purposes, as we don’t have to go into registry anymore to look for the Admin console path and then import the Powershell module or register com-objects, we just use this variable.

I will definitely rewrite my scripts to use these variables.
