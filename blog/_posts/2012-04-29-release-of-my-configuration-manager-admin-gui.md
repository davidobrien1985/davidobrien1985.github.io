---
id: 312
title: Release of my Configuration Manager Admin GUI
date: 2012-04-29T01:08:07+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=312
permalink: /2012/04/release-of-my-configuration-manager-admin-gui/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - Configuration Manager
  - Configuration Manager 2012
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2012
  - scripting
  - System Center
---
It’s done! I finally got my script to a point where I would like to start sharing it with the whole community.

Go ahead and download the package here: Download Link

# What’s covered?

Deploy a Task Sequence to a defined collection:
  
- the Task Sequence will be available as soon as possible
  
- it will be available via PXE boot
  
- it will be required

Import machines:
  
- import a single machine to a given collection
  
- import any given number of machines via a CSV file
  
- the CSV needs to have the following format:
  
_C0012324;00-00-11-11-22-33
  
C0012325;01-00-11-11-22-33
  
C0012326;00-03-11-11-22-33_

# What will some day be covered?

I am going to continue working on the script as much as my time permits. There are still lots of things that I would like to see covered, such as

- create variables (collections and machines)
  
- configure the Task Sequence deployments yourself
  
- create applications

# Why all this?

Some of you might ask why I am doing this? First of all, because it’s fun. I learned quite a lot about Powershell scripting during the last weeks. It’s really interesting to see what you can do in Configuration Manager 2012 via Powershell.
  
And then I do believe, that this could be of interest for some people or even companies.

I am looking forward to your feedback! Here or on Twitter (@david_obrien) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


