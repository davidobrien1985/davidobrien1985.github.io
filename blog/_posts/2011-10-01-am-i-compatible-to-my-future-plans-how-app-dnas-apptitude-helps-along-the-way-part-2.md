---
id: 267
title: Am I compatible to my future plans? How App-DNA’s AppTitude helps along the way… (part 2)
date: 2011-10-01T19:02:00+00:00

layout: single

permalink: /2011/10/am-i-compatible-to-my-future-plans-how-app-dnas-apptitude-helps-along-the-way-part-2/
categories:
  - APP-DNA
  - Applications
  - Citrix
  - Common
  - migration
  - Operating System
  - Windows 7
  - x64
tags:
  - compatibility
  - SBC
  - Streaming
  - Win7
  - x64
  - XenApp; APP-V
---
In my last [article](http://www.sepago.de/d/david/2011/09/20/am-i-compatible-to-my-future-plans) about AppTitude I gave you a short overview of what AppTitude is and where it can help you save time and such save you money.

This article will all be about how you can actually go and import your applications and let them be analysed by AppTitude.

# DIY or let someone else work?

IT nowadays is all about automation. Nobody really wants to go and install a computer manually anymore, neither does anyone really want to test a company’s application portfolio for compatibility against Windows 7, RDS or Application Streaming, all by himself!

AppTitude helps you with this! As I already mentioned, the AppTitude Service is capable of remoting into a VM to control the application’s install progress and do the before and after snapshot.

Just for the fun of it I am going to import Adobe Reader 8 as an InstallShield installation.
Everything that is not MSI has to be imported with AppTitude’s “Install Capture” technique and thus should happen unattended.

Installations during “Install Capture” need to suppress a reboot in order for the AppTitude’s “Remoteadmin.exe” service to work and successfully monitor the application’s installation process.

For Adobe Reader 8 the install commandline would look like this:

```PowerShell
AdbeRdr80_en_US.exe /sPB /rs
```

I recorded an import example of Adobe Reader 8 using a VMware Workstation VM. (This is w/o audio! But I promise the next videos will be with commentary!)
You will see how I select Adobe Reader 8 to be my imported application and then configure how the command line will look.

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="scid:5737277B-5D6D-4f48-ABFC-DD9C333F4C5D:01115bf0-9d67-4e99-9b6d-b49ed8c03eeb" class="wlWriterEditableSmartContent">
  <div>
  </div>

  <div style="width:448px;clear:both;font-size:.8em">
    Import of Adobe Reader into APP-DNA AppTitude
  </div>
</div>

On pressing “import” the following steps will run:

* AppTitude will revert the VM to a known state
* VM gets started
* AppTitude will take the “Before Snapshot”
* this is no VM snapshot!
* Adobe Reader gets installed
* AppTitude will take the “After Snapshot”
* all changes will be saved in an output folder and a MSI is created, which AppTitude will then use for analysation
** again: this MSI cannot be used for deployment!
* the VM is shut down/suspended or whatever action you configure

We can now find our freshly imported application in AppTitude ‘s application list.

![application overview](/media/2012/01/application_overview.jpg "application_overview")

As a next step the next application could be processed, this way a fully automated import can be managed, with nearly no effort.

The next part of this series will cover the analysed application and what reports you can generate out of your data. Stay tuned!






