---
id: 2760
title: Recover deleted users in Azure Active Directory
date: 2014-12-04T20:12:31+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2760
permalink: /2014/12/recover-deleted-users-azure-active-directory/
categories:
  - Azure
  - Office365
  - PowerShell
tags:
  - AAD
  - active directory
  - Azure
  - O365
  - Office365
  - Powershell
---
You know of the [recycle bin in Active Directory](http://technet.microsoft.com/en-us/library/dd392261%28v=ws.10%29.aspx), right?

I guess this feature has probably saved a bunch of people already big time. Anyways, even the cloud can’t save you from stupidity, failures or “Are you sure? Of course I’m sure!” situations when, for whatever reason, user accounts get deleted when they should not have been deleted.

This scenario will specifically show how you can recover deleted user accounts both from Office 365 and also from Azure Active Directory.

# Azure Active Directory

You can’t view deleted users in your Azure Portal (unless you can show me where!), too bad. Gone is gone.

PowerShell to the rescue.

Connect your PowerShell session to your Azure Active Directory by using the MSOnline module.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb.png" alt="image" width="396" height="198" border="0" />]("image" /media/2014/12/image.png)

You can use the following function to easily connect yourself to MSOnline:

<div id="wpshdo_18" class="wp-synhighlighter-outer">
  <div id="wpshdt_18" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_18"></a><a id="wpshat_18" class="wp-synhighlighter-title" href="#codesyntax_18"  onClick="javascript:wpsh_toggleBlock(18)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_18" onClick="javascript:wpsh_code(18)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_18" onClick="javascript:wpsh_print(18)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_18" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="co1">#region Functions</span>
<span class="kw3">Function</span> Save<span class="sy0">-</span>Password
<span class="br0">&#123;</span>
  <span class="kw3">Param</span>
  <span class="br0">&#40;</span>
    <span class="br0">[</span>parameter<span class="br0">&#40;</span>Mandatory <span class="sy0">=</span> <span class="re0">$true</span><span class="br0">&#41;</span><span class="br0">]</span>
    <span class="br0">[</span><span class="re3">String</span><span class="br0">]</span>
    <span class="re0">$FilePath</span><span class="sy0">,</span>
&nbsp;
    <span class="br0">[</span>parameter<span class="br0">&#40;</span>Mandatory <span class="sy0">=</span> <span class="re0">$false</span><span class="br0">&#41;</span><span class="br0">]</span>
    <span class="br0">[</span><span class="kw3">Switch</span><span class="br0">]</span>
    <span class="re0">$PassThru</span>
  <span class="br0">&#41;</span>
&nbsp;
  <span class="re0">$secure</span> <span class="sy0">=</span> <span class="kw1">Read-Host</span> <span class="kw5">-AsSecureString</span> <span class="st0">'Enter your Azure organization ID password.'</span>
  <span class="re0">$encrypted</span> <span class="sy0">=</span> <span class="kw1">ConvertFrom-SecureString</span> <span class="kw5">-SecureString</span> <span class="re0">$secure</span>
  <span class="re0">$result</span> <span class="sy0">=</span> <span class="kw1">Set-Content</span> <span class="kw5">-Path</span> <span class="re0">$FilePath</span> <span class="kw5">-Value</span> <span class="re0">$encrypted</span> <span class="kw5">-PassThru</span>
&nbsp;
  <span class="kw3">if</span> <span class="br0">&#40;</span><span class="sy0">!</span><span class="re0">$result</span><span class="br0">&#41;</span>
  <span class="br0">&#123;</span>
    <span class="kw3">throw</span> <span class="st0">"Failed to store encrypted string at $FilePath."</span>
  <span class="br0">&#125;</span>
  <span class="kw3">if</span> <span class="br0">&#40;</span><span class="re0">$PassThru</span><span class="br0">&#41;</span>
  <span class="br0">&#123;</span>
    <span class="kw1">Get-ChildItem</span> <span class="re0">$FilePath</span>
  <span class="br0">&#125;</span>
<span class="br0">&#125;</span>
&nbsp;
<span class="co1">#endregion Functions</span>
<span class="co1">#region connect to MSOnline</span>
try <span class="br0">&#123;</span>
  <span class="kw3">if</span> <span class="br0">&#40;</span><span class="kw4">-not</span> <span class="br0">&#40;</span>Get<span class="sy0">-</span>Module <span class="kw5">-Name</span> MSOnline<span class="br0">&#41;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
    <span class="re0">$null</span> <span class="sy0">=</span> Import<span class="sy0">-</span>Module <span class="kw5">-Name</span> MSOnline
  <span class="br0">&#125;</span>
<span class="br0">&#125;</span> 
catch <span class="br0">&#123;</span>
  <span class="kw1">Write-Error</span> <span class="kw5">-Message</span> <span class="br0">&#123;</span><span class="br0">&#125;</span> <span class="kw4">-f</span> <span class="re0">$PSItem</span>;
<span class="br0">&#125;</span>
&nbsp;
<span class="re0">$FilePath</span> <span class="sy0">=</span> Save<span class="sy0">-</span>Password <span class="kw5">-FilePath</span> <span class="st0">'C:\Users\David\OneDrive\Scripts\Azure\Password_MSOL.txt'</span> <span class="kw5">-PassThru</span>
<span class="re0">$userName</span> <span class="sy0">=</span> <span class="st0">'david@dopsftw.onmicrosoft.com'</span>
<span class="re0">$securePassword</span> <span class="sy0">=</span> <span class="kw1">ConvertTo-SecureString</span> <span class="br0">&#40;</span><span class="kw1">Get-Content</span> <span class="kw5">-Path</span> <span class="re0">$FilePath</span><span class="br0">&#41;</span>
<span class="re0">$msolcred</span> <span class="sy0">=</span> <span class="kw1">New-Object</span> System.Management.Automation.PSCredential<span class="br0">&#40;</span><span class="re0">$userName</span><span class="sy0">,</span> <span class="re0">$securePassword</span><span class="br0">&#41;</span>
&nbsp;
connect<span class="sy0">-</span>msolservice <span class="kw5">-credential</span> $msolcred</pre>
  </div>
</div>

Logged on to your Azure Portal (<a href="https://manage.windowsazure.com" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://manage.windowsazure.com', 'https://manage.windowsazure.com']);" >https://manage.windowsazure.com</a> ) you can view all your users in your Domains.

<a href="/media/2014/12/image1.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image1.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb1.png" alt="image" width="367" height="287" border="0" /></a>

What you can’t do via this GUI/website is, view a recycle bin. If you go and delete a user from here, that user is gone from your view.

The way you restore a user account in this situation is very simple using PowerShell.

<div id="wpshdo_19" class="wp-synhighlighter-outer">
  <div id="wpshdt_19" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_19"></a><a id="wpshat_19" class="wp-synhighlighter-title" href="#codesyntax_19"  onClick="javascript:wpsh_toggleBlock(19)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_19" onClick="javascript:wpsh_code(19)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_19" onClick="javascript:wpsh_print(19)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_19" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Get<span class="sy0">-</span>MsolUser <span class="sy0">-</span>ReturnDeletedUser</pre>
  </div>
</div>

<a href="/media/2014/12/image2.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image2.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb2.png" alt="image" width="388" height="50" border="0" /></a>

This will show all user accounts that have been previously deleted.

<div id="wpshdo_20" class="wp-synhighlighter-outer">
  <div id="wpshdt_20" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_20"></a><a id="wpshat_20" class="wp-synhighlighter-title" href="#codesyntax_20"  onClick="javascript:wpsh_toggleBlock(20)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_20" onClick="javascript:wpsh_code(20)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_20" onClick="javascript:wpsh_print(20)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_20" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Get<span class="sy0">-</span>MsolUser <span class="sy0">-</span>ReturnDeletedUsers <span class="sy0">|</span> <span class="kw3">foreach</span> <span class="br0">&#123;</span><span class="re0">$PSItem</span> <span class="sy0">|</span> <span class="kw2">fl</span> <span class="sy0">*</span> <span class="kw5">-Force</span><span class="br0">&#125;</span></pre>
  </div>
</div>

This will show you even more information on that deleted user. For example if you have a look at the ‘SoftDeletionTimestamp’ property. The first picture is from the user before we deleted it, the second after we deleted it.

&nbsp;

<a href="/media/2014/12/image3.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image3.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb3.png" alt="image" width="214" height="273" border="0" /></a><a href="/media/2014/12/image4.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image4.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb4.png" alt="image" width="219" height="244" border="0" /></a>

Use the following command to restore deleted accounts:

<div id="wpshdo_21" class="wp-synhighlighter-outer">
  <div id="wpshdt_21" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_21"></a><a id="wpshat_21" class="wp-synhighlighter-title" href="#codesyntax_21"  onClick="javascript:wpsh_toggleBlock(21)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_21" onClick="javascript:wpsh_code(21)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_21" onClick="javascript:wpsh_print(21)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_21" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Restore<span class="sy0">-</span>MsolUser <span class="sy0">-</span>UserPrincipalName <span class="st0">'TestUser01@dopsftw.onmicrosoft.com'</span></pre>
  </div>
</div>

# Office 365 Admin Portal – deleted users

The Office 365 Admin Portal (<a href="https://portal.office.com" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://portal.office.com', 'https://portal.office.com']);" >https://portal.office.com</a> ) makes it a bit easier for the common administrator to restore deleted user accounts.

<a href="/media/2014/12/image5.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image5.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb5.png" alt="image" width="371" height="139" border="0" /></a>

<a href="/media/2014/12/image6.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2014/12/image6.png', '']);" ><img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="/media/2014/12/image_thumb6.png" alt="image" width="381" height="174" border="0" /></a>

Still, the MSOnline cmdlets work both for Azure Active Directory and for users in your Office365 Active Directory.

-<a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="AAD,active+directory,Azure,O365,Office365,Powershell" data-count="vertical" data-url="http://www.david-obrien.net/2014/12/recover-deleted-users-azure-active-directory/">Tweet</a>
</div>


