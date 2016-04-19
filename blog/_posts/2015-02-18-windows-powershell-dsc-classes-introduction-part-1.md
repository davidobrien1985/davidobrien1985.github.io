---
id: 2966
title: 'Windows PowerShell DSC - classes - introduction (part 1)'
date: 2015-02-18T06:43:17+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2966
permalink: /2015/02/windows-powershell-dsc-classes-introduction-part-1/
categories:
  - Git
  - PowerShell
  - WMF
tags:
  - Chef
  - Configuration Management
  - Desired State Configuration
  - developing
  - DSC
  - git
  - github
  - Powershell
  - Puppet
  - scripting
  - WMF5
---
The Windows Management Framework 5 (WMF 5) Technical Preview also brought us PowerShell 5, and with that we got Desired State Configuration v2 (DSC v2). I just made that name up, I don’t believe it’s officially called DSC v2. 😉
  
Anyways, with PowerShell v5 we now got two new keywords, called “class” and “enum”.

<p class="">
  Developers will instantly recognise these two keywords and will also know what to do with them. I’m an IT Pro, not a developer, I had (have) to learn what to do with them. Follow me on my journey to a more “dev” side of the PowerShell world than I was ever used to.
</p>

<p class="">
  <!--more-->
</p>

# PSDSC and classes {.}

<p class="">
  With the introduction of PowerShell v5 and the <i>class </i>keyword it is now supported to define your custom DSC resources through a class.<br /> If you want to know a bit more about custom DSC resources in general, go have a look at my session slides from NicConf in Oslo here: [http://www.david-obrien.net/2015/02/powershell-dsc-session-slides-nicconf/](http://www.david-obrien.net/2015/02/powershell-dsc-session-slides-nicconf/)
</p>

## PSDSC and schema.mof {.}

<p class="">
  If you have previously looked at DSC resource modules you will have noticed that most of them (except for composite resources) have a <b style="font-style: italic;">%classname%.schema.mof </b>file in their respective <i>resource folder.<br /> </i>The schema.mof file implements the resource class and its parameters.<br /> Using the classes keyword there is no longer a need for the schema.mof file. Woohoo, right? 😉 Even with the New-MofFile function on github I didn't like that file. I mentioned I'm an IT Pro, right? Working in mof files makes me uncomfortable. <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" /><br /> The class already implements all necessary parameters and their data types.
</p>

## DscResources folder structure {.}

<p class="">
  In order to get a cmdlet based, as in not class based, DSC Resource working, one had to adhere to a given folder structure. If you didn't follow that folder structure, your resource didn't work, simple as that.
</p>

[<img class="img-responsive full aligncenter" title="Hyper-V DSC Resource" src="/media/2015/02/1424200220_thumb.png" alt="" align="middle" />]("Hyper-V DSC Resource" /media/2015/02/1424200220_full.png)

<p class="wrapped">
  A class based DSC resource module implementation doesn't need the DscResources folder anymore. An example for a class based resource module would look like this:
</p>

[<img class="img-responsive full aligncenter" title="" src="/media/2015/02/1424200509_thumb.png" alt="" align="middle" />](/media/2015/02/1424200509_full.png)

<p class="">
  This implies something very interesting, by the way. You can now define multiple resource classes in one module file. Staying with my ConfigMgr resource module example. Where before I had multiple resources for example like this:
</p>

[<img class="img-responsive full aligncenter" title="" src="/media/2015/02/1424200811_thumb.png" alt="" align="middle" />](/media/2015/02/1424200811_full.png)

You can see that I have multiple resources in that one resource module, all underneath the DscResources folder. If you are using class based resources, that's gone. All those resources move into the one ***.psm1** file in the root.
  
What else does this mean? Technically not much, but from a process workflow point of view, if you didn't have it before, **NOW(!!!)** you really need proper version control, like git(hub). You could easily end up in a situation where there are multiple persons working on the same module (at the same time) and overwrite each others work or change something which affects the other resources and you can't roll back to a previous version.
  
**Go implement version control!!!
  
** 

# Known gotchas so far {.}

<p class="">
  This is pre-release software, so of course there are some gotchas around it. The release notes clearly state that there are experimental features included in this November release of WMF5 and "Develop with classes in Windows PowerShell" is one of them.
</p>

  *  **_Get-DscResource_** doesn't work with class based DSC resources. This used to be something I did to test if my resource is usable / discoverable.
  * To instantiate a new object of any sort we are used to use New-Object. This currently doesn't work with classes. Instead, use the .Net format of **_[class]::new()_**
  * If you were already using classes in the September preview of WMF5 and are wondering why they stopped working after updating to the November preview, or you are looking at examples on some blogs that weren't using the November preview, then this could be the issue.
  * Variables defined in the scope of the class and used in a method's scope need to use $this.
  * Variable $a on class scope
  * To use in the the Set() method for example, you'd need to use $this.a

## Up next... {.}

The next articles will describe how to build a class based resource, what to look out for and why it isn't really that hard at all. I will also show the ConfigMgr resource in its end state at some point and will let you take part in my journey into dev-land. <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

Download the WMF 5 November preview here: [http://www.microsoft.com/en-us/download/details.aspx?id=44987<br /> ](http://www.microsoft.com/en-us/download/details.aspx?id=44987)
  
Enjoy!
  
-[David](http://www.twitter.com/david_obrien) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


