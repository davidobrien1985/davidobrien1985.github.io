---
id: 3108
title: PowerShell DSC to manage PowerShell modules
date: 2015-09-24T22:01:57+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3108
permalink: /2015/09/powershell-dsc-to-manage-powershell-modules/
categories:
  - automation
  - Configuration Management
  - Desired State Configuration
  - DevOps
  - PowerShell
tags:
  - Ansible
  - Chef
  - Configuration Management
  - DevOps
  - Powershell
  - Powershell DSC
  - PowerShellGallery
  - PSDSC
  - Puppet
  - Windows
  - Windows 10
---
While on my way back from the 2015 IT DevConnections conference, it was a loooooong way back, I got the idea that I somehow wanted to make sure that certain PowerShell modules were installed on my servers, without logging on to every server (\*brrr\*) and installing them all manually.

I use [Vagrant](https://www.vagrantup.com) to quickly spin up new test environments on my MacBook as I need them. The Vagrant boxes I use might not always be up to date with everything or might miss some things.

Vagrant doesn't only provision new machines, it can also call scripts or execute commands while provisioning the machine, such as applying DSC configuration to a machine.

# Class based DSC Resource

So I sat down (I already sat, on a plane, for 14.5 hours...) and started writing code, a PowerShell DSC resource, class-based, obviously. Latest and greatest 😉

If you want to read more about class based resources, check out my previous articles, [here](/2015/02/windows-powershell-dsc-classes-introduction-part-1/) and [here](/2015/02/windows-powershell-dsc-classes-resource-basics-part-2/).

This resource supports the installation and removal of PowerShell modules through native PowerShell version 5 functionality.

The Set() Method uses **Find-Module** and **Install-Module / Uninstall-Module** to bring the machine into its desired state.

These cmdlets use nuget to reach out to [Microsoft's PowerShell Gallery](http://www.powershellgallery.com) to find and install PowerShell Modules, which by the way also includes DSC Resources.

## Requirements

In order to use my custom DSC resource the following prerequisites need to be met:

* WMF 5 / PowerShell v5 (preferably Production Preview or later)
* Internet connection (for now)

## How to get the resource and contribute

The Resource / Module itself is available on the PowerShell Gallery and can easily be installed by executing


`Install-Module -Name PowerShellModule`

From here on you can use the resource in any of your DSC configurations or via Invoke-DscResource.

You think I could've done a better job and want to contribute to my resource? Awesome! Head over to Github and contribute: <http://www.github.com/davidobrien1985/DscResources>

If I like what you've done, I'll happily merge it into my repository and give ALL the credits!

Stuff on my ToDo list can be found in the same repository under <https://github.com/davidobrien1985/DscResources/issues>

## How to use the DSC resource

![image](/media/2015/09/1443095754_full.jpeg)

With this little snippet I can make sure that the 'AzureExt' PowerShell module is installed from the PowerShell Gallery.

## Bonus:

** Don't like writing full DSC documents? You know how to properly manage your systems via Puppet, Chef, Ansible, etc? Use my resource like this:

![image](/media/2015/09/1443096018_full.jpeg)

Nice? Any feedback?

Watch Github and the Gallery for updates!