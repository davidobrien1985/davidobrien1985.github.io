---
id: 1093
title: Deploy Google Chrome with ConfigMgr 2012
date: 2013-07-20T01:04:22+00:00
author: "David O'Brien"
layout: single

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

The deployment itself is pretty easy. Google is very kind in offering a MSI package to deploy it in enterprise environments: [http://www.google.de/intl/en/chrome/business/browser/admin/](http://www.google.de/intl/en/chrome/business/browser/admin/)

They even give us loads of GPOs to configure the user experience: [https://support.google.com/chrome/a/answer/187202](https://support.google.com/chrome/a/answer/187202)

![Chrome policies](/media/2013/07/policies.jpg)

After downloading the MSI from above link you're able to deploy Chrome with ConfigMgr.

I'm a big fan of the new Application Model for client deployments (not so much for servers, but that's a different story) and seeing that we already have a MSI, what more could we ask for?

This is how I configured it in ConfigMgr:

![image](/media/2013/07/App_creation4.jpg)
![image](/media/2013/07/App_creation1.jpg)
![image](/media/2013/07/App_creation2.jpg)
![image](/media/2013/07/App_creation3.jpg)

The nice thing with MSI applications is they get their Detection Method created automatically based on the Product Code:

![detection method](/media/2013/07/DT_2.jpg)

I deployed it for a specific user and had a look at the user's Software Center / Application Catalog and there was my new deployment:

![appcatalog](/media/2013/07/appcatalog_1.jpg)

I don't need an administrator's approval to install the application so I can continue right away until this little fellow tells me that everything went fine:

![software center](/media/2013/07/softwarecenter_2.jpg)

I can confirm the successful installation by looking at the AppEnforce.log on the client, which tells me exactly what happened during execution.

![image](/media/2013/07/log_2.jpg)

## Google Chrome Policies

In the beginning I said that Google provides an admin with GPOs to configure the user's experience. Here's just a quick example for some settings if you take a look at chrome://settings

![image](/media/2013/07/chrome_settings.jpg)


