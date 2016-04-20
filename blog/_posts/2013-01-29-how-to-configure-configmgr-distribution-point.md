---
id: 705
title: How to configure ConfigMgr Distribution Point
date: 2013-01-29T21:28:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=705
permalink: /2013/01/how-to-configure-configmgr-distribution-point/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Distribution Point
  - Microsoft
  - Powershell
  - SCCM
---
# Script to configure your SCCM 2012 Distribution Point

This is one I came up with while going for a run last Sunday and what I missed a for long time in Configuration Manager.
  
Microsoft changed a lot with the 2012 release, especially regarding Distribution Points, which got some more intelligence now. They can be grouped into intelligent, dynamic Distribution Point Groups and also be configured to only communicate during certain times with their Site Management Point.

Now I know that many companies have more than one location, possibly a lot more have more than 100 locations. Since ConfigMgr 2012 we don’t have to install Secondary Sites anymore to throttle network communication, we can use Distribution Points.

## Missing automation

Microsoft must have forgotten one big thing: Automation.

  * We still can’t install more than one Distribution Point from GUI 
      * There’s also no Microsoft native commandline to do this
      * One way would be my script: [How to install a Distribution Point via PowerShell](http://www.david-obrien.net/2012/06/08/install-distribution-point-for-configuration-manager-2012/)
  * No way to configure Distribution Points via commandline 
      * the SP1 cmdlet Set-CMDistributionPoint seems to enable us to add or remove a DP to or from a group only

**Feature Request**: Would be cool to configure network throttling on a Distribution Point Group!

## Configure existing Distribution Points

Back to my idea I had during running:
  
You have a big number of Distribution Points and want to configure them to only use the network for package replication on certain days of the week and only for certain priorities and maybe also only a certain amount of bandwidth (in percent).

We want to configure these settings, but be sure to look at remote distribution points, as these settings are only configurable for remote DPs.

Our approach will be to configure all distribution points the same. This is version 1 of the script and over time I’ll definitely put some more features into it, but right now it’s enough to do it this way.

## How to create a new Address in ConfigMgr

### SMS\_SCI\_ADDRESS

What we’re basically doing is create a new address to the distribution point and give this new address a new configuration. Like always we need to work with embedded classes again (see [How to create a new Software Update Group](http://www.david-obrien.net/2012/12/02/create-a-new-software-update-group-in-configmgr/) for more info).

Our main class will be **SMS\_SCI\_ADDRESS** ([Technet: SMS_SCI_ADDRESS](http://msdn.microsoft.com/en-us/library/hh948862.aspx)) and here we need to add quite a lot properties:

  * SMS\_SCI\_ADDRESS.UsageSchedule
  * SMS\_SCI\_ADDRESS.RateLimitingSchedule
  * SMS\_SCI\_ADDRESS.AddressPriorityOrder
  * SMS\_SCI\_ADDRESS.AddressType
  * SMS\_SCI\_ADDRESS.DesSiteCode
  * SMS\_SCI\_ADDRESS.DestinationType
  * SMS\_SCI\_ADDRESS.SiteCode
  * SMS\_SCI\_ADDRESS.UnlimitedRateForAll
  * SMS\_SCI\_ADDRESS.PropLists (embedded class: SMS_EmbeddedPropertyList)
  * SMS\_SCI\_ADDRESS.Props (embedded class: SMS_EmbeddedProperty)

This class is well documented, so filling the properties wasn’t too difficult. A bit of a challenge were the two properties .PropLists and .Props. You can’t query them directly, so I tend to go the way via the Site Control File.

## How to query the Site Control File of SCCM 2012

Open your SQL Management Studio and create a new query on your CM Database.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">Select</span> SiteControl <span style="color: #0000ff;">From</span> vSMS_SC_SiteControlXML <span style="color: #0000ff;">Where</span> SiteCode = <span style="color: #006080;">'SITECODE'</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Execute and access your Site Control File (SCF) in an xml format. Now search the SCF and look for the distribution point’s address properties.
  
This is where I found the properties for “Pulse Mode”, “Connection Point” and “LAN Login”.

## How to create the Addresse’s usage schedule

### SMS_SiteControlDaySchedule

Here we configure these settings:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb8.png" width="287" height="265" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image8.png)

We need to use the SMS_SiteControlDaySchedule class to configure these settings. This is done with an array of arrays.

$HourUsageSchedule = @(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)

This variable configures every hour of one day regarding to which priorities are allowed to be replicated. Element [0] is the first hour of the day.

<table width="400" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="200">
      1
    </td>
    
    <td valign="top" width="200">
      ALL_PRIORITY
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      2
    </td>
    
    <td valign="top" width="200">
      ALL_BUT_LOW
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      3
    </td>
    
    <td valign="top" width="200">
      HIGH_ONLY
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      4
    </td>
    
    <td valign="top" width="200">
      CLOSED
    </td>
  </tr>
</table>

<p align="center">
  (source: [MSDN](http://msdn.microsoft.com/en-us/library/cc145538.aspx))
</p>

<p align="left">
  By setting the variable to this values I’m telling it that the whole day is closed for replication.
</p>

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb9.png" width="289" height="266" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image9.png)

This page is set with this variable (array):
  
$RateLimitingSchedule = @(10,20,30,40,50,60,70,80,90,100,90,80,70,60,50,40,30,20,10,70,10,20,30,40)

Here I’m telling it how much bandwidth (relative) for every hour of the day the replication process is allowed to use. The minimum value is 1 and maximum is 100.
  
In order for the setting to have any impact I need to set the property “SMS\_SCI\_ADDRESS.UnlimitedRateForAll” to $false. Otherwise it would replicate at an unlimited rate.

This is the command to execute the script:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb10.png" width="508" height="21" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image10.png)

Be aware of the server’s FQDN, the script needs the FQDN of the distribution point.
  
In the future I will implement a workflow to execute the script with different configurations on more than just one server.

Let me know what you think about the script or if you would like to see some more of it or different things!

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">param(</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[parameter(Mandatory=$<span style="color: #0000ff;">true</span>)]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">[<span style="color: #0000ff;">String</span>]$ServerName,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">[parameter(Mandatory=$<span style="color: #0000ff;">true</span>)]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">[<span style="color: #0000ff;">String</span>]$SiteCode</pre>
    
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
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># <span style="color: #0000ff;">Set</span> the schedules first!</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#Array containing 24 elements, one <span style="color: #0000ff;">for</span> <span style="color: #0000ff;">each</span> hour of the day. A value of <span style="color: #0000ff;">true</span> indicates that the address (sender) embedding SMS_SiteControlDaySchedule can be used <span style="color: #0000ff;">as</span> a backup.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$UsageAsBackup = @($<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>,$<span style="color: #0000ff;">true</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">#Array containing 24 elements, one <span style="color: #0000ff;">for</span> <span style="color: #0000ff;">each</span> hour of the day. This <span style="color: #0000ff;">property</span> specifies the type of usage <span style="color: #0000ff;">for</span> <span style="color: #0000ff;">each</span> hour.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># 1 means all Priorities, 2 means all but low, 3 <span style="color: #0000ff;">is</span> high only, 4 means none</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$HourUsageSchedule = @(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">#<span style="color: #0000ff;">Set</span> RateLimitingSchedule, array <span style="color: #0000ff;">for</span> every hour of the day, percentage of how much bandwidth can be used, min 1, max 100</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$RateLimitingSchedule = @(10,20,30,40,50,60,70,80,90,100,90,80,70,60,50,40,30,20,10,70,10,20,30,40)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS = <span style="color: #006080;">"SMS_SCI_ADDRESS"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$class_SMS_SCI_ADDRESS = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$class_SMS_SCI_ADDRESS.psbase.Path =<span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):$($SMS_SCI_ADDRESS)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS = $class_SMS_SCI_ADDRESS.CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"># <span style="color: #0000ff;">Set</span> the UsageSchedule</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule           = <span style="color: #006080;">"SMS_SiteControlDaySchedule"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule_class     = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule_class.psbase.Path = <span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):$($SMS_SiteControlDaySchedule)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule              = $SMS_SiteControlDaySchedule_class.createInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule.Backup    = $UsageAsBackup</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule.HourUsage = $HourUsageSchedule</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SiteControlDaySchedule.Update    = $<span style="color: #0000ff;">true</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.UsageSchedule        = @($SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.RateLimitingSchedule = $RateLimitingSchedule</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.AddressPriorityOrder = <span style="color: #006080;">"0"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.AddressType          = <span style="color: #006080;">"MS_LAN"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.DesSiteCode          = <span style="color: #006080;">"$($ServerName)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.DestinationType      = <span style="color: #006080;">"1"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.SiteCode             = <span style="color: #006080;">"$($SiteCode)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.UnlimitedRateForAll  = $<span style="color: #0000ff;">false</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># <span style="color: #0000ff;">Set</span> the embedded Properties</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedpropertyList = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty_class = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty_class.psbase.Path = <span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedPropertyList"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedpropertyList                 = $embeddedproperty_class.createInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedpropertyList.PropertyListName     = <span style="color: #006080;">"Pulse Mode"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedpropertyList.Values        = @(0,5,8) #second value <span style="color: #0000ff;">is</span> size of data block <span style="color: #0000ff;">in</span> KB, third <span style="color: #0000ff;">is</span> delay between data blocks <span style="color: #0000ff;">in</span> seconds</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.PropLists += $embeddedpropertyList</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty_class = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty_class.psbase.Path = <span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty                 = $embeddedproperty_class.createInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty.PropertyName     = <span style="color: #006080;">"Connection Point"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty.Value         = <span style="color: #006080;">"0"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty.Value1        = <span style="color: #006080;">"$($ServerName)"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty.Value2        = <span style="color: #006080;">"SMS_DP$"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.Props += $embeddedproperty</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty = $null</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty_class = [wmiclass]<span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty_class.psbase.Path = <span style="color: #006080;">"ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty                 = $embeddedproperty_class.createInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty.PropertyName     = <span style="color: #006080;">"LAN Login"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty.Value         = <span style="color: #006080;">"0"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$embeddedproperty.Value1        = <span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$embeddedproperty.Value2        = <span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.Props += $embeddedproperty</pre>
    
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
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$SMS_SCI_ADDRESS.Put() | Out-Null</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Download the script here: [http://davidobrien.codeplex.com/downloads/get/613106](http://davidobrien.codeplex.com/downloads/get/613106) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

