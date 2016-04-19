---
id: 287
title: Microsoft Configuration Manager 2012 and Powershell–Create Deployments
date: 2012-03-17T11:11:21+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=287
permalink: /2012/03/microsoft-configuration-manager-2012-and-powershellcreate-deployments/
categories:
  - Common
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Powershell
  - SCCM
  - SCCM 2012
  - scripting
  - System Center
---
Hi all,

here another quick script I wrote to deploy a specified Task Sequence to a given collection.

This was a real quick one, as I could find out all the required values through WMIExplorer (thanks to [http://thepowershellguy.com/blogs/posh/archive/2007/03/22/powershell-wmi-explorer-part-1.aspx](http://thepowershellguy.com/blogs/posh/archive/2007/03/22/powershell-wmi-explorer-part-1.aspx) ), some self-made WMI queries and SMSProv.log (always look in here for help!!!)

So here’s my script:

&nbsp;

<div class="csharpcode">
  <pre><span class="lnum"> 1: </span>$sitename = <span class="str">"PRI"</span></pre>
  
  <pre><span class="lnum"> 2: </span></pre>
  
  <pre><span class="lnum"> 3: </span><span class="kwrd">function</span> create-TSDeployment{</pre>
  
  <pre><span class="lnum"> 4: </span>$targetcoll = gwmi -ns <span class="str">"rootSMSSite_$sitename"</span> -<span class="kwrd">class</span> SMS_Collection | WHERE {$_.Name -eq <span class="rem">'Install WinXP'} #if you want to deploy to multiple collections, you'll need to replace the name here</span></pre>
  
  <pre><span class="lnum"> 5: </span>$collID = $targetcoll.CollectionID</pre>
  
  <pre><span class="lnum"> 6: </span>$collName = $targetcoll.Name</pre>
  
  <pre><span class="lnum"> 7: </span></pre>
  
  <pre><span class="lnum"> 8: </span>$TS = Gwmi -ns <span class="str">"rootSMSSite_$sitename"</span> -<span class="kwrd">class</span> SMS_TaskSequencePackage | WHERE {$_.Name -eq <span class="rem">'Install XP'} #place TS Name in here</span></pre>
  
  <pre><span class="lnum"> 9: </span>$TSID = $TS.PackageID</pre>
  
  <pre><span class="lnum"> 10: </span>$TSName = $TS.Name</pre>
  
  <pre><span class="lnum"> 11: </span>$AdvName = $TSName+<span class="str">"_"</span>+$TSID+<span class="str">"_"</span>+$collName</pre>
  
  <pre><span class="lnum"> 12: </span></pre>
  
  <pre><span class="lnum"> 13: </span>$AdvArgs =  @{</pre>
  
  <pre><span class="lnum"> 14: </span> AdvertFlags = 42860576;</pre>
  
  <pre><span class="lnum"> 15: </span> AdvertisementName = <span class="str">"$AdvName"</span>;</pre>
  
  <pre><span class="lnum"> 16: </span> CollectionID = $collID;</pre>
  
  <pre><span class="lnum"> 17: </span> PackageID = $TSID;</pre>
  
  <pre><span class="lnum"> 18: </span> ProgramName = <span class="str">"*"</span>;</pre>
  
  <pre><span class="lnum"> 19: </span> RemoteClientFlags = 8480;</pre>
  
  <pre><span class="lnum"> 20: </span> SourceSite = $sitename;</pre>
  
  <pre><span class="lnum"> 21: </span> TimeFlags = 8193</pre>
  
  <pre><span class="lnum"> 22: </span> }</pre>
  
  <pre><span class="lnum"> 23: </span></pre>
  
  <pre><span class="lnum"> 24: </span><span class="kwrd">Set</span>-WmiInstance -<span class="kwrd">Class</span> SMS_Advertisement -arguments $AdvArgs -<span class="kwrd">namespace</span> <span class="str">"rootSMSSite_$sitename"</span> | Out-Null</pre>
  
  <pre><span class="lnum"> 25: </span>}</pre>
  
  <pre><span class="lnum"> 26: </span></pre>
  
  <pre><span class="lnum"> 27: </span>create-TSDeployment</pre>
</div>

As my customer would like to deploy one Task Sequence to round about 150 collections, I will have to build a for-each loop to fill in the correct target collection name.

## 

## SMS_Advertisement

For more information on the SMS_Advertisement WMI class, see [http://msdn.microsoft.com/en-us/library/cc146108.aspx](http://msdn.microsoft.com/en-us/library/cc146108.aspx)
  
There you’ll find more about the AdvertFlags, RemoteClientFlags and TimeFlags, as you will configure your deployment via these values, e.g “Deployment is available” or “Deployment is required and allowed to PXE”.

Any questions? Contact me here or via Twitter @david_obrien 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

