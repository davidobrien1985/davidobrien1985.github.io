---
id: 410
title: Citrix AppDNA 6.1–what’s new?
date: 2012-06-29T13:10:25+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=410
permalink: /2012/06/citrix-appdna-6-1whats-new/
categories:
  - APP-DNA
  - AppDNA
  - Applications
  - Citrix
  - Configuration Manager
  - migration
  - Operating System
  - PowerShell
  - Windows 8
  - x64
tags:
  - App-DNA
  - APPDNA
  - Applications
  - Citrix
  - Microsoft
  - Migration
---
Just before my wedding holiday Citrix decided to upload all the new releases of the products I work with.
XenApp 6.5 HRP1, XenDesktop 5.6 FP1 and of course AppDNA 6.1.

Because time’s rare today (I’m getting married tomorrow), here’s a quick overview of what is new in this 6.1 release.

# Licensing

Well, first of all, you do not download the sources from the AppDNA portal anymore. Instead they’re available via MyCitrix, which obviously requires a MyCitrix account.

Furthermore it’s actually not version 6.1, it’s 6.1.63.

There is no Launchpad anymore! You can now use AppDNA for a trial period of 30 days and import up to 10 applications and analyze 5 of them.

They changed the default features a bit, for example the Configuration Manager and Active Directory integration required a separate license, which isn’t the case anymore. That’s good!
The 64bit module also now comes as a bundle with the Desktop and Server compatability module.

# New Features / what has changed?

A lot of rebranding has been done. Citrix tried to get rid of the name “AppTitude” and replaced it with AppDNA. Examples are the IIS website on the webserver connecting the client and the database and also parts of the registry.

Before:

![before update](/media/2012/06/IIS_beforeUpdate.jpg "IIS_beforeUpdate")

After:

![IIS after update](/media/2012/06/IIS_afterUpdate.jpg "IIS_afterUpdate")

![updated registry](/media/2012/06/update_registry.jpg "update_registry")

## Remoteadmin.exe

This is the agent running on every virtual machine used to do “Install Capture”. It’s used for communication between the Client and the VM.
Up until now this remoteadmin.exe prevented the VM from shutting down, as long as it was active. That means that when you wanted to reconfigure something on your VM or just boot it, you had to manually shut down the exe first and then boot the VM. In 6.1 that changed. The remoteadmin.exe will only prevent the VM from booting as long as there is an “Install Capture” process running, not when idling around.

## Apptoolsfolder

What I always forgot when doing an implementation of AppDNA was configuring the Apptoolsfolder in my Execution Profile. This points to the installation path of my VM configuration tools (ossnapshot.exe and so on).
The default value didn’t work on x86 machines.
Citrix now solved this issue by creating an environment variable on the VM called %APPDNAVMCONFIG% and using this in an execution profile.
Be sure to check your execution profiles to work this way.

## Lakeside

Still found no time to test the Lakeside integration, but will definitely do that after my holidays! :-)
As I haven’t done that yet, I can’t say much about this feature, other than I will write an other article about this product soon!

## Menus

Most menus underwent some tweaking by making them easier to understand, but there’s not much of more features.

## Conclusion

More of a rebranding to Citrix than new features.

Hope they will soon come up with the automation of AppDNA, like importing an Application into AppDNA silently via Powershell and then let it be analyzed etc
Also waiting for XenDesktop support and a module for Windows 8 and Server 2012. I will try to find out something about the roadmap regarding these points!

