---
id: 1567
title: How to find ConfigMgr Collection membership of client via Powershell?
date: 2014-01-13T15:47:52+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1567
permalink: /2014/01/find-configmgr-collection-membership-client-via-powershell/
categories:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - Powershell
  - SCCM
---
During my session today at the ConfigMgr User Group in Zurich / CH I demoed a little Powershell function which will output all the Collection Names a device is a member of. Unfortunately, this cannot be done by default from the Admin Console.

I know there are Console extensions doing EXACTLY the same, but I know of people who don’t want to install any extensions not made available by the vendor. This is why I wrote this little snippet which in turn can easily be turned into a function.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> $ResID = (Get-CMDevice -Name <span style="color: #006080;">"CLTwin7"</span>).ResourceID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2:</span> $Collections = (Get-WmiObject -Class sms_fullcollectionmembership -Namespace root\sms\site_HQ1 -Filter <span style="color: #006080;">"ResourceID = '$($ResID)'"</span>).CollectionID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3:</span> <span style="color: #0000ff;">foreach</span> ($Collection <span style="color: #0000ff;">in</span> $Collections)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:</span>         Get-CMDeviceCollection -CollectionId $Collection | select Name, CollectionID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

&nbsp;

In line 1 just change the Name of the Client you want to check and in line 2 change the SiteCode (mine is HQ1).
  
Because of lines 1 and 5 you need to import the ConfigMgr Powershell module first.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/01/image10.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/01/image10.png', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="SCCM Collection Membership" alt="SCCM Collection Membership" src="http://www.david-obrien.net/wp-content/uploads/2014/01/image_thumb10.png" width="244" height="63" border="0" /></a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="ConfigMgr,Configuration+Manager,Microsoft,Powershell,SCCM" data-count="vertical" data-url="http://www.david-obrien.net/2014/01/find-configmgr-collection-membership-client-via-powershell/">Tweet</a>
</div>
