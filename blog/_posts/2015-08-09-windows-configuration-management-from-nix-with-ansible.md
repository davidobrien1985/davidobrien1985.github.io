---
id: 3098
title: 'Windows configuration management - from *nix with Ansible'
date: 2015-08-09T09:19:13+00:00

layout: single

permalink: /2015/08/windows-configuration-management-from-nix-with-ansible/
categories:
  - Ansible
  - automation
  - DevOps
  - PowerShell
tags:
  - Ansible
  - automation
  - DevOps
  - Linux
  - Powershell
  - UNIX
---
Wait, what? First he turns his [back on ConfigMgr](/2015/07/from-here-on-automating-the-universe/) and now he's doing Configuration Management on Windows from a *nix machine?!

Yes, that's what I've been doing over the last couple of weeks now. I am using a Configuration Management Framework running on Ubuntu (or RHEL, whatever you like) and provision Windows with it.

Over the last couple of days I haven't even logged on to a Windows Server anymore, all the management happens from the *nix management server and all the development happens on my Mac OS X.

# What is Ansible?

This article will not explain in detail how Ansible works or how it is set up or best practices. This article is about some of my observations after working with it for a bit now.

Ansible is a configuration management software designed to be as lightweight and easy to learn as possible. It is written in Python (I do not know Python, yet) and is, so far, possibly the easiest to learn product I have come across. Also, it is free, open source and standing up a PoC takes about 10minutes.

You want more information? Go check out [Ansible's website](http://www.ansible.com) or their [Github repo](http://github.com/ansible).

# Ansible on Windows

How do you get started? Well, that depends. You need a Linux/Unix based machine as your management machine. You got a Mac? Great, use that. Otherwise, spin something up on Azure, AWS or just a local VM, whatever. Check out [Trond's article here](http://hindenes.com/trondsworking/2015/02/21/megapost-getting-up-and-running-with-ansible-and-dsc/) to get started.

## How does Ansible work?

I am only going to talk about how it executes on Windows here. The awesome thing about Ansible is, there are no services, no processes that need to be installed, maintained or monitored, it's basically a "**_git clone_**" of the Ansible repo (or use whatever package management tool you like) and off you go.

Ansible runs agentless. On Windows, all you need to do is make sure that winrm is enabled and accepts remote connections.

![Ansible](/media/2015/08/2015-08-09_08-39-54.jpg)

Ansible is able to use local users or domain users to authenticate on the Windows node. Why now is it so easy for a Windows guy to run Ansible on Windows? It's PowerShell.

Ansible copies the required modules during runtime over to the target node, into a temporary work and executes the scripts or commands via winrm port 5985 (http) or 5986 (https).

After execution each module reports back through JSON format if it has changed anything or not and finally cleans up the workspace and that's it.

This way, because all load is effectively on the target node, you can provision 100s of nodes from a laptop.

## Configuration Management - lightweight

One thing I really had to get my head around with Ansible was the seemingly lack of idempotency in the Windows modules. Being able to use modules like command or raw didn't feel right, as they are really not idempotent. In my opinion, Ansible is great for the initial provisioning of a machine, not so much for ongoing management. This is because of the following:

* no remote agents
  * need for manual execution of playbooks or custom scheduled task (cron job)
* no built-in PowerShell DSC (Desired State Configuration) support
  * built-in Windows modules not always very idempotent
  * Trond Hindenes has written some great [custom PSDSC modules for Ansible](https://github.com/trondhindenes/Ansible-win_dsc)
* no central management server collecting the state of systems

## Ansible's idempotence on Windows

I've now once or twice mentioned that some modules aren't very idempotent, some might disagree, but that's my opinion at least.

An example is win_msi ([https://github.com/ansible/ansible-modules-core/blob/devel/windows/win_msi.ps1](https://github.com/ansible/ansible-modules-core/blob/devel/windows/win_msi.ps1)), which executes msiexec without checking if the Product ID might already exist. Msiexec will not actually go and install the application, because it does its own detection of the app, but then it still says that it has changed something on the machine.

Idempotence for me means that a process will also check if it actually has to do something before attempting to do something. I don't want to rely on a 3rd party's implementation.

I know, Pull Request welcome. 😉 Working on it.

# Facts - Facts - Facts

Facts are properties on targets that are collected during runtime of playbooks. This is done through the setup module, which uses facter or ohai on remote systems. Ansible on Windows doesn't rely on any 3rd party components, so by default neither facter nor ohai are used, only native PowerShell in the setup.ps1 file. This file is limited, as it only discovers very basic information about the system and right now there is no way to collect custom inventory data. On *nix there is a parameter called "_facts_path_" for the setup module which is parsed during data collection. Unfortunately, that isn't possible on Windows. Ansible just doesn't use that parameter.

![Ansible facts](/media/2015/08/2015-08-09_08-29-27.jpg)

However, if you want it to use it, check this Pull Request of mine out: [https://github.com/ansible/ansible-modules-core/pull/1876](https://github.com/ansible/ansible-modules-core/pull/1876)

I have added custom capability to the core setup module for Windows to use ps1 scripts in "facts_path" and add it to the machine's facts.

These facts can then be used in plays for conditional tasks.

## Summary

Everybody was quite impressed with me that without really knowing Ansible that much that I was able to write custom modules after only two days. Then again, it's just PowerShell. Easy for Windows people.

Check out Ansible, it's really cool! And if you're using it on Windows, make sure you upload your custom modules and code modifications to git and tell us all about it. There's much to do to make it awesome on Windows.

Looking forward to get PowerShell v5 RTM soon and then use that with Ansible.


