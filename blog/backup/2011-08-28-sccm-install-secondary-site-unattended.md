---
id: 60
title: 'SCCM - Install secondary site unattended'
date: 2011-08-28T09:49:59+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=60
permalink: /2011/08/sccm-install-secondary-site-unattended/
categories:
  - SCCM
tags:
  - Configuration Manager
  - SCCM
  - System Center
  - unattended
---
At a customer's site I was asked if one could install a SCCM 2007 site silently and unattended.

At this customer of mine there are going to be round about 170 to 180 sites and surely nobody would want to do a manual installation of all those sites. Furthermore this customer is highly automated and nearly no software is installed by hand.

How do we install a SCCM site unattended?

By calling setup.exe with the /script switch pointing to an .ini file you're able to install both primary and secondary sites, depending on your needs.

In my example I have to install lots of secondary sites. All the required parameters for my installation will be read by setup.exe out of my ini file which could be looking like this:

<span style="font-family: monospace;">

<div id="wpshdo_1" class="wp-synhighlighter-outer">
  <div id="wpshdt_1" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_1"></a><a id="wpshat_1" class="wp-synhighlighter-title" href="#codesyntax_1"  onClick="javascript:wpsh_toggleBlock(1)" title="Click to show/hide code block">installsecondarysite.ini</a>
        </td>

        <td align="right">
          <a href="#codesyntax_1" onClick="javascript:wpsh_code(1)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_1" onClick="javascript:wpsh_print(1)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>

  <div id="wpshdi_1" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="php" style="font-family:monospace;"><span class="br0">[</span>Identification<span class="br0">]</span>
&nbsp;
Action<span class="sy0">=</span>InstallSecondarySite
&nbsp;
<span class="br0">[</span>Options<span class="br0">]</span>
&nbsp;
SiteCode<span class="sy0">=</span>S01
&nbsp;
PrerequisiteComp<span class="sy0">=</span><span class="nu0">1</span>
&nbsp;
PrerequisitePath<span class="sy0">=</span><span class="st0">"<span class="es6">%s</span>ccmserver%prereqs"</span>
&nbsp;
SiteName<span class="sy0">=</span><span class="st0">"Secondary 1"</span>
&nbsp;
SMSInstallDir<span class="sy0">=</span><span class="st0">"%ProgramFiles%SCCM"</span>
&nbsp;
DistributionPoint<span class="sy0">=</span><span class="nu0">1</span>
&nbsp;
AddressType<span class="sy0">=</span>MS_LAN
&nbsp;
ParentSiteCode<span class="sy0">=</span>LAB
&nbsp;
ParentSiteServer<span class="sy0">=</span>SCCM01</pre>
  </div>
</div>

<br /> </span>

My command-line would then look like this: `Setup.exe /script C:tempinstallsecondarysite.ini /nouserinput`

For all other parameters read Microsoft's Technet: <a href="http://technet.microsoft.com/en-us/library/bb693561.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://technet.microsoft.com/en-us/library/bb693561.aspx', 'http://technet.microsoft.com/en-us/library/bb693561.aspx']);" title="Technet Unattended Setup Overview"  target="_blank">http://technet.microsoft.com/en-us/library/bb693561.aspx</a>
