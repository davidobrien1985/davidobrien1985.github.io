---
id: 2863
title: Missing Save button while creating a Windows Azure Pack Plan
date: 2015-01-05T19:08:23+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=2863
permalink: /2015/01/missing-save-button-while-creating-a-windowsazurepackp-plan/
categories:
  - Azure
  - SCVMM
  - System Center
  - WAP
tags:
  - Azure
  - System Center
  - WAP
  - WAPack
---
I was setting up my new lab environment at home and ran into a **VERY** weird issue, that caused me a bit of a headache. Thanks to Social Media and a very helpful colleague I now found the solution, and because I wasn’t able to find any other article, here it is.

# Create a Plan in Windows Azure Pack

If you ever wanted to create a Plan in your Windows Azure Pack (WAP) environment to give your tenants / users some IaaS / DBaaS functionality, then you might have run into this issue as well, or not.

This whole issue just came to be because I got a bit ahead of myself and wanted to configure something in WAP before I had everything fully configured in VMM. It would’ve been nice of WAP to tell me so.

While creating and configuring the plan I also have to add a Service to the plan, in this case a Service for “**Virtual Machine Clouds**”, so IaaS.

I went into the Plan Service and started configuring stuff. I selected the correct **VMM Management Server** and also the **Virtual Machine Cloud** I wanted to use for this Service. Next I configured some **Usage Limits,** I did  see that I was told that there are no networks, hardware profile, templates or gallery items configured, but I thought that I could do that later on.

Well, as I wanted to save the configuration I discovered that the Save button wasn’t there. It wasn’t greyed out or so, it was actually missing. See the screenshot, **those buttons weren’t there!**

&nbsp;

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2015/01/image_thumb.png" alt="image" width="452" height="340" border="0" />]("image" /media/2015/01/image.png)

I already started to believe that there was something wrong with my WAP installation, when I went back to Twitter and asked around:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2015/01/image_thumb1.png" alt="image" width="269" height="323" border="0" />]("image" /media/2015/01/image1.png)

That’s strange, why would WAP have a check in there somewhere for a network being available, but then won’t tell me?
  
I set up a Logical Network, a VM Network and connected them to the cloud and et voila, there was my save button.

Weirdest thing here: I didn’t need to add a network to the plan (although you actually need to in order to actually in the end use it), it still let me save it.

No idea if this kind of behaviour is likely to happen in other places in WAP as well, but if you come across this anywhere else, it’s worth checking if there are any requirements you have not met.

- [David](http://www.twitter.com/david_obrien) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


