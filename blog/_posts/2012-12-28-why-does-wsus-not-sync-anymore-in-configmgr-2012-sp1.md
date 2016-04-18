---
id: 594
title: Why does WSUS not sync anymore in ConfigMgr 2012 SP1?
date: 2012-12-28T22:05:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=594
permalink: /2012/12/why-does-wsus-not-sync-anymore-in-configmgr-2012-sp1/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - Configuration Manager
  - SCCM
  - System Center
  - System Center Configuration Manager
  - WSUS
---
# Issue with Software Update Point synchronization after SP1 update in SCCM 2012

This article is just as an information for everybody in the same situation. I can’t give any evidence for it being true, it’s just an observation I made (and at least one guy on Twitter confirmed it!).

After doing my Microsoft System Center 2012 SP1 Configuration Manager upgrade (in-place, no fresh install) I wanted to check the latest updates on my Software Update Point and was quite surprised seeing no new ones.
  
Okay, it was offline for a while and I only sync every 14 days in my Lab, so I synced manually.

After a few minutes I checked again and saw nothing, no new updates.

So I had a look at the components status page and WCM.log and found that there was some error:

<a href="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync.jpg', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="WSUS_failed_sync" alt="WSUS_failed_sync" src="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync_thumb.jpg" width="423" height="39" border="0" /></a>

I went ahead and had a look at the WCM.log file:

<p align="center">
  <a href="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync_WCMlog.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync_WCMlog.jpg', '']);" class="broken_link"><img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="WSUS_failed_sync_WCMlog" alt="WSUS_failed_sync_WCMlog" src="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_failed_sync_WCMlog_thumb.jpg" width="344" height="55" border="0" /></a>
</p>

<p align="left">
  Error 404, not found… but as a matter of fact, the real error is in the line above, it’s using port 80 to connect to my WSUS, which I never configured it to do.
</p>

<h2 align="left">
  How to set the WSUS port in ConfigMgr 2012 SP1
</h2>

<p align="left">
  Well, something during the upgrade to SP1 must have changed my configuration back to default, without telling me so.<br /> How to fix it?<br /> Go into your “Servers and Site System Roles” settings and open up the Software Update Point’s properties.
</p>

<p align="left">
  <a href="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_config.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_config.jpg', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="WSUS_config" alt="WSUS_config" src="http://www.david-obrien.net/wp-content/uploads/2012/12/WSUS_config_thumb.jpg" width="350" height="168" border="0" /></a>
</p>

After I changed the ports back to the numbers I need, everything was fine again.

Would be great to know if anyone of you had the same problem or if it was just me (and one more from Twitter) 
<img class="img-responsive wlEmoticon wlEmoticon-smile" style="border-style: none;" alt="Smile" src="http://www.david-obrien.net/wp-content/uploads/2012/12/wlEmoticon-smile1.png" /> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Configuration+Manager,SCCM,System+Center,System+Center+Configuration+Manager,WSUS" data-count="vertical" data-url="http://www.david-obrien.net/2012/12/why-does-wsus-not-sync-anymore-in-configmgr-2012-sp1/">Tweet</a>
</div>
