---
id: 359
title: Install Distribution Point for Configuration Manager 2012
date: 2012-06-08T23:35:45+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=359
permalink: /2012/06/install-distribution-point-for-configuration-manager-2012/
categories:
  - Applications
  - Cloud
  - Common
  - Community
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
  - WMI
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Install Distribution Point
  - Installation
  - Powershell
  - SCCM 2012
  - SCCM2012
  - Script
  - silent
  - System Center
  - unattended
---
# or: documentation would have been nice!

&nbsp;

I like automating as much as possible, as you might have already learned from my other articles. My next plan was to script the installation of a site system role in Microsoft System Center Configuration Manager 2012, to be more precise, I wanted to deploy a Distribution Point. With no access to the GUI, totally scripted, with Powershell!

And here comes the problem kicking you somewhere bad  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/06/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" />There’s no documentation on how to do this. The only thing around is the ConfigMgr 2012 SDK PreRelease, and even there not everything is covered.

# automation with Powershell

Today I’m going to show you my script as far as I have come up until now.

## What will the script do?

  * create a Site System 
      * configure whether it’s protected or not
  * create a Distribution Point on that Site System 
      * configure this Distribution Point with properties that I’ve found in the Site Control file (which is now inside of the Site Database)
      * and fill these properties with values, that I’ve also found in the Site Control file and also guessed a lot

## What are the script’s prereqs?

  * installed Windows Deployment Server (WDS)
  * installed IIS 
      * although there is this property “InstallInternetServer”, this didn’t seem to work 
          * maybe wrong values?

## Which problems am I facing?

A Distribution Point usually has a certificate on it, whether it’s self-signed or previously created and imported doesn’t matter. This is the problem! My script is unable to create a certificate.
  
I can’t find anything on how to create/import a certificate and bind it to a Distribution Point. **<span style="font-size: medium;">[For Update see below!]</span>**

<span style="text-decoration: line-through;">There has been a COM Object in ConfigMgr 2007, but this seems to have vanished. There was also a WMI method which is also gone.<br /> SMSProv.log tells me nothing, I used ProcMon and API monitors and I’m as wise as before… <img class="img-responsive wlEmoticon wlEmoticon-sadsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/06/wlEmoticon-sadsmile.png" alt="Trauriges Smiley" /> What I did find out is, that it uses the local server’s crypto API.</span>

<span style="text-decoration: line-through;">Might be I’m just overlooking something, but this is driving me nuts.</span>

## <span style="text-decoration: line-through;">Assumptions</span>

<span style="text-decoration: line-through;">After creating a Distribution Point with my script I can see it in the ConfigMgr console and inside the database’s Site Control file (without the certificate properties!)</span>

<a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image.png', '']);" class="broken_link"><span style="text-decoration: line-through;"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb.png" alt="image" width="370" height="229" border="0" /></span></a>

<span style="text-decoration: line-through;">As soon as I open up it’s properties inside the console the “Apply” (german: “Übernehmen”) button is active, without me doing anything!</span>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image1.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image1.png', '']);" class="broken_link"><span style="text-decoration: line-through;"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border-width: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb1.png" alt="image" width="331" height="316" border="0" /></span></a>
</p>

<span style="text-decoration: line-through;">When I press the button, only that, nothing else, the window closes and ConfigMgr creates a self-signed certificate and assigns it to the Distribution Point, which can then be seen in the Site Control File.</span>

<span style="text-decoration: line-through;">I’d like the community to have a look at my script and tell me what’s wrong <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://www.david-obrien.de/wp-content/uploads/2012/06/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" /></span>

<span style="text-decoration: line-through;">Now, here it comes: (old, not functioning script…)</span>

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum1" style="color: #606060;"> 1:</span> ########</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum2" style="color: #606060;"> 2:</span> # This script installs a Microsoft System Center Configuration Manager 2012 Distribution Point Server Role</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum3" style="color: #606060;"> 3:</span> # Author: David O<span style="color: #008000;">'Brien, sepago GmbH</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum4" style="color: #606060;"> 4:</span> # <span style="color: #0000ff;">date</span>: 01.06.2012</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum5" style="color: #606060;"> 5:</span> ########</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"><span style="text-decoration: line-through;"> 6:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum7" style="color: #606060;"> 7:</span> <span style="color: #0000ff;">Function</span> <span style="color: #0000ff;">global</span>:<span style="color: #0000ff;">Set</span>-<span style="color: #0000ff;">Property</span>(</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum8" style="color: #606060;"> 8:</span> $PropertyName,</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum9" style="color: #606060;"> 9:</span> $Value,</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum10" style="color: #606060;"> 10:</span> $Value1,</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum11" style="color: #606060;"> 11:</span> $Value2,</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum12" style="color: #606060;"> 12:</span> $roleproperties)</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum13" style="color: #606060;"> 13:</span> {</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum14" style="color: #606060;"> 14:</span> $embeddedproperty_class = [wmiclass]<span style="color: #006080;">""</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum15" style="color: #606060;"> 15:</span> $embeddedproperty_class.psbase.Path = <span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_EmbeddedProperty"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum16" style="color: #606060;"> 16:</span> $embeddedproperty = $embeddedproperty_class.createInstance()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"><span style="text-decoration: line-through;"> 17:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum18" style="color: #606060;"> 18:</span> $embeddedproperty.PropertyName = $PropertyName</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum19" style="color: #606060;"> 19:</span> $embeddedproperty.Value = $Value</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum20" style="color: #606060;"> 20:</span> $embeddedproperty.Value1 = $Value1</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum21" style="color: #606060;"> 21:</span> $embeddedproperty.Value2 = $Value2</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum22" style="color: #606060;"> 22:</span> $<span style="color: #0000ff;">global</span>:roleproperties += [System.Management.ManagementBaseObject]$embeddedproperty</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum23" style="color: #606060;"> 23:</span> }</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"><span style="text-decoration: line-through;"> 24:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"><span style="text-decoration: line-through;"> 25:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum26" style="color: #606060;"> 26:</span> <span style="color: #0000ff;">Function</span> <span style="color: #0000ff;">global</span>:<span style="color: #0000ff;">new</span>-DistributionPoint {</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"><span style="text-decoration: line-through;"> 27:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum28" style="color: #606060;"> 28:</span> ############### Create Site System ################################################</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum29" style="color: #606060;"> 29:</span> $<span style="color: #0000ff;">global</span>:roleproperties = @()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum30" style="color: #606060;"> 30:</span> $<span style="color: #0000ff;">global</span>:properties =@()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"><span style="text-decoration: line-through;"> 31:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum32" style="color: #606060;"> 32:</span> # connect <span style="color: #0000ff;">to</span> SMS Provider <span style="color: #0000ff;">for</span> Site</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum33" style="color: #606060;"> 33:</span> $role_class = [wmiclass]<span style="color: #006080;">""</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum34" style="color: #606060;"> 34:</span> $role_class.psbase.Path =<span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_SCI_SysResUse"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum35" style="color: #606060;"> 35:</span> $script:role = $role_class.createInstance()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"><span style="text-decoration: line-through;"> 36:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum37" style="color: #606060;"> 37:</span> #create the SMS Site Server</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum38" style="color: #606060;"> 38:</span> $role.NALPath = <span style="color: #006080;">"[`"</span>Display=\$server`<span style="color: #006080;">"]MSWNET:[`"</span>SMS_SITE=$sitename`<span style="color: #006080;">"]\$server"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum39" style="color: #606060;"> 39:</span> $role.NALType = <span style="color: #006080;">"Windows NT Server"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum40" style="color: #606060;"> 40:</span> $role.RoleName = <span style="color: #006080;">"SMS SITE SYSTEM"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum41" style="color: #606060;"> 41:</span> $role.SiteCode = <span style="color: #006080;">"S01"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"><span style="text-decoration: line-through;"> 42:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum43" style="color: #606060;"> 43:</span> #####</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum44" style="color: #606060;"> 44:</span> #filling <span style="color: #0000ff;">in</span> properties</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum45" style="color: #606060;"> 45:</span> $IsProtected = @(<span style="color: #006080;">"IsProtected"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # 0 <span style="color: #0000ff;">to</span> disable fallback <span style="color: #0000ff;">to</span> this site system, 1 <span style="color: #0000ff;">to</span> enable</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum46" style="color: #606060;"> 46:</span> <span style="color: #0000ff;">set</span>-<span style="color: #0000ff;">property</span> $IsProtected[0] $IsProtected[1] $IsProtected[2] $IsProtected[3]</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum47" style="color: #606060;"> 47:</span> $role.Props = $roleproperties</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum48" style="color: #606060;"> 48:</span> $role.Put()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"><span style="text-decoration: line-through;"> 49:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum50" style="color: #606060;"> 50:</span> ################ Deploy <span style="color: #0000ff;">New</span> Distribution Point #####################################</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum51" style="color: #606060;"> 51:</span> $role = <span style="color: #006080;">""</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum52" style="color: #606060;"> 52:</span> $<span style="color: #0000ff;">global</span>:properties = @()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum53" style="color: #606060;"> 53:</span> $<span style="color: #0000ff;">global</span>:roleproperties = @()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"><span style="text-decoration: line-through;"> 54:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum55" style="color: #606060;"> 55:</span> # connect <span style="color: #0000ff;">to</span> SMS Provider <span style="color: #0000ff;">for</span> Site</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum56" style="color: #606060;"> 56:</span> $role_class = [wmiclass]<span style="color: #006080;">""</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum57" style="color: #606060;"> 57:</span> $role_class.psbase.Path = <span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_SCI_SysResUse"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum58" style="color: #606060;"> 58:</span> $role = $role_class.createInstance()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum59" style="color: #606060;"><span style="text-decoration: line-through;"> 59:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum60" style="color: #606060;"> 60:</span> #create the SMS Distribution Point Role</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum61" style="color: #606060;"> 61:</span> $role.NALPath = <span style="color: #006080;">"[`"</span>Display=\$server`<span style="color: #006080;">"]MSWNET:[`"</span>SMS_SITE=$sitename`<span style="color: #006080;">"]\$server"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum62" style="color: #606060;"> 62:</span> $role.NALType = <span style="color: #006080;">"Windows NT Server"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum63" style="color: #606060;"> 63:</span> $role.RoleName = <span style="color: #006080;">"SMS DISTRIBUTION POINT"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum64" style="color: #606060;"> 64:</span> $role.SiteCode = <span style="color: #006080;">"S01"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum65" style="color: #606060;"><span style="text-decoration: line-through;"> 65:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum66" style="color: #606060;"><span style="text-decoration: line-through;"> 66:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum67" style="color: #606060;"> 67:</span> # filling <span style="color: #0000ff;">in</span> the properties</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum68" style="color: #606060;"><span style="text-decoration: line-through;"> 68:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum69" style="color: #606060;"> 69:</span> $ServerRemoteName = ,@(<span style="color: #006080;">"Server Remote Name"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">"$server"</span>) #FQDN of server</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum70" style="color: #606060;"> 70:</span> $BITS = ,@(<span style="color: #006080;">"BITS download"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # <span style="color: #0000ff;">is</span> BITS going <span style="color: #0000ff;">to</span> be enabled</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum71" style="color: #606060;"> 71:</span> $SslState = ,@(<span style="color: #006080;">"SslState"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # HTTP (0) <span style="color: #0000ff;">or</span> HTTPS (63) connections?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum72" style="color: #606060;"> 72:</span> $IsMulticast = ,@(<span style="color: #006080;">"IsMulticast"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # <span style="color: #0000ff;">is</span> Multicast enabled? <span style="color: #0000ff;">if</span> 1, <span style="color: #0000ff;">then</span> also the SMS Multicast Role has <span style="color: #0000ff;">to</span> be configured</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum73" style="color: #606060;"> 73:</span> $UseMachineAccount = ,@(<span style="color: #006080;">"UseMachineAccount"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # <span style="color: #0000ff;">in</span> <span style="color: #0000ff;">case</span> of multicast, use machine account <span style="color: #0000ff;">to</span> connect <span style="color: #0000ff;">to</span> database</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum74" style="color: #606060;"> 74:</span> $IsPXE = ,@(<span style="color: #006080;">"IsPXE"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # <span style="color: #0000ff;">is</span> PXE going <span style="color: #0000ff;">to</span> be enabled?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum75" style="color: #606060;"> 75:</span> #$PXEPassword = ,@(<span style="color: #006080;">"PXEPassword"</span>,<span style="color: #006080;">"0"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # no idea how <span style="color: #0000ff;">to</span> put an encrypted <span style="color: #0000ff;">string</span> <span style="color: #0000ff;">in</span> there</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum76" style="color: #606060;"> 76:</span> $SupportUnknownMachines = ,@(<span style="color: #006080;">"SupportUnknownMachine"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # PXE unknown computer support enabled?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum77" style="color: #606060;"> 77:</span> $IsAnonymousEnabled = ,@(<span style="color: #006080;">"IsAnonymousEnabled"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # are clients allowed <span style="color: #0000ff;">to</span> make anonymous connections? only <span style="color: #0000ff;">for</span> HTTP</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum78" style="color: #606060;"> 78:</span> $AllowInternetClients = ,@(<span style="color: #006080;">"AllowInternetClients"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # self explaining</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum79" style="color: #606060;"> 79:</span> $IsActive = ,@(<span style="color: #006080;">"IsActive"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # <span style="color: #0000ff;">is</span> PXE active? requires it <span style="color: #0000ff;">to</span> be enabled!</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum80" style="color: #606060;"> 80:</span> $InstallInternetServer = ,@(<span style="color: #006080;">"InstallInternetServer"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # shall IIS be installed & configured?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum81" style="color: #606060;"> 81:</span> $RemoveWDS = ,@(<span style="color: #006080;">"RemoveWDS"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum82" style="color: #606060;"> 82:</span> $UDASetting = ,@(<span style="color: #006080;">"UDASetting"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # User Device Affinity enabled?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum83" style="color: #606060;"> 83:</span> $MinFreeSpace = ,@(<span style="color: #006080;">"MinFreeSpace"</span>,444,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # minimum free space <span style="color: #0000ff;">on</span> DP</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum84" style="color: #606060;"> 84:</span> $PreStagingAllowed = ,@(<span style="color: #006080;">"PreStagingAllowed"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # DP enabled <span style="color: #0000ff;">for</span> PreStaging of files?</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum85" style="color: #606060;"> 85:</span> $ResponseDelay = ,@(<span style="color: #006080;">"ResponseDelay"</span>,5,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # how many seconds shall PXE wait <span style="color: #0000ff;">until</span> answering, between 0 <span style="color: #0000ff;">and</span> 32 seconds</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum86" style="color: #606060;"> 86:</span> $DPShareDrive = ,@(<span style="color: #006080;">"DPShareDrive"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # where does the DP Share reside (primary <span style="color: #0000ff;">and</span> secondary), e.g <span style="color: #006080;">"C:,D:"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum87" style="color: #606060;"> 87:</span> $DPDrive = ,@(<span style="color: #006080;">"DPDrive"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # which <span style="color: #0000ff;">is</span> the DP content library drive</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum88" style="color: #606060;"><span style="text-decoration: line-through;"> 88:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum89" style="color: #606060;"> 89:</span> #$<span style="color: #0000ff;">global</span>:properties = @()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum90" style="color: #606060;"> 90:</span> $properties = $ServerRemoteName + $DPDrive + $DPShareDrive + $ResponseDelay + $BITS + $UseMachineAccount + $IsPXE + $IsAnonymousEnabled + $IsActive + $InstallInternetServer + $IsMulticast + $SslState + $RemoveWDS + $SupportUnknownMachines + $AllowInternetClients + $MinFreeSpace + $PreStagingAllowed + $UDASetting# + $PXEPassword</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum91" style="color: #606060;"><span style="text-decoration: line-through;"> 91:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum92" style="color: #606060;"> 92:</span> #$<span style="color: #0000ff;">global</span>:roleproperties = @()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum93" style="color: #606060;"><span style="text-decoration: line-through;"> 93:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum94" style="color: #606060;"> 94:</span> foreach ($<span style="color: #0000ff;">property</span> <span style="color: #0000ff;">in</span> $properties)</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum95" style="color: #606060;"> 95:</span> {</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum96" style="color: #606060;"> 96:</span> $PropertyName = $<span style="color: #0000ff;">property</span>[0]</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum97" style="color: #606060;"> 97:</span> $Value = $<span style="color: #0000ff;">property</span>[1]</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum98" style="color: #606060;"> 98:</span> $Value1 = $<span style="color: #0000ff;">property</span>[2]</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum99" style="color: #606060;"> 99:</span> $Value2 = $<span style="color: #0000ff;">property</span>[3]</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum100" style="color: #606060;"><span style="text-decoration: line-through;"> 100:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum101" style="color: #606060;"> 101:</span> <span style="color: #0000ff;">Set</span>-<span style="color: #0000ff;">Property</span> $PropertyName $Value $Value1 $Value2 $roleproperties</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum102" style="color: #606060;"> 102:</span> }</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum103" style="color: #606060;"><span style="text-decoration: line-through;"> 103:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum104" style="color: #606060;"> 104:</span> $role.Props = $roleproperties</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum105" style="color: #606060;"> 105:</span> $role.Put()</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum106" style="color: #606060;"><span style="text-decoration: line-through;"> 106:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum107" style="color: #606060;"><span style="text-decoration: line-through;"> 107:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum108" style="color: #606060;"><span style="text-decoration: line-through;"> 108:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum109" style="color: #606060;"> 109:</span> }</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum110" style="color: #606060;"><span style="text-decoration: line-through;"> 110:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum111" style="color: #606060;"> 111:</span> $script:sitename = <span style="color: #006080;">"S01"</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum112" style="color: #606060;"><span style="text-decoration: line-through;"> 112:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum113" style="color: #606060;"> 113:</span> $script:server = <span style="color: #006080;">"AppV01.do.local"</span> #FQDN of server, which <span style="color: #0000ff;">is</span> going <span style="color: #0000ff;">to</span> be installed <span style="color: #0000ff;">as</span> a <span style="color: #0000ff;">new</span> server role</span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum114" style="color: #606060;"><span style="text-decoration: line-through;"> 114:</span></span></pre>
    
    <p>
      &nbsp;
    </p>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span style="text-decoration: line-through;"><span id="lnum115" style="color: #606060;"> 115:</span> <span style="color: #0000ff;">new</span>-distributionpoint $server</span></pre>
  </div>
