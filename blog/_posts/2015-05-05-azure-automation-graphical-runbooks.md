---
id: 3048
title: Azure Automation - graphical runbooks
date: 2015-05-05T07:00:38+00:00

layout: single

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

I have already touched this in my [last article here](/2015/05/azure-automation-whats-new), Azure Automation now comes with a graphical user interface to 

## Why do you need an Azure Automation GUI?

To be honest, no idea, but it's something still a lot of people think they need. Funny thing is, they say that thinking that they can't expect everybody to be able to code. True, but if you want to still be around in the upcoming future (jobwise, in IT), you kinda do.

## 

You basically now have got two options to 

How does it look like 

![Azure Automation Runbooks](/media/2015/05/AA_Runbooks.png)

The first runbook's icon means the runbook is a textual runbook, like we are already used to from SMA or Azure Automation previously, the second runbook's icon means the runbook is a graphical one.

## Azure Automation Runbook Pane

Clicking a graphical runbook will open up the next pane (by the way, I really like the new Azure Portal!). Here you will see all details of that runbook as an overview.

![Azure Automation Runbooks overview](/media/2015/05/RB_Overview.png)

Hit edit and we'll get to the actual editing pane.

What we'll see next is new.

![Azure Automation Runbook editing](/media/2015/05/RB_Editing1.png)

On the left there are all the activities we can add to our runbook, such as cmdlets, runbooks, assets and "runbook control". Most of the times we will have to work with the cmdlets section I would assume. So what is it?

## Adding cmdlets to Azure Automation runbooks

By default there are 7 modules available in Azure Automation to choose from. Expanding the cmdlets node exposes them.

![Azure Automation PowerShell modules](/media/2015/05/RB_cmdlets.png)

Pick a cmdlet, like Add-AzureAccount, which is part of the "Azure" module, right-cklick it and "Add to Canvas". It will now show up in the centre pane and be available to be configured. A click on an added cmdlet will populate the pane on the right with fields that need to be configured in order for that cmdlet to run. So here we need to fill parameters with values for example.

![Azure Automation Activities](/media/2015/05/RB_Activity.png)

I will not go into detail as to how each and every cmdlet can be configured, the Runbook Editor keeps that task fairly easy.

Having only 7 modules at hand is a bit restricting, so we need to make more modules available. Joe Levy wrote a good article about creating Azure Automation Integration Modules: [http://azure.microsoft.com/blog/2014/12/15/

## Links

What is making this whole graphical editing / 

Links make the graphical 

A Pipeline would be the equivalent of a foreach loop in PowerShell, whereas a Sequence is just telling the runbook to go to the next activity.

Links can have conditions and basically act like the Data Bus in System Center Orchestrator.

However, you can't configure colours on those links, that's something a lot of people did in Orchestrator.

## Call runbook from runbook

Obviously, the concept of modularity still applies. We do not want to have one huge runbook with a million steps that nobody will understand. We want small runbooks where we know exactly what they do and then call those runbooks from a "master" or "control" runbook. In the left pane, right under cmdlets, we can call runbooks from our runbook. That child runbook will then execute the task and populate data back to the parent runbook's data bus.

## PowerShell Workflow

If all this is still not enough, you can still write actual PowerShell Workflow and add that to your runbook. Expand "Runbook Control" and add the "Workflow Script" activity to your canvas.

![Azure Automation workflow](/media/2015/05/RB_Workflow.png)

## Why a graphical UI to 

I still don't understand why this was something so many people were apparently asking for, but from the first looks, Microsoft did a good job at implementing it. You still need to know PowerShell, you still need to understand the code you are writing and the flow of data in that code. What you might not have to worry about as much is handling the peculiarities of PowerShell Workflow. Although, only time will tell what people will prefer in real life as their choice of runbook type.

As it stands now you cannot export graphical runbooks, so you cannot view the actual code behind the scenes. There's no way of converting a graphical runbook into a textual runbook or vice-versa.

However, this can all change in the future.

This was just a first look at the new graphical runbooks in Azure Automation. I am looking forward to testing this new way of 

Here are the other articles from my Ignite series so far:

Azure Automation – what’s new?

What are your thoughts on this?


