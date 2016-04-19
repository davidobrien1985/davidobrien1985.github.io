---
id: 399
title: Updating Configuration Manager 2012 to Service Pack 1
date: 2012-06-17T10:36:05+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=399
permalink: /2012/06/updating-configuration-manager-2012-to-service-pack-1/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
  - System Center Configuration Manager
  - Windows 8
tags:
  - ADK
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Microsoft
  - System Center
  - System Center Configuration Manager
  - Windows 8
---
You most probably already know that the “Service Pack 1 Customer Technology Preview 2” for System Center Configuration Manager 2012 has been released a few days ago. If not, here: <a href="http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx', 'http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx']);" >http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx</a>

It’s an early sunday morning, the fiancee is still asleep and I wanted to “quickly” update my virtual ConfigMgr 2012 environment to SP1, and got stuck…

# New Prerequisites

As there are new features (see previous article: <a href="http://www.david-obrien.de/?p=369" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/?p=369', 'http://www.david-obrien.de/?p=369']);" >http://www.david-obrien.de/?p=369</a>), there are also new prerequisites you need to fulfil before being able to update your site.

<a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image2.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image2.png', '']);" class="broken_link"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb2.png" alt="image" width="244" height="162" border="0" /></a>
  
Go download and install the <a href="http://www.microsoft.com/en-us/download/details.aspx?id=28997" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.microsoft.com/en-us/download/details.aspx?id=28997', 'Windows 8 Assessment and Deployment Kit (ADK)']);" target="_blank" class="broken_link">Windows 8 Assessment and Deployment Kit (ADK)</a>, this in itself is just under 1MB size but it will download a huge amount of data during installation (approx. 3GB, depending on what features you install).

You also need to run the setupdl.exe (found in “smssetupbinx64”) or download the prerequisites from the GUI. This won’t download the ADK!
  
It will, for example, download the Silverlight 5 binaries.

If any of your sites have a language pack installed, you will need to uninstall it before updating your site.

<a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image3.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image3.png', '']);" class="broken_link"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb3.png" alt="image" width="244" height="72" border="0" /></a>

Do this by running setup again and chose “site maintenance” and then “modify language settings”.

# 

# Update the site

<p align="left">
  Before updating my sites I had a look at the buildnumbers:
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image4.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image4.png', '']);" class="broken_link"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb4.png" alt="image" width="244" height="28" border="0" /></a>
</p>

<p align="left">
  The update is quite straightforward, here some screenshots of it:
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image5.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image5.png', '']);" class="broken_link"><img style="background-image: none; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb5.png" alt="image" width="244" height="183" border="0" /></a>
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image6.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image6.png', '']);" class="broken_link"><img style="background-image: none; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb6.png" alt="image" width="244" height="184" border="0" /></a>
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image7.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image7.png', '']);" class="broken_link"><img style="background-image: none; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb7.png" alt="image" width="244" height="184" border="0" /></a><br /> No errors, only warnings from my virtual environment…
</p>

<p align="left">
  The whole update took about 40minutes (in my virtual environment):
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image8.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image8.png', '']);" class="broken_link"><img style="background-image: none; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb8.png" alt="image" width="244" height="183" border="0" /></a>
</p>

<p align="left">
  Updated the CAS:
</p>

<p align="center">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image9.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image9.png', '']);" class="broken_link"><img style="background-image: none; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb9.png" alt="image" width="244" height="29" border="0" /></a>
</p>

<p align="left">
  I don’t want to get into details (that’s for another article), but the Boot images got updated to “Windows 8”.
</p>

<p align="left">
  <a href="http://www.david-obrien.de/wp-content/uploads/2012/06/image10.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/06/image10.png', '']);" class="broken_link"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border: 0px;" title="image" src="http://www.david-obrien.de/wp-content/uploads/2012/06/image_thumb10.png" alt="image" width="244" height="38" border="0" /></a>
</p>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ADK,ConfigMgr,ConfigMgr+2012,ConfigMgr2012,Configuration+Manager,Configuration+Manager+2012,Microsoft,System+Center,System+Center+Configuration+Manager,Windows+8" data-count="vertical" data-url="http://www.david-obrien.net/2012/06/updating-configuration-manager-2012-to-service-pack-1/">Tweet</a>
</div>
