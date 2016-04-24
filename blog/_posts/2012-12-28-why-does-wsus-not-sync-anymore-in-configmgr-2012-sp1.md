---
id: 594
title: Why does WSUS not sync anymore in ConfigMgr 2012 SP1?
date: 2012-12-28T22:05:00+00:00
author: "David O'Brien"
layout: single

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

![WSUS failed sync](/media/2012/12/WSUS_failed_sync.jpg "WSUS_failed_sync")

I went ahead and had a look at the WCM.log file:

![WSUS failed sync WCMlog](/media/2012/12/WSUS_failed_sync_WCMlog.jpg "WSUS_failed_sync_WCMlog")

Error 404, not found… but as a matter of fact, the real error is in the line above, it’s using port 80 to connect to my WSUS, which I never configured it to do.

## How to set the WSUS port in ConfigMgr 2012 SP1

Well, something during the upgrade to SP1 must have changed my configuration back to default, without telling me so. How to fix it? Go into your “Servers and Site System Roles” settings and open up the Software Update Point’s properties.

![WSUS config](/media/2012/12/WSUS_config.jpg "WSUS_config")

After I changed the ports back to the numbers I need, everything was fine again.

Would be great to know if anyone of you had the same problem or if it was just me (and one more from Twitter) :-)


