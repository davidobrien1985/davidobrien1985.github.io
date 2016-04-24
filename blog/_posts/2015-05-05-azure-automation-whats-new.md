---
id: 3043
title: Azure Automation, what is new?
date: 2015-05-05T00:53:19+00:00
author: "David O'Brien"
layout: single

permalink: /2015/05/azure-automation-whats-new/
categories:
  - Azure
  - Ignite
  - Orchestrator
  - PowerShell
tags:
  - Azure
  - Cloud
  - Ignite
  - Microsoft
  - Orchestrator
  - Powershell
  - PSDSC
---
Microsoft has just released the next iteration of Azure Automation on their Microsoft Cloud and announced a lot of new features around it at their [Microsoft Ignite Conference](http://ignite.microsoft.com).

This is just an overview of the features I am most excited about.

# New Preview Portal

* Automation node is now available in the new [http://portal.azure.com](http://portal.azure.com)

# Graphical User Interface for Azure Automation

* Orchestrator's appeal always was the simple "drag and drop" experience while building runbooks. While this was usually quite limited and you quickly had to revert back to writing PowerShell code, the idea was that you could easily see what was happening.
* Graphical runbooks give you the ability to now view what is happening in that runbook at a single glance.

![Azure Automation Graphical Runbook](/media/2015/05/AA_GraphicalRunbook.png)

* Azure Automation has now two types of runbooks, graphical and textual. While both essentially still run PowerShell Workflow, while creating a graphical runbook you don't have to think about that and (for now at least) you are unable to see the actual code.

# Hybrid runbook workers for Azure Automation

* Wow! When I saw this I thought "Yes, that's what I want". Hook up on-premises servers into your Azure Automation environment. These servers will receive jobs from Azure Automation, execute them and report back the results. No details yet as to how this will be charged to customers (will workloads executed on-premises be part of the free 500mins/month?), but I am very excited to see Azure Automation evolve into this.

# Webhooks for Azure Automation

* Continuous Deployment is now a lot easier with Webhooks supported for Azure Automation
* Set up a webhook to git or any other of your Source Control products and whenever you push something to your repository (commit and sync) a specific Azure Automation runbook can be kicked off which will (for example) import that new commit as a new runbook into Azure Automation

# Desired State Configuration on Azure

* Azure Automation DSC allows you to manage PowerShell Desired State Configuration in the cloud. Cloud or on-premises servers can retrieve these configurations, conform to the desired state they specify, and report back on their compliance.
* Essentially, this is a PowerShell DSC Pull Server in the cloud

Seeing how Azure Automation progresses only shows that those people still betting on Orchestrator and its "drag and drop" activities are still living in the past. SMA will most likely get all those new graphical UI runbooks as well, but you still need to know how to write PowerShell. Just recently I was told that admins and users of such orchestration tools should not be expected to be able to write code / scripts. Alright, I thought that guy was plain wrong and missed a couple of very important announcements in the industry.

This is not a complete list of new stuff, these are just features I am excited to see. They all make sense to be hosted on Azure and I'm looking forward to be using them in real life.

Stay tuned for some more detailed articles on certain features.

[David](http://www.twitter.com/david_obrien)


