---
id: 1716
title: How to configure client activity settings in ConfigMgr
date: 2014-04-12T00:44:04+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1716
permalink: /2014/04/configure-client-activity-settings-configmgr/
categories:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
tags:
  - Client Activity
  - Client Status
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - SCCM
---
# When does the ConfigMgr client become Inactive or Active?

Ever wondered what triggers the ConfigMgr client change its Client Activity status from Active to Inactive?

![image]](/media/2014/04/image.png)

My lab doesn’t have any inactive client at the moment, but I guess you know what I mean ;-)

## Client Status Settings

There isn’t too much information on the internet how to configure the client’s behaviour and I myself searched about 1.5 hours today until a colleague of mine helped me out with a simple screenshot.

![image](/media/2014/04/image1.png)

I always forget about this configuration menu and I really don’t understand why Microsoft put it there. This should be in the client settings or discovery node.

In this menu you can configure after how many days of missed communication with the site the client is deemed inactive.

## Delete Inactive Client Discovery Data

Then there is also one Site Maintenance Tasks which cleans up your environment. It will delete inactive client entries after a configured amount of days.

Use this task to delete discovery data for inactive clients from the database. Clients are marked as inactive when the client is flagged as obsolete and by configurations made for Client status. This task operates only on resources that are Configuration Manager clients. It is different than the **Delete Aged Discovery Data** task which deletes any aged discovery data record. When this task runs at a site, it removes the data from the database at all sites in a hierarchy.

**Important**

When enabled, configure this task to run at an interval greater than the **Heartbeat Discovery** schedule. This enables active clients to send a Heartbeat Discovery record to mark their client record as active so this task does not delete them.

[http://technet.microsoft.com/en-us/library/e555d7e3-3681-440a-82d0-319d2b4bdd08#BKMK_PlanMaintenanceTasks](http://technet.microsoft.com/en-us/library/e555d7e3-3681-440a-82d0-319d2b4bdd08#BKMK_PlanMaintenanceTasks)

![image](/media/2014/04/image2.png)

From there I actually found the following technet article on the Client Status Settings which describes it pretty well: [http://technet.microsoft.com/en-us/library/hh338432](http://technet.microsoft.com/en-us/library/hh338432)