---
id: 526
title: 'Easy versioning of Images&ndash;Configuration Manager and Powershell'
date: 2012-10-13T11:12:52+00:00

layout: single

permalink: /2012/10/easy-versioning-of-imagesconfiguration-manager-and-powershell/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - scripting
tags:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Configuration Manager 2012
  - Powershell
  - SCCM
  - SCCM 2012
  - scripting
  - Task Sequence
---

Did I ever tell you that I like thin-thick images? Thin-thick?! I like to put as many applications as possible into my base image, but only that much that the image still stays as “generic” as possible.

I know that there are people who just deploy the Operating System’s install.wim and install all applications on top of it during a Deploy Task Sequence. Then there are others who build an image for every department, hardware model and weekday they have. I like to be somewhere in between.

That puts me into a position that I also have some applications in my image that get updated quite regular. The OS updates can be managed via Offline Servicing, but all the other apps need to be reinstalled or patched during installation.

Now lets say you’re like me and need to rebuild your image on a regular basis, for example once a month.

# Automation

As always I want to do all this with as little manual effort as possible. How nice of Microsoft to give us Task Sequences, they install everything we want automatically.

Unfortunately there’s one step where we will always need to change something in the Task Sequence, and that’s the name of our result, the captured .wim file.

![image](/media/2012/10/image3.png "image")

There’s no way Microsoft gave us a out-of-the-box way to use versioning here. When you create a new image you also need to change its name in here. As I’m already getting old (I’m 27 now ;-) )  I tend to forget this step.

That’s the reason why I always wanted to build something to let me forget about this step. Yesterday a colleague of mine reminded me of this plan, so here’s my really easy solution.

# Microsoft.SMS.TSEnvironment and Powershell

Good for us, Microsoft gave us variables to work with. There are a lot of variables already built-in to a Task Sequence ([http://technet.microsoft.com/en-us/library/hh273375.aspx](http://technet.microsoft.com/en-us/library/hh273375.aspx)), but there was none that I could use.

My goal was to use a variable for my filename so that I wouldn’t always need to change it in my Task Sequence.

Microsoft uses a COM-Class for its variables called Microsoft.SMS.TSEnvironment. The name already tells us, this is only loaded and accessible during a Task Sequence.

```PowerShell
$vars = New-Object -ComObject Microsoft.SMS.TSEnvironment
$vars.Getvariables()
```

Running this during a Task Sequence will list all the variables in our TS Environment.

`$vars.Value("_SMSTSLogPath")`

This will give us the current value of the specified variable.

Running this with a foreach loop would be great for documenting what exactly happened on our client. But that’s not what I want to do.

I want to create a new variable with a specific value which is going to be evaluated right before the client is captured.

Setting a new variable is nearly as easy as getting one. Here’s the script I wrote. Honestly, that was a real no-brainer.

```PowerShell
#####

#Purpose: This script calculates the current date and time, builds a string containing a new Filename and sets this filename as a new Configuration
#         Manager Task Sequence variable.
#Requirements:
#         - running Task Sequence environment
#         - Powershell added to your boot image
#
#####

$date = get-date -UFormat %Y%m%d
$time = Get-Date -UFormat %H%M%S
$filename = "$($date)_$($time).wim"
$var = New-Object -ComObject Microsoft.SMS.TSEnvironment
$var.Value("ImageName") = "$($filename)"
```

I created a Package out of this script and run this as a command line right before the client is captured.

You can also easily go ahead and add the script into your boot image, but that would mean that you would need to change your boot image every time you change the script.

I checked how my variable looks during Task Sequence:

&nbsp;

![image](/media/2012/10/image4.png "image")

My variable now holds the OS which is getting installed (I could also get that out of an existing variable at an earlier stage) and the current date and time.

This is now my Task Sequence.

![image](/media/2012/10/image5.png "image")

![image](/media/2012/10/image6.png "image")

Notice the variable inside my filepath (%ImageName%).

# Requirements

Before WinPE 4.0 we would have needed to run these commands as VBS or batch, because there would be no Powershell support in WinPE. Now we can do exactly this by adding Powershell to our WinPE. Here’s a good article of how this works: [http://myitforum.com/myitforumwp/2012/10/07/configmgr-2012-sp1-beta-boot-image-optional-components/](http://myitforum.com/myitforumwp/2012/10/07/configmgr-2012-sp1-beta-boot-image-optional-components/)

That’s it, I hope you like it.



