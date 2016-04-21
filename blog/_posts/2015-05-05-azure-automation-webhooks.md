---
id: 3062
title: Azure Automation - Webhooks
date: 2015-05-05T09:00:57+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3062
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

[<img class="img-responsive aligncenter wp-image-3064 size-medium" src="/media/2015/05/RB_Webhook-298x300.png" alt="Azure Automation create webhook" width="298" height="300" srcset="/media/2015/05/RB_Webhook-298x300.png 298w, /media/2015/05/RB_Webhook.png 624w" sizes="(max-width: 298px) 100vw, 298px" />](/media/2015/05/RB_Webhook.png)

Copy the URL, that's also important, as you won't be able to view that URL after creating the webhook. Now go to your service, for example github, and add that URL. For github this would look like this:

[<img class="img-responsive aligncenter wp-image-3065 size-medium" src="/media/2015/05/Github_Webhook-300x196.png" alt="Github webhook" width="300" height="196" srcset="/media/2015/05/Github_Webhook-300x196.png 300w, /media/2015/05/Github_Webhook.png 931w" sizes="(max-width: 300px) 100vw, 300px" />](/media/2015/05/Github_Webhook.png)

Paste the URL into the first text box and keep the content type as application/JSON.

# Access the webhook data in an Azure Automation runbook

Every commit (or whatever type of trigger you configure) will now call that runbook and provide it with an input parameter called webhookData. This webhookData can be accessed during the called runbook with this code: (just an example)

<div id="wpshdo_37" class="wp-synhighlighter-outer">
  <div id="wpshdt_37" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_37"></a><a id="wpshat_37" class="wp-synhighlighter-title" href="#codesyntax_37"  onClick="javascript:wpsh_toggleBlock(37)" title="Click to show/hide code block">Source code</a>
        </td>

        <td align="right">
          <a href="#codesyntax_37" onClick="javascript:wpsh_code(37)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_37" onClick="javascript:wpsh_print(37)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>

  <div id="wpshdi_37" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Workflow Test<span class="sy0">-Workflow
<span class="br0">&#123;
<span class="kw3">Param<span class="br0">&#40;
<span class="br0">[<span class="re3">object<span class="br0">]
<span class="re0">$webhookData
<span class="br0">&#41;
&nbsp;
<span class="re0">$a <span class="sy0">= <span class="re0">$webhookData <span class="sy0">| ConvertTo<span class="sy0">-Json
&nbsp;
<span class="re0">$b <span class="sy0">= <span class="re0">$a <span class="sy0">| ConvertFrom<span class="sy0">-Json
&nbsp;
<span class="re0">$RequestBody <span class="sy0">= <span class="re0">$b.RequestBody <span class="sy0">| ConvertFrom<span class="sy0">-Json
<span class="re0">$RequestBody
<span class="br0">&#125;
  </div>
</div>

From here on your imagination is the limit I would say. I will absolutely check this out further and see what I can come up with.

Exciting times ahead!

- <a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Azure+Automation,Continuous+Deployment,git,github,TFS,web+hooks,Webhooks" data-count="vertical" data-url="http://www.david-obrien.net/2015/05/azure-automation-webhooks/">Tweet</a>
</div>