</div>

<span style="text-decoration: line-through;">Where am I going wrong? Already asked that on Twitter (@david_obrien) and Linkedin!</span>

# 

# 

# [UPDATE] Certificate gets created!!!

A clever Microsoft employee gave me a real good hint to use a dll, which comes with the ConfigMgr 2007 SDK, the tsmediaapi.dll.
  
This .dll needs to be registered on the ConfigMgr server you run it on in a x86 environment (%windir%syswow64cmd.exe regsvr32.exe tsmediaapi.dll)
  
The whole powershell script then needs to be executed from a x86 powershell to use this API.

Here’s the working script:

<div id="codeSnippetWrapper" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 20px 0px 10px; width: 97.5%; font-family: 'Courier New', courier, monospace; direction: ltr; max-height: 200px; font-size: 8pt; overflow: auto; cursor: text; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="text-align: left; line-height: 12pt; background-color: #f4f4f4; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;">
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> 1:</span> ########</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;"> 2:</span> # This script installs a Microsoft System Center Configuration Manager 2012 Distribution Point Server Role</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> 3:</span> # Author: David O<span style="color: #008000;">'Brien, sepago GmbH</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;"> 4:</span> # <span style="color: #0000ff;">date</span>: 01.06.2012</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;"> 5:</span> ########</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;"> 6:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;"> 7:</span> <span style="color: #0000ff;">Function</span> <span style="color: #0000ff;">global</span>:<span style="color: #0000ff;">Set</span>-<span style="color: #0000ff;">Property</span>(</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;"> 8:</span>     $PropertyName,</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;"> 9:</span>     $Value,</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum10" style="color: #606060;"> 10:</span>     $Value1,</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum11" style="color: #606060;"> 11:</span>     $Value2,</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum12" style="color: #606060;"> 12:</span>     $roleproperties)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum13" style="color: #606060;"> 13:</span> {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum14" style="color: #606060;"> 14:</span>             $embeddedproperty_class             = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum15" style="color: #606060;"> 15:</span>             $embeddedproperty_class.psbase.Path = <span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_EmbeddedProperty"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum16" style="color: #606060;"> 16:</span>             $embeddedproperty                     = $embeddedproperty_class.createInstance()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum17" style="color: #606060;"> 17:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum18" style="color: #606060;"> 18:</span>             $embeddedproperty.PropertyName  = $PropertyName</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum19" style="color: #606060;"> 19:</span>             $embeddedproperty.Value         = $Value</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum20" style="color: #606060;"> 20:</span>             $embeddedproperty.Value1        = $Value1</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum21" style="color: #606060;"> 21:</span>             $embeddedproperty.Value2        = $Value2</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum22" style="color: #606060;"> 22:</span>             $<span style="color: #0000ff;">global</span>:roleproperties += [System.Management.ManagementBaseObject]$embeddedproperty</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum23" style="color: #606060;"> 23:</span>     }</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum24" style="color: #606060;"> 24:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum25" style="color: #606060;"> 25:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum26" style="color: #606060;"> 26:</span> <span style="color: #0000ff;">Function</span> <span style="color: #0000ff;">global</span>:<span style="color: #0000ff;">new</span>-DistributionPoint {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum27" style="color: #606060;"> 27:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum28" style="color: #606060;"> 28:</span> ############### Create Site System ################################################</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum29" style="color: #606060;"> 29:</span> $<span style="color: #0000ff;">global</span>:roleproperties = @()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum30" style="color: #606060;"> 30:</span> $<span style="color: #0000ff;">global</span>:properties =@()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum31" style="color: #606060;"> 31:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum32" style="color: #606060;"> 32:</span> # connect <span style="color: #0000ff;">to</span> SMS Provider <span style="color: #0000ff;">for</span> Site</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum33" style="color: #606060;"> 33:</span> $role_class = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum34" style="color: #606060;"> 34:</span> $role_class.psbase.Path =<span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_SCI_SysResUse"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum35" style="color: #606060;"> 35:</span> $script:role = $role_class.createInstance()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum36" style="color: #606060;"> 36:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum37" style="color: #606060;"> 37:</span> #create the SMS Site Server</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum38" style="color: #606060;"> 38:</span> $role.NALPath     = <span style="color: #006080;">"[`"</span>Display=\$server`<span style="color: #006080;">"]MSWNET:[`"</span>SMS_SITE=$sitename`<span style="color: #006080;">"]\$server"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum39" style="color: #606060;"> 39:</span> $role.NALType     = <span style="color: #006080;">"Windows NT Server"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum40" style="color: #606060;"> 40:</span> $role.RoleName     = <span style="color: #006080;">"SMS SITE SYSTEM"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum41" style="color: #606060;"> 41:</span> $role.SiteCode     = <span style="color: #006080;">"S01"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum42" style="color: #606060;"> 42:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum43" style="color: #606060;"> 43:</span> #####</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum44" style="color: #606060;"> 44:</span> #filling <span style="color: #0000ff;">in</span> properties</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum45" style="color: #606060;"> 45:</span> $IsProtected                    = @(<span style="color: #006080;">"IsProtected"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)  # 0 <span style="color: #0000ff;">to</span> disable fallback <span style="color: #0000ff;">to</span> this site system, 1 <span style="color: #0000ff;">to</span> enable</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum46" style="color: #606060;"> 46:</span> <span style="color: #0000ff;">set</span>-<span style="color: #0000ff;">property</span> $IsProtected[0] $IsProtected[1] $IsProtected[2] $IsProtected[3]</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum47" style="color: #606060;"> 47:</span> $role.Props = $roleproperties</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum48" style="color: #606060;"> 48:</span> $role.Put()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum49" style="color: #606060;"> 49:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum50" style="color: #606060;"> 50:</span> ################ Deploy <span style="color: #0000ff;">New</span> Distribution Point #####################################</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum51" style="color: #606060;"> 51:</span> $role         = <span style="color: #006080;">""</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum52" style="color: #606060;"> 52:</span> $<span style="color: #0000ff;">global</span>:properties = @()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum53" style="color: #606060;"> 53:</span> $<span style="color: #0000ff;">global</span>:roleproperties = @()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum54" style="color: #606060;"> 54:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum55" style="color: #606060;"> 55:</span> # connect <span style="color: #0000ff;">to</span> SMS Provider <span style="color: #0000ff;">for</span> Site</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum56" style="color: #606060;"> 56:</span> $role_class             = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum57" style="color: #606060;"> 57:</span> $role_class.psbase.Path = <span style="color: #006080;">"\.ROOTSMSSite_S01:SMS_SCI_SysResUse"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum58" style="color: #606060;"> 58:</span> $role                     = $role_class.createInstance()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum59" style="color: #606060;"> 59:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum60" style="color: #606060;"> 60:</span> #create the SMS Distribution Point Role</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum61" style="color: #606060;"> 61:</span> $role.NALPath     = <span style="color: #006080;">"[`"</span>Display=\$server`<span style="color: #006080;">"]MSWNET:[`"</span>SMS_SITE=$sitename`<span style="color: #006080;">"]\$server"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum62" style="color: #606060;"> 62:</span> $role.NALType     = <span style="color: #006080;">"Windows NT Server"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum63" style="color: #606060;"> 63:</span> $role.RoleName     = <span style="color: #006080;">"SMS DISTRIBUTION POINT"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum64" style="color: #606060;"> 64:</span> $role.SiteCode     = <span style="color: #006080;">"S01"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum65" style="color: #606060;"> 65:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum66" style="color: #606060;"> 66:</span> # Certificate creation</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum67" style="color: #606060;"> 67:</span> $pxeauth    = <span style="color: #0000ff;">new</span>-<span style="color: #0000ff;">object</span> -comobject Microsoft.ConfigMgr.PXEAuth</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum68" style="color: #606060;"> 68:</span> <span style="color: #0000ff;">if</span> (!$pxeauth -<span style="color: #0000ff;">is</span> [<span style="color: #0000ff;">Object</span>]) {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum69" style="color: #606060;"> 69:</span>     <span style="color: #006080;">"PXEAuth Object OK"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum70" style="color: #606060;"> 70:</span> }</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum71" style="color: #606060;"> 71:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum72" style="color: #606060;"> 72:</span> $strSubject = [System.Guid]::NewGuid().toString() # toString(<span style="color: #008000;">'B')</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum73" style="color: #606060;"> 73:</span> $strSMSID   = [System.Guid]::NewGuid().toString() # toString(<span style="color: #008000;">'B')</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum74" style="color: #606060;"> 74:</span> $StartTime  = [DateTime]::Now.ToUniversalTime()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum75" style="color: #606060;"> 75:</span> $EndTime    = $StartTime.AddYears(5)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum76" style="color: #606060;"> 76:</span> $TargetPXEServerFQDN = $server</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum77" style="color: #606060;"> 77:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum78" style="color: #606060;"> 78:</span> $ident        = $pxeauth.CreateIdentity($strSubject, $strSubject, $strSMSID, $StartTime, $EndTime)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum79" style="color: #606060;"> 79:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum80" style="color: #606060;"> 80:</span> <span style="color: #006080;">"Subject: "</span> + $strSubject</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum81" style="color: #606060;"> 81:</span> <span style="color: #006080;">"SMSID: "</span> + $strSMSID</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum82" style="color: #606060;"> 82:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum83" style="color: #606060;"> 83:</span> # Certificate registration</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum84" style="color: #606060;"> 84:</span> $siteclass = [wmiclass](<span style="color: #006080;">"\.rootsmssite_$sitename"</span> + <span style="color: #006080;">":SMS_Site"</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum85" style="color: #606060;"> 85:</span> $intResult = $siteclass.SubmitRegistrationRecord($strSMSID, $ident[1], $ident[0], 2, $server)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum86" style="color: #606060;"> 86:</span> <span style="color: #0000ff;">if</span> ($intResult.StatusCode -eq 0) {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum87" style="color: #606060;"> 87:</span>     <span style="color: #006080;">"Certificate Registration OK"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum88" style="color: #606060;"> 88:</span> } <span style="color: #0000ff;">else</span> {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum89" style="color: #606060;"> 89:</span>     (<span style="color: #006080;">"Certificate Registration failed, error: "</span> + $intResult)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum90" style="color: #606060;"> 90:</span> }</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum91" style="color: #606060;"> 91:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum92" style="color: #606060;"> 92:</span> # filling <span style="color: #0000ff;">in</span> the properties</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum93" style="color: #606060;"> 93:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum94" style="color: #606060;"> 94:</span> $ServerRemoteName       = ,@(<span style="color: #006080;">"Server Remote Name"</span>,0,<span style="color: #006080;">"$server"</span>,<span style="color: #006080;">""</span>) #FQDN of server</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum95" style="color: #606060;"> 95:</span> $BITS                     = ,@(<span style="color: #006080;">"BITS download"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)         # <span style="color: #0000ff;">is</span> BITS going <span style="color: #0000ff;">to</span> be enabled</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum96" style="color: #606060;"> 96:</span> $SslState                = ,@(<span style="color: #006080;">"SslState"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)             # HTTP (0) <span style="color: #0000ff;">or</span> HTTPS (63) connections?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum97" style="color: #606060;"> 97:</span> $IsMulticast             = ,@(<span style="color: #006080;">"IsMulticast"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)           # <span style="color: #0000ff;">is</span> Multicast enabled? <span style="color: #0000ff;">if</span> 1, <span style="color: #0000ff;">then</span> also the SMS Multicast Role has <span style="color: #0000ff;">to</span> be configured</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum98" style="color: #606060;"> 98:</span> $UseMachineAccount         = ,@(<span style="color: #006080;">"UseMachineAccount"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)     # <span style="color: #0000ff;">in</span> <span style="color: #0000ff;">case</span> of multicast, use machine account <span style="color: #0000ff;">to</span> connect <span style="color: #0000ff;">to</span> database</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum99" style="color: #606060;"> 99:</span> $IsPXE                    = ,@(<span style="color: #006080;">"IsPXE"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)                 # <span style="color: #0000ff;">is</span> PXE going <span style="color: #0000ff;">to</span> be enabled?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum100" style="color: #606060;"> 100:</span> #$PXEPassword             = ,@(<span style="color: #006080;">"PXEPassword"</span>,<span style="color: #006080;">"0"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)           # no idea how <span style="color: #0000ff;">to</span> put an encrypted <span style="color: #0000ff;">string</span> <span style="color: #0000ff;">in</span> there</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum101" style="color: #606060;"> 101:</span> $SupportUnknownMachines = ,@(<span style="color: #006080;">"SupportUnknownMachine"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # PXE unknown computer support enabled?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum102" style="color: #606060;"> 102:</span> $IsAnonymousEnabled     = ,@(<span style="color: #006080;">"IsAnonymousEnabled"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)    # are clients allowed <span style="color: #0000ff;">to</span> make anonymous connections? only <span style="color: #0000ff;">for</span> HTTP</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum103" style="color: #606060;"> 103:</span> $AllowInternetClients      = ,@(<span style="color: #006080;">"AllowInternetClients"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)  # self explaining</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum104" style="color: #606060;"> 104:</span> $IsActive                 = ,@(<span style="color: #006080;">"IsActive"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)              # <span style="color: #0000ff;">is</span> PXE active? requires it <span style="color: #0000ff;">to</span> be enabled!</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum105" style="color: #606060;"> 105:</span> $InstallInternetServer     = ,@(<span style="color: #006080;">"InstallInternetServer"</span>,1,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>) # shall IIS be installed & configured?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum106" style="color: #606060;"> 106:</span> $RemoveWDS                = ,@(<span style="color: #006080;">"RemoveWDS"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum107" style="color: #606060;"> 107:</span> $UDASetting                = ,@(<span style="color: #006080;">"UDASetting"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)            # User Device Affinity enabled?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum108" style="color: #606060;"> 108:</span> $MinFreeSpace             = ,@(<span style="color: #006080;">"MinFreeSpace"</span>,444,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)        # minimum free space <span style="color: #0000ff;">on</span> DP</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum109" style="color: #606060;"> 109:</span> $PreStagingAllowed        = ,@(<span style="color: #006080;">"PreStagingAllowed"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)     # DP enabled <span style="color: #0000ff;">for</span> PreStaging of files?</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum110" style="color: #606060;"> 110:</span> $ResponseDelay          = ,@(<span style="color: #006080;">"ResponseDelay"</span>,5,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)        # how many seconds shall PXE wait <span style="color: #0000ff;">until</span> answering, between 0 <span style="color: #0000ff;">and</span> 32 seconds</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum111" style="color: #606060;"> 111:</span> $DPShareDrive           = ,@(<span style="color: #006080;">"DPShareDrive"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)     # where does the DP Share reside (primary <span style="color: #0000ff;">and</span> secondary), e.g <span style="color: #006080;">"C:,D:"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum112" style="color: #606060;"> 112:</span> $DPDrive                = ,@(<span style="color: #006080;">"DPDrive"</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)          # which <span style="color: #0000ff;">is</span> the DP content library drive</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum113" style="color: #606060;"> 113:</span> $CertificateType        = ,@(<span style="color: #006080;">"CertificateType"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum114" style="color: #606060;"> 114:</span> $CertificateExpiration  = ,@(<span style="color: #006080;">"CertificateExpirationDate"</span>,0,([<span style="color: #0000ff;">String</span>]$EndTime.ToFileTime()),<span style="color: #006080;">""</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum115" style="color: #606060;"> 115:</span> $CertificateFile        = ,@(<span style="color: #006080;">"CertificateFile"</span>,0,<span style="color: #006080;">""</span>,<span style="color: #006080;">""</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum116" style="color: #606060;"> 116:</span> $PXECertGUID            = ,@(<span style="color: #006080;">"PXECertGUID"</span>,0,$strSMSID,<span style="color: #006080;">""</span>)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum117" style="color: #606060;"> 117:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum118" style="color: #606060;"> 118:</span> #$<span style="color: #0000ff;">global</span>:properties = @()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum119" style="color: #606060;"> 119:</span> $properties = $CertificateType + $CertificateExpiration + $CertificateFile + $PXECertGUID + $ServerRemoteName + $DPDrive + $DPShareDrive + $ResponseDelay + $BITS + $UseMachineAccount + $IsPXE + $IsAnonymousEnabled + $IsActive + $InstallInternetServer + $IsMulticast + $SslState + $RemoveWDS + $SupportUnknownMachines + $AllowInternetClients + $MinFreeSpace + $PreStagingAllowed + $UDASetting# + $PXEPassword</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum120" style="color: #606060;"> 120:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum121" style="color: #606060;"> 121:</span> #$<span style="color: #0000ff;">global</span>:roleproperties = @()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum122" style="color: #606060;"> 122:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum123" style="color: #606060;"> 123:</span> foreach ($<span style="color: #0000ff;">property</span> <span style="color: #0000ff;">in</span> $properties)</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum124" style="color: #606060;"> 124:</span>    {</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum125" style="color: #606060;"> 125:</span>         $PropertyName     = $<span style="color: #0000ff;">property</span>[0]</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum126" style="color: #606060;"> 126:</span>         $Value            = $<span style="color: #0000ff;">property</span>[1]</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum127" style="color: #606060;"> 127:</span>         $Value1            = $<span style="color: #0000ff;">property</span>[2]</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum128" style="color: #606060;"> 128:</span>         $Value2            = $<span style="color: #0000ff;">property</span>[3]</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum129" style="color: #606060;"> 129:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum130" style="color: #606060;"> 130:</span>         <span style="color: #0000ff;">Set</span>-<span style="color: #0000ff;">Property</span> $PropertyName $Value $Value1 $Value2 $roleproperties</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum131" style="color: #606060;"> 131:</span> }</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum132" style="color: #606060;"> 132:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum133" style="color: #606060;"> 133:</span> $role.Props = $roleproperties</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum134" style="color: #606060;"> 134:</span> $role.Put()</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum135" style="color: #606060;"> 135:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum136" style="color: #606060;"> 136:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum137" style="color: #606060;"> 137:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum138" style="color: #606060;"> 138:</span> }</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum139" style="color: #606060;"> 139:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum140" style="color: #606060;"> 140:</span> $script:sitename = <span style="color: #006080;">"S01"</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum141" style="color: #606060;"> 141:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum142" style="color: #606060;"> 142:</span> $script:server = <span style="color: #006080;">"AppV01.do.local"</span> #FQDN of server, which <span style="color: #0000ff;">is</span> going <span style="color: #0000ff;">to</span> be installed <span style="color: #0000ff;">as</span> a <span style="color: #0000ff;">new</span> server role</pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: white; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum143" style="color: #606060;"> 143:</span></pre>
    
    <pre style="text-align: left; line-height: 12pt; background-color: #f4f4f4; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;"><span id="lnum144" style="color: #606060;"> 144:</span> <span style="color: #0000ff;">new</span>-distributionpoint $server</pre>
  </div>
</div>

Looking forward to your feedback via comments, tweets or mail! 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,ConfigMgr+2012,ConfigMgr2012,Configuration+Manager,Configuration+Manager+2012,Install+Distribution+Point,Installation,Powershell,SCCM+2012,SCCM2012,Script,silent,System+Center,unattended" data-count="vertical" data-url="http://www.david-obrien.net/2012/06/install-distribution-point-for-configuration-manager-2012/">Tweet</a>
</div>
