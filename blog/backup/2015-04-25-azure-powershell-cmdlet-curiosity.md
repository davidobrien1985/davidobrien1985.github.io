---
id: 3017
title: Azure PowerShell cmdlet curiosity
date: 2015-04-25T13:53:20+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=3017
permalink: /2015/04/azure-powershell-cmdlet-curiosity/
categories:
  - Azure
  - PowerShell
  - Uncategorized
tags:
  - Azure
  - Cloud
  - IaaS
  - Powershell
  - SDK
---
This is a real quick one.

In preparation to the Global Azure Bootcamp in Melbourne I had to write a lot of PowerShell code and while provisioning VMs on Azure I came across a strange issue which took me a while to troubleshoot.

# New-AzureVMConfig case-sensitive

I wanted to run the following script:

<div id="wpshdo_34" class="wp-synhighlighter-outer">
  <div id="wpshdt_34" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_34"></a><a id="wpshat_34" class="wp-synhighlighter-title" href="#codesyntax_34"  onClick="javascript:wpsh_toggleBlock(34)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_34" onClick="javascript:wpsh_code(34)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_34" onClick="javascript:wpsh_print(34)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_34" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="re0">$AzureVMImage</span> <span class="sy0">=</span> Get<span class="sy0">-</span>AzureVMImage <span class="sy0">|</span> <span class="kw1">Where-Object</span> <span class="br0">&#123;</span> <a href="about:blank"><span class="kw6">$_</span></a>.ImageFamily <span class="kw4">-eq</span> <span class="st0">'Windows Server 2012 R2 Datacenter'</span> <span class="br0">&#125;</span> <span class="sy0">|</span> <span class="kw1">Sort-Object</span> <span class="kw5">-Descending</span> <span class="kw5">-Property</span> PublishedDate <span class="sy0">|</span> Out<span class="sy0">-</span>GridView <span class="sy0">-</span>OutputMode Single
New<span class="sy0">-</span>AzureService <span class="sy0">-</span>ServiceName test <span class="sy0">-</span>Location <span class="st0">'Southeast Asia'</span>
<span class="re0">$vm</span> <span class="sy0">=</span> New<span class="sy0">-</span>AzureVMConfig <span class="sy0">-</span>InstanceSize small <span class="kw5">-Name</span> test <span class="sy0">-</span>ImageName <span class="re0">$AzureVMImage</span>.ImageName
<span class="re0">$vm</span> <span class="sy0">=</span> Add<span class="sy0">-</span>AzureProvisioningConfig <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>Windows <span class="sy0">-</span>AdminUsername <span class="st0">'adobrien'</span> <span class="sy0">-</span>Password <span class="st0">'P@ssw0rd'</span> <span class="kw5">-Verbose</span> 
&nbsp;
New<span class="sy0">-</span>AzureVM <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>ServiceName <span class="st0">'test'</span> <span class="kw5">-Verbose</span> <span class="sy0">-</span>Location <span class="st0">'Southeast Asia'</span></pre>
  </div>
</div>

It resulted in this output:

<a href="/media/2015/04/1429933109_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/04/1429933109_full.png', '']);" target="_blank"><img class="img-responsive aligncenter" src="/media/2015/04/1429933109_thumb.png" alt="" align="middle" /></a>

Strange, I specified a RoleSize of small and that is a valid value, or is it?
  
small is **unequal** to Small. That parameter of <a href="https://msdn.microsoft.com/en-us/library/azure/dn495159.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://msdn.microsoft.com/en-us/library/azure/dn495159.aspx', 'New-AzureVMConfig']);" target="_blank">New-AzureVMConfig</a> is case-sensitive.

Note:

> New-AzureVMConfig -InstanceSize small

Fails!

> New-AzureVMConfig -InstanceSize Small

Works!

Also note, the whole Azure SDK is still pre-release, so this might change in the future.

Thanks to <a href="http://www.twitter.com/alexandair" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/alexandair', 'Aleksandar Nikolic']);" target="_blank">Aleksandar Nikolic</a> for reminding me of this again. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Azure,Cloud,IaaS,Powershell,SDK" data-count="vertical" data-url="http://www.david-obrien.net/2015/04/azure-powershell-cmdlet-curiosity/">Tweet</a>
</div>

