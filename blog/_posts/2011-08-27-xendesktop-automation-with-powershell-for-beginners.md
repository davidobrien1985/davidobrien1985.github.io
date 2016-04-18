---
id: 39
title: XenDesktop automation with Powershell (for beginners)
date: 2011-08-27T00:29:15+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=39
permalink: /2011/08/xendesktop-automation-with-powershell-for-beginners/
categories:
  - PowerShell
  - XenDesktop
tags:
  - automation
  - Citrix
  - Powershell
  - XenDesktop
---
Since XenDesktop 5 is around I began working with Microsoft&#8217;s PowerShell (I know what you&#8217;re thinking&#8230;&#8221;what? THAT late?&#8221;) And it&#8217;s been really easy to learn it because of XenDesktop&#8217;s integrated &#8216;script editor&#8217; which translates all the stuff you&#8217;re doing in the console into the appropriate Powershell commands.

The thing with XenDesktop 5 is now, that you can do quite a lot inside the Desktop Studio, like creating machines, assignments and such, but you can do lots more with a little help of your (maybe soon to be) friend named Powershell.
  
Like, have you ever tried assigning a catalog to an IP address or ever wanted to change the minimum number of idle desktops in a desktop group? Those things can only be done with Powershell.

By opening Desktop Studio we are presented with three default registers at the top of the console: Dashboard, Actions and Powershell.

<a href="http://www.david-obrien.de/wp-content/uploads/2011/08/ps_example.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/08/ps_example.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-41" title="ps_example" src="http://www.david-obrien.de/wp-content/uploads/2011/08/ps_example-300x136.jpg" alt="" width="300" height="136" /></a>

Everything you change, create or delete will eventually come up in there. Just try a bit around and have a look at a sort of history of what you&#8217;ve done.

By clicking on the Powershell button on this page you open up a shell which already has the Citrix cmdlets imported and you can instantly go and play around.
  
Or maybe you&#8217;re already an advanced user who wants to go ahead and use his own scripts to create Desktop groups or do some maintenance tasks, then you&#8217;ll need to import all the XenDesktop cmdlets into your Powershell.

Here&#8217;s how:
  
<a href="http://www.david-obrien.de/wp-content/uploads/2011/08/add-pssnapin.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2011/08/add-pssnapin.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-45" title="add-pssnapin" src="http://www.david-obrien.de/wp-content/uploads/2011/08/add-pssnapin-300x68.jpg" alt="" width="300" height="68" /></a>
  
If you now enter `Get-Module -Module Citrix.*` you&#8217;ll get all the available cmdlets. You can find an overview of them at Citrix&#8217;s site: <a href="http://support.citrix.com/static/kc/CTX127254/help/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://support.citrix.com/static/kc/CTX127254/help/', 'http://support.citrix.com/static/kc/CTX127254/help/']);" target="_blank">http://support.citrix.com/static/kc/CTX127254/help/</a>
  
One could also go and add these to his/her own Powershell profile. For those, look here: <a href="http://msdn.microsoft.com/en-us/library/bb613488(v=vs.85).aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://msdn.microsoft.com/en-us/library/bb613488(v=vs.85).aspx', 'http://msdn.microsoft.com/en-us/library/bb613488(v=vs.85).aspx']);" target="_blank">http://msdn.microsoft.com/en-us/library/bb613488(v=vs.85).aspx</a>

btw my most-used commandline is: `Set-BrokerDesktopGroup -Name %DesktopGroupName% -InMaintenanceMode $True` 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,Citrix,Powershell,XenDesktop" data-count="vertical" data-url="http://www.david-obrien.net/2011/08/xendesktop-automation-with-powershell-for-beginners/">Tweet</a>
</div>
