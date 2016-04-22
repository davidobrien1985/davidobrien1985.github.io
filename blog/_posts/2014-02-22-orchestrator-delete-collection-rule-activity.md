---
id: 1655
title: 'Orchestrator &ndash; Delete Collection Rule activity'
date: 2014-02-22T00:29:00+00:00
author: "David O'Brien"
layout: single
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

[<img src="/media/2015/03/1426821342_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/03/1426821342_full.png) 

<p class="">
</p>

[](/media/2014/02/image10.png) 

<p class="">
  Adding that activity and editing it will make it look like this:
</p>

[<img src="/media/2015/03/1426821385_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/03/1426821385_full.png) 

<p class="">
</p>

[](/media/2014/02/image11.png) 

If you plan to delete a Direct Membership Rule and now think “nice, it’s already preconfigured to do so”… nope, it’s not.

<p class="">
  Testing that runbook will give you this result:
</p>

[<img src="/media/2015/03/1426821425_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/03/1426821425_full.png) 

<p class="">
</p>

[](/media/2014/02/image12.png)
  


> Direct is not a valid Rule Type</p>
Aha… Checking the “Membership Rule Type” selection we see what we actually need to put in there.

[<img src="/media/2015/03/1426821467_thumb.png" align="middle" class="full aligncenter" title="" alt="" />](/media/2015/03/1426821467_full.png) 

<p class="">
</p>

[](/media/2014/02/image13.png) 

Thought I’d share, because it took me two failures to actually properly read the error message and find what’s wrong.

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

