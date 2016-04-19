---
id: 3048
title: 'Azure Automation - graphical runbooks'
date: 2015-05-05T07:00:38+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=3048
permalink: /2015/05/azure-automation-graphical-runbooks/
categories:
  - Azure
  - Azure Automation
  - Cloud
  - PowerShell
tags:
  - Azure
  - Azure Automation
  - Cloud
  - GUI
  - Ignite
  - Microsoft
  - Orchestrator
  - Powershell
  - System Center
---
# Microsoft Ignite

Microsoft Ignite 2015 conference is in full swing and they have already announced a lot of cool things at last week's Build conference that we've seen covered in a lot of articles. This article here will focus on one of the new features in Azure Automation.
  
I have already touched this in my <a href="http://www.david-obrien.net/2015/05/azure-automation-whats-new" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2015/05/azure-automation-whats-new', 'last article here']);" target="_blank">last article here</a>, Azure Automation now comes with a graphical user interface to author runbooks.

## Why do you need an Azure Automation GUI?

To be honest, no idea, but it's something still a lot of people think they need. Funny thing is, they say that thinking that they can't expect everybody to be able to code. True, but if you want to still be around in the upcoming future (jobwise, in IT), you kinda do.

# Authoring runbooks on Azure Automation

You basically now have got two options to author runbooks, a textual and a graphical option. Make your choice, you **cannot** convert a runbook afterwards. At least not yet, maybe later.
  
How does it look like authoring a graphical runbook now? Is it like System Center Orchestrator? Fortunately not!

<a href="/media/2015/05/AA_Runbooks.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/AA_Runbooks.png', '']);" ><img class="img-responsive aligncenter wp-image-3050 size-medium" src="/media/2015/05/AA_Runbooks-300x82.png" alt="AA_Runbooks" width="300" height="82" srcset="/media/2015/05/AA_Runbooks-300x82.png 300w, /media/2015/05/AA_Runbooks.png 828w" sizes="(max-width: 300px) 100vw, 300px" /></a>

The first runbook's icon means the runbook is a textual runbook, like we are already used to from SMA or Azure Automation previously, the second runbook's icon means the runbook is a graphical one.

## Azure Automation Runbook Pane

Clicking a graphical runbook will open up the next pane (by the way, I really like the new Azure Portal!). Here you will see all details of that runbook as an overview.

<a href="/media/2015/05/RB_Overview.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/RB_Overview.png', '']);" ><img class="img-responsive aligncenter wp-image-3053 " src="/media/2015/05/RB_Overview-300x280.png" alt="Azure Automation Runbook Overview" width="233" height="217" /></a>

Hit edit and we'll get to the actual editing pane.
  
What we'll see next is new.

<a href="/media/2015/05/RB_Editing1.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/RB_Editing1.png', '']);" ><img class="img-responsive aligncenter wp-image-3057 size-medium" src="/media/2015/05/RB_Editing1-300x145.png" alt="Azure Automation Runbook Editor" width="300" height="145" srcset="/media/2015/05/RB_Editing1-300x145.png 300w, /media/2015/05/RB_Editing1-1024x495.png 1024w, /media/2015/05/RB_Editing1-768x372.png 768w, /media/2015/05/RB_Editing1.png 1349w" sizes="(max-width: 300px) 100vw, 300px" /></a>

On the left there are all the activities we can add to our runbook, such as cmdlets, runbooks, assets and "runbook control". Most of the times we will have to work with the cmdlets section I would assume. So what is it?

## Adding cmdlets to Azure Automation runbooks

By default there are 7 modules available in Azure Automation to choose from. Expanding the cmdlets node exposes them.

<a href="/media/2015/05/RB_cmdlets.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/RB_cmdlets.png', '']);" ><img class="img-responsive aligncenter size-thumbnail wp-image-3055" src="/media/2015/05/RB_cmdlets-150x150.png" alt="Azure Automation cmdlets" width="150" height="150" /></a>

Pick a cmdlet, like Add-AzureAccount, which is part of the "Azure" module, right-cklick it and "Add to Canvas". It will now show up in the centre pane and be available to be configured. A click on an added cmdlet will populate the pane on the right with fields that need to be configured in order for that cmdlet to run. So here we need to fill parameters with values for example.

