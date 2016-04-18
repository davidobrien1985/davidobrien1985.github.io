---
id: 107
title: 'Citrix personal vDisk &#8211; a personalized static Desktop'
date: 2011-09-01T13:38:39+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=107
permalink: /2011/09/citrix-personal-vdisk-a-personalized-static-desktop/
categories:
  - Citrix
  - personal vDisk
  - Ringcube
  - XenDesktop
tags:
  - Citrix
  - Ringcube
  - XenDesktop
---
As most of you will have heard by now, Ringcube is now part of Citrix, who integrated Ringcube&#8217;s &#8220;vDesk for VDI&#8221; into XenDesktop 5.5 as their new &#8220;personal vDisk&#8221; technology.

Personally, I haven&#8217;t heard from them before, so I was kind of curious about what this &#8220;new&#8221; technology might hold for us.

Installation is pretty easy and straightforward, not that much to do wrong actually.
  
I installed a new Windows 7 VM on a XenServer pool, installed all necessary  updates and did some of the configurations recommended by Citrix in their <a href="http://support.citrix.com/article/CTX127050" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://support.citrix.com/article/CTX127050', 'Windows 7 Optimization Guide']);" target="_blank">Windows 7 Optimization Guide</a>.

Inside the only 17MB large install sources for &#8220;Citrix personal  vDisk&#8221; is a nice paper which guides you through the installation and configuration.
  
On the server side, there isn&#8217;t much to see or do, only two powershell scripts, one, which will help you create the personal vDisk, the other one to query your Desktop Groups for some statistics.

What does &#8220;personal vDisk&#8221; even mean?
  
Usually a desktop&#8217;s storage created by the XenDesktop MCS looks something like this:<figure id="attachment_110" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/storage_no_vdisk.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/storage_no_vdisk.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-110" title="storage_no_vdisk" src="http://www.david-obrien.de/wp-content/uploads/2011/09/storage_no_vdisk-300x71.jpg" alt="" width="300" height="71" /></a><figcaption class="wp-caption-text">Storage tab of a MCS Desktop in XenServer</figcaption></figure> 

We have the Difference Disk and the Identity Disk. That&#8217;s it! Changes to the OS are stored to the Diff-disk and usually discarded at reboot.

Now what the personal vDisk does, it creates a third disk where all the changes to the OS are stored, for example a user installs an application, a browser or even a driver, and those changes are not discarded. They are redirected by a file system filter driver, so that if an installer tries to install to the &#8220;local&#8221; system drive, it actually gets redirected to the &#8220;personal vDisk system drive&#8221;. I will show you how this looks in a second.

Installation on the client side means executing a msi, depending on your architecture you either use personalvDiskInstaller.msi or personalvDisk64Installer.msi.
  
There&#8217;s nothing to configure, you just click &#8220;next&#8221; five times and that&#8217;s it.<figure id="attachment_111" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/installation_step5_final.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/installation_step5_final.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-111" title="installation_step5_final" src="http://www.david-obrien.de/wp-content/uploads/2011/09/installation_step5_final-300x243.jpg" alt="" width="300" height="243" /></a><figcaption class="wp-caption-text">Installation of personal vDisk complete</figcaption></figure> 

After successful installation you&#8217;ll find a new taskbar icon.<figure id="attachment_112" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_menu.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_menu.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-112" title="vdisk_menu" src="http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_menu-300x131.jpg" alt="" width="300" height="131" /></a><figcaption class="wp-caption-text">personal vDisk taskbar icon</figcaption></figure> 

By choosing &#8220;preferences&#8221; you open the vDisk GUI, and, again not that much to do.<figure id="attachment_113" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_GUI.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_GUI.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-113" title="vdisk_GUI" src="http://www.david-obrien.de/wp-content/uploads/2011/09/vdisk_GUI-300x192.jpg" alt="" width="300" height="192" /></a><figcaption class="wp-caption-text">personal vDisk GUI</figcaption></figure> 

By default the vDisk is going to be mounted as drive letter V:, and this drive will be visible to all users unless you hide it from them, which will reduce the helpdesk calls quite a lot. You are probably doing the same with App-V&#8217;s drive &#8220;Q:&#8221; or PVS&#8217;s write-cache drive.
  
You will get more information on each option by clicking the round, blue &#8220;I&#8221;.
  
Before shutting down the VM you have to update the &#8220;personal vDisk inventory&#8221;, otherwise you will get into problems later on.<figure id="attachment_127" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_inventory.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_inventory.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-127" title="create_vdisk_inventory" src="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_inventory-300x161.jpg" alt="" width="300" height="161" /></a><figcaption class="wp-caption-text">Create the personal vDisk's inventory</figcaption></figure> 

&nbsp;

As the next step I took a snapshot of the shut-down VM from which I am going to create my Desktop Catalog in XenDesktop Desktop Studio.

By design, for now, the only pool type supported is &#8220;pooled-static&#8221;. This is due to the fact, that the vdisk needs to be mounted really early to support adding drivers or kernel objects for example and this doesn&#8217;t work with &#8220;pooled-random&#8221;.
  
