---
id: 1894
title: Add or remove features in MDT WinPE
date: 2014-08-06T15:56:35+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1894
permalink: /2014/08/add-remove-features-mdt-winpe/
categories:
  - automation
  - Deployment
  - MDT
  - Windows
tags:
  - automation
  - DISM
  - FeatureNames
  - MDT
  - MDT 2013
  - WinPE
  - XML
---
Not going too deep here, just something I found the other day.

In your MDT 2013 Deploymentshare, if you go to the share&#8217;s properties, you will find the WinPE Tab and the WinPE&#8217;s features:

<a href="/media/2014/12/image11.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image11.png', '']);" ><img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; border-left: 0px; display: block; padding-right: 0px; margin-right: auto" border="0" alt="image" src="/media/2014/12/image_thumb11.png" width="375" height="217" /></a>

In here you can add components to your boot images. These components are either in _C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools_ (like DaRT: <a href="http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx', 'http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx']);" title="http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx">http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx</a> ) or in your ADK install directory here: _C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs_

If you take a look at the latter, you might see that there are components in there that don&#8217;t show up in that list in your MDT Deploymentshare, for example WinPE-FMAPI.cab (File Management API).

Why is that?

That list is being built off of an XML file (like MDT uses a lot of XML files), which is _C:\Program Files\Microsoft Deployment Toolkit\Bin\FeatureNames.XML_

<a href="/media/2014/12/image12.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image12.png', '']);" ><img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; border-left: 0px; display: block; padding-right: 0px; margin-right: auto" border="0" alt="image" src="/media/2014/12/image_thumb12.png" width="386" height="235" /></a>

That file lists all the components MDT knows how to handle (don&#8217;t know how to else say it) and also defines whether or not that component will be included or excluded in that list. Obviously, WinPE-FMAPI is excluded (don&#8217;t know why!).

If you want to have it in your GUI as a component you can add and maybe at the same time take away the possibility to add some language packs, just change the XML to this:

<p align="center">
  <a href="/media/2014/12/image13.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image13.png', '']);" ><img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; margin: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="/media/2014/12/image_thumb13.png" width="386" height="232" /></a>
</p>

Restart your MDT Deployment Workbench, go back to the Deploymentshare&#8217;s properties and be happy <img class="img-responsive wlEmoticon wlEmoticon-smile" style="border-top-style: none; border-bottom-style: none; border-right-style: none; border-left-style: none" alt="Smile" src="/media/2014/12/wlEmoticon-smile.png" />

<a href="/media/2014/12/image14.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image14.png', '']);" ><img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; border-left: 0px; display: block; padding-right: 0px; margin-right: auto" border="0" alt="image" src="/media/2014/12/image_thumb14.png" width="382" height="314" /></a>

Have fun deploying your WinPEs!

&#8211; <a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,DISM,FeatureNames,MDT,MDT+2013,WinPE,XML" data-count="vertical" data-url="http://www.david-obrien.net/2014/08/add-remove-features-mdt-winpe/">Tweet</a>
</div>
