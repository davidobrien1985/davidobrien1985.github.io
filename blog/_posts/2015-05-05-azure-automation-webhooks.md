---
id: 3062
title: Azure Automation - Webhooks
date: 2015-05-05T09:00:57+00:00
author: "David O'Brien"
layout: single

permalink: /2015/05/azure-automation-webhooks/
categories:
  - Azure
  - Azure Automation
  - Ignite
  - Microsoft
tags:
  - Azure Automation
  - Continuous Deployment
  - git
  - github
  - TFS
  - web hooks
  - Webhooks
---
# Continuous Deployment with Azure Automation

This part of my "What's new in Azure Automation" series will focus on something that a lot of people (me included) are quite excited about - Webhooks.

## What is a webhook?

Github has a very good explanation of webhooks:

> Webhooks allow you to build or set up integrations which subscribe to certain events on GitHub.com. When one of those events is triggered, we’ll send a HTTP POST payload to the webhook’s configured URL. Webhooks can be used to update an external issue tracker, trigger CI builds, update a backup mirror, or even deploy to your production server. You’re only limited by your imagination.

What that means is that you can now do something on, for example, github and that automatically triggers a runbook on Azure Automation.

Webhooks were already previously available for Azure websites.

## Why use webhooks with Azure Automation?

The first use case that came to my mind was the following. Somebody commits a change to a git(hub) repository, this commit triggers a runbook and that runbook can get the new commit and import it as a new (textual) runbook into Azure Automation. It could maybe even execute the new runbook and test if it ran successfully.

This is the whole idea behind Continuous Deployment, automated deployment of newly developed content into your environment (test / dev / prod).

There are so many use cases where webhooks can now support you in your work, it doesn't need to be git, there are other services in which you can hook into. Maybe you have your own service developed in-house?

# How to set up webhook from Github to Azure Automation?

All you have to do is create your webhook on a published runbook. This is important, your runbook has to be published, otherwise you won't be able to create a webhook.

![Azure Automation webhook](/media/2015/05/RB_Webhook.png)

Copy the URL, that's also important, as you won't be able to view that URL after creating the webhook. Now go to your service, for example github, and add that URL. For github this would look like this:

![Azure Automation webhook Github](/media/2015/05/Github_Webhook.png)

Paste the URL into the first text box and keep the content type as application/JSON.

## Access the webhook data in an Azure Automation runbook

Every commit (or whatever type of trigger you configure) will now call that runbook and provide it with an input parameter called webhookData. This webhookData can be accessed during the called runbook with this code: (just an example)

```
Workflow Test-Workflow
{
Param(
  [object]
  $webhookData
)

  $a = $webhookData | ConvertTo-Json

  $b = $a | ConvertFrom-Json

  $RequestBody = $b.RequestBody | ConvertFrom-Json
  $RequestBody
}
```

From here on your imagination is the limit I would say. I will absolutely check this out further and see what I can come up with.

Exciting times ahead!

