---
id: 419
title: Unattended installation of Citrix Provisioning Services
date: 2012-08-06T15:45:14+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=419
permalink: /2012/08/unattended-installation-of-citrix-provisioning-services/
categories:
  - automation
  - Citrix
  - Provisioning Services
  - PVS
tags:
  - automation
  - Citrix
  - Provisioning Services
  - PVS
---
As I always say/write **‘automation is key’.** It’s important to me and also to a lot of customers/companies.

That’s why I had and still have the task to automate Citrix’s Provisioning Services.

# What’s been asked for?

Citrix PVS farms need to be installed, created, configured and maintained. No more <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/media/2012/08/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" />

Doesn’t sound that much to ask for, bearing in mind that it’s 2012 and almost all products nowadays can easily be automated.

# Provisioning Services sounds promising

When looking at an already installed server and the Citrix eDocs, you find loads of information about how to automate stuff.
  
You can for example use the MCLI or Powershell equivalent. But these aren’t available before installation. So they won’t help you with installing the servers.

# 

# configwizard.exe

Then there’s the configwizard.exe which is used to create or configure a PVS farm or a single server. The configwizard.exe gives you the power to even configure the services PVS installs on the server.

When running “configwizard.exe /c” a configwizard.out file is created under “C:ProgramDataCitrixProvisioning Services”.
  
That .out file contains all valid parameters with description to silently run the configwizard.exe.

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1: Monday, July 23, 2012 11:16:38
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3: ConfigWizard version 6.1, © 2001-2012 Citrix Systems, Inc. All rights reserved.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5: IP Address Assignement Service
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6:  IPServiceType=n       If n is 0, uses Microsoft DHCP.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7:                        If n is 2, uses Provisioning Services BOOTP service.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8:                        If n is 3, uses Other BOOTP or DHCP service.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10: PXE Service Type
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11:  PXEServiceType=n      If this not found, uses another device.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:                        If n is 0, uses Microsoft DHCP.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13:                        If n is 1, uses Provisioning Services PXE.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15: Farm Configuration
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16:  FarmConfiguration=x        x is 0 for already configured, 1 for create farm, or 2 for join existing farm.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18: Database Server
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19:  DatabaseServer=x        x is the name of the server.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20:  DatabaseInstance=x      x is the name of the instance.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21:  FailoverDatabaseServer=x    x is the name of the failover server.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22:  FailoverDatabaseInstance=x  x is the name of the failover instance.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24: Existing Farm
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25:  FarmExisting=x        x is the name of the Farm.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27: Site
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28:  Site=x        x is the name of the new site.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29:  Collection=x  x is the default path of the new site.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;"> 30:  ExistingSite=x  x is the name of the site selected.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"> 31:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;"> 32: Store
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;"> 33:  Store=x        x is the name of the new store.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;"> 34:  DefaultPath=x  x is the default path of the new store.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;"> 35:  ExistingStore=x  x is the name of the store selected.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"> 36:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;"> 37: New Farm
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;"> 38:  DatabaseNew=x       x is the name of the new database.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;"> 39:  FarmNew=x           x is the name of the new farm.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;"> 40:  SiteNew=x           x is the name of the new site.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;"> 41:  CollectionNew=x     x is the name of the new collection.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"> 42:  ADGroup=x           x is is the Active Directory group.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;"> 43:  Group=x             x is is the Windows group.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;"> 44:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;"> 45: New Store
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;"> 46:  Store=x        x is the name of the new store.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;"> 47:  DefaultPath=x  x is the default path of the new store.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;"> 48:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"> 49: License Server Name
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;"> 50:  LicenseServer=x        x is the name of the server.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;"> 51:  LicenseServerPort=x    x is the port number.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;"> 52:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;"> 53: Stream Service User Account
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"> 54:  UserName=x  x is a user account name.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;"> 55:  UserPass=x  x is the password (not encrypted) for the user account.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum56" style="color: #606060;"> 56:  UserName2=x x is the password (encrypted) for the user account.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum57" style="color: #606060;"> 57:              UserPass or UserName2 can be used for the password.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum58" style="color: #606060;"> 58:  Network=1   Network is used for the <span style="color: #008000;">'Network service account' choice.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum59" style="color: #606060;"> 59:  Database=1  Configure the database the database for the account.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum60" style="color: #606060;"> 60:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum61" style="color: #606060;"> 61: PasswordManagement
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum62" style="color: #606060;"> 62:  PasswordManagementInterval=x        x is the day internal between password resets.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum63" style="color: #606060;"> 63:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum64" style="color: #606060;"> 64: Stream Service Network Cards
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum65" style="color: #606060;"> 65:  StreamNetworkAdapterIP=x  x is a comma delimited IP address list.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum66" style="color: #606060;"> 66:                            Uses first card if not found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum67" style="color: #606060;"> 67:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum68" style="color: #606060;"> 68: Management Services First and Last Port
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum69" style="color: #606060;"> 69:  ManagementFirstPort=n n is first port number.  6905 if not found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum70" style="color: #606060;"> 70:  ManagementLastPort=n  n is the last port number.  6909 if not found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum71" style="color: #606060;"> 71:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum72" style="color: #606060;"> 72: TFTP and Bootstrap File
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum73" style="color: #606060;"> 73:  BootstrapFile=x        x is file.  TFTP and Bootstrap not used, if not found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum74" style="color: #606060;"> 74:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum75" style="color: #606060;"> 75: Boot Servers
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum76" style="color: #606060;"> 76:  LS#=ip,subnet,gateway,port  # is the number of the server, 1 is the first.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum77" style="color: #606060;"> 77:                              If not found, uses the first in the database or
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum78" style="color: #606060;"> 78:                              if none in the database, the first card found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum79" style="color: #606060;"> 79:                              if none in the database, the first card found.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum80" style="color: #606060;"> 80:  AdvancedVerbose=x           x is 1 when verbose mode is turned on.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum81" style="color: #606060;"> 81:  AdvancedInterrultSafeMode=x x is 1 when interrupt safe mode is turned on.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum82" style="color: #606060;"> 82:  AdvancedMemorySupport=x     x is 1 when advanced memory support is turned on.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum83" style="color: #606060;"> 83:  AdvancedRebootFromHD=x      x is 1 when reboot from hard drive on fail.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum84" style="color: #606060;"> 84:  AdvancedRecoverSeconds=x    x is the number of seconds to reboot to hard drive after fail.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum85" style="color: #606060;"> 85:  AdvancedLoginPolling=x      x is the number of milliseconds for login polling timeout.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum86" style="color: #606060;"> 86:  AdvancedLoginGeneral=x      x is the number of milliseconds for login general timeout.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum87" style="color: #606060;"> 87:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum88" style="color: #606060;"> 88: Start Services
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum89" style="color: #606060;"> 89:  NoStartServices=1     Do not start services if exists.
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

