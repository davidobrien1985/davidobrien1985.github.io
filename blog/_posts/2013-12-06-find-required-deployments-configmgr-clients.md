---
id: 1492
title: Find required deployments on ConfigMgr clients
date: 2013-12-06T21:33:17+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1492
permalink: /2013/12/find-required-deployments-configmgr-clients/
categories:
  - ConfigMgr
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - SCCM
  - SDK
tags:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - Powershell
  - SCCM
---
I just came across a situation at a customer where I had to find out if a client was still installing required application deployments after an Operating System Deployment.

## SCCM Client WMI classes

In order for us to get that information we need to query the CCM_Application class in the root\CCM\ClientSDK WMI namespace.

<div id="codeSnippetWrapper" style="margin: 20px 0px 10px; padding: 4px; border: 1px solid silver; width: 97.5%; text-align: left; line-height: 12pt; overflow: auto; font-family: 'Courier New', courier, monospace; font-size: 8pt; cursor: text; direction: ltr; max-height: 200px; background-color: #f4f4f4;">
  <div id="codeSnippet" style="padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">Get-WmiObject -Class ccm_application -Namespace root\ccm\clientsdk | Where-Object {($_.IsMachineTarget) -and ($_.InstallState -ne "Installed") -and ($_.ResolvedState -eq "Installed")}
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

# 

Take a look at the MSDN article for this WMI class: [http://msdn.microsoft.com/en-us/library/jj874280.aspx]("http://msdn.microsoft.com/en-us/library/jj874280.aspx" http://msdn.microsoft.com/en-us/library/jj874280.aspx)

I am currently trying to get around the Where-Object pipe, because this can be quite slow, especially if you have a lot of deployments to that machine, unfortunately the WQL query still gives me the finger…

  * **$_.IsMachineTarget** means that this deployment is for the device
  * **$_.InstallState –ne Installed** means that the application isn’t installed yet
  * **$_.ResolvedState -eq 'Installed'** means that it’s a required installation. Otherwise it would say “Available”.

Would love some feedback if this works on your machines. I only tried it on CM12 R2 and SP1 CU3 and the ConfigMgr documentation wasn’t too helpful. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


