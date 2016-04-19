---
id: 419
title: Unattended installation of Citrix Provisioning Services
date: 2012-08-06T15:45:14+00:00
author: "David O'Brien"
layout: post
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

Citrix PVS farms need to be installed, created, configured and maintained. No more <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/08/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" />

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
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1:</span> Monday, July 23, 2012 11:16:38</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3:</span> ConfigWizard version 6.1, © 2001-2012 Citrix Systems, Inc. All rights reserved.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5:</span> IP Address Assignement Service</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6:</span>  IPServiceType=n       <span style="color: #0000ff;">If</span> n <span style="color: #0000ff;">is</span> 0, uses Microsoft DHCP.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7:</span>                        <span style="color: #0000ff;">If</span> n <span style="color: #0000ff;">is</span> 2, uses Provisioning Services BOOTP service.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8:</span>                        <span style="color: #0000ff;">If</span> n <span style="color: #0000ff;">is</span> 3, uses Other BOOTP <span style="color: #0000ff;">or</span> DHCP service.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10:</span> PXE Service Type</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11:</span>  PXEServiceType=n      <span style="color: #0000ff;">If</span> this <span style="color: #0000ff;">not</span> found, uses another device.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:</span>                        <span style="color: #0000ff;">If</span> n <span style="color: #0000ff;">is</span> 0, uses Microsoft DHCP.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13:</span>                        <span style="color: #0000ff;">If</span> n <span style="color: #0000ff;">is</span> 1, uses Provisioning Services PXE.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15:</span> Farm Configuration</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16:</span>  FarmConfiguration=x        x <span style="color: #0000ff;">is</span> 0 <span style="color: #0000ff;">for</span> already configured, 1 <span style="color: #0000ff;">for</span> create farm, <span style="color: #0000ff;">or</span> 2 <span style="color: #0000ff;">for</span> join existing farm.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18:</span> Database Server</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19:</span>  DatabaseServer=x        x <span style="color: #0000ff;">is</span> the name of the server.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20:</span>  DatabaseInstance=x      x <span style="color: #0000ff;">is</span> the name of the instance.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21:</span>  FailoverDatabaseServer=x    x <span style="color: #0000ff;">is</span> the name of the failover server.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22:</span>  FailoverDatabaseInstance=x  x <span style="color: #0000ff;">is</span> the name of the failover instance.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24:</span> Existing Farm</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25:</span>  FarmExisting=x        x <span style="color: #0000ff;">is</span> the name of the Farm.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27:</span> Site</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28:</span>  Site=x        x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> site.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29:</span>  Collection=x  x <span style="color: #0000ff;">is</span> the <span style="color: #0000ff;">default</span> path of the <span style="color: #0000ff;">new</span> site.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;"> 30:</span>  ExistingSite=x  x <span style="color: #0000ff;">is</span> the name of the site selected.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"> 31:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;"> 32:</span> Store</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;"> 33:</span>  Store=x        x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> store.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;"> 34:</span>  DefaultPath=x  x <span style="color: #0000ff;">is</span> the <span style="color: #0000ff;">default</span> path of the <span style="color: #0000ff;">new</span> store.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;"> 35:</span>  ExistingStore=x  x <span style="color: #0000ff;">is</span> the name of the store selected.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"> 36:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;"> 37:</span> <span style="color: #0000ff;">New</span> Farm</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;"> 38:</span>  DatabaseNew=x       x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> database.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;"> 39:</span>  FarmNew=x           x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> farm.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;"> 40:</span>  SiteNew=x           x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> site.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;"> 41:</span>  CollectionNew=x     x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> collection.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"> 42:</span>  ADGroup=x           x <span style="color: #0000ff;">is</span> <span style="color: #0000ff;">is</span> the Active Directory group.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;"> 43:</span>  Group=x             x <span style="color: #0000ff;">is</span> <span style="color: #0000ff;">is</span> the Windows group.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;"> 44:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;"> 45:</span> <span style="color: #0000ff;">New</span> Store</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;"> 46:</span>  Store=x        x <span style="color: #0000ff;">is</span> the name of the <span style="color: #0000ff;">new</span> store.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;"> 47:</span>  DefaultPath=x  x <span style="color: #0000ff;">is</span> the <span style="color: #0000ff;">default</span> path of the <span style="color: #0000ff;">new</span> store.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;"> 48:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"> 49:</span> License Server Name</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;"> 50:</span>  LicenseServer=x        x <span style="color: #0000ff;">is</span> the name of the server.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;"> 51:</span>  LicenseServerPort=x    x <span style="color: #0000ff;">is</span> the port number.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;"> 52:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;"> 53:</span> Stream Service User Account</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"> 54:</span>  UserName=x  x <span style="color: #0000ff;">is</span> a user account name.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;"> 55:</span>  UserPass=x  x <span style="color: #0000ff;">is</span> the password (<span style="color: #0000ff;">not</span> encrypted) <span style="color: #0000ff;">for</span> the user account.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum56" style="color: #606060;"> 56:</span>  UserName2=x x <span style="color: #0000ff;">is</span> the password (encrypted) <span style="color: #0000ff;">for</span> the user account.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum57" style="color: #606060;"> 57:</span>              UserPass <span style="color: #0000ff;">or</span> UserName2 can be used <span style="color: #0000ff;">for</span> the password.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum58" style="color: #606060;"> 58:</span>  Network=1   Network <span style="color: #0000ff;">is</span> used <span style="color: #0000ff;">for</span> the <span style="color: #008000;">'Network service account' choice.</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum59" style="color: #606060;"> 59:</span>  Database=1  Configure the database the database <span style="color: #0000ff;">for</span> the account.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum60" style="color: #606060;"> 60:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum61" style="color: #606060;"> 61:</span> PasswordManagement</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum62" style="color: #606060;"> 62:</span>  PasswordManagementInterval=x        x <span style="color: #0000ff;">is</span> the day internal between password resets.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum63" style="color: #606060;"> 63:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum64" style="color: #606060;"> 64:</span> Stream Service Network Cards</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum65" style="color: #606060;"> 65:</span>  StreamNetworkAdapterIP=x  x <span style="color: #0000ff;">is</span> a comma delimited IP address list.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum66" style="color: #606060;"> 66:</span>                            Uses first card <span style="color: #0000ff;">if</span> <span style="color: #0000ff;">not</span> found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum67" style="color: #606060;"> 67:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum68" style="color: #606060;"> 68:</span> Management Services First <span style="color: #0000ff;">and</span> Last Port</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum69" style="color: #606060;"> 69:</span>  ManagementFirstPort=n n <span style="color: #0000ff;">is</span> first port number.  6905 <span style="color: #0000ff;">if</span> <span style="color: #0000ff;">not</span> found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum70" style="color: #606060;"> 70:</span>  ManagementLastPort=n  n <span style="color: #0000ff;">is</span> the last port number.  6909 <span style="color: #0000ff;">if</span> <span style="color: #0000ff;">not</span> found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum71" style="color: #606060;"> 71:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum72" style="color: #606060;"> 72:</span> TFTP <span style="color: #0000ff;">and</span> Bootstrap File</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum73" style="color: #606060;"> 73:</span>  BootstrapFile=x        x <span style="color: #0000ff;">is</span> file.  TFTP <span style="color: #0000ff;">and</span> Bootstrap <span style="color: #0000ff;">not</span> used, <span style="color: #0000ff;">if</span> <span style="color: #0000ff;">not</span> found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum74" style="color: #606060;"> 74:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum75" style="color: #606060;"> 75:</span> Boot Servers</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum76" style="color: #606060;"> 76:</span>  LS#=ip,subnet,gateway,port  # <span style="color: #0000ff;">is</span> the number of the server, 1 <span style="color: #0000ff;">is</span> the first.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum77" style="color: #606060;"> 77:</span>                              <span style="color: #0000ff;">If</span> <span style="color: #0000ff;">not</span> found, uses the first <span style="color: #0000ff;">in</span> the database <span style="color: #0000ff;">or</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum78" style="color: #606060;"> 78:</span>                              <span style="color: #0000ff;">if</span> none <span style="color: #0000ff;">in</span> the database, the first card found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum79" style="color: #606060;"> 79:</span>                              <span style="color: #0000ff;">if</span> none <span style="color: #0000ff;">in</span> the database, the first card found.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum80" style="color: #606060;"> 80:</span>  AdvancedVerbose=x           x <span style="color: #0000ff;">is</span> 1 <span style="color: #0000ff;">when</span> verbose mode <span style="color: #0000ff;">is</span> turned <span style="color: #0000ff;">on</span>.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum81" style="color: #606060;"> 81:</span>  AdvancedInterrultSafeMode=x x <span style="color: #0000ff;">is</span> 1 <span style="color: #0000ff;">when</span> interrupt safe mode <span style="color: #0000ff;">is</span> turned <span style="color: #0000ff;">on</span>.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum82" style="color: #606060;"> 82:</span>  AdvancedMemorySupport=x     x <span style="color: #0000ff;">is</span> 1 <span style="color: #0000ff;">when</span> advanced memory support <span style="color: #0000ff;">is</span> turned <span style="color: #0000ff;">on</span>.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum83" style="color: #606060;"> 83:</span>  AdvancedRebootFromHD=x      x <span style="color: #0000ff;">is</span> 1 <span style="color: #0000ff;">when</span> reboot from hard drive <span style="color: #0000ff;">on</span> fail.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum84" style="color: #606060;"> 84:</span>  AdvancedRecoverSeconds=x    x <span style="color: #0000ff;">is</span> the number of seconds <span style="color: #0000ff;">to</span> reboot <span style="color: #0000ff;">to</span> hard drive after fail.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum85" style="color: #606060;"> 85:</span>  AdvancedLoginPolling=x      x <span style="color: #0000ff;">is</span> the number of milliseconds <span style="color: #0000ff;">for</span> login polling timeout.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum86" style="color: #606060;"> 86:</span>  AdvancedLoginGeneral=x      x <span style="color: #0000ff;">is</span> the number of milliseconds <span style="color: #0000ff;">for</span> login general timeout.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum87" style="color: #606060;"> 87:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum88" style="color: #606060;"> 88:</span> Start Services</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum89" style="color: #606060;"> 89:</span>  NoStartServices=1     <span style="color: #0000ff;">Do</span> <span style="color: #0000ff;">not</span> start services <span style="color: #0000ff;">if</span> exists.</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