If you like you can also run the configwizard with the “/s” switch. The wizard opens and lets you configure all you want and at the end creates the configwizard.ans (also under “C:ProgramDataCitrixProvisioning Services”) file which then can be used to repeat what you have just configured on other servers.

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1: FarmConfiguration=1
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2: DatabaseServer=SQL01
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3: DatabaseInstance=
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4: DatabaseNew=DB_TEST
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5: FarmNew=TEST_FARM
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6: SiteNew=TEST_SITE
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7: CollectionNew=COLL_TEST
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8: ADGroup=do.local/Groups/AdminGroups/ADM_PVS
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9: Store=STORE_TEST
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10: DefaultPath=c:temp
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11: LicenseServer=srv1
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12: LicenseServerPort=27000
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13: UserName=doadobrien
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14: UserName2=ppnfpjhhokjqqipoilofbgddnelsqibsprclcnbegeknkhnmckod
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15: Database=1
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16: PasswordManagementInterval=7
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17: StreamNetworkAdapterIP=172.16.0.30
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18: IpcPortBase=6890
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19: IpcPortCount=20
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20: SoapPort=54321
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21: BootstrapFile=C:ProgramDataCitrixProvisioning ServicesTftpbootARDBP32.BIN
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22: LS1=172.16.0.30,0.0.0.0,0.0.0.0,6910
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23: AdvancedVerbose=0
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24: AdvancedInterrultSafeMode=0
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25: AdvancedMemorySupport=1
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26: AdvancedRebootFromHD=0
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27: AdvancedRecoverSeconds=50
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28: AdvancedLoginPolling=5000
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29: AdvancedLoginGeneral=30000
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Looking at this configwizard.ans file and the above parameters you can see that a new farm should be created, telling the wizard which database server, instance and database to use, what the name of the admingroup is, under which account the streaming service shall run and much more.

Well, the problem is:
  
If you do all this via the configwizard, then everything is fine. The database gets created and the server joins the new farm.
  
If you install the server and then run “configwizard.exe /a:%PathToANSfile%” nothing happens. No database created and nothing configured.

# 

# 

# 

# 

# 

# 

# 

# 

# Database creation

After a bit of searching you will come across the DBScript.exe. This exe empowers you to create a sql script which will create a database, create all necessary tables and also create the farm in this database.
  
This script actually does what it’s supposed to do, but again when running “configwizard.exe /a:%PathToANSfile%” the server won’t join the farm.

The logfile “C:ProgramDataCitrixProvisioning Servicesconfigwizard.out” claims that the “DefaultPath” parameter is missing, although I clearly provided one.The same goes for “C:ProgramDataCitrixProvisioning ServicesLogsConfigWizard.log”.

