---
id: 3108
title: PowerShell DSC to manage PowerShell modules
date: 2015-09-24T22:01:57+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=3108
permalink: /2015/09/powershell-dsc-to-manage-powershell-modules/
categories:
  - automation
  - Configuration Management
  - Desired State Configuration
  - DevOps
  - PowerShell
tags:
  - Ansible
  - Chef
  - Configuration Management
  - DevOps
  - Powershell
  - Powershell DSC
  - PowerShellGallery
  - PSDSC
  - Puppet
  - Windows
  - Windows 10
---
While on my way back from the 2015 IT DevConnections conference, it was a loooooong way back, I got the idea that I somehow wanted to make sure that certain PowerShell modules were installed on my servers, without logging on to every server (\*brrr\*) and installing them all manually.
  
I use <a href="https://www.vagrantup.com" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://www.vagrantup.com', 'Vagrant']);" title="Vagrant"  target="_blank">Vagrant</a> to quickly spin up new test environments on my MacBook as I need them. The Vagrant boxes I use might not always be up to date with everything or might miss some things.

Vagrant doesn&#8217;t only provision new machines, it can also call scripts or execute commands while provisioning the machine, such as applying DSC configuration to a machine.

<!--more-->

# Class based DSC Resource

So I sat down (I already sat, on a plane, for 14.5 hours&#8230;) and started writing code, a PowerShell DSC resource, class-based, obviously. Latest and greatest 😉
  
If you want to read more about class based resources, check out my previous articles, <a href="http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/', 'here']);" target="_blank">here</a> and <a href="http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-resource-basics-part-2/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-resource-basics-part-2/', 'here']);" target="_blank">here</a>.
  
This resource supports the installation and removal of PowerShell modules through native PowerShell version 5 functionality.
  
The Set() Method uses **Find-Module** and **Install-Module / Uninstall-Module** to bring the machine into its desired state.
  
These cmdlets use nuget to reach out to <a href="http://www.powershellgallery.com" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.powershellgallery.com', 'Microsoft&#8217;s PowerShell Gallery']);" target="_blank">Microsoft&#8217;s PowerShell Gallery</a> to find and install PowerShell Modules, which by the way also includes DSC Resources.

## Requirements

In order to use my custom DSC resource the following prerequisites need to be met:

  * WMF 5 / PowerShell v5 (preferably Production Preview or later)
  * Internet connection (for now)

## How to get the resource and contribute

The Resource / Module itself is available on the PowerShell Gallery and can easily be installed by executing
  


<div id="wpshdo_38" class="wp-synhighlighter-outer">
  <div id="wpshdt_38" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_38"></a><a id="wpshat_38" class="wp-synhighlighter-title" href="#codesyntax_38"  onClick="javascript:wpsh_toggleBlock(38)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_38" onClick="javascript:wpsh_code(38)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_38" onClick="javascript:wpsh_print(38)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_38" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Install<span class="sy0">-</span>Module <span class="kw5">-Name</span> PowerShellModule</pre>
  </div>
</div>


  
From here on you can use the resource in any of your DSC configurations or via Invoke-DscResource.
  
You think I could&#8217;ve done a better job and want to contribute to my resource? Awesome! Head over to Github and contribute: <a href="http://www.github.com/davidobrien1985/DscResources" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.github.com/davidobrien1985/DscResources', 'http://www.github.com/davidobrien1985/DscResources']);" >http://www.github.com/davidobrien1985/DscResources</a>
  
If I like what you&#8217;ve done, I&#8217;ll happily merge it into my repository and give ALL the credits!
  
Stuff on my ToDo list can be found in the same repository under <a href="https://github.com/davidobrien1985/DscResources/issues" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://github.com/davidobrien1985/DscResources/issues', '&#8220;Issues&#8221;']);" target="_blank">&#8220;Issues&#8221;</a>.

## How to use the DSC resource

<a href="/media/2015/09/1443095754_full.jpeg" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/09/1443095754_full.jpeg', '']);" target="_blank"><img class="img-responsive aligncenter" src="/media/2015/09/1443095754_thumb.jpeg" alt="" align="middle" /></a>

With this little snippet I can make sure that the &#8216;AzureExt&#8217; PowerShell module is installed from the PowerShell Gallery.

**Bonus:
  
** Don&#8217;t like writing full DSC documents? You know how to properly manage your systems via Puppet, Chef, Ansible, etc? Use my resource like this:

<a href="/media/2015/09/1443096018_full.jpeg" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/09/1443096018_full.jpeg', '']);" target="_blank"><img class="img-responsive aligncenter" src="/media/2015/09/1443096018_thumb.jpeg" alt="" align="middle" /></a>

Nice? Any feedback?

Watch Github and the Gallery for updates!

&#8211;<a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Ansible,Chef,Configuration+Management,DevOps,Powershell,Powershell+DSC,PowerShellGallery,PSDSC,Puppet,Windows,Windows+10" data-count="vertical" data-url="http://www.david-obrien.net/2015/09/powershell-dsc-to-manage-powershell-modules/">Tweet</a>
</div>
