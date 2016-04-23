---
id: 1579
title: Multiple copy of Applications during ConfigMgr Task Sequence
date: 2014-01-22T22:29:14+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1579
permalink: /2014/01/multiple-copy-applications-configmgr-task-sequence/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - SCCM
tags:
  - ConfigMgr
  - Issue
  - Microsoft
  - SCCM
  - Task Sequence
---
**[Update below 05.03.2014]**

# SCCM Task Sequence issue in stand alone media

I am currently working with a customer that has a strange issue during ConfigMgr standalone media Task Sequences provided to remote workers.

The issue is happening during installation of applications, which are installed as part of the Task Sequence.

The issue is around the copy of sources into the cache and with this customer is happening since version 2012 SP1 and is still there in R2.

What’s happening is that all the applications inside the Task Sequence get copied into the client’s cache multiple times.

Right now there are 24 applications inside this Task Sequence, they are put into 4 different “Install Application” steps, each separated by a reboot.

These applications are all working great (they are also used during online installation and normal Software Deployment) and are of varying size.

In this environment the applications now are copied 24 * 24 times. With each application being installed all applications referenced inside the Task Sequence get copied to the cache again. In this scenario this means in the end there are going to be 576 folders inside the C:\Windows\ccmcache folder. This also means that on some hardware with small hard drives the hard drives gets filled up (we had to extend the cache) or the whole Task Sequence fails.

There’s already a call with Microsoft, but I wanted to check if this issue is also known to others.

I kind of reproduced the behaviour in my environment and I really can’t explain it other than it’s a bug in the stand alone Task Sequence process.

Here is what my Task Sequence looks like:

![SCCM Task Sequence](/media/2014/01/TS1.jpg)

![SCCM Task Sequence](/media/2014/01/ts2.jpg)

I only configured six applications to be installed in this test and even two applications to be installed a second time (which I, to be honest, only discovered afterwards).

What would I expect to happen?

I would have expected that each application be copied into the cache if necessary, but only each application by application, not all at once nor absolutely not all applications with every “Install Application” step all over again.

I tested this Task Sequence both online and as “Stand alone media” and came across a similar issue.

This is how the cache looks like after installing Windows 8.1 after stand alone installation:

![ccmcache](/media/2014/01/cache.jpg)

As you can see the Task Sequence behaved a bit differently in my environment than in the customer’s environment. The Task Sequence even copied the applications that weren’t referenced twice. Although it did not copy 6*6 application folders, “only” 8. This is a bit different to what my customer is experiencing, but still not what I expected.

The online installation looks like this:

![ccmcache](/media/2014/01/image11.png)

This is sort of what I would expect. It’s clearly not more copy processes than necessary, but those sources were still all copied to the cache before the first installation even was installed.

## Summing up

* Stand alone media copies application sources too often into the cache and keeps it there
* online Task Sequence doesn’t experience this issue

Has anybody else experienced this issue? If so, please contact me here, on Twitter or via eMail.

The only workaround I could now think of is to use packages again during Task Sequences. This is actually going against the customer’s design, which only accounted for the new App model and not for Packages, but this fixes the issue at least.

I will keep you updated here on this issue.

## Hotfix available KB2928122

Microsoft just publicly released the following hotfix to solve this issue: [http://support.microsoft.com/kb/2928122](http://support.microsoft.com/kb/2928122)

Description:

```
Application contents are duplicated in the client cache folder for every Install Application step that is used in a task sequence in Microsoft System Center 2012 R2 Configuration Manager. This affects only clients that are deployed by using stand-alone media.

For example, a task sequence is created that has two Install Application steps, and each has a separate .msi file:

Install Application: Application1.msi
Install Application: Application2.msi


On the client that is installed by using this stand-alone media, the client cache folder (by default, this is Windows\CCMCache) contains two copies of each .msi file:

  \Windows\CCMCache\1\Application1.msi
  \Windows\CCMCache\2\Application2.msi
  \Windows\CCMCache\3\Application1.msi
  \Windows\CCMCache\4\Application2.msi
```