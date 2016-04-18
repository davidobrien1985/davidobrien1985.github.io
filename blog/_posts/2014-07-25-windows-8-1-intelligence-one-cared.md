---
id: 1870
title: What if Windows 8.1 had intelligence and no-one cared?
date: 2014-07-25T17:43:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1870
permalink: /2014/07/windows-8-1-intelligence-one-cared/
categories:
  - ConfigMgr
  - Configuration Manager
  - Deployment
  - GPO
  - MDT
  - SCCM
  - Windows 8.1
tags:
  - BIOS
  - ConfigMgr
  - deployment
  - GPO
  - Hardware
  - MDT
  - SCCM
  - Tablet
  - UEFI
  - WMI
---
I am currently working on a Windows 8.1 deployment that will end up on quite a few tablets used in retail stores. Interesting project from a requirements perspective, because usually I never had to worry about machines being stolen by customers that much 😉

# New Feature in Windows 8.1 Update

Of course, I am deploying Windows 8.1 Update (latest and greatest!) to these tablets which is easy. Create a Build & Capture Task Sequence in MDT and afterwards deploy it with whatever you like. I have to stick to MDT as a deployment tool for the time being, as the customer has not yet upgraded their ConfigMgr environment to 2012 R2.

These tablets (Lenovo Thinkpad Tablet 10 by the way) are of course touch and always used with touch, because the retail agents will be walking around with these devices. Because of this the customer wants the Operating System to boot to Start and not to desktop and use as many modern / immersive applications as possible, for example IE11.

It&#8217;s pretty easy to force this behaviour via Group Policy. What would happen though, if the Organisational Unit (OU) these tablets are in, does not only have tablets, but also Laptops which are not touch enabled? You would need to create some kind of filter to only apply this setting to the touch-enabled tablets, right? WRONG!

Microsoft implemented a neat little feature into Windows 8.1 Update which automatically detects whether it is running on a tablet / slate or something else. This feature, if it detects that it&#8217;s running on a slate device, will automatically let Windows boot to Start and set File Type Associations to open up the modern / immersive applications. If it detects that it&#8217;s running on a mobile or desktop device, then it will boot to Desktop and use the desktop IE11.

Pretty cool, huh? So away goes that GPO!

**STOP!**

# POWER\_PLATFORM\_ROLE enumeration

How does Windows 8.1 Update know what it&#8217;s running on? It&#8217;s checking a hardware property, which needs to be set by the device&#8217;s vendor. It&#8217;s called POWER\_PLATFORM\_ROLE, seems to be part of PowrProf.dll and can be queried like this:

<div id="wpshdo_11" class="wp-synhighlighter-outer">
  <div id="wpshdt_11" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_11"></a><a id="wpshat_11" class="wp-synhighlighter-title" href="#codesyntax_11"  onClick="javascript:wpsh_toggleBlock(11)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_11" onClick="javascript:wpsh_code(11)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_11" onClick="javascript:wpsh_print(11)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_11" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="br0">&#40;</span><span class="kw1">get-wmiobject</span> win32_computersystem<span class="br0">&#41;</span>.PCSystemType</pre>
  </div>
</div>

More information on this POWER\_PLATFORM\_ROLE can be found here: <a href="http://msdn.microsoft.com/en-us/library/aa373174%28v=vs.85%29.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://msdn.microsoft.com/en-us/library/aa373174%28v=vs.85%29.aspx', 'http://msdn.microsoft.com/en-us/library/aa373174%28v=vs.85%29.aspx']);" title="http://msdn.microsoft.com/en-us/library/aa373174%28v=vs.85%29.aspx">http://msdn.microsoft.com/en-us/library/aa373174%28v=vs.85%29.aspx</a>

What&#8217;s the result of above query if you run it on your device? Chances are it&#8217;s probably 1, 2 or 4. Bad luck, this cool feature won&#8217;t work on your device.

Windows will only boot to Start if this property has a value of &#8216;8&#8217;. (<a href="http://msdn.microsoft.com/en-us/library/windows/desktop/aa373174%28v=vs.85%29.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://msdn.microsoft.com/en-us/library/windows/desktop/aa373174%28v=vs.85%29.aspx', 'http://msdn.microsoft.com/en-us/library/windows/desktop/aa373174%28v=vs.85%29.aspx']);" title="http://msdn.microsoft.com/en-us/library/windows/desktop/aa373174%28v=vs.85%29.aspx">http://msdn.microsoft.com/en-us/library/windows/desktop/aa373174%28v=vs.85%29.aspx</a>)

I started a quick poll on Twitter the other day asking people to run that query and report back with their result and hardware:

<table border="0" width="700" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">ASUS All-in-One ET2321I</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">All-in-One with touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">HP Probook 6560b</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">HP Elitebook 8470w</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Dell Latitude E6230</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Dell Latitude E6420</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Dell Latitude E6540</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Dell XPS 15 9530</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Dell Optiplex 990</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">1</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Lenovo 10123 (Ideacentre A730)</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">1</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Lenovo T440 P</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Lenovo X230 Tablet</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #9bbb59;">Lenovo W530</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #9bbb59;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #9bbb59;">no touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Lenovo Thinkpad Tablet 10</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Lenovo 20266 (Yoga Pro 2)</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Microsoft Surface Pro (1. Gen)</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
      <span style="color: #c0504d;">Microsoft Surface Pro (3. Gen)</span>
    </td>
    
    <td valign="top" width="225">
      <span style="color: #c0504d;">2</span>
    </td>
    
    <td valign="top" width="221">
      <span style="color: #c0504d;">touch</span>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
    </td>
    
    <td valign="top" width="225">
    </td>
    
    <td valign="top" width="221">
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="252">
    </td>
    
    <td valign="top" width="225">
    </td>
    
    <td valign="top" width="221">
    </td>
  </tr>
</table>

I guess you get the point. No vendor bothers to call their touch devices what they are. Not even Microsoft, not even on the latest of the latest devices! It&#8217;s a bit like the Chassis Type thing we here and there have to struggle with when we try to rely on MDT to gather if the device we want to deploy to is a Laptop or a Desktop.

If you are in a position where you are buying devices for your company, then please do us all a favour and try to force the vendor to put in the correct value in this property.
  
Maybe you have a device that already tells you the truth and you want to have it on this list? Just put it into the comments and I&#8217;ll update the table. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="BIOS,ConfigMgr,deployment,GPO,Hardware,MDT,SCCM,Tablet,UEFI,WMI" data-count="vertical" data-url="http://www.david-obrien.net/2014/07/windows-8-1-intelligence-one-cared/">Tweet</a>
</div>
