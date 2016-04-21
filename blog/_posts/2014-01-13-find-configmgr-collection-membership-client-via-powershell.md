---
id: 1567
title: How to find ConfigMgr Collection membership of client via Powershell?
date: 2014-01-13T15:47:52+00:00
author: "David O'Brien"
layout: single
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
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1: $ResID = (Get-CMDevice -Name "CLTwin7").ResourceID
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2: $Collections = (Get-WmiObject -Class sms_fullcollectionmembership -Namespace root\sms\site_HQ1 -Filter "ResourceID = '$($ResID)'").CollectionID
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3: foreach ($Collection in $Collections)
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:     {
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:         Get-CMDeviceCollection -CollectionId $Collection | select Name, CollectionID
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6:     }
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

&nbsp;

In line 1 just change the Name of the Client you want to check and in line 2 change the SiteCode (mine is HQ1).
  
Because of lines 1 and 5 you need to import the ConfigMgr Powershell module first.

[<img style="float: none; margin-left: auto; display: block; margin-right: auto; border: 0px;" title="SCCM Collection Membership" alt="SCCM Collection Membership" src="http://www.david-obrien.net/wp-content/uploads/2014/01/image_thumb10.png" width="244" height="63" border="0" />]("SCCM Collection Membership" http://www.david-obrien.net/wp-content/uploads/2014/01/image10.png) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

