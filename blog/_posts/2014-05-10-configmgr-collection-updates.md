---
id: 1790
title: 'How to - ConfigMgr collection updates'
date: 2014-05-10T00:45:24+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1790
permalink: /2014/05/configmgr-collection-updates/
categories:
  - Collections
  - ConfigMgr
  - Configuration Manager
  - SCCM
tags:
  - Best Practices
  - Collections
  - ConfigMgr
  - Configuration Manager
  - SCCM
  - SQL
---
This is a topic I haven’t seen much covered around but is quite important, especially if you’re managing an environment with a lot of clients, regular changes and a lot of collections.

# What is a ConfigMgr collection?

According to Technet ([http://technet.microsoft.com/en-us/library/gg682169.aspx]("http://technet.microsoft.com/en-us/library/gg682169.aspx" http://technet.microsoft.com/en-us/library/gg682169.aspx)):

> Collections in System Center 2012 Configuration Manager provide a method of managing groups of computers, mobile devices, users, and other resources in your organization.

So they are nothing more than groups of objects in your environment. How you group them is not mentioned yet or for what reason.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" src="/media/2014/05/image_thumb3.png" alt="image" width="311" height="56" border="0" />]("image" /media/2014/05/image3.png)

Collections can be used to deploy Software, Operating Systems, Task Sequences or settings to these managed groups.

Basics covered, we all now know what a collection is and what it’s for. <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/media/2014/05/wlEmoticon-winkingsmile.png" alt="Winking smile" />

Collections have members and members can change, that’s why we need to regularly update our collections. This way we guarantee that collections reflect our environment as accurately as possible.

# ConfigMgr Collection updates

There are four ways collections can get their membership rules updates:

  * full update
  * incremental update
  * manual update
  * ‘indirect’ update

## ConfigMgr Collection full and manual update

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb4.png" alt="image" width="253" height="270" border="0" />]("image" /media/2014/05/image4.png)

When creating a collection through the console then this will be the default setting. A full update for this collection will run every seven days. This will then completely reevaluate the collection memberships. Speaking SQL it will execute a stored procedure on the database which will rebuild the view for that specific collection.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb5.png" alt="image" width="262" height="81" border="0" />]("image" /media/2014/05/image5.png)

After the full update runs you can check the properties of the view which represents that collection in your database and see that it was just newly created.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb6.png" alt="image" width="267" height="100" border="0" />]("image" /media/2014/05/image6.png)

You can image that creating a whole new view puts some load on your box, well, it’s alright for one collection, but if you run the full update too frequently on too many collections with too complex queries then you might get some performance problems.

The same behaviour can be observed when using the **‘Update Membership’** (manual update) button in the Admin Console.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb7.png" alt="image" width="259" height="105" border="0" />]("image" /media/2014/05/image7.png)

This option will also trigger a full update on your collection.

# Incremental Collection Updates

If you are familiar with incremental backups then you should know what an incremental update could be. This feature will periodically check those collections which have that feature enabled for any changes since the last full update. It’s not doing a full update, which means that it usually has less performance impact on your SQL box. (big BUT, later…)

## How to configure incremental update schedules?

The schedule on which this feature runs is configured per site, you can’t set it per collection.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb8.png" alt="image" width="266" height="144" border="0" />]("image" /media/2014/05/image8.png)

The default value in ConfigMgr 2012 R2 is 5 minutes. You can chose between 1 and 1440 minutes / 24hrs.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb9.png" alt="image" width="244" height="123" border="0" />]("image" /media/2014/05/image9.png)

## Should you use incremental updates for collections?

Is it a good idea to use this? Maybe, yes, maybe, no. It all depends on your use case and your environment. I’ve been to a customer which had problems with their Software Deployments. Machines just wouldn’t pick up any deployments, even after a week of waiting. Why?
  
They were using AD Security groups as targets for their Software Deployments. Good so far. They put their machines into those groups. Still good. They had 900 collections configured for incremental updates. Hmpf…

Quick math.

Looking at their colleval.log gave me the following rough numbers:

> 1 collection update took about 15 seconds
> 
> 900 collections had incremental updates enabled
> 
> the Collection Membership Evaluation Component was at its default, 5 minutes.
> 
> One run through all collections took the CollEval component 650 * 15 seconds = 9750 seconds = 162.5 minutes = 2.7 hrs

Cool  <img class="img-responsive wlEmoticon wlEmoticon-smile" style="border-style: none;" src="/media/2014/05/wlEmoticon-smile.png" alt="Smile" />And after 5 minutes the component tried to run the next incremental update, where it wasn’t nearly finished with the first run, then after another 5 minutes the third and so on…

I ended up creating a script which would turn the incremental updates off on those collections.

Microsoft gives you a bit of a guideline here on how many collections you should have this setting enabled: [http://technet.microsoft.com/en-us/library/gg699372.aspx]("http://technet.microsoft.com/en-us/library/gg699372.aspx" http://technet.microsoft.com/en-us/library/gg699372.aspx)

> When you enable the **Use incremental updates for this collection** option, this configuration might cause evaluation delays when you enable it for many collections. The threshold is about 200 collections in your hierarchy. The exact number depends on the following factors:
> 
>   * The total number of collections
>   * The frequency of new resources being added and changed in the hierarchy
>   * The number of clients in your hierarchy
>   * The complexity of collection membership rules in your hierarchy

Hierarchy here means that if you have a CAS and several primaries then those 200 collections is a TOTAL over all your sites.

## Indirect collection updates

What’s that? Nothing you can directly trigger in any way, but during your collection design this is something you should definitely keep in mind!

This has to do with limiting and limited collections.

Are you maybe a bit lazy and limit ever collection by ‘All Systems’? That’s bad for several reasons, one, you can’t use Role Based Administration properly with this, second, you will get problems with you collection updates.

The following pretty picture (powered by MSPaint) is supposed to show you an easy collection design.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/05/image_thumb10.png" alt="image" width="294" height="212" border="0" />]("image" /media/2014/05/image10.png)

What will happen here? If I say ‘Update Membership’ on ‘All Systems’ then the collection evaluation (CollEval) process will kick in and check for any new members in All Systems. There actually is one. So it’s put into ‘All Systems’. Furthermore via Hardware Inventory we know that it’s a Workstation. CollEval will now check ALL the collections that are limited by All Systems if these collections are going to be affected by this new member. As it is a workstation the ‘All Workstations’ collection will be updated and its limited collections will again be evaluated, both x64 and x86. Any collections limited by ‘All Servers’ will not be touched. Only ever the limited collections by a collection that has been changed. That Workstation is a 64bit OS, so x64 collection will be updated and only its limited collections evaluated, no collection underneath x86 will be.

What would have been if all your collections were limited to ‘All Systems’? Right, because of one new member ALL your collections would have been evaluated. Imagine that happening in your uber large environment with hundreds of collections with complex queries and such.

So always keep in mind: Don’t limit your collections by ‘All Systems’! Except if you are doing OSD, then you kind of have to. Except, if you’re using unknown computer support, then you don’t. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