If you like you can also run the configwizard with the “/s” switch. The wizard opens and lets you configure all you want and at the end creates the configwizard.ans (also under “C:ProgramDataCitrixProvisioning Services”) file which then can be used to repeat what you have just configured on other servers.

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1:</span> FarmConfiguration=1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2:</span> DatabaseServer=SQL01</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3:</span> DatabaseInstance=</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4:</span> DatabaseNew=DB_TEST</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5:</span> FarmNew=TEST_FARM</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6:</span> SiteNew=TEST_SITE</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7:</span> CollectionNew=COLL_TEST</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8:</span> ADGroup=<span style="color: #0000ff;">do</span>.local/Groups/AdminGroups/ADM_PVS</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9:</span> Store=STORE_TEST</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10:</span> DefaultPath=c:temp</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11:</span> LicenseServer=srv1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:</span> LicenseServerPort=27000</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13:</span> UserName=<span style="color: #0000ff;">do</span>adobrien</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14:</span> UserName2=ppnfpjhhokjqqipoilofbgddnelsqibsprclcnbegeknkhnmckod</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15:</span> Database=1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16:</span> PasswordManagementInterval=7</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17:</span> StreamNetworkAdapterIP=172.16.0.30</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18:</span> IpcPortBase=6890</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19:</span> IpcPortCount=20</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20:</span> SoapPort=54321</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21:</span> BootstrapFile=C:ProgramDataCitrixProvisioning ServicesTftpbootARDBP32.BIN</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22:</span> LS1=172.16.0.30,0.0.0.0,0.0.0.0,6910</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23:</span> AdvancedVerbose=0</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24:</span> AdvancedInterrultSafeMode=0</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25:</span> AdvancedMemorySupport=1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26:</span> AdvancedRebootFromHD=0</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27:</span> AdvancedRecoverSeconds=50</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28:</span> AdvancedLoginPolling=5000</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29:</span> AdvancedLoginGeneral=30000</pre>
    
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

I don’t know why my machine would do that and it doesn’t matter anymore, that was the Windows 7 time, now is Windows 8 time and all is fine!!! ![Winking smile](http://www.david-obrien.de/wp-content/uploads/2012/08/wlEmoticon-winkingsmile1.png)

# Powershell to set encoding

I’m doing the whole installation and configuration of Citrix Provisioning Services in one Powershell script and that’s also the place where I now build the “configwizard.ans” file in.
  
It looks like this:

<div>
  <pre> 1: $installstring ="FarmConfiguration=1</pre>
  
  <pre> 2: DatabaseServer=$DBServer</pre>
  
  <pre> 3: DatabaseInstance=$DBInstance</pre>
  
  <pre> 4: DatabaseNew=$DBName</pre>
  
  <pre> 5: FarmNew=$FarmName</pre>
  
  <pre> 6: SiteNew=$SiteName</pre>
  
  <pre> 7: CollectionNew=$CollectionName</pre>
  
  <pre> 8: ADGroup=$AdminGroup</pre>
  
  <pre> 9: Store=$StoreName</pre>
  
  <pre> 10: DefaultPath=$StorePath</pre>
  
  <pre> 11: LicenseServer=$LicSrv</pre>
  
  <pre> 12: LicenseServerPort=27000</pre>
  
  <pre> 13: UserName=rzixtecabitpvsdbuser</pre>
  
  <pre> 14: UserPass=TQlYjCDnuvqJu1FthjdU</pre>
  
  <pre> 15: Database=1</pre>
  
  <pre> 16: PasswordManagementInterval=7</pre>
  
  <pre> 17: StreamNetworkAdapterIP=$IP</pre>
  
  <pre> 18: IpcPortBase=6890</pre>
  
  <pre> 19: IpcPortCount=20</pre>
  
  <pre> 20: SoapPort=54321</pre>
  
  <pre> 21: BootstrapFile=C:ProgramDataCitrixProvisioning ServicesTftpbootARDBP32.BIN</pre>
  
  <pre> 22: LS1=$IP,0.0.0.0,0.0.0.0,6910</pre>
  
  <pre> 23: AdvancedVerbose=0</pre>
  
  <pre> 24: AdvancedInterrultSafeMode=0</pre>
  
  <pre> 25: AdvancedMemorySupport=1</pre>
  
  <pre> 26: AdvancedRebootFromHD=0</pre>
  
  <pre> 27: AdvancedRecoverSeconds=50</pre>
  
  <pre> 28: AdvancedLoginPolling=5000</pre>
  
  <pre> 29: AdvancedLoginGeneral=30000</pre>
  
  <pre> 30: NoStartServices=1</pre>
  
  <pre> 31: "}</pre>
  
  <pre> 32:</pre>
  
  <pre> 33: if (-not (Test-Path $(join-path $installpathServer configwizard.ans)))</pre>
  
  <pre> 34:     {</pre>
  
  <pre> 35:     New-Item -Path $(join-path $installpathServer configwizard.ans) -ItemType File</pre>
  
  <pre> 36:     }</pre>
  
  <pre> 37: Set-Content -Path $(join-path $installpathServer configwizard.ans) -Value $installstring -Encoding Unicode</pre>
</div>

&nbsp;

Line 37 is the one where I set the right Encoding and that’s how it works! Despite what Citrix says in their edocs, this way you’re even able to join the first server to a farm.

<del><strong>What are your experiences? Did you get it to work?</strong></del>

&nbsp;

# Sum up

I thought nowadays to automate a software would be easier. When searching the internet you don’t find a lot of people who install PVS unattended (or they don’t speak about it) and if you find something it’s nearly always about some problems they have.

Take a look at Simon Pettit’s blog article about automating PVS with RES Automation Manager if you don’t want to use Powershell ![Winking smile](http://www.david-obrien.de/wp-content/uploads/2012/08/wlEmoticon-winkingsmile1.png) [http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/](http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