<a href="/media/2015/05/RB_Activity.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/RB_Activity.png', '']);" ><img class="img-responsive aligncenter wp-image-3056 size-medium" src="/media/2015/05/RB_Activity-300x208.png" alt="Azure Automation Runbook Activity" width="300" height="208" srcset="/media/2015/05/RB_Activity-300x208.png 300w, /media/2015/05/RB_Activity.png 909w" sizes="(max-width: 300px) 100vw, 300px" /></a>

I will not go into detail as to how each and every cmdlet can be configured, the Runbook Editor keeps that task fairly easy.
  
Having only 7 modules at hand is a bit restricting, so we need to make more modules available. Joe Levy wrote a good article about creating Azure Automation Integration Modules: <a href="http://azure.microsoft.com/blog/2014/12/15/authoring-integration-modules-for-azure-automation/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://azure.microsoft.com/blog/2014/12/15/authoring-integration-modules-for-azure-automation/', 'http://azure.microsoft.com/blog/2014/12/15/authoring-integration-modules-for-azure-automation/']);" target="_blank">http://azure.microsoft.com/blog/2014/12/15/authoring-integration-modules-for-azure-automation/</a>

## Links

What is making this whole graphical editing / authoring so interesting is seeing the actual flow of activities in our runbook, something that is hard to grasp from just looking at code. However, I am not saying that it's impossible to understand code.
  
Links make the graphical authoring so powerful and easy to configure. You configure an activity, add a second one and tie them to each other by creating a link, just like you did in System Center Orchestrator. Links can be configured to run in two different modes, as a Pipeline or a Sequence.

A Pipeline would be the equivalent of a foreach loop in PowerShell, whereas a Sequence is just telling the runbook to go to the next activity.

Links can have conditions and basically act like the Data Bus in System Center Orchestrator.
  
However, you can't configure colours on those links, that's something a lot of people did in Orchestrator.

## Call runbook from runbook

Obviously, the concept of modularity still applies. We do not want to have one huge runbook with a million steps that nobody will understand. We want small runbooks where we know exactly what they do and then call those runbooks from a "master" or "control" runbook. In the left pane, right under cmdlets, we can call runbooks from our runbook. That child runbook will then execute the task and populate data back to the parent runbook's data bus.

## PowerShell Workflow

If all this is still not enough, you can still write actual PowerShell Workflow and add that to your runbook. Expand "Runbook Control" and add the "Workflow Script" activity to your canvas.

<a href="/media/2015/05/RB_Workflow.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/05/RB_Workflow.png', '']);" ><img class="img-responsive aligncenter wp-image-3059 size-medium" src="/media/2015/05/RB_Workflow-300x276.png" alt="Azure Automation PowerShell Workflow" width="300" height="276" srcset="/media/2015/05/RB_Workflow-300x276.png 300w, /media/2015/05/RB_Workflow.png 869w" sizes="(max-width: 300px) 100vw, 300px" /></a>

# Why a graphical UI to author Azure Automation runbooks?

I still don't understand why this was something so many people were apparently asking for, but from the first looks, Microsoft did a good job at implementing it. You still need to know PowerShell, you still need to understand the code you are writing and the flow of data in that code. What you might not have to worry about as much is handling the peculiarities of PowerShell Workflow. Although, only time will tell what people will prefer in real life as their choice of runbook type.

As it stands now you cannot export graphical runbooks, so you cannot view the actual code behind the scenes. There's no way of converting a graphical runbook into a textual runbook or vice-versa.

However, this can all change in the future.

This was just a first look at the new graphical runbooks in Azure Automation. I am looking forward to testing this new way of authoring runbooks on Azure.

Here are the other articles from my Ignite series so far:
  
Azure Automation – what’s new?

What are your thoughts on this?

- <a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Azure,Azure+Automation,Cloud,GUI,Ignite,Microsoft,Orchestrator,Powershell,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2015/05/azure-automation-graphical-runbooks/">Tweet</a>
</div>

