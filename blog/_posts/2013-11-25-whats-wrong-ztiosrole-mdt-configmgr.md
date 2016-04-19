---
id: 1480
title: 'What&rsquo;s wrong with ZTIOSRole in MDT / ConfigMgr ?'
date: 2013-11-25T10:04:48+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1480
permalink: /2013/11/whats-wrong-ztiosrole-mdt-configmgr/
categories:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - GPO
  - MDT
  - PowerShell
  - Windows Server 2012 R2
tags:
  - Configuration Manager
  - GPO
  - MDT 2013
  - Powershell
  - SCCM
  - Windows Server 2012 R2
---
# Adding OS Roles via MDT step / Script ZTIOSRole.wsf

While doing a new Windows Build for my Lab I came across an issue which I at first was unable to solve and I’m still not certain as to why this issue occured.

[<img style="margin-right: auto; margin-left: auto; float: none; display: block;" title="ZTIOSRole.wsf" alt="ZTIOSRole.wsf" src="http://www.david-obrien.net/wp-content/uploads/2013/11/image_thumb2.png" width="189" height="243" border="0" />]("ZTIOSRole.wsf" http://www.david-obrien.net/wp-content/uploads/2013/11/image2.png)

I wanted to add some OS features to a Windows Server 2012 R2 installation and was pretty surprised when I saw that none of them got installed.

This is a snippet of ZTIOSRole.log:

<div id="codeSnippetWrapper" style="margin: 20px 0px 10px; padding: 4px; border: 1px solid silver; width: 97.5%; text-align: left; line-height: 12pt; overflow: auto; font-family: 'Courier New', courier, monospace; font-size: 8pt; cursor: text; direction: ltr; max-height: 200px; background-color: #f4f4f4;">
  <div id="codeSnippet" style="padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">Microsoft Deployment Toolkit version: 6.2.5019.0    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">The task sequencer log <span style="color: #0000ff;">is</span> located at C:\Users\ADMINI~1\AppData\Local\Temp\1\SMSTSLog\SMSTS.LOG.  <span style="color: #0000ff;">For</span> task sequence failures, please consult this log.    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">Roles will be installed.    ZTIOSRole    23.11.2013 14:58:06    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">No items were specified <span style="color: #0000ff;">in</span> variable OSRoles.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">No items were specified <span style="color: #0000ff;">in</span> variable OSRoleServices.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">Features specified <span style="color: #0000ff;">in</span> Feature:    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">  NET-Framework-Core    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">No items were specified <span style="color: #0000ff;">in</span> variable OptionalOSRoles.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">No items were specified <span style="color: #0000ff;">in</span> variable OptionalOSRoleServices.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">No items were specified <span style="color: #0000ff;">in</span> variable OptionalOSFeatures.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">ZTI Heartbeat: Processing roles (0% complete    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;"><span style="color: #0000ff;">Property</span> Parameters <span style="color: #0000ff;">is</span> now = -FeatureName NET-Framework-Core    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">Using a local <span style="color: #0000ff;">or</span> mapped drive, no connection <span style="color: #0000ff;">is</span> required.    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">Copying source files locally from E:\Deploy\Operating Systems\WS2012R2\sources\sxs    ZTIOSRole    23.11.2013 14:58:07    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;"><span style="color: #0000ff;">Property</span> Parameters <span style="color: #0000ff;">is</span> now = -FeatureName NET-Framework-Core -Source <span style="color: #006080;">"C:\MININT\sources\X64"</span>    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">PowerShell version detected: 4.0    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">About <span style="color: #0000ff;">to</span> run: <span style="color: #006080;">"E:\Deploy\Tools\Modules\Microsoft.BDD.TaskSequenceModule\Microsoft.BDD.TaskSequencePSHost40.exe"</span> <span style="color: #006080;">"E:\Deploy\Scripts\ZTIOSRolePS.ps1"</span> <span style="color: #006080;">"C:\MININT\SMSOSD\OSDLOGS"</span> -FeatureName NET-Framework-Core -Source <span style="color: #006080;">"C:\MININT\sources\X64"</span>    ZTIOSRole    23.11.2013 14:58:14    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;"><span style="color: #0000ff;">Property</span> Parameters <span style="color: #0000ff;">is</span> now =     ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;"><span style="color: #0000ff;">ERROR</span> - NET-Framework-Core role processing via PowerShell failed, rc = 10904    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;"><span style="color: #0000ff;">Property</span> InstalledRoles001 <span style="color: #0000ff;">is</span> now = NET-FRAMEWORK-CORE    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">One <span style="color: #0000ff;">or</span> more roles were <span style="color: #0000ff;">not</span> processed successfully    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">FAILURE: 1: Server Blue Role Processing    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">ZTIOSRole processing completed successfully.    ZTIOSRole    23.11.2013 14:58:16    0 (0x0000)</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Also ZTIOSRolePS.log wasn’t being created which I found weird.

So what was the problem? No MDT script which used Powershell executed successfully.

## Setting Powershell ExecutionPolicy via GPO

I usually set my Powershell ExecutionPolicy via GPO for my users in my Lab, because I sometimes forget to set it during script runtime. The user I used for auto logon for this Task Sequence also had this GPO applied to him and it was set to “Bypass”.

[<img style="margin-right: auto; margin-left: auto; float: none; display: block;" title="GPO Powershell" alt="GPO Powershell" src="http://www.david-obrien.net/wp-content/uploads/2013/11/image_thumb3.png" width="244" height="58" border="0" />]("GPO Powershell" http://www.david-obrien.net/wp-content/uploads/2013/11/image3.png)

## 

It looks like this is not a  good idea when using MDT with Server 2012 R2 (I didn’t test it with any other OS).

This is a snippet from ZTIOSRole.wsf:

<div id="codeSnippetWrapper" style="margin: 20px 0px 10px; padding: 4px; border: 1px solid silver; width: 97.5%; text-align: left; line-height: 12pt; overflow: auto; font-family: 'Courier New', courier, monospace; font-size: 8pt; cursor: text; direction: ltr; max-height: 200px; background-color: #f4f4f4;">
  <div id="codeSnippet" style="padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;">iRetVal = RunPowerShellScript(<span style="color: #006080;">"ZTIOSRolePS.ps1"</span>, <span style="color: #0000ff;">true</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">oEnvironment.Item(<span style="color: #006080;">"Parameters"</span>) = <span style="color: #006080;">""</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I reset that Policy to “not defined” and re-executed my Task Sequence and now all is fine. No idea why these lines should have a problem when ExecutionPolicy has been previously set via GPO.

[<img style="margin-right: auto; margin-left: auto; float: none; display: block;" title="ZTIOSRolePS.log" alt="ZTIOSRolePS.log" src="http://www.david-obrien.net/wp-content/uploads/2013/11/image_thumb4.png" width="244" height="25" border="0" />]("ZTIOSRolePS.log" http://www.david-obrien.net/wp-content/uploads/2013/11/image4.png)

Both logs get created and all my roles and features are installed.
  
Anyone else came across this problem and knows why setting an ExecutionPolicy via GPO is a problem? 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

