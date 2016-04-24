---
id: 79
title: 'XenDesktop - Updating to version 5.5'
date: 2011-08-30T09:19:43+00:00
author: "David O'Brien"
layout: single

permalink: /2011/08/xendesktop-updating-to-version-5-5/
if_slider_text:
  - Install sources for DDC in XD5 SP1
categories:
  - XenDesktop
---
As XenDesktop 5.5 just got released the other day I planned to upgrade the lab environment I usually do my tests in.

My environment looks like this:

* 1 XenDesktop Controller
* 1 XenServer Pool containing of 2 XenServer 5.6 SP2 with attached iSCSI storage
* 1 Windows 7 Master VM

I usually work with the MCS, due to the fact that it's easier to maintain in a lab than PVS.

After downloading the update package from MyCitrix I mounted the ISO and fired up the setup, chose "Upgrade" and whoop, done! That was fast?! I honestly had to check if I missed an error or something but obviously not that much happened.

So what **did** happen? I started Desktop Studio, didn't look too different, then Desktop Director, which actually looks a bit different and then went to have a look at the install sources and compared the installers from XD5.5 to the installers from XD 5 SP1. And what a surprise - nothing changed! Look at the dates and sizes!

[<img class="img-responsive size-medium wp-image-86 alignleft" title="XD5 SP1 installers" src="/media/2011/08/xd55_ddc_upgrade21-300x173.jpg" alt="" width="300" height="173" />]("XD5 SP1 installers" /media/2011/08/xd55_ddc_upgrade21.jpg)

[<img class="img-responsive aligncenter size-medium wp-image-88" title="XD 5.5 installers" src="/media/2011/08/xd55_ddc_upgrade2_compared2xd5sp1-300x176.jpg" alt="" width="300" height="176" />]("XD 5.5 installers" /media/2011/08/xd55_ddc_upgrade2_compared2xd5sp1.jpg)

But what did the installer do? It installed a new version of the Desktop Director, which got tweaked a bit here and there, and furthermore added some new policies.

So much for the server side!

The real changes are on the other side, the user side. As we all know we have to think about our customers, the users, who have to work with the stuff we provide them with.

You might ask yourself by now what the big news are about XD5.5.

Here is what Citrix says: (Citrix: <http://support.citrix.com/proddocs/topic/xendesktop-als/cds-whats-new-xd5fp1.html>)

At a Citrix Solutions Roundtable I was once told that Citrix updates XenDesktop only in halves with each update cycle. XD5 was the release in which the consoles underwent a major upgrade, so 5.5 is the release in which the VDA gets its new features. XD6 will then again be the release for the administrator.

The nice and easy thing about XenDesktop is, that you can administer most things via the Desktop Studio GUI, especially everything which is going to happen on the Desktop side of XenDesktop. So lets have a quick look at the policies in XD5.5 Desktop Studio. In the policy section you can now filter all the policies that apply to either XD5, XD5.5 or both, which makes it really easy to test all the new policies like "Win7 Aero redirection" and such.

[<img class="img-responsive aligncenter size-medium wp-image-91" title="XD5.5 policies" src="/media/2011/08/XD55_policies-300x129.jpg" alt="" width="300" height="129" />]("XD5.5 policies" /media/2011/08/XD55_policies.jpg)

As time permits I am going to test the new policies such as "Win7 Aero redirection" and all the other HDX settings.

Until then, have fun with XenDesktop 5.5! I will!



