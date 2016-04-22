---
id: 369
title: 'Microsoft TechEd North America &#038; Configuration Manager'
date: 2012-06-11T20:03:05+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=369
permalink: /2012/06/microsoft-teched-north-america-configuration-manager/
categories:
  - Applications
  - Cloud
  - Community
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - MDT
  - Microsoft
  - MSTechEd
  - Operating System
  - SCCM
  - System Center
  - System Center Configuration Manager
  - TechEd
  - Windows 7
  - Windows 8
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Linux
  - Microsoft
  - MSTechEd
  - SCCM
  - SCCM 2012
  - TechEd
  - UNIX
  - Win7
  - Windows 7
  - Windows 8
---
Just a bit of a sum up of the announcements that were made around ConfigMgr 2012 at TechEd North America.
I’m not there myself, so this is just what I found in the community and what I think about these…

* Microsoft announced availability of ConfigMgr 2012 SP1 CTP at the end of this week

That would be great, I always like to test new stuff :-)

* Windows 8 support

I stopped trying to get it done with the current version, it’s just not working (problems with sysprep). This way I’d finally get to really play with Windows 8 and ConfigMgr. Looking forward to it!

* Linux and UNIX support

I never installed a Linux/UNIX machine (except for XenServer), so this is no biggy for me, although I can imagine lots of customers asking for this, as many still deploy infrastructure like DHCP/DNS on Linux machines. Now they can manage them aswell.

* Mac OS X support (with Endpoint Protection!)

Same goes for Mac, I’m no Mac guy, but since BYOD is growing fast I guess this is also quite important to some enterprises.

* still nothing about ConfigMgr 2012 and Powershell

Whyyyyyy???? I honestly don’t know and understand why they still don’t come up with their own cmdlets. Most of the other System Center products got them.
Or am I really the only one who wants to automate stuff in Configuration Manager?

[UPDATE]
They just now announced Powershell support!!! **FINALLY!!!

* I’m looking forward to see how they did it.

* adding a Central Administration Site (CAS) into an existing environment

Now this I find huge! Up until now you had to decide whether you deploy a CAS or not right at the very first moment of you building your environment. It now seems as if this isn’t the case anymore after SP1.
Although I have to admit that there are not that many scenarios for deploying a CAS, those that come along after you deployed your stuff without the CAS make life hard.

[Update]

More info available on Kent Agerlund’s blog: [http://blog.coretech.dk/kea/configmgr-2012-sp1-announced-teched-2012/](http://blog.coretech.dk/kea/configmgr-2012-sp1-announced-teched-2012/)

