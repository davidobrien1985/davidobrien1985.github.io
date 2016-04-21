---
id: 1671
title: Why you shouldn't use the Powershell pipe when using ConfigMgr
date: 2014-04-02T21:05:52+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1671
permalink: /2014/04/filter-faster-piping-using-configmgr/
categories:
  - automation
  - CM12
  - ConfigMgr
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
  - Uncategorized
tags:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - Powershell
  - SCCM
---
The other day I was asked why I used the -filter parameter in one of my Powershell scripts with Get-WmiObject instead of just doing a pipe to Where-Object.

When writing scripts for Configuration Manager you quite often have to use the Get-WmiObject cmdlet (or the gwmi alias) to get certain objects. But how do you manage to do it as performant as possible?

The answer to that is best shown with a quick example.

# Find ConfigMgr device with Powershell

My ConfigMgr demo environment consists of approximately 2500 demo machines in one domain. I now want to find a certain machine and I only know its name. As the Admin Console won't show more than 1,000 devices at first search by default I reckon it's faster to use Powershell.

Using the built-in ConfigMgr cmdlet would look like this:



<div id="wpshdo_4" class="wp-synhighlighter-outer">
  <div id="wpshdt_4" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_4"></a><a id="wpshat_4" class="wp-synhighlighter-title" href="#codesyntax_4"  onClick="javascript:wpsh_toggleBlock(4)" title="Click to show/hide code block">Source code</a>
        </td>

        <td align="right">
          <a href="#codesyntax_4" onClick="javascript:wpsh_code(4)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_4" onClick="javascript:wpsh_print(4)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>

  <div id="wpshdi_4" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Get<span class="sy0">-CMDevice <span class="kw5">-Name <span class="st0">"CON-LAP-01"
  </div>
</div>

This will give me the machine I'm looking for.

Here are some other ways to get one machine, they all work, but which is the most performant of them?

<div id="wpshdo_5" class="wp-synhighlighter-outer">
  <div id="wpshdt_5" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_5"></a><a id="wpshat_5" class="wp-synhighlighter-title" href="#codesyntax_5"  onClick="javascript:wpsh_toggleBlock(5)" title="Click to show/hide code block">Source code</a>
        </td>

        <td align="right">
          <a href="#codesyntax_5" onClick="javascript:wpsh_code(5)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_5" onClick="javascript:wpsh_print(5)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>

  <div id="wpshdi_5" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="kw1">Get-WmiObject –Class SMS_R_System –Namespace root\sms\site_HQ1 <span class="sy0">| <span class="kw1">Where-Object <span class="br0">&#123;<a href="about:blank"><span class="kw6">$_</a>.Name –eq „DO<span class="sy0">-LAP<span class="sy0">-0“<span class="br0">&#125;
<span class="kw1">Get-WmiObject <span class="kw5">-Namespace root\sms\site_HQ1 <span class="kw5">-Query <span class="st0">"SELECT * FROM SMS_R_System where name='DO-LAP-0'"
Get<span class="sy0">-CMDevice –Name <span class="st0">"DO-LAP-0"
  </div>
</div>

Measuring how long each of these commands will take in my environment is pretty self-explaining and should convince you of not using the pipe with Where-Object if possible.

<div id="wpshdo_6" class="wp-synhighlighter-outer">
  <div id="wpshdt_6" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_6"></a><a id="wpshat_6" class="wp-synhighlighter-title" href="#codesyntax_6"  onClick="javascript:wpsh_toggleBlock(6)" title="Click to show/hide code block">Source code</a>
        </td>

        <td align="right">
          <a href="#codesyntax_6" onClick="javascript:wpsh_code(6)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_6" onClick="javascript:wpsh_print(6)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>

  <div id="wpshdi_6" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="kw1">Measure-Command <span class="kw5">-Expression <span class="br0">&#123;Get<span class="sy0">-CMDevice –Name <span class="st0">"DO-LAP-0"<span class="br0">&#125;
<span class="kw1">Measure-Command <span class="kw5">-Expression <span class="br0">&#123;<span class="kw1">Get-WmiObject –Class SMS_R_System –Namespace root\sms\site_HQ1  <span class="sy0">| <span class="kw3">where <span class="br0">&#123;<a href="about:blank"><span class="kw6">$_</a>.Name –eq „DO<span class="sy0">-LAP<span class="sy0">-0“<span class="br0">&#125;<span class="br0">&#125;
<span class="kw1">Measure-Command <span class="kw5">-Expression <span class="br0">&#123;<span class="kw1">Get-WmiObject <span class="kw5">-Namespace root\SMS\site_HQ1 <span class="kw5">-Query <span class="st0">"SELECT * FROM SMS_R_System where name='DO-LAP-0'"<span class="br0">&#125;
<span class="kw1">Measure-Command <span class="kw5">-Expression <span class="br0">&#123;Get<span class="sy0">-CMDevice <span class="sy0">| <span class="kw1">Where-Object <span class="br0">&#123;<a href="about:blank"><span class="kw6">$_</a>.Name <span class="kw4">-eq <span class="st0">"DO-LAP-0"<span class="br0">&#125;<span class="br0">&#125;
<span class="kw1">Measure-Command <span class="kw5">-Expression <span class="br0">&#123;<span class="kw1">Get-WmiObject <span class="kw5">-Namespace root\sms\site_HQ1 <span class="kw5">-Class SMS_R_System <span class="sy0">-<span class="kw3">Filter <span class="st0">"name='DO-LAP-0'"<span class="br0">&#125;
  </div>
</div>

Here are the results:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/04/query_results.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/04/query_results.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1690" alt="query_results" src="http://www.david-obrien.net/wp-content/uploads/2014/04/query_results-289x300.jpg" width="289" height="300" /></a><a href="http://www.david-obrien.net/wp-content/uploads/2014/04/query_results2.jpg" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/04/query_results2.jpg', '']);" class="broken_link"><img class="img-responsive aligncenter size-medium wp-image-1691" alt="query_results2" src="http://www.david-obrien.net/wp-content/uploads/2014/04/query_results2-300x71.jpg" width="300" height="71" srcset="/media/2014/04/query_results2-300x71.jpg 300w, /media/2014/04/query_results2-250x59.jpg 250w, /media/2014/04/query_results2.jpg 905w" sizes="(max-width: 300px) 100vw, 300px" /></a>

# Why is the pipe so slow in Powershell?

What happens when you use the pipe?

Using the pipe tells Powershell to first execute the left side of the pipe and then take all those results over to the right side of the pipe and go through them again and find the result.Means: The first time it's getting ALL devices, even those not necessary and then the where-object searches through ALL those devices again. Why do it twice when you can get it right the first time around?

# Results

The results are obvious: Don't use the 'Where-Object' cmdlet. If possible use Get-WmiObject with -filter or even better -Query parameter.

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="CM12,ConfigMgr+2012,Configuration+Manager,Powershell,SCCM" data-count="vertical" data-url="http://www.david-obrien.net/2014/04/filter-faster-piping-using-configmgr/">Tweet</a>
</div>

