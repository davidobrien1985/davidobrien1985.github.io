---
id: 1950
title: ConfigMgr Application catalog broken
date: 2014-10-04T00:29:31+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1950
permalink: /2014/10/configmgr-application-catalog-broken/
categories:
  - ConfigMgr
  - Microsoft
  - SCCM
tags:
  - application catalog
  - ConfigMgr
  - Microsoft
  - SCCM
---
I just had an issue at a customer&#8217;s site where the ConfigMgr Application Catalogs would complain. Here&#8217;s the quick and easy solution to it.

# Server Error in &#8216;/CMApplicationCatalog&#8217; Application

This customer does quite a lot of customisation on their servers. Granting permissions, taking them away, redirecting folders from here to there.

They for example redirect the system temp to C:\temp and take away all the permissions the user &#8216;Local Service&#8217; has to that temp directory.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/10/image2.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/10/image2.png', '']);" class="broken_link"><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb2.png" alt="image" width="244" height="136" border="0" /></a>

As soon as I added &#8216;Local Service&#8217; again with full permissions, all was fine and the ConfigMgr Application Catalog started up again.

&#8211; <a href="www.twitter.com/david_obrien" target="_blank" class="broken_link">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="application+catalog,ConfigMgr,Microsoft,SCCM" data-count="vertical" data-url="http://www.david-obrien.net/2014/10/configmgr-application-catalog-broken/">Tweet</a>
</div>
