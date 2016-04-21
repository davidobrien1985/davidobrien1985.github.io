---
id: 1845
title: 'Powershell DSC 101 - How to add Windows Features'
date: 2014-07-09T22:04:48+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1845
permalink: /2014/07/powershell-dsc-101-add-windows-features/
categories:
  - automation
  - PowerShell
  - scripting
tags:
  - automation
  - Desired State Configuration
  - DSC
  - Powershell
  - Windows Features
---
Powershell Desired State Configuration is a very powerful feature of Powershell 4.0 and Windows Server 2012 R2. Coming from a very strong Microsoft System Center Configuration Manager background I like to think of it a bit as Compliance Settings. I'm configuring a state I want a Server to be in and DSC makes sure it ends up looking like that (and even stays like that - remediation!). And all that, if you like, without the "overhead" of any additional infrastructure (and even for Linux!) Crazy?! <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

More information around DSC can be found here: [http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx]("http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx" http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx) and [http://technet.microsoft.com/en-us/library/dn249912.aspx]("http://technet.microsoft.com/en-us/library/dn249912.aspx" http://technet.microsoft.com/en-us/library/dn249912.aspx)

# WindowsFeature resource in DSC

Being based on Powershell, DSC knows certain keywords you can use in your configuration file. I won't go too much into detail for all of them, but here's a high-level view on a very simple DSC configuration.

<div id="wpshdo_8" class="wp-synhighlighter-outer">
  <div id="wpshdt_8" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_8"></a><a id="wpshat_8" class="wp-synhighlighter-title" href="#codesyntax_8"  onClick="javascript:wpsh_toggleBlock(8)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_8" onClick="javascript:wpsh_code(8)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_8" onClick="javascript:wpsh_print(8)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_8" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Configuration SimpleDSC
<span class="br0">&#123;
        <span class="kw3">param <span class="br0">&#40; <span class="re0">$NodeName <span class="br0">&#41;
        Node <span class="re0">$NodeName
        <span class="br0">&#123;
            WindowsFeature WebServer
                <span class="br0">&#123;
                    Ensure <span class="sy0">= <span class="st0">"Present"
                    Name <span class="sy0">= <span class="st0">"Web-Server"
		<span class="br0">&#125;
	<span class="br0">&#125;
<span class="br0">&#125;
  </div>
</div>

Just by configuring this I am telling DSC to ensure that the Windows Feature "Web-Server" is present on that Node.
  
You can find all the Feature Names you can use here by executing

> Get-WindowsFeature | Out-GridView

<a href="http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1846" src="http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg" alt="2014-07-09 21_48_35-SMAWorker01 on NB-DOBRIEN - Virtual Machine Connection" width="483" height="384" srcset="/media/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection-300x238.jpg 300w, /media/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection-150x119.jpg 150w, /media/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg 904w" sizes="(max-width: 483px) 100vw, 483px" /></a>After adding in all the Windows Features you would like to have on that server, compiling the MOF and pushing the setting onto the server, you can see the results in your Powershell console:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1847" src="http://www.david-obrien.net/wp-content/uploads/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg" alt="Start-DSCConfiguration" width="955" height="341" srcset="/media/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection-300x107.jpg 300w, /media/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection-1024x365.jpg 1024w, /media/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection-250x89.jpg 250w, /media/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg 1805w" sizes="(max-width: 955px) 100vw, 955px" /></a>Adding that one Windows Feature (Web-Server) and a child feature (Web-Basic-Auth) to the server only took DSC 36 seconds, very nice.
  
You can find more information about the "WindowsFeature" DSC resource here: <a href="http://technet.microsoft.com/en-us/library/dn282127.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://technet.microsoft.com/en-us/library/dn282127.aspx', 'http://technet.microsoft.com/en-us/library/dn282127.aspx']);" target="_blank">http://technet.microsoft.com/en-us/library/dn282127.aspx</a>

In the next article I am going to show you how to leverage this basic knowledge here to deploy some cool custom Server Roles in your environment!

I hope this short trip into DSC-land was already enough to get you hooked (if you're not already) onto the new Powershell features that came with Powershell 4.

- <a href="https://twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/david_obrien', '@david_obrien']);" target="_blank">@david_obrien</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,Desired+State+Configuration,DSC,Powershell,Windows+Features" data-count="vertical" data-url="http://www.david-obrien.net/2014/07/powershell-dsc-101-add-windows-features/">Tweet</a>
</div>


