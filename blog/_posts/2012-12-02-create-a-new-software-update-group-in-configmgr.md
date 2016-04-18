---
id: 532
title: Create a new Software Update Group in ConfigMgr
date: 2012-12-02T23:23:42+00:00
author: "David O'Brien"
layout: post
guid: http://david-obrien.de/?p=532
permalink: /2012/12/create-a-new-software-update-group-in-configmgr/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - scripting
  - System Center
  - System Center Configuration Manager
tags:
  - automation
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Powershell
  - SCCM
  - Software Updates
  - WSUS
---
**[Update 07.01.2013]**

This post is still valid. Nevertheless, find a more recent script version here: <a href="http://www.david-obrien.net/2013/01/07/update-how-to-create-a-new-software-update-group-in-configmgr-2012/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2013/01/07/update-how-to-create-a-new-software-update-group-in-configmgr-2012/', '&#8220;Update: How to create a new Software Update Group in ConfigMgr 2012&#8221;']);" title="Update: How to create a new Software Update Group in ConfigMgr 2012"  target="_blank">&#8220;Update: How to create a new Software Update Group in ConfigMgr 2012&#8221;</a>

On my way to automating everything possible in Microsoft System Center 2012 Configuration Manager I thought about new things to play with.
  
A week ago a colleague of mine asked me some questions regarding Software Update management in ConfigMgr and how we should handle them in a project that we both are currently working on.
  
His questions were related to how we would manage new software updates coming in every month.

That brought up the idea of scripting the creation of new Software Update groups and adding new updates to them.

# Embedded classes and lazy properties in WMI

Unfortunately Microsoft doesn’t give us a cmdlet to just create a new Software Update group, so we have to do it ourself.

I’m still learning a lot of Powershell and those embedded properties in WMI were quite a challenge for me.
  
In order to create a new Software Update Group one has to use the WMI class SMS_AuthorizationList (clearly!) and this has a lot of properties. (<a href="http://msdn.microsoft.com/en-us/library/hh949278.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://msdn.microsoft.com/en-us/library/hh949278.aspx', 'MSDN: SMS_AuthorizationList']);" target="_blank">MSDN: SMS_AuthorizationList</a>)
  
For example the Software Update Group’s name is a lazy property and if you want to set it you have to do it via another embedded class (<a href="http://msdn.microsoft.com/en-us/library/cc145662.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://msdn.microsoft.com/en-us/library/cc145662.aspx', 'MSDN: SMS_CI_LocalizedProperties']);" target="_blank">MSDN: SMS_CI_LocalizedProperties</a>).
  
If you want to know what a lazy property is, have a look at Trevor Sullivan’s blog article about those weirdos: <a href="http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/', 'http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/']);" title="http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/">http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/</a>

For the stuff we want to do we need the following WMI classes:

  * SMS_SoftwareUpdate
  * SMS\_CI\_LocalizedProperties
  * SMS_AuthorizationList

# 

# Find the updates and link them

What we’re going to do is the following.

First we need to find the future members of our new Update Group. That was a bit tricky at first, because I had to find a property that’s universal, meaning that can be used on every system. All the definitions and names are all localized, so they can’t be used. I chose to Knowledge Base ID.

## How do I find the Knowledge Base ID?

Every update by Microsoft is published on their site, for example a Dot Net 3.5 SP1 hotfix for Windows 7 can be found here: <a href="http://support.microsoft.com/kb/976462" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://support.microsoft.com/kb/976462', 'http://support.microsoft.com/kb/976462']);" title="http://support.microsoft.com/kb/976462">http://support.microsoft.com/kb/976462</a>
  
For our script to run you’ll need the number at the end of the URL, 976462.

With this ID the script can now parse the SMS\_SoftwareUpdate class and find the CI\_ID we need to link this update to our new Update Group we’re about to create.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">(gwmi -ns root\sms\site_$($SiteCode) -<span style="color: #0000ff;">class</span> SMS_SoftwareUpdate | where {$_.ArticleID -eq $KBID }).CI_ID</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

# Name the Update Group

Looking at the SMS_AuthorizationList class we see the following properties:

  * ****LocalizedDescription****
  * ****LocalizedDisplayName****
  * ****LocalizedInformativeURL****
  * ****LocalizedPropertyLocaleID****

