---
id: 935
title: Live from E2EVC 2013 Copenhagen
date: 2013-05-27T20:48:13+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=935
permalink: /2013/05/live-from-e2evc-2013-copenhagen/
categories:
  - Community
  - E2EVC
  - System Center
  - System Center Configuration Manager
tags:
  - Community
  - ConfigMgr
  - Configuration Manager
  - E2EVC
  - speaker
  - System Center
---
# Live blog from E2EVC (aka Pubforum) 2013 Copenhagen

It’s only a few days left and just like I did <a href="http://www.david-obrien.net/2012/05/27/im-at-e2evc-2012-in-vienna-live-feed-2/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2012/05/27/im-at-e2evc-2012-in-vienna-live-feed-2/', 'last year']);" target="_blank">last year</a> in Vienna, I’m also doing a “live feed” from this year’s E2EVC in Copenhagen. Only this year I’m going to have two(!) speaker slots. One on Saturday morning and the other one on Sunday morning. My first slot will be about an installation framework for Citrix XenApp and other Citrix products like XenDesktop and Provisioning Services, which can be used as part of a System Center Configuration Manager deployment. The second slot will be about automation in a System Center 2012 environment, mostly around SCSM (Service Manager), Orchestrator and ConfigMgr.
  


## Speakers at E2EVC

I’m kinda proud to be part of such splendid and well-known speakers and community people at E2EVC. I won’t list them here, as Alex already did that on his site (<a href="http://www.e2evc.com/home/E2EVCPresenters.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.e2evc.com/home/E2EVCPresenters.aspx', 'http://www.e2evc.com/home/E2EVCPresenters.aspx']);" >http://www.e2evc.com/home/E2EVCPresenters.aspx</a> ) and I don’t want to miss any on them in my list. So follow my blog and this article to stay up to date on what’s happening at E2EVC in Copenhagen. I will update this article when in Copenhagen and you can also follow me on Twitter during the event <a href="https://twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/david_obrien', '@david_obrien']);" target="_blank">@david_obrien</a>
  


# First day of E2EVC

We arrived yesterday and already had a great day. Did a Bus-/Canaltour with Jeff Wouters (@<a href="http://twitter.com/Jeff_Wouters" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://twitter.com/Jeff_Wouters', 'Jeff_Wouters']);" target="_blank" class="broken_link">Jeff_Wouters</a>) and Carl Webster (@<a href="http://twitter.com/CarlWebster" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://twitter.com/CarlWebster', 'CarlWebster']);" target="_blank">CarlWebster</a>).

E2EVC 2013 Copenhagen will start in 30min with the Introduction by Alex Juschin. I’m already looking forward to all sessions, although I haven’t decided yet which I’m going to see. 

The keynotes are over and we heard news from Citrix Synergy and XenDesktop 7:

  * AppDNA is included in XenDesktop 7 Platinum
  * reverse seamless apps included in XenApp 6.5 FP2
  * Receiver 4 will support session pre-launch
  * Citrix PVS 7 will integrate into MS System Center 2012 Virtual Machine Manager

Sasa Masic told us about his vision of the future SBC. That Amazon Web Services is the big competitor to Microsoft, Citrix and VMware wasn’t too big of a surprise for me.

## App-V 5 – best practices, what’s new

Nicke Kallen talked about what’s new in AppV 5 and best practices.

  * lots of improvements with file type associations (FTA)
  * Connection groups
  * group virtuall apps into groups

  * shared content store
  * just an install switch
  * content on a network share
  * pointers on OS to network share
  * good for XenApp, XenDesktop, RDS, bad for Desktops

  * adding packages is slower
  * Office 2013 requires AppV 5, does not work in 4.6
  * per-computer / per-user publishing
  * web-based management interface
  * Integration into ConfigMgr 2012
  * no configuration on client
  * native support for 4.x/5

  * AppV5 packages does not support WinXP
  * package conversion from 4.6 to 5 done with Powershell cmdlets
  * use this GUI: <a href="http://www.michelstevelmans.com/nomorefour-appv-50-converter-gui-application/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.michelstevelmans.com/nomorefour-appv-50-converter-gui-application/', 'http://www.michelstevelmans.com/nomorefour-appv-50-converter-gui-application/']);" >http://www.michelstevelmans.com/nomorefour-appv-50-converter-gui-application/</a>

  * XML editor by VirtualEngine ACE: <a href="http://virtualengine.co.uk/2013/introducing-the-app-v-5-configuration-editor-ace/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://virtualengine.co.uk/2013/introducing-the-app-v-5-configuration-editor-ace/', 'http://virtualengine.co.uk/2013/introducing-the-app-v-5-configuration-editor-ace/']);" >http://virtualengine.co.uk/2013/introducing-the-app-v-5-configuration-editor-ace/</a>
  * KNOW YOUR APP! If you don’t know your app, don’t sequence it!

## Day 2 of E2EVC 2013

Early start for me. My first session about “XenApp automation Powershell framework” started at 8.15AM.  
Surprisingly a lot more people than I expected showed up at this time and lots of interesting questions were asked. Thanks for that. Of course my demo failed, my ConfigMgr server obviously crashed.  
If you want to know more about this framework, don’t hesitate to contact me. 

After me Carl Webster presented his brilliant Citrix documentation scripts, which should be EVERY consultant’s standard tool. 

Shawn Bass and Benny Tritsch demoed a comparison of remote protocols with some impressive results with RDP8 on Win7 and Win8, which looked nearly as good as Citrix XenDesktop or local experience.  
RDP8 looked good even on Win7, so just take a look at deploying it onto your Win7.

Helge Klein showed off his uberAgent for Splunk which is a really cool product giving you sooooo many more information on your environment than any other (or most) product.  
It was really cool watching that session and I really hope to find some time in the future to have a deeper look into uberAgent. Have a look at <a href="http://helgeklein.com/uberagent-for-splunk/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://helgeklein.com/uberagent-for-splunk/', 'http://helgeklein.com/uberagent-for-splunk/']);" >http://helgeklein.com/uberagent-for-splunk/</a> for more info.

That last session was a hard decision, “SCVMM” against “Powershell using CIM”. I decided to see SCVMM, sorry Jeff 😉

Thomas Maurer and Michael Rüefli talked about SCVMM 2012 mania.

  * changes regarding 2012 (legacy already) and 2012 SP1
  * bare-metal deployment
  * use VMM to deploy VMs
  * boot from VHD

  * demo by Thomas showing how bare-metal deployment works
  * fast update of servers
  * update services without downtime by letting VMM decide in which order to do it

### Conclusion Day 2

Been to VERY(!) interesting sessions today and again talked to a lot of intelligent people. It’s a shame that I couldn’t be at all the sessions, would’ve really liked to see Shawn Bass’s session which unfortunately was parallel to mine. But despite the early hour and “competing” against Shawn I was glad that so many people came to my session and gave me some nice feedback on it.

Looking forward to tomorrow and the next E2EVC in Rome.

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Community,ConfigMgr,Configuration+Manager,E2EVC,speaker,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2013/05/live-from-e2evc-2013-copenhagen/">Tweet</a>
</div>
