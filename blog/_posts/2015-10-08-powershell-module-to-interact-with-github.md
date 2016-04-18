---
id: 3116
title: PowerShell module to interact with Github
date: 2015-10-08T22:00:25+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=3116
permalink: /2015/10/powershell-module-to-interact-with-github/
categories:
  - automation
  - DevOps
  - Git
  - PowerShell
  - PowerShellGallery
tags:
  - automation
  - DevOps
  - git
  - github
  - gitlab
  - Powershell
  - powershell gallery
  - Windows PowerShell
---
I sometimes find myself in a situation where I need to do something on Github, but, because I still once in a while use Windows machines which don&#8217;t have any git installed, I have to go and use the Web UI, pretty clunky.

# Github API

Fortunately github offers a great Rest API with an awesome documentation. <a href="https://developer.github.com/v3/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://developer.github.com/v3/', 'https://developer.github.com/v3/']);" target="_blank">https://developer.github.com/v3/</a>

All calls to the Github API are over _**https **_and accept and respond with _**json**_.

From PowerShell it is very easy to interact with this web API via _Invoke-WebRequest _or _curl_.
  
The latter however is not the actual curl, but just an alias for Invoke-WebRequest.

<div id="wpshdo_39" class="wp-synhighlighter-outer">
  <div id="wpshdt_39" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_39"></a><a id="wpshat_39" class="wp-synhighlighter-title" href="#codesyntax_39"  onClick="javascript:wpsh_toggleBlock(39)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_39" onClick="javascript:wpsh_code(39)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_39" onClick="javascript:wpsh_print(39)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_39" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="kw1">Get-Alias</span> curl</pre>
  </div>
</div>

# Github authentication

Most Github API calls need authentication to happen before interacting with the API.
  
In order to connect to Github there are two scenarios:

  * Username and Password
  * Username and Password and One Time Password

The One Time Password is only needed if the user you are using to authenticate has 2 Factor Authentication / Multi-Factor-Authentication enabled for Github.

# PowerShell module for Github

The PowerShell module **GithubConnect** that I developed is currently (07/10/2015) available in version 0.5 and installable from the **<a href="http://www.powershellgallery.com" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.powershellgallery.com', 'PowerShell Gallery']);" target="_blank">PowerShell Gallery</a>.**

<a href="/media/2015/10/2015-10-07_23-50-06.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/10/2015-10-07_23-50-06.png', '']);" ><img class="img-responsive aligncenter wp-image-3117" src="/media/2015/10/2015-10-07_23-50-06-150x150.png" alt="PowerShell Gallery" width="236" height="236" /></a>

Find it and install it through the PSGet module:

<a href="https://www.powershellgallery.com/packages/GithubConnect/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://www.powershellgallery.com/packages/GithubConnect/', 'https://www.powershellgallery.com/packages/GithubConnect/']);" target="_blank">https://www.powershellgallery.com/packages/GithubConnect/</a>

<div id="wpshdo_40" class="wp-synhighlighter-outer">
  <div id="wpshdt_40" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_40"></a><a id="wpshat_40" class="wp-synhighlighter-title" href="#codesyntax_40"  onClick="javascript:wpsh_toggleBlock(40)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_40" onClick="javascript:wpsh_code(40)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_40" onClick="javascript:wpsh_print(40)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_40" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Find<span class="sy0">-</span>Module <span class="kw5">-Name</span> GithubConnect
Install<span class="sy0">-</span>Module <span class="kw5">-Name</span> GithubConnect</pre>
  </div>
</div>

The following cmdlets are currently implemented in version 0.5:

<div id="wpshdo_41" class="wp-synhighlighter-outer">
  <div id="wpshdt_41" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_41"></a><a id="wpshat_41" class="wp-synhighlighter-title" href="#codesyntax_41"  onClick="javascript:wpsh_toggleBlock(41)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_41" onClick="javascript:wpsh_code(41)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_41" onClick="javascript:wpsh_print(41)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_41" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Connect<span class="sy0">-</span>Github
Get<span class="sy0">-</span>GithubBranch
Get<span class="sy0">-</span>GithubOrgRepository
Get<span class="sy0">-</span>GithubOwnRepositories
Get<span class="sy0">-</span>GithubPublicRepositories
Get<span class="sy0">-</span>GithubWebhook
List<span class="sy0">-</span>GithubBranches
New<span class="sy0">-</span>GithubRepository
New<span class="sy0">-</span>GithubWebhook
Remove<span class="sy0">-</span>GithubRepository</pre>
  </div>
</div>

# Contributions welcome!

Of course, as always, if you want to add something to the module or would like to &#8220;properly&#8221; report and issue with the module, head over to Gitlab and check out the repository directly:

<a href="https://gitlab.com/dobrien/GithubConnect" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://gitlab.com/dobrien/GithubConnect', 'https://gitlab.com/dobrien/GithubConnect']);" target="_blank">https://gitlab.com/dobrien/GithubConnect</a>

Is this helpful?

<a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,DevOps,git,github,gitlab,Powershell,powershell+gallery,Windows+PowerShell" data-count="vertical" data-url="http://www.david-obrien.net/2015/10/powershell-module-to-interact-with-github/">Tweet</a>
</div>
