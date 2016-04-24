---
id: 261
title: Am I compatible to my future plans? How APP-DNA ’s AppTitude helps along the way…(Part 1)
date: 2011-09-26T18:58:00+00:00
author: "David O'Brien"
layout: single

permalink: /2011/09/am-i-compatible-to-my-future-plans-how-app-dna-s-apptitude-helps-along-the-waypart-1/
categories:
  - APP-DNA
  - App-V
  - Applications
  - Citrix
  - Common
  - migration
  - x64
tags:
  - compatibility
  - SBC
  - Streaming
  - Win7
  - x64
  - XenApp; APP-V
---
What are the future plans for your environment? I believe most customers/companies are going to update to Win7 and might also change their architecture from x86 to x64.

Or maybe you’re not upgrading your clients but your servers.
Server 2003 to 2008 R2? Would you like to join the Citrix XenApp world?

How many applications do you have in your environment? Even the smallest company will have a lot more apps than you’ll guess at first thought.

Ever asked the following? “What does this app do? How does it work?”

I believe that most people couldn’t say what each app does and what it is really compatible to. But that’s the most important question when migrating your operating systems. Are my apps still working after the OS has been updated? Does application virtualization really solve everything? (as some claim!)

Here is where App-DNA’s AppTitude comes in handy.

AppTitude is able to check whether an application is able to run on an x64 OS or if it is possible to use application streaming technologies like Microsoft APP-V or Citrix Streaming or nearly any combination one can think of.

# MSI is best – don’t worry about the rest

You maybe already use a lot of MSIs in your software deployment solution (like Microsoft System Center Configuration Manager (SCCM), enteo Netinstall, Symantec Altiris or what ever else you are using).
Analysing a MSI package is the easiest thing to do with AppTitude, as the AppTitude Agent will only import the MSI, analyse its contents, check what it does and runs it against the configured modules/rules for its compatibility.

![](/media/2012/01/image.png)

But being honest, chances are that you are just like nearly everybody else and still use self-written installer scripts or other setup programs that are no MSI installers.
What about them? Don’t worry! You don’t have to repackage your installers and it’s really not too difficult to analyse even those applications.

## Install & Capture

There will be virtually no application that Apptitude can’t import and analyse.

The basic idea is that Apptitude controls a virtual machine, takes a ‘snapshot’ of it, installs one application a time, takes another ‘snapshot’ of the machine and that way finds all the system changes the just installed application caused.

![]("image" /media/2012/01/image1.png)

To make those changes easier to analyse, Apptitude creates an msi file out of those changes and imports this msi file into its own datastore. By the way, this msi file can’t be used to deploy this software onto clients.

How the install & capture works in detail, what you can get out of the reports and what else AppTitude has to offer will be covered in the next part of this series. Stay tuned!


