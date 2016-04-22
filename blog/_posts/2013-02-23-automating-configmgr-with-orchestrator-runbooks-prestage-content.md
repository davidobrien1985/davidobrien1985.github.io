---
id: 744
title: 'Automating ConfigMgr with Orchestrator Runbooks - PreStage content'
date: 2013-02-23T15:52:10+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=744
permalink: /2013/02/automating-configmgr-with-orchestrator-runbooks-prestage-content/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Orchestrator
  - PowerShell
  - SCCM
  - scripting
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - prestaging
  - runbooks
  - SCCM
  - System Center
---
I’ve been working with System Center Configuration Manager for quite some time now and all the time I wanted to automate stuff.

Sure, we all build zero touch Operating System deployments, application installations or other cool stuff, but many people out there forget that there are also administration workflows that need to be automated or at least would work better if they were automated.

I have already written a lot of scripts which I published here on my site which are mainly PowerShell. While this is cool and already a step in the right direction I thought that there’s more to it and sat down to integrate my scripts into System Center 2012 Orchestrator runbooks.

## Powershell in Orchestrator

You might have noticed that the scripts I wrote so far were not really made for remote execution. My approach was to execute the scripts locally on the site server. Some people like that, others don’t, but that’s how I wrote them.

The approach with Orchestrator needs to be different. Now it’s possible that Admins execute runbooks from any computer in your network, that’s what the Orchestrator web service is there for.

Admins don’t need access to an installed ConfigMgr console, they only need an internet browser to access the Orchestrator website. They then want to execute a runbook which in my case relies on loads of things that in 95% of all cases are not present on an Orchestrator server, e.g. ConfigMgr WMI namespace or ConfigMgr Powershell modules. But in order to execute my runbooks successfully I need those.

That means I have to rewrite my scripts to enable remote execution of my scripts.

The PowerShell script will still be executed on the runbook server, but some of the commands will then be executed on a different remote server, in our case a ConfigMgr site server.

Unfortunately Orchestrator doesn’t provide us good ways of executing PowerShell. There is one built-in activity called “Run .Net Script” which allows us to execute PowerShell. This activity however comes along with the crappiest “Script Editor” ever. The window is too small, it can’t be resized and it’s totally not intuitive.

![image](/media/2013/02/image1.png "image")

There is one Integration Pack on CodePlex which allows us to execute PowerShell scripts and gives us some more options than the previously mentioned “Run .Net Script”, but this then has its own downsides, like it’s a bit more difficult to integrate Orchestrator variables in an external script than putting them directly into your script box like in the picture above.

The link to the Integration Pack: [http://orchestrator.codeplex.com/releases/view/76101](http://orchestrator.codeplex.com/releases/view/76101)

This is how it looks like:

![image](/media/2013/02/image2.png "image")

I need to execute script on a remote machine. Doesn’t sound too difficult, does it? It’s not, at least if you stop there.

## Double-Hop and CredSSP

I’m going to write a short article about this little fellow which I, in this context, just learned about a few days ago.

Just so much:

Try running a Powershell script which opens a PSSession from Server A to Server B. In that session try a “test-path” on any local path. That should work as expected. Then from that session try a “test-path” on any other remote path and that will fail. Why? CredSSP. Google it or read my other blog post here: [/2013/02/24/the-curse-of-the-second-hop-powershell-credssp/](/2013/02/24/the-curse-of-the-second-hop-powershell-credssp/)

## Content PreStaging with Orchestrator

I thought I’d start my Orchestrator project with the latest scripts I wrote. So I looked at my content prestaging scripts and rewrote them a bit (in fact quite a lot) to make them work in Orchestrator.

What do they do now? Exactly what their names say. They prestage packages, OSs, boot images, applications and driver packages. All on a per folder basis only, no single packages and for every package in a folder a new pkgx file will be created.

To be able to successfully execute the runbooks you’ll need the following variables in your environment:

![image](/media/2013/02/image3.png "image")

These variables are used inside the runbooks to determine the CM Site Server on which we want the script to run its commands and also to find the CM12 Powershell module.

Furthermore we define a user which has access to the ConfigMgr 2012 environment. Doing it via variables takes away the pain when hardcoding the user’s password into the script.

## Runbook execution

These runbooks aren’t the most perfect ones, I admit. They have no real error handling or logging. Just a few lines of output at the end. So don’t expect too much on that side.

Each runbook will need a few input data of you when executed.

![image](/media/2013/02/image4.png "image")

Fire it off and enjoy the results!

Download the runbooks here: [http://davidobrien.codeplex.com/releases/view/102376](http://davidobrien.codeplex.com/releases/view/102376)

More runbooks will come! Promise!

