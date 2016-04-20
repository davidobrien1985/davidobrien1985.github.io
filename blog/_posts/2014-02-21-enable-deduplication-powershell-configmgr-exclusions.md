---
id: 1658
title: Enable Deduplication with Powershell for ConfigMgr exclusions
date: 2014-02-21T15:58:43+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1658
permalink: /2014/02/enable-deduplication-powershell-configmgr-exclusions/
categories:
  - ConfigMgr
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Deduplication
  - Powershell
  - SCCM
  - Server 2012
---
Microsoft just released the following blog post on the support of Data Deduplication on Windows Server 2012 R2 in combination with System Center 2012 R2 Configuration Manager.

[http://blogs.technet.com/b/configmgrteam/archive/2014/02/18/configuration-manager-distribution-points-and-windows-server-2012-data-deduplication.aspx]("http://blogs.technet.com/b/configmgrteam/archive/2014/02/18/configuration-manager-distribution-points-and-windows-server-2012-data-deduplication.aspx" http://blogs.technet.com/b/configmgrteam/archive/2014/02/18/configuration-manager-distribution-points-and-windows-server-2012-data-deduplication.aspx)

Then Johan (@Jarwidmark) published his post on how to actually configure deduplication and a small summary on the support statement:

[http://www.deploymentresearch.com/Research/tabid/62/EntryId/151/Using-Data-DeDuplication-with-ConfigMgr-2012-R2.aspx]("http://www.deploymentresearch.com/Research/tabid/62/EntryId/151/Using-Data-DeDuplication-with-ConfigMgr-2012-R2.aspx" http://www.deploymentresearch.com/Research/tabid/62/EntryId/151/Using-Data-DeDuplication-with-ConfigMgr-2012-R2.aspx)

&nbsp;

# Enable Data Deduplication for ConfigMgr with Powershell

If you don’t want to enable it all manually, then just use this code snippet inside an administrative Powershell.

Just change line 6 and enter the Volume you like to enable Deduplication on and do the same in line 9.
  
In line 9 you should also add any exclusions you want. Like Johan and the MS article stated, don’t enable dedup for your Content Source!

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> #Install the feature</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2:</span> Import-Module ServerManager</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3:</span> Add-WindowsFeature -Name FS-Data-Deduplication</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:</span> #Enable on volume</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6:</span> Enable-DedupVolume D:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum7" style="color: #606060;">   7:</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum8" style="color: #606060;">   8:</span> # Set exclusions</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum9" style="color: #606060;">   9:</span> Set-DedupVolume –Volume D: -ExcludeFolder <span style="color: #006080;">'D:\ContentSource'</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

&nbsp;

Have fun saving space! 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

