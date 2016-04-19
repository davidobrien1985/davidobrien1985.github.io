---
id: 2191
title: 'ConfigMgr evaluation expired - what now?'
date: 2014-10-10T15:42:42+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2191
permalink: /2014/10/configmgr-evaluation-expired-now/
categories:
  - ConfigMgr
  - Configuration Manager
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - SCCM
  - System Center
---
I just rescued myself out of a pretty embarrassing situation... My home lab is managed by ConfigMgr and I am using the eval version for it, all good so far.

System Center 2012 eval versions are valid for 180 days, after that you either need to reinstall them or add a license key, whichever you like.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image3.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image3.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb3.png" alt="image" width="354" height="150" border="0" /></a>

&nbsp;

# How to add a license key to Configuration Manager post install

Adding the license key to ConfigMgr post install is pretty easy. Just run the setup.exe from your local ConfigMgr Installation directory. **DO NOT** use the installation media, it won't work!

Choose "Perform Site Maintenance or reset this site":

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image4.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image4.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb4.png" alt="image" width="303" height="221" border="0" /></a>

The next page normally let's you add a license key. Normally, that's **before** your version has expired.

As soon as it's expired ConfigMgr changes a registry key on the Site Server.

> _HKEY\_LOCAL\_MACHINE\SOFTWARE\Microsoft\SMS\Setup_ 

This key has a value of "Product ID" which can have two values itself, either "EVAL" or "NONEVAL".
  
As soon as an Eval version expires ConfigMgr sets that value from "EVAL" to "NONEVAL" and because of this the setup wizard will not show you the option to insert a license key.

Changing that value to "EVAL" again makes the setup wizard think that you are still running an Eval version and upon restart of setup.exe you are presented with the option to add a license key.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image5.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image5.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb5.png" alt="image" width="313" height="157" border="0" /></a>

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image6.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image6.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb6.png" alt="image" width="300" height="219" border="0" /></a>

After setup completion and a console restart the console now reflects the changes:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image7.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image7.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb7.png" alt="image" width="301" height="192" border="0" /></a>
  
I am not talking about supportability here, because I don't know if this is even supported. Anyway, if you need to ask yourself this question, you're probably doing something else very wrong. (like running an eval in production...)

- <a href="http://twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Configuration+Manager,SCCM,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2014/10/configmgr-evaluation-expired-now/">Tweet</a>
</div>