Cool, DisplayName, absolutely what we want! Unfortunately, this property is read-only. Damn!!!
  
What now?

The property **LocalizedInformation** is read/write and seems to be able of what we want to achieve, naming the group. This property consists of an embedded WMI class named SMS\_CI\_LocalizedProperties.

Filling in the properties isn’t that difficult, you’ll see.

# Create the Update Group

This one is easy again. Create an instance of the SMS_AuthorizationList class, fill in the info and commit it, et voila! <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://david-obrien.de/wp-content/uploads/2012/12/wlEmoticon-winkingsmile.png" alt="Winking smile" />

This is the whole script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">&lt;#</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">Functionality: This script creates a <span style="color: #0000ff;">new</span> Software Update Group <span style="color: #0000ff;">in</span> Microsoft System Center 2012 Configuration Manager</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">How does it work: create-SoftwareUpdateGroup.ps1 -UpdateGroupName $Name -KnowledgeBaseIDs $KBID -SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">KnowledgeBaseID can contain comma separated KnowledgeBase IDs <span style="color: #0000ff;">like</span> 981852,16795779</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">Author: David O<span style="color: #008000;">'Brien, david.obrien@sepago.de</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"><span style="color: #0000ff;">Date</span>: 02.12.2012</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">param (</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">[<span style="color: #0000ff;">string</span>]$UpdateGroupName,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[array]$KnowledgeBaseIDs,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">[<span style="color: #0000ff;">string</span>]$SiteCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">Function</span> create-Group {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[array]$CIIDs = @()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">foreach ($KBID <span style="color: #0000ff;">in</span> $KnowledgeBaseIDs)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        $KBID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        $CIID = (gwmi -ns root\sms\site_$($SiteCode) -<span style="color: #0000ff;">class</span> SMS_SoftwareUpdate | where {$_.ArticleID -eq $KBID }).CI_ID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        $CIIDs += $CIID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_CI_LocalizedProperties = <span style="color: #006080;">"SMS_CI_LocalizedProperties"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$class_Localization = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$class_Localization.psbase.Path =<span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):$($SMS_CI_LocalizedProperties)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$Localization = $class_Localization.CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$Localization.DisplayName = $UpdateGroupName</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$Localization.LocaleID = 1033</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$Description += $Localization</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMSAuthorizationList = <span style="color: #006080;">"SMS_AuthorizationList"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$class_AuthList = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$class_AuthList.psbase.Path =<span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):$($SMSAuthorizationList)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$AuthList = $class_AuthList.CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$AuthList.Updates = $CIIDs</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$AuthList.LocalizedInformation = $Description</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$AuthList.Put() | Out-Null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">create-Group</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

# How do you use it?

Save the script under what ever name you like and execute it like this:

create-SoftwareUpdateGroup.ps1 -UpdateGroupName $Name -KnowledgeBaseIDs $KBID –SiteCode $YourSiteCode

$Name is the name of the Update Group you’re about to create.
  
$KBID is an array of the Knowledge Base IDs, e.g. 981852,16795779
  
$SiteCode is your Configuration Manager Site SiteCode

# What’s next?

This is version 0.1 <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="http://david-obrien.de/wp-content/uploads/2012/12/wlEmoticon-winkingsmile.png" alt="Winking smile" />
  
Following the completion of this version I had some more ideas that I like to put into the script, like using a text file/csv file with the KB IDs, rather than typing them on the command line.
  
The script needs error handling! Right now it won’t tell you what it did and if there was an error at some point.
  
Interaction: One KB can contain more than one hotfixes (e.g. KB890830). If the script finds more than one hotfix it should ask which one to add. Right now it adds all of them.

I hope you like it! Text me here or on Twitter (<a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', '@david_obrien']);" target="_blank">@david_obrien</a>) if you do. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,CM12,ConfigMgr,ConfigMgr+2012,Powershell,SCCM,Software+Updates,WSUS" data-count="vertical" data-url="http://www.david-obrien.net/2012/12/create-a-new-software-update-group-in-configmgr/">Tweet</a>
</div>
