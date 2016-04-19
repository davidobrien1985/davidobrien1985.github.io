---
id: 930
title: Configuration Manager 2012 powershell environment variables
date: 2013-05-21T15:13:08+00:00
author: "David O'Brien"
layout: post
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
# 

# SMS\_ADMIN\_UI\_PATH and SMS\_LOG_PATH

This is a quick one, because I just stumbled upon these two Powershell environment variables on a Site System Server (with installed Admin console)

The following variable will resolve to the local path where the ConfigMgr 2012 Admin Console is installed to:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/05/image.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/05/image.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="SMS_ADMIN_UI_PATH" src="http://www.david-obrien.net/wp-content/uploads/2013/05/image_thumb.png" width="331" height="18" border="0" /></a>

This variable will resolve to the local path where the ConfigMgr 2012 logfiles are stored to:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/05/image1.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/05/image1.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="SMS_LOG_PATH" src="http://www.david-obrien.net/wp-content/uploads/2013/05/image_thumb1.png" width="326" height="23" border="0" /></a>

## Variables for automation in ConfigMgr 2012

These variables are great for automation purposes, as we don’t have to go into registry anymore to look for the Admin console path and then import the Powershell module or register com-objects, we just use this variable.

I will definitely rewrite my scripts to use these variables. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Configuration+Manager,Powershell,SCCM,scripting,variables" data-count="vertical" data-url="http://www.david-obrien.net/2013/05/configuration-manager-2012-powershell-environment-variables/">Tweet</a>
</div>
