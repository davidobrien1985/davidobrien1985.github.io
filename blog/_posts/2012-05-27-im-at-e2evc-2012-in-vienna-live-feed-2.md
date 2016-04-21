---
id: 344
title: I’m at E2EVC 2012 in Vienna (“Live Feed”)
date: 2012-05-27T14:22:43+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=344
permalink: /2012/05/im-at-e2evc-2012-in-vienna-live-feed-2/
categories:
  - App-V
  - AppDNA
  - Citrix
  - Cloud
  - Cloud
  - Common
  - Community
  - E2EVC
  - Microsoft
  - VDI
tags:
  - APPDNA
  - AppSense
  - Citrix
  - Cloud Gateway
  - Community
  - E2EVC
  - RES
  - SBC
  - SMSPasscode
  - TBM
  - The Bandwidth Matrix
  - ThinKiosk
  - User Environment Manager
  - VDI
  - Virtuall UEM
  - Whiptail
  - XenApp
  - XenDesktop
---
I’m writing this article while on board my Germanwings flight from Cologne/Germany to Vienna/Austria where I’ll be attending the 2012 Experts to Experts Virtualization Conference ([www.e2evc.com](http://www.e2evc.com)).

I know, this comes kind of late, but if you’re there and like to see me present on Citrix AppDNA 6 , then come watch my session today (Friday) scheduled to begin at 2:10PM.

I will try to update this article while attending other sessions, so that if you’re not in Vienna, you still know what we were talking about.

This is my second community event (after ICE Lingen 2011 [www.ice-lingen.de](http://www.ice-lingen.de)), and the first for me to present at, so I’m really excited to meet all the people attending the event!

Keep following this article to stay up to date on the sessions I visit.

# Arrival at Conference

![]("IMAG0226" /media/2012/05/IMAG0226.jpg)

Alex’s welcoming was a bit delayed due to some misorganization on the hotel’s side.

RES then showed what they have been doing the last months and what can be expected to be released by them in the next couple of days/weeks/months.

They’re going to release the RES Workspace Manager 2012 and Hyperdrive in the next days and I think especially the latter sounds really interesting.

# SMSPasscode 6.1 Session

David Hald from SMSPasscode talks about the threats that are out there in the world and security breaches. Apparently RAS are protected by Spiderman ;)

A demo environment of SMSPasscode 6.1 (released last Monday) is available at demo.smspasscode.com

# AppDNA Session

This was my session. I believe the video recording and PowerPoint slides will soon be available for everyone to download.

My feeling is that it went quite well. It’s my first time at E2EVC, so I can only guess ;)

The internet connection is still unavailable so I’m writing this offline, hoping I can upload the updates later on or tonight. Up until now all the sessions have been really interesting!

# Whiptail

* Silicon Storage Arrays
* claim to have solved the “lifetime” problem with flash drives
* have their own OS above the hardware which accumulates write processes
* writes one storage cell after another, so that one storage cell only gets written to the second time if all the other cells already have a write on them

# AppSense Session

I don’t know much about AppSense, so most of the session is quite new to me.

* System Center Operations Manager Management Packs for 2007 and 2012
* Environment Manager 8.3 just released
* Desktop settings can be set to be “shared” or “separate”, meaning if they should roam between OS versions
* User managed applications (Strata Apps from AppSense Labs):
* applications user want to use, but are not part of the company
* applications are installed into a sandbox
* another filter driver :(

* DataLocker (also from AppSense Labs)
  * encryption/decryption of data
  * free product
  * native DropBox integration in iOS

* DataNow:
  * Data broker, follow-me-data
  * virtual appliance
  * sounds and looks like Citrix ShareFile
  * enterprise connector to Active Directory

I expected to hear something about their profile management solution, but that was left out completely. Guess that means that I have to go look myself.

# Veeam Session

Interesting VM backup & recovery product, also new to me.

# Risks and Side Effects of Poor Network Design

Interesting session about network problems in a RDS environment, where “Flow Control” on Router actually slowed down the User expperience

# Cracking with Remko Weijnen ( [@remkoweijnen](https://twitter.com//RemkoWeijnen))

How to crack a setup installer, which doesn’t want to install on your client. I honestly didn’t understand more than 2% ;) Most of the time it looked like Matrix, with HexEditors, IDAPro and lots of funny programs.

# RES Master Class: Dynamic Desktop Studio

Day 2 of E2EVC starts early at 9am with RES Master Class (Dynamic Desktop Studio at work)

Awesome, we got “The IT Crowd: Version 1.0”…in dutch ;)

* The Master Class will cover the installation of a RES WorkspaceManager and Automation Manager environment, which in the end is supposed to be capable of creating a new employee user workspace fully automatically.
* install RES Automation Manager 2012
* works with SQL login only
* created a workflow to automatically join a Client to a Domain, there are lots of other modules to use, like install ConfigMgr applications, App-V Packages and so on
* install Workspace Manager 2012 RC (will be generally available next week!)
* configure Workspace Manager agent via Automation Manager
* create an AD user in Automation Manager
* [tutorials.ressoftware.com](http://tutorials.ressoftware.com) for more information

![]("IMAG0202" /media/2012/05/IMAG0202.jpg)>

# Next E2EVC / PubForum

Alex ([@E2EVC](https://twitter.com/#!/E2EVC)) just announced that the next E2EVC is going to be held in Hamburg (Germany) November 2nd to 4th.

# VirtuAll User Environment Manager:A Deep Dive into Free User Env Mngm Tool [@pmarmignon](http://twitter.com/#!/pmarmignon)

Well this was an interesting session about User Environment Management. I will definitely have a look at it.

![]("IMAG0203" /media/2012/05/IMAG0203.jpg)

For more information on Pierre’s tool, look at CitrixTools.net or [VirtualDesktops.info](http://VirtualDesktops.info)

# The Bandwidth Matrix by [@IngmarVerheij](http://twitter.com/#!/IngmarVerheij)

Ingmar announced the release of [www.thebandwidthmatrix.com](http://www.thebandwidthmatrix.com) , a bandwidth benchmarking website (beta) for Citrix ICA connections.

Have to check the website, shown some interesting results during the session.

For now it’s “only” ICA protocol, but others will follow, like PCoIP.

Follow @TheBandwidthMatrix on Twitter!

# Citrix CloudGateway – the simple way by [@archynet](http://twitter.com/#!/archynet)

Stéphane talked about the new product CloudGateway by Citrix.

Citrix Storefront Receiver 1.2 maybe released by July 2012.

* No SDK
* No Powershell Snapin
* No SSON

Java client fallback will not be possible in Receiver Storefront, but native HTML5 support will come.

# Day 3 of E2EVC

It’s been a short night in Vienna and I’m already back in the InterCity Hotel.

# ThinKiosk by [@andyjmorgan](http://twitter.com/#!/andyjmorgan)

Sitting in Andrew Morgan’s session "Leveraging old enterprise PC’s with ThinKiosk to lower the Desktop cost".

ThinKiosk is a DotNet 2.0 application, which locks down the whole desktop and just presents the user with the configured Citrix WebInterface. It’s a free community tool available at [www.andrewmorgan.ie/thinkiosk](http://www.andrewmorgan.ie/thinkiosk)

This way the user is only able to work with the published desktop and do nothing more with his local desktop!

[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="IMAG0214" src="/media/2012/05/IMAG0214_thumb.jpg" alt="IMAG0214" width="244" height="148" border="0" />]("IMAG0214" /media/2012/05/IMAG0214.jpg)[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="IMAG0216" src="/media/2012/05/IMAG0216_thumb.jpg" alt="IMAG0216" width="244" height="148" border="0" />]("IMAG0216" /media/2012/05/IMAG0216.jpg)

# “How real is virtual” by [@neilspellings](http://twitter.com/#!/neilspellings)

Neil presented on Netscaler VPX and how to break it  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/media/2012/05/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" />Interesting demos on Netscaler VPX and XenMotioning them around and how this could affect your user’s experience.

&nbsp;

# "Virtualization clients in enterprise, when to use what and why" by [@keesbaggerman](http://twitter.com/#!/kbaggerman/) and [@barryschiffer](http://twitter.com/#!/barryschiffer)

Comparing women to Fat/Thin Clients? Interesting analogy in this session. They tested different thin/zero clients against a Fat Client.

  * power usage nearly the same with Fat Client and Thin Clients, why then use Thin Clients?
  * there’s a market for both

<p align="center">
  [<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border-width: 0px;" title="IMAG0219" src="/media/2012/05/IMAG0219_thumb.jpg" alt="IMAG0219" width="244" height="148" border="0" />]("IMAG0219" /media/2012/05/IMAG0219.jpg)
</p>

# “Gone in 60 seconds-#all #user #passwords on #XA/RDS SRV” by [@remkoweijnen](http://twitter.com/#!/remkoweijnen)

This was actually one of the coolest but scariest sessions at E2E. Remko demonstrated how easy it is to get any logged on user’s password from any XenApp or RDS session.

[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="IMAG0220" src="/media/2012/05/IMAG0220_thumb.jpg" alt="IMAG0220" width="244" height="148" border="0" />]("IMAG0220" /media/2012/05/IMAG0220.jpg)

[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="IMAG0222" src="/media/2012/05/IMAG0222_thumb.jpg" alt="IMAG0222" width="244" height="148" border="0" />]("IMAG0222" /media/2012/05/IMAG0222.jpg)

Apparently a 7-year-old can go and get any user’s password in plain text from as far back as Win2000. Remko even programmed his own tool that goes and gets them for you.

He even showed us the Matrix! <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/media/2012/05/wlEmoticon-winkingsmile.png" alt="Zwinkerndes Smiley" />

[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border-width: 0px;" title="IMAG0225" src="/media/2012/05/IMAG0225_thumb.jpg" alt="IMAG0225" width="244" height="148" border="0" />]("IMAG0225" /media/2012/05/IMAG0225.jpg)

#

# Sum Up

All in all my first E2EVC was a really cool experience. I got to meet all the people I already knew from Twitter and such in person (which is always great!), talk to them, discuss with them and get a beer with them.

This was also the first time I presented in front of such a large and skilled audience and if there’s no too bad feedback, then this was not the last you’ve seen of me!

It’s a shame that I can’t make it to Hamburg in November, but I will definitely try to make Stockholm next year!

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


