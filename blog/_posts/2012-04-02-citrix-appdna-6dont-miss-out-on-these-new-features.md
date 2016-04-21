---
id: 308
title: Citrix AppDNA 6–don’t miss out on these new features!
date: 2012-04-02T20:20:35+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=308
permalink: /2012/04/citrix-appdna-6dont-miss-out-on-these-new-features/
categories:
  - APP-DNA
  - Citrix
  - migration
  - System Center
tags:
  - APPDNA
  - AppTitude
  - Citrix
  - Migration
  - reporting
  - update
  - upgrade
---
After [Citrix](http://www.citrix.com)’s acquisition of AppDNA in November 2011, the product formerly known as AppDNA AppTitude underwent some major rebranding and was just a few days ago reborn as Citrix AppDNA.

# First impressions

The first impression is: “<span style="text-decoration: underline;">fancy</span>”

[<img style="border: 0px currentcolor; padding-top: 0px; padding-right: 0px; padding-left: 0px; margin-right: auto; margin-left: auto; float: none; display: block; background-image: none;" title="logon_screen" src="/media/2012/04/logon_screen_thumb.jpg" alt="logon_screen" width="315" height="219" border="0" />]("logon_screen" /media/2012/04/logon_screen.jpg)
  
Cool new colours, cool new look and some cool new features.

The navigation inside of the console changed quite a bit and isn’t as straightforward anymore as it used to be. But you’ll get used to it pretty fast.

# Sites

When logging in to AppDNA you’ll get asked to which site you want to connect yourself and that’s just one of a lot of new features.
  
From now on you can split your testing into multiple sites. These sites can be geographically or organizational, for example you want your server admins to test get access to the site “Servers” and your client admins to the site “Clients” only. There will obviously be different websites (for communication) and databases (for storage) behind these sites.

# Import bunch of OS Images

In AppTitude 5 you could already import your custom OS image to analyze your applications against your own productive environment. That already was pretty cool!
  
But what with those environments where you have a Windows 7 image for Notebooks, another one for your desktop PCs, one more for virtual desktops and one for users with disabilities?
  
With AppDNA 6 you can now import more than one OS image per OS to get all the information you need regarding to your specific needs.

<p align="center">
  [<img style="border: 0px currentcolor; padding-top: 0px; padding-right: 0px; padding-left: 0px; display: inline; background-image: none;" title="OS_images" src="/media/2012/04/OS_images_thumb.jpg" alt="OS_images" width="227" height="272" border="0" />]("OS_images" /media/2012/04/OS_images.jpg)
</p>

# Reporting

## Create custom reports

Until now the only way to see if an application was compatible to Windows 7 SP1 AND x64 was to create a Forward Path stating exactly this combination or merging the reports of Windows 7 SP1 and x64.
  
But what if you want to see if your application ships with a specific file that’s not tested during one of the default module tests or you only need a specific subset of rules of one module and not the rest.

You don’t have to disable the module rules, just create your own report.
  
You either do this via drag&drop from the existing module rules or, for the more advanced,  create SQL queries.

<p align="center">
  [<img style="border: 0px currentcolor; padding-top: 0px; padding-right: 0px; padding-left: 0px; display: inline; background-image: none;" title="custom_reports" src="/media/2012/04/custom_reports_thumb.jpg" alt="custom_reports" width="304" height="205" border="0" />]("custom_reports" /media/2012/04/custom_reports.jpg)
</p>

## Organizational Reports

AppDNA now brings a better integration into your Active Directory, meaning that you can now generate reports based on applications that are linked to AD groups or computers/users/OUs.

# Mozilla Firefox

I don’t know how many enterprise customers really use anything else than Microsoft’s Internet Explorer,  but in case you’re one of those who are using Firefox, the web module now gets shipped with a set of rules for it.

# VMWare Workstation 8

<p align="left">
  Although the GUI says different, VMWare Workstation 8 is now fully supported for Install Capture imports.
</p>

# [<img style="border: 0px currentcolor; padding-top: 0px; padding-right: 0px; padding-left: 0px; margin-right: auto; margin-left: auto; float: none; display: block; background-image: none;" title="install_capture" src="/media/2012/04/install_capture_thumb.jpg" alt="install_capture" width="309" height="120" border="0" />]("install_capture" /media/2012/04/install_capture.jpg)

# Integrated Login

As you might see on the Logon screen shown above, it is now possible to log on to your AppDNA console with your currently logged on Windows credentials.
  
This will make user administration a bit easier.

<p align="center">
  [<img style="border: 0px currentcolor; padding-top: 0px; padding-right: 0px; padding-left: 0px; display: inline; background-image: none;" title="users" src="/media/2012/04/users_thumb.jpg" alt="users" width="368" height="62" border="0" />]("users" /media/2012/04/users.jpg)
</p>

# What, unfortunately, didn’t change?

There are still no documented/supported ways to automate workflows in AppDNA. There are customers who do want to automate the import process. Some even want to use XenDesktop for this task and I really hope that this will soon be possible, now that it’s all one company it shouldn’t be too difficult to integrate a way to communicate with XenDesktop VMs.
  
I heard that maybe one day there even might be some integrated Powershell cmdlets available, maybe possible could be <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" src="/media/2012/04/wlEmoticon-winkingsmile.png" alt="Winking smile" />

Integration with Configuration Manager 2012 is also not available, although other Citrix products do support that (e.g. XenDesktop 5.6). But I believe this as well won’t take too long, as System Center 2012 just went RTM today.

# What, thank someone, didn’t change?

I could import all of my existing Forward Path scripts and Task Scripts. That saved me a lot of work. So if you’re upgrading from AppTitude 5 to AppDNA 6, make sure to export all of your customized scripts, you CAN still use them in the new version. Thank you, AppDNA! 
<img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" src="/media/2012/04/wlEmoticon-winkingsmile.png" alt="Winking smile" /> 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

