---
id: 526
title: 'Easy versioning of Images&ndash;Configuration Manager and Powershell'
date: 2012-10-13T11:12:52+00:00
author: "David O'Brien"
layout: single
guid: http://david-obrien.de/?p=526
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
&nbsp;

Did I ever tell you that I like thin-thick images? Thin-thick?! I like to put as many applications as possible into my base image, but only that much that the image still stays as “generic” as possible.
  
I know that there are people who just deploy the Operating System’s install.wim and install all applications on top of it during a Deploy Task Sequence. Then there are others who build an image for every department, hardware model and weekday they have. I like to be somewhere in between.
  
That puts me into a position that I also have some applications in my image that get updated quite regular. The OS updates can be managed via Offline Servicing, but all the other apps need to be reinstalled or patched during installation.

Now lets say you’re like me and need to rebuild your image on a regular basis, for example once a month.

# Automation

As always I want to do all this with as little manual effort as possible. How nice of Microsoft to give us Task Sequences, they install everything we want automatically.
  
Unfortunately there’s one step where we will always need to change something in the Task Sequence, and that’s the name of our result, the captured .wim file.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" src="http://david-obrien.de/wp-content/uploads/2012/10/image_thumb3.png" alt="image" width="325" height="112" border="0" />]("image" http://david-obrien.de/wp-content/uploads/2012/10/image3.png)

There’s no way Microsoft gave us a out-of-the-box way to use versioning here. When you create a new image you also need to change its name in here. As I’m already getting old (I’m 27 now  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://david-obrien.de/wp-content/uploads/2012/10/wlEmoticon-winkingsmile1.png" alt="Winking smile" />) I tend to forget this step.
  
That’s the reason why I always wanted to build something to let me forget about this step. Yesterday a colleague of mine reminded me of this plan, so here’s my really easy solution.

# Microsoft.SMS.TSEnvironment and Powershell

Good for us, Microsoft gave us variables to work with. There are a lot of variables already built-in to a Task Sequence ([http://technet.microsoft.com/en-us/library/hh273375.aspx](http://technet.microsoft.com/en-us/library/hh273375.aspx)), but there was none that I could use.
  
My goal was to use a variable for my filename so that I wouldn’t always need to change it in my Task Sequence.
  
Microsoft uses a COM-Class for its variables called Microsoft.SMS.TSEnvironment. The name already tells us, this is only loaded and accessible during a Task Sequence.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$vars = New-Object -ComObject Microsoft.SMS.TSEnvironment
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$vars.Getvariables()
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Running this during a Task Sequence will list all the variables in our TS Environment.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$vars.Value("_SMSTSLogPath")
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

This will give us the current value of the specified variable.
  
Running this with a foreach loop would be great for documenting what exactly happened on our client. But that’s not what I want to do.

I want to create a new variable with a specific value which is going to be evaluated right before the client is captured.

Setting a new variable is nearly as easy as getting one. Here’s the script I wrote. Honestly, that was a real no-brainer.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#####
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#Purpose: This script calculates the current date and time, builds a string containing a new Filename and sets this filename as a new Configuration
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#         Manager Task Sequence variable.
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#Requirements:
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#         - running Task Sequence environment
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#         - Powershell added to your boot image
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#Author: David O<span style="color: #008000;">'Brien, david.obrien@sepago.de
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#####
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$date = get-date -UFormat %Y%m%d
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$time = Get-Date -UFormat %H%M%S
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$filename = "$($date)_$($time).wim"
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$var = New-Object -ComObject Microsoft.SMS.TSEnvironment
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$var.Value("ImageName") = "$($filename)"
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I created a Package out of this script and run this as a command line right before the client is captured.
  
You can also easily go ahead and add the script into your boot image, but that would mean that you would need to change your boot image every time you change the script.

I checked how my variable looks during Task Sequence:

&nbsp;

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" src="http://david-obrien.de/wp-content/uploads/2012/10/image_thumb4.png" alt="image" width="300" height="263" border="0" />]("image" http://david-obrien.de/wp-content/uploads/2012/10/image4.png)

My variable now holds the OS which is getting installed (I could also get that out of an existing variable at an earlier stage) and the current date and time.

This is now my Task Sequence.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" src="http://david-obrien.de/wp-content/uploads/2012/10/image_thumb5.png" alt="image" width="293" height="156" border="0" />]("image" http://david-obrien.de/wp-content/uploads/2012/10/image5.png)

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" src="http://david-obrien.de/wp-content/uploads/2012/10/image_thumb6.png" alt="image" width="293" height="114" border="0" />]("image" http://david-obrien.de/wp-content/uploads/2012/10/image6.png)

Notice the variable inside my filepath (%ImageName%).

# 

# 

# 

&nbsp;

# 

# Requirements

Before WinPE 4.0 we would have needed to run these commands as VBS or batch, because there would be no Powershell support in WinPE. Now we can do exactly this by adding Powershell to our WinPE. Here’s a good article of how this works: [http://myitforum.com/myitforumwp/2012/10/07/configmgr-2012-sp1-beta-boot-image-optional-components/](http://myitforum.com/myitforumwp/2012/10/07/configmgr-2012-sp1-beta-boot-image-optional-components/)

That’s it, I hope you like it. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

