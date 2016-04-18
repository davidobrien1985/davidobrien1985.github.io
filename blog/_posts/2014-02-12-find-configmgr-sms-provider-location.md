---
id: 1626
title: How to find the ConfigMgr SMS Provider Location
date: 2014-02-12T12:46:09+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1626
permalink: /2014/02/find-configmgr-sms-provider-location/
categories:
  - ConfigMgr
  - Configuration Manager
  - PowerShell
  - SCCM
  - WMI
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - SMS Provider
  - System Center
  - WMI
---
In my role as a technical consultant I sometimes need to visit customer sites where there are already ConfigMgr environments in place and I need to quickly find my way around.

One cool way of getting a quick overview would be my <a href="http://www.david-obrien.net/?p=1592" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/?p=1592', 'Inventory Script for Configuration Manager']);" target="_blank">Inventory Script for Configuration Manager</a>.

I now had to quickly find all the SMS Providers that were installed in a site.

# ConfigMgr SMS Provider

What’s the SMS Provider you ask? Quoting <a href="http://technet.microsoft.com/en-us/library/gg712282.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://technet.microsoft.com/en-us/library/gg712282.aspx', 'http://technet.microsoft.com/en-us/library/gg712282.aspx']);" title="http://technet.microsoft.com/en-us/library/gg712282.aspx">http://technet.microsoft.com/en-us/library/gg712282.aspx</a>

> The SMS Provider is the interface between the Configuration Manager console and the site database. This role is installed when you install a central administration site or primary site. Secondary sites do not install the SMS Provider. You can install the SMS Provider on the site server, the site database server (unless the site database is hosted on a clustered instance of SQL Server), or on another computer. You can also move the SMS Provider to another computer after the site is installed, or install multiple SMS Providers on additional computers. To move or install additional SMS Providers for a site, run Configuration Manager Setup, select the option **Perform site maintenance or reset the Site**, click **Next** , and then on the **Site Maintenance** page, select the option **Modify SMS Provider configuration**.
> 
> ![note](http://i.technet.microsoft.com/areas/global/content/clear.gif "note")Note
> 
> The SMS Provider is only supported on computers that are in the same domain as the site server.

&nbsp;

# Site Properties in SCCM Admin Console

To find all the SMS Providers in your environment you can check via the Console by looking at the Administration Node –> Site Configuration –> Sites and open up the Site’s properties.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image3.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image3.png', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="SCCM Site Properties" alt="SCCM Site Properties" src="http://www.david-obrien.net/wp-content/uploads/2014/02/image_thumb3.png" width="224" height="126" border="0" /></a>

You see that I have two SMS Providers in my environment.

# Check SMS Provider Locations via WMI with Powershell

As an alternative you can just open up a Powershell on one SMS Provider you know (you always know at least one) and execute the following query:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> (Get-WmiObject -<span style="color: #0000ff;">class</span> SMS_ProviderLocation -Namespace root\SMS).Machine</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

This will give you something like this:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image4.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image4.png', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="SMS_ProviderLocation" alt="SMS_ProviderLocation" src="http://www.david-obrien.net/wp-content/uploads/2014/02/image_thumb4.png" width="244" height="34" border="0" /></a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Configuration+Manager,Powershell,SCCM,SMS+Provider,System+Center,WMI" data-count="vertical" data-url="http://www.david-obrien.net/2014/02/find-configmgr-sms-provider-location/">Tweet</a>
</div>
