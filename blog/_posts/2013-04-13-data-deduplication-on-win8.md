---
id: 901
title: Data deduplication on Win8
date: 2013-04-13T21:03:39+00:00
author: "David O'Brien"
layout: single

permalink: /2013/04/data-deduplication-on-win8/
categories:
  - Dedup
  - PowerShell
  - Windows 8
tags:
  - Data deduplication
  - dedup
  - Powershell
  - SSD
  - Win8
---
# How to enable Data Deduplication on Win8

A fellow Configuration Manager community member, Nickolaj Andersen, posted a blog article about Data Deduplication on Win8 and how to save quite some disk space.

**BE AWARE: This is totally unsupported on Win8!!! Do backups first!**

Find his article here: [http://www.scconfigmgr.com/2013/04/13/enable-deduplication-for-your-lab-environment-in-windows-8/](http://www.scconfigmgr.com/2013/04/13/enable-deduplication-for-your-lab-environment-in-windows-8/)

I tried it on my disk (both SSD and HDD) and saved a huge amount of disk space for my private lab on my notebook. I’m running Win8 with Hyper-V and run my System Center environment in there and need a lot of disk space. Due to the still high prices of SSDs I only got a 256GB Samsung 830 SSD and a 512GB HDD.

I did the mistake of putting my system on the SSD, which takes two of three partitions with a total of 100GB of the 256GB. So there’s only about 130GB left of my SSD and 500GB on my HDD for nearly 7VMs running simultaneously most of the time.

So what did I gain by enabling Nickolaj’s tip?

This is what I get back as a result when running “Get-DedupStatus”:

![image](/media/2013/04/image3.png)

So I actually saved quite a bit on my disks!

If you aren’t scared of playing around a bit, look at Nickolaj’s article!



