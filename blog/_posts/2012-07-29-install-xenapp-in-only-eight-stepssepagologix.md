---
id: 436
title: Install XenApp in only eight steps–sepagoLogiX
date: 2012-07-29T20:27:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=436
permalink: /2012/07/install-xenapp-in-only-eight-stepssepagologix/
categories:
  - automation
  - Citrix
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - sepago
  - XenApp
tags:
  - automation
  - Citrix
  - Powershell
  - Script
  - scripting
  - Sepago
  - sepagoLogiX
  - XenApp
---
Recently I’m doing a lot of projects where customers either want to upgrade their existing Presentation Server 4 / 4.x / XenApp 5 or even 6 environments to XenApp 6.5 or also those who are new to SBC and implement XenApp the first time.
  
These are customers ranging from as few as a dozen XenApp servers up to environments with thousands of XenApp servers.

## Challenges

A lot of people already wrote about stuff you need to think of when deploying a new XenApp environment. Best practices and white-papers are all over the place, but naturally nobody reads all –or even some- of them.

A successful deployment thus should take care of all of these best practices and guidelines. A collection of all the knowledge of the past years, got from loads of projects, from all the white-papers and vendor recommendations would be great.

What more?

### Automation is key!

An even more successful deployment can be rebuilt over and over again and the outcome should be exactly the same. This is also great for disaster recovery!
  
Automation makes documentation easier, because a well-written script is nearly as good, but of course is no substitute!

Enough chit-chat… what am I talking about?

# sepagoLogiX – The XenApp automation framework

Some colleagues of mine at sepago started developing installation frameworks for Presentation Server years ago (based on batch scripts) and continued to enhance these scripts.

XenApp 6.x brought some new features and concepts into this world and the framework grew further until it became known as sepagoLogiX, a collection of sepago best practices for RDS and XenApp, recommendations from Microsoft and Citrix and of course the whole installation and configuration of a XenApp farm, based completely on PowerShell.

This framework is able to run stand-alone or in any ESD environment like Microsoft System Center Configuration Manager 2007/2012, Altiris, enteo NetInstall/DSM7 or whatever.
  
The trick is that it’s really fast and easy to implement, because this whole framework is run from only one “master-script”, which then itself executes all the other scripts (that’s for standalone) or e.g. for ConfigMgr there are already pre-configured Task Sequences one can import and use.

It’s fairly simple to configure, because around 90% is done via variables that are written to the machine’s (the XenApp server to be) local registry and from there evaluated by sepagoLogiX. One can write these variables directly into the registry, use a *.reg file or ConfigMgr collection/machine variables.

# 

# eight ways to a successful deployment

sepagoLogix is built up in eight steps.

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/08/folders.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/08/folders.jpg', '']);" class="broken_link"><img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border-width: 0px;" title="folders" src="http://www.david-obrien.de/wp-content/uploads/2012/08/folders_thumb.jpg" alt="folders" width="223" height="181" border="0" /></a>
</p>

<p align="left">
  The first seven steps are kind of a must with sepagoLogiX to get your farm up and running. It starts with a bit of System customization in step 1 (registry, services, prerequisites for XenApp, hotfixes etc), continues with the XenApp installation itself in step 3 (also with HRP or any hotfixes you like), farm join or creation in step 4 and application publishing in step 7.
</p>

<p align="left">
  Step 8 is only an addon if you want to use Citrix Provisioning Services (PVS) in your environment. Here sepagoLogiX can automatically create a vDisk from your machine.
</p>

<p align="left">
  If you already know a bit about XenApp 6.x you might have noticed that sepagoLogiX also splits the installation and configuration of XenApp into two parts. This way you’re able to for example capture an image from this machine (manually or if you like with Microsoft ConfigMgr) and deploy this image later on with any technology you like, starting with step 4 and creating a new or joining an existing farm. You can even create a template (VMware or XenServer) at this point.
</p>

<p align="left">
  One can of course deviate from the standard by using steps 2 and 6, where you can put in any configuration/scripts/installs/whatever that’s specific to your environment.
</p>

<p align="left">
  In using this standardized framework it’s now possible to deploy a new XenApp environment with less effort than before.
</p>

## Sum up

sepagoLogiX is a powerful framework which made XenApp deployments that much easier and faster, because most of the thinking and script development has already been done.

Of course this doesn’t mean that everything in sepagoLogiX fits every customer, but most of it does and you can focus on the stuff that’s special to your environment.

Want some more information on sepagoLogix? Contact me <a href="https://twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/david_obrien', '@david_obrien']);" target="_blank">@david_obrien</a> or comment here… 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,Citrix,Powershell,Script,scripting,Sepago,sepagoLogiX,XenApp" data-count="vertical" data-url="http://www.david-obrien.net/2012/07/install-xenapp-in-only-eight-stepssepagologix/">Tweet</a>
</div>
