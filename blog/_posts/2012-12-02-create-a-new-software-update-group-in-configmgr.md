---
id: 532
title: Create a new Software Update Group in ConfigMgr
date: 2012-12-02T23:23:42+00:00
author: "David O'Brien"
layout: single

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

This post is still valid. Nevertheless, find a more recent script version here: ["Update: How to create a new Software Update Group in ConfigMgr 2012"]("Update: How to create a new Software Update Group in ConfigMgr 2012" /2013/01/07/update-how-to-create-a-new-software-update-group-in-configmgr-2012/)

On my way to automating everything possible in Microsoft System Center 2012 Configuration Manager I thought about new things to play with.

A week ago a colleague of mine asked me some questions regarding Software Update management in ConfigMgr and how we should handle them in a project that we both are currently working on.

His questions were related to how we would manage new software updates coming in every month.

That brought up the idea of scripting the creation of new Software Update groups and adding new updates to them.

# Embedded classes and lazy properties in WMI

Unfortunately Microsoft doesn’t give us a cmdlet to just create a new Software Update group, so we have to do it ourself.

I’m still learning a lot of Powershell and those embedded properties in WMI were quite a challenge for me.

In order to create a new Software Update Group one has to use the WMI class SMS_AuthorizationList (clearly!) and this has a lot of properties. ([MSDN: SMS_AuthorizationList](http://msdn.microsoft.com/en-us/library/hh949278.aspx))

For example the Software Update Group’s name is a lazy property and if you want to set it you have to do it via another embedded class ([MSDN: SMS_CI_LocalizedProperties](http://msdn.microsoft.com/en-us/library/cc145662.aspx)).

If you want to know what a lazy property is, have a look at Trevor Sullivan’s blog article about those weirdos: [http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/]("http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/" http://trevorsullivan.net/2010/09/28/powershell-configmgr-wmi-provider-feat-lazy-properties/)

For the stuff we want to do we need the following WMI classes:

* SMS_SoftwareUpdate
* SMS\_CI\_LocalizedProperties
* SMS_AuthorizationList

# Find the updates and link them

What we’re going to do is the following.

First we need to find the future members of our new Update Group. That was a bit tricky at first, because I had to find a property that’s universal, meaning that can be used on every system. All the definitions and names are all localized, so they can’t be used. I chose to Knowledge Base ID.

## How do I find the Knowledge Base ID?

Every update by Microsoft is published on their site, for example a Dot Net 3.5 SP1 hotfix for Windows 7 can be found here: [http://support.microsoft.com/kb/976462]("http://support.microsoft.com/kb/976462" http://support.microsoft.com/kb/976462)

For our script to run you’ll need the number at the end of the URL, 976462.

With this ID the script can now parse the SMS\_SoftwareUpdate class and find the CI\_ID we need to link this update to our new Update Group we’re about to create.

```
(gwmi -ns root\sms\site_$($SiteCode) -class SMS_SoftwareUpdate | where {$_.ArticleID -eq $KBID }).CI_ID
```

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

This one is easy again. Create an instance of the SMS_AuthorizationList class, fill in the info and commit it, et voila! ;-)

This is the whole script:

```PowerShell
<#
Functionality: This script creates a new Software Update Group in Microsoft System Center 2012 Configuration Manager
How does it work: create-SoftwareUpdateGroup.ps1 -UpdateGroupName $Name -KnowledgeBaseIDs $KBID -SiteCode
KnowledgeBaseID can contain comma separated KnowledgeBase IDs like 981852,16795779
Author: David O'Brien, david.obrien@sepago.de
Date: 02.12.2012
#>

param (

[string]$UpdateGroupName,
[array]$KnowledgeBaseIDs,
[string]$SiteCode
)

Function create-Group {

[array]$CIIDs = @()

foreach ($KBID in $KnowledgeBaseIDs)

  {
    $KBID
    $CIID = (gwmi -ns root\sms\site_$($SiteCode) -class SMS_SoftwareUpdate | where {$_.ArticleID -eq $KBID }).CI_ID
    $CIIDs += $CIID
  }

$SMS_CI_LocalizedProperties = "SMS_CI_LocalizedProperties"
$class_Localization = [wmiclass]""
$class_Localization.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_CI_LocalizedProperties)"
$Localization = $class_Localization.CreateInstance()
$Localization.DisplayName = $UpdateGroupName
$Localization.LocaleID = 1033
$Description += $Localization
$SMSAuthorizationList = "SMS_AuthorizationList"
$class_AuthList = [wmiclass]""
$class_AuthList.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMSAuthorizationList)"
$AuthList = $class_AuthList.CreateInstance()
$AuthList.Updates = $CIIDs
$AuthList.LocalizedInformation = $Description
$AuthList.Put() | Out-Null

}

create-Group
```

# How do you use it?

Save the script under what ever name you like and execute it like this:

create-SoftwareUpdateGroup.ps1 -UpdateGroupName $Name -KnowledgeBaseIDs $KBID –SiteCode $YourSiteCode

$Name is the name of the Update Group you’re about to create.

$KBID is an array of the Knowledge Base IDs, e.g. 981852,16795779

$SiteCode is your Configuration Manager Site SiteCode

# What’s next?

This is version 0.1.

Following the completion of this version I had some more ideas that I like to put into the script, like using a text file/csv file with the KB IDs, rather than typing them on the command line.

The script needs error handling! Right now it won’t tell you what it did and if there was an error at some point.

Interaction: One KB can contain more than one hotfixes (e.g. KB890830). If the script finds more than one hotfix it should ask which one to add. Right now it adds all of them.

I hope you like it! Text me here or on Twitter ([@david_obrien](http://www.twitter.com/david_obrien)) if you do.


