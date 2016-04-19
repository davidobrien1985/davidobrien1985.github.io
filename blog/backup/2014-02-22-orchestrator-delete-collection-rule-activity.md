---
id: 1655
title: 'Orchestrator &ndash; Delete Collection Rule activity'
date: 2014-02-22T00:29:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1655
permalink: /2014/02/orchestrator-delete-collection-rule-activity/
categories:
  - ConfigMgr
  - Orchestrator
  - SCCM
tags:
  - ConfigMgr
  - Orchestrator
  - SCCM
  - SCOrch
  - System Center
---
<p class="">
  While writing my last article I discovered a little issue with one of the Microsoft System Center Configuration Manager activities you’ll get by importing the Integration Pack for Orchestrator.
</p>

<a href="/media/2015/03/1426821342_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/03/1426821342_full.png', '']);" target="_blank"><img src="/media/2015/03/1426821342_thumb.png" align="middle" class="full aligncenter" title="" alt="" /></a> 

<p class="">
</p>

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image10.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image10.png', '']);" class="broken_link"></a> 

<p class="">
  Adding that activity and editing it will make it look like this:
</p>

<a href="/media/2015/03/1426821385_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/03/1426821385_full.png', '']);" target="_blank"><img src="/media/2015/03/1426821385_thumb.png" align="middle" class="full aligncenter" title="" alt="" /></a> 

<p class="">
</p>

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image11.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image11.png', '']);" class="broken_link"></a> 

If you plan to delete a Direct Membership Rule and now think “nice, it’s already preconfigured to do so”… nope, it’s not.

<p class="">
  Testing that runbook will give you this result:
</p>

<a href="/media/2015/03/1426821425_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/03/1426821425_full.png', '']);" target="_blank"><img src="/media/2015/03/1426821425_thumb.png" align="middle" class="full aligncenter" title="" alt="" /></a> 

<p class="">
</p>

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image12.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image12.png', '']);" class="broken_link"></a>
  


> Direct is not a valid Rule Type</p>
Aha… Checking the “Membership Rule Type” selection we see what we actually need to put in there.

<a href="/media/2015/03/1426821467_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/03/1426821467_full.png', '']);" target="_blank"><img src="/media/2015/03/1426821467_thumb.png" align="middle" class="full aligncenter" title="" alt="" /></a> 

<p class="">
</p>

<a href="http://www.david-obrien.net/wp-content/uploads/2014/02/image13.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/02/image13.png', '']);" class="broken_link"></a> 

Thought I’d share, because it took me two failures to actually properly read the error message and find what’s wrong.

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Orchestrator,SCCM,SCOrch,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2014/02/orchestrator-delete-collection-rule-activity/">Tweet</a>
</div>
