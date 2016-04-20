---
id: 1950
title: ConfigMgr Application catalog broken
date: 2014-10-04T00:29:31+00:00
author: "David O'Brien"
layout: single
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
I just had an issue at a customer's site where the ConfigMgr Application Catalogs would complain. Here's the quick and easy solution to it.

# Server Error in '/CMApplicationCatalog' Application

This customer does quite a lot of customisation on their servers. Granting permissions, taking them away, redirecting folders from here to there.

They for example redirect the system temp to C:\temp and take away all the permissions the user 'Local Service' has to that temp directory.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2014/10/image_thumb2.png" alt="image" width="244" height="136" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2014/10/image2.png)

As soon as I added 'Local Service' again with full permissions, all was fine and the ConfigMgr Application Catalog started up again.

- [David](www.twitter.com/david_obrien) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