The overview of my created catalog looks like this:
  
<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/create_catalog.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/create_catalog.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-115" title="create_catalog" src="http://www.david-obrien.de/wp-content/uploads/2011/09/create_catalog-300x212.jpg" alt="Summary Catalog" width="300" height="212" /></a>After hitting finish the VMs get created, this might take a few minutes, depending on your environment.

As soon as the VMs are visible in your hypervisor (in my case XenServer) we can continue with the creation of the VM&#8217;s personal vDisk.
  
Before creating the vDisks you should think about where you want to store them and if it might be wise to use thin provisioned storage. I have XenServer 5.6 SP2 with EXT3 as file system, so I will definately use thin provisioning in my environment.
  
The default size of the personal vDisk is 2GB, depending on your use case this might be enough or maybe not. When using thick provisioned disks you have to have a lot of storage capacity: storage needed = (desktops * (size of vDisk))

I am going to give my vDisk 5GB of storage and because it&#8217;s thin provisioned it will, at the beginning, only use near to nothing of it.
  
Again, it&#8217;s only a few steps until we&#8217;re finished.
  
Either start the Powershell from the start menu or from the &#8220;Actions&#8221; tab in Desktop Studio. Then change to your install path of the &#8220;personal vDisk Server Tools&#8221; and execute &#8220;create-personal-vdiskpool.ps1&#8221;

<p style="text-align: left;">
  The script will ask you a few questions which you will have to answer in order to create the vDisks.<br /> First you select the just created catalog:<br /> <a href="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectpool.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectpool.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-119" title="create_vdisk_selectpool" src="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectpool-300x52.jpg" alt="" width="300" height="52" /></a>Next the storage where you want to have your vdisks put:<br /> <a href="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectstorage.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectstorage.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-120" title="create_vdisk_selectstorage" src="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectstorage-300x60.jpg" alt="" width="300" height="60" /></a>At last the size of your vDisks:<br /> <a href="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectdisksize.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectdisksize.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-121" title="create_vdisk_selectdisksize" src="http://www.david-obrien.de/wp-content/uploads/2011/09/create_vdisk_selectdisksize-300x58.jpg" alt="" width="300" height="58" /></a>The script will now create the vDisks for all the desktops in this catalog and at the end tell you if it was successful or not.
</p>

How does this look in XenCenter?<figure id="attachment_122" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/storage_with_vdisk.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/storage_with_vdisk.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-122 " title="storage_with_vdisk" src="http://www.david-obrien.de/wp-content/uploads/2011/09/storage_with_vdisk-300x77.jpg" alt="" width="300" height="77" /></a><figcaption class="wp-caption-text">Storage tab of VM</figcaption></figure> <figure id="attachment_123" class="wp-caption aligncenter" style="max-width: 300px"><a href="http://www.david-obrien.de/wp-content/uploads/2011/09/local_storage_xenserver.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/local_storage_xenserver.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-123 " title="local_storage_xenserver" src="http://www.david-obrien.de/wp-content/uploads/2011/09/local_storage_xenserver-300x71.jpg" alt="" width="300" height="71" /></a><figcaption class="wp-caption-text">Storage tab of XenServer</figcaption></figure> 

See how a third disk has been added to our VM and how, at the moment, it takes up 0% of its assigned 5GB on the XenServer&#8217;s storage?

Coming to an end of this article I will just give you a quick look at how this now looks in the OS. For this I created a Desktop Group and launched the desktop from Webinterface.
  
Looking at Windows Explorer you will now see (if you didn&#8217;t chose to hide the drives) two more drives than you would expect to.<figure id="attachment_129" class="wp-caption aligncenter" style="max-width: 300px">

<a href="http://www.david-obrien.de/wp-content/uploads/2011/09/explorer_vdisk.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/09/explorer_vdisk.jpg', '']);" class="broken_link"><img class="img-responsive size-medium wp-image-129" title="explorer_vdisk" src="http://www.david-obrien.de/wp-content/uploads/2011/09/explorer_vdisk-300x120.jpg" alt="" width="300" height="120" /></a><figcaption class="wp-caption-text">A look at Windows Explorer</figcaption></figure> 

In my case drive F: contains all the Logs and the VHD file &#8220;personal vDisk&#8221; uses to store all the changes in and drive V: is the mounted VHD file. Remember, earlier, you could have chosen to hide drives from the user, plural! This is why.
  
Looking at V: you will notice that this looks quite a lot like your C: drive. I told you that the file system filter driver redirects changes on C: to your personal vDisk. So whatever the user changes on his system will eventually land on V: and because of that also on my F: drive, the VHD.

I will go on and play a bit with this nice new feature of XenDesktop 5.5, it does look quite cool and I hope that some customers will come to the same conclusion. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Citrix,Ringcube,XenDesktop" data-count="vertical" data-url="http://www.david-obrien.net/2011/09/citrix-personal-vdisk-a-personalized-static-desktop/">Tweet</a>
</div>