It’s weird that the same thing done manually via the configwizard.exe works, but if I use the configwizard.ans file for the first server, then it doesn’t.

Apparently this is what Citrix says:

[http://support.citrix.com/proddocs/topic/provisioning-61/pvs-install-silent-conf-wiz.html](http://support.citrix.com/proddocs/topic/provisioning-61/pvs-install-silent-conf-wiz.html)

###### Prerequisite

The Configuration Wizard must first be run on any Provisioning Server in the farm that has the configuration settings that will be used in order to create the Provisioning Services database and to configure the farm.

If I understand that correctly, then the first server in a new PVS farm has to be configured manually, which is quite a bummer…

# [UPDATE] It works!

I promised an update as soon as I’d know anything more, and here it is. It works and it’s a bit strange.
  
I tend to write scripts or edit them in Notepad ++ or just Notepad and it seems as if that caused the problem. Looking at an original unedited “configwizard.ans” you will notice that it’s in Unicode, which is fine. It’s also what I saw when looking at it in Notepad ++, but not what my notebook did to it. After editing it, it saved it as ANSI, but continued to show Unicode. Looking at it from a different notebook one could see it was in ANSI.

I don’t know why my machine would do that and it doesn’t matter anymore, that was the Windows 7 time, now is Windows 8 time and all is fine!!! ![Winking smile](/media/2012/08/wlEmoticon-winkingsmile1.png)

# Powershell to set encoding

I’m doing the whole installation and configuration of Citrix Provisioning Services in one Powershell script and that’s also the place where I now build the “configwizard.ans” file in.
  
It looks like this:

<div>
  <pre> 1: $installstring ="FarmConfiguration=1
  
  <pre> 2: DatabaseServer=$DBServer
  
  <pre> 3: DatabaseInstance=$DBInstance
  
  <pre> 4: DatabaseNew=$DBName
  
  <pre> 5: FarmNew=$FarmName
  
  <pre> 6: SiteNew=$SiteName
  
  <pre> 7: CollectionNew=$CollectionName
  
  <pre> 8: ADGroup=$AdminGroup
  
  <pre> 9: Store=$StoreName
  
  <pre> 10: DefaultPath=$StorePath
  
  <pre> 11: LicenseServer=$LicSrv
  
  <pre> 12: LicenseServerPort=27000
  
  <pre> 13: UserName=rzixtecabitpvsdbuser
  
  <pre> 14: UserPass=TQlYjCDnuvqJu1FthjdU
  
  <pre> 15: Database=1
  
  <pre> 16: PasswordManagementInterval=7
  
  <pre> 17: StreamNetworkAdapterIP=$IP
  
  <pre> 18: IpcPortBase=6890
  
  <pre> 19: IpcPortCount=20
  
  <pre> 20: SoapPort=54321
  
  <pre> 21: BootstrapFile=C:ProgramDataCitrixProvisioning ServicesTftpbootARDBP32.BIN
  
  <pre> 22: LS1=$IP,0.0.0.0,0.0.0.0,6910
  
  <pre> 23: AdvancedVerbose=0
  
  <pre> 24: AdvancedInterrultSafeMode=0
  
  <pre> 25: AdvancedMemorySupport=1
  
  <pre> 26: AdvancedRebootFromHD=0
  
  <pre> 27: AdvancedRecoverSeconds=50
  
  <pre> 28: AdvancedLoginPolling=5000
  
  <pre> 29: AdvancedLoginGeneral=30000
  
  <pre> 30: NoStartServices=1
  
  <pre> 31: "}
  
  <pre> 32:
  
  <pre> 33: if (-not (Test-Path $(join-path $installpathServer configwizard.ans)))
  
  <pre> 34:     {
  
  <pre> 35:     New-Item -Path $(join-path $installpathServer configwizard.ans) -ItemType File
  
  <pre> 36:     }
  
  <pre> 37: Set-Content -Path $(join-path $installpathServer configwizard.ans) -Value $installstring -Encoding Unicode
</div>

&nbsp;

Line 37 is the one where I set the right Encoding and that’s how it works! Despite what Citrix says in their edocs, this way you’re even able to join the first server to a farm.

<del><strong>What are your experiences? Did you get it to work?</strong></del>

&nbsp;

# Sum up

I thought nowadays to automate a software would be easier. When searching the internet you don’t find a lot of people who install PVS unattended (or they don’t speak about it) and if you find something it’s nearly always about some problems they have.

Take a look at Simon Pettit’s blog article about automating PVS with RES Automation Manager if you don’t want to use Powershell ![Winking smile](/media/2012/08/wlEmoticon-winkingsmile1.png) [http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/](http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

