---
id: 693
title: How to trigger Software Updates Re-Scan in Configuration Manager 2012 SP1
date: 2013-01-23T11:56:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=693
permalink: /2013/01/trigger-software-updates-rescan-in-configuration-manager-2012-sp1/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - scripting
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - Updates
  - WMI
---
# How to trigger Updates Re-scan in SCCM 2012

Did you ever do a OSD in Configuration Manager and wonder why some Software Updates weren’t installed?
  
As a workaround, did you try adding more “Install Software Updates” steps to your Task Sequence?
  
It probably didn’t work, did it?

The answer to this is ‘simple’. The ConfigMgr agent caches the results of a Software Update evaluation scan in a cache and this cache seems to have a rather long TTL, at least when talking about OSD, where you usually have a “Install Software Updates” step at the beginning and at the end of the Task Sequence.
  
The step at the end will most likely don’t do a re-scan, because the cache is still valid.

## How to trigger a re-evaluation of Software Updates?

The answer to this question has been around for some time now, as this problem was also present with ConfigMgr 2007.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border-width: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb6.png" width="455" height="21" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image6.png)

It’s possible to tell the SMS Agent to forget the cache (in fact, you’re telling it that the TTL is invalid, see picture above) and do a re-evaluation of Software Updates.
  
There is a WMI method in the SMS Client’s namespace called “TriggerSchedule” which accepts certain ScheduleIDs. Jürgen Pietsch wrote them down here: [http://social.technet.microsoft.com/Forums/en-US/configmanagerosd/thread/a535e509-fc6a-483c-bf24-7e2aa064e5b7/]("http://social.technet.microsoft.com/Forums/en-US/configmanagerosd/thread/a535e509-fc6a-483c-bf24-7e2aa064e5b7/" http://social.technet.microsoft.com/Forums/en-US/configmanagerosd/thread/a535e509-fc6a-483c-bf24-7e2aa064e5b7/)

Knowing the ID we can go ahead and trigger it. This can be done in several ways:

WMIC (like in the thread on technet):

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">WMIC /<span style="color: #0000ff;">namespace</span>:\\root\ccm path sms_client <span style="color: #0000ff;">CALL</span> TriggerSchedule <span style="color: #006080;">"{00000000-0000-0000-0000-000000000113}"</span> /NOINTERACTIVE</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I translated it to PowerShell:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #006080;">([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000113}’)</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Or even via the [Right-Click tools](http://myitforum.com/myitforumwp/2012/05/07/config-manager-2012-right-click-tools/) by Ryan Ephgrave (MyITForum) for the ConfigMgr console (of course, not during the OSD).

## How to trigger Software Update rescan on Windows Server 2012 and Windows 8?

ConfigMgr 2012 SP1 supports Windows Server 2012 and Windows 8 (and more) and here we found the same problem as described above.

Fortunately, it still works with the new OS versions and it looks like there are a few more Triggers now with ConfigMgr 2012 SP1 compared to the versions before, although I don’t now (yet!) why there are so much doubles.

&nbsp;

<div>
  <table width="800" border="1" cellspacing="0" cellpadding="2" align="left">
    <tr>
      <td valign="top" width="400">
        <p align="left">
          ScheduledMessageID
        </p>
      </td>
      
      <td valign="top" width="397">
        TargetEndPoint
      </td>
    </tr>
    
    <tr>
      <td valign="top" width="296">
        <p align="left">
          {00000000-0000-0000-0000-000000000223}<br /> {00000000-0000-0000-0000-000000000222}<br /> {00000000-0000-0000-0000-000000000221}<br /> {00000000-0000-0000-0000-000000000131}<br /> {00000000-0000-0000-0000-000000000121}<br /> {00000000-0000-0000-0000-000000000120}<br /> {00000000-0000-0000-0000-000000000116}<br /> {00000000-0000-0000-0000-000000000114}<br /> {00000000-0000-0000-0000-000000000113}<br /> {00000000-0000-0000-0000-000000000112}<br /> {00000000-0000-0000-0000-000000000111}<br /> {00000000-0000-0000-0000-000000000108}<br /> {00000000-0000-0000-0000-000000000051}<br /> {00000000-0000-0000-0000-000000000042}<br /> {00000000-0000-0000-0000-000000000040}<br /> {00000000-0000-0000-0000-000000000032}<br /> {00000000-0000-0000-0000-000000000031}<br /> {00000000-0000-0000-0000-000000000025}<br /> {00000000-0000-0000-0000-000000000024}<br /> {00000000-0000-0000-0000-000000000023}<br /> {00000000-0000-0000-0000-000000000022}<br /> {00000000-0000-0000-0000-000000000021}<br /> {00000000-0000-0000-0000-000000000010}<br /> {00000000-0000-0000-0000-000000000003}<br /> {00000000-0000-0000-0000-000000000002}<br /> {00000000-0000-0000-0000-000000000001}
        </p>
      </td>
      
      <td valign="top" width="405">
        direct:ExternalEventAgent<br /> direct:EndpointProtectionAgent<br /> direct:EndpointProtectionAgent<br /> direct:pwrmgmt<br /> direct:DCMAgent<br /> direct:OOBMgmt<br /> direct:StateMessageManager<br /> direct:UpdateStore<br /> direct:ScanAgent<br /> direct:StateMessageManager<br /> direct:StateMessageManager<br /> direct:UpdatesDeploymentAgent<br /> direct:CertificateMaintenanceEndpoint<br /> direct:PolicyAgent_RequestAssignments<br /> direct:PolicyAgent_Cleanup<br /> direct:SrcUpdateMgr<br /> direct:SWMTRReportGen<br /> direct:LS_ScheduledCleanup<br /> direct:LS_ScheduledCleanup<br /> direct:LS_ScheduledCleanup<br /> direct:PolicyAgent_PolicyEvaluator<br /> direct:PolicyAgent_RequestAssignments<br /> direct:InventoryAgent<br /> direct:InventoryAgent<br /> direct:InventoryAgent<br /> direct:InventoryAgent
      </td>
    </tr>
  </table>
</div>

The trigger 113 is still available and can be used on Windows 8 and Windows Server 2012:

After executing the trigger via the PowerShell and having a look at the client’s ‘ScanAgent.log’, we see that it succeeded:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb7.png" width="317" height="76" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image7.png)

Do you use other triggers on a regular basis? If so, which and why? I’m very interested in learning more about the other triggers and how you might use them. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

