---
id: 1093
title: Deploy Google Chrome with ConfigMgr 2012
date: 2013-07-20T01:04:22+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1093
permalink: /2013/07/deploy-google-chrome-with-configmgr-2012/
categories:
  - ConfigMgr
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Deployment
tags:
  - Chrome
  - CM12
  - ConfigMgr 2012
  - deployment
  - GoogleChrome
  - System Center Configuration Manager
---
Some of you might have already read on Twitter that I'm currently doing a little 'experiment'.
  
About a month ago I got me a Surface Pro and said to myself, "Now that you got it, you have to use it!" and started to think about how to do that. I came to the conclusion that all the stuff I do on my laptop (Mail, browsing, Word, Powerpoint, Excel) can easily be transfered to the Surface, what about demo labs? Well, that's why I still have the laptop... more in a separate article.

This article will be about deploying Google Chrome with ConfigMgr 2012 to my notebook, which in fact now is managed by my ConfigMgr site.

It's no technical deep-dive, but I hope that it still helps some people with deploying Chrome.

## Deploying Google Chrome

Chrome is my favourite browser and usually the first application I install on any new system of mine. That's why I also needed to install it on my notebook, a Windows Server 2012 R2 (preview). 😉

The deployment itself is pretty easy. Google is very kind in offering a MSI package to deploy it in enterprise environments: <a href="http://www.google.de/intl/en/chrome/business/browser/admin/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.google.de/intl/en/chrome/business/browser/admin/', 'http://www.google.de/intl/en/chrome/business/browser/admin/']);" >http://www.google.de/intl/en/chrome/business/browser/admin/</a>

They even give us loads of GPOs to configure the user experience: <a href="https://support.google.com/chrome/a/answer/187202" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://support.google.com/chrome/a/answer/187202', 'https://support.google.com/chrome/a/answer/187202']);" >https://support.google.com/chrome/a/answer/187202</a>

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/policies.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/policies.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Google Chrome Policies" alt="Google Chrome Policies" src="http://www.david-obrien.net/wp-content/uploads/2013/07/policies_thumb.jpg" width="228" height="244" border="0" /></a>

After downloading the MSI from above link you're able to deploy Chrome with ConfigMgr.
  
I'm a big fan of the new Application Model for client deployments (not so much for servers, but that's a different story) and seeing that we already have a MSI, what more could we ask for?

This is how I configured it in ConfigMgr:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation4.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation4.jpg', '']);" class="broken_link"><img style="display: inline; border: 0px;" title="App_creation4" alt="App_creation4" src="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation4_thumb.jpg" width="244" height="201" border="0" /></a> <a href="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation1.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation1.jpg', '']);" class="broken_link"><img style="display: inline; border: 0px;" title="App_creation1" alt="App_creation1" src="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation1_thumb.jpg" width="244" height="200" border="0" /></a> <a href="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation2.jpg', '']);" class="broken_link"><img style="display: inline; border: 0px;" title="App_creation2" alt="App_creation2" src="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation2_thumb.jpg" width="244" height="202" border="0" /></a> <a href="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation3.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation3.jpg', '']);" class="broken_link"><img style="display: inline; border: 0px;" title="App_creation3" alt="App_creation3" src="http://www.david-obrien.net/wp-content/uploads/2013/07/App_creation3_thumb.jpg" width="244" height="201" border="0" /></a>

The nice thing with MSI applications is they get their Detection Method created automatically based on the Product Code:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/DT_2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/DT_2.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="Detection Method" alt="Detection Method" src="http://www.david-obrien.net/wp-content/uploads/2013/07/DT_2_thumb.jpg" width="244" height="210" border="0" /></a>

I deployed it for a specific user and had a look at the user's Software Center / Application Catalog and there was my new deployment:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/appcatalog_1.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/appcatalog_1.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="appcatalog_1" alt="appcatalog_1" src="http://www.david-obrien.net/wp-content/uploads/2013/07/appcatalog_1_thumb.jpg" width="244" height="128" border="0" /></a>I don't need an administrator's approval to install the application so I can continue right away until this little fellow tells me that everything went fine:

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/softwarecenter_2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/softwarecenter_2.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="softwarecenter_2" alt="softwarecenter_2" src="http://www.david-obrien.net/wp-content/uploads/2013/07/softwarecenter_2_thumb.jpg" width="244" height="140" border="0" /></a>  I can confirm the successful installation by looking at the AppEnforce.log on the client, which tells me exactly what happened during execution.

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/log_2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/log_2.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="AppEnforce.log" alt="AppEnforce.log" src="http://www.david-obrien.net/wp-content/uploads/2013/07/log_2_thumb.jpg" width="244" height="119" border="0" /></a>

## Google Chrome Policies

In the beginning I said that Google provides an admin with GPOs to configure the user's experience. Here's just a quick example for some settings if you take a look at chrome://settings

<a href="http://www.david-obrien.net/wp-content/uploads/2013/07/chrome_settings.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/07/chrome_settings.jpg', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="chrome_settings" alt="chrome_settings" src="http://www.david-obrien.net/wp-content/uploads/2013/07/chrome_settings_thumb.jpg" width="244" height="236" border="0" /></a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Chrome,CM12,ConfigMgr+2012,deployment,GoogleChrome,System+Center+Configuration+Manager" data-count="vertical" data-url="http://www.david-obrien.net/2013/07/deploy-google-chrome-with-configmgr-2012/">Tweet</a>
</div>

