---
id: 787
title: ConfigMgr and Powershell ExecutionPolicy
date: 2013-03-14T22:40:10+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=787
permalink: /2013/03/configmgr-and-powershell-executionpolicy/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - ExecutionPolicy
  - Powershell
  - SCCM
  - System Center
---
There are a lot of articles around talking about Microsoft SCCM 2012 / Configuration Manager and executing Powershell scripts.

I won’t cover the basics here about Powershell, just something a colleague pointed out to me and today I investigated a bit further.

# Powershell ExecutionPolicy

In order to execute a Powershell script, you have to set your ExecutionPolicy. If you don’t or someone else hasn’t done it for you (e.g. via GPO), you won’t be able to run any ps1 files.

Here you will find a bit more about executing Powershell scripts in general:

  * [Running Windows PowerShell Scripts (Technet)](http://technet.microsoft.com/en-us/library/ee176949.aspx)

# Client Settings in ConfigMgr

With ConfigMgr 2012 we’re now able to deploy some default or custom “client settings” to devices and users.
  
In the device client settings we’ll find a group for “Computer Agent” and in it a setting for the Powershell Execution Policy.

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="ConfigMgr client settings" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb.png" width="292" height="224" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image.png)
</p>

This defaults to “restricted”, just like the “normal” execution policy does aswell.
  
Now I usually set the execution policy via GPO, but there you’re unable to target the setting to a specific scope. This is, by the way, the same with ConfigMgr, it looks like it’s a device setting.

I reset my GPO to “not configured”, which should mean that the execution policy is set to restricted again. I can verify that in the registry.

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="Powershell Execution Policy in registry" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb1.png" width="298" height="86" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image1.png)
</p>

Now I want to set my Execution policy via the Client settings to be able to execute powershell scripts in applications, packages and task sequences.

Therefore I created a new client setting device policy and configured the execution policy to Bypass.

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="Execution Policy SCCM bypass" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb2.png" width="271" height="210" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image2.png)
</p>

I deployed this policy to one of my device collections in order to reconfigure my computer’s execution policy.

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="SCCM client settings" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb3.png" width="286" height="53" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image3.png)
</p>

Before updating my client’s policy I checked all the execution policies on the client by running

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">Get</span>-ExecutionPolicy –List</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

and got back this:

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="Get-ExecutionPolicy" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb4.png" width="303" height="66" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image4.png)
</p>

Like I expected. “MachinePolicy” is my unconfigured GPO, which sets it to undefined/restricted and I believe LocalMachine is the default client setting.

Now after updating the client’s machine policy I find the following settings.

Registry (still the same):

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="Registry Powershell" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb5.png" width="275" height="77" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image5.png)

Powershell query (still the same):

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb6.png" width="278" height="59" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image6.png)
</p>

Executing the following WMI query on the client tells me a bit more about the ConfigMgr client settings:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">get</span>-wmiobject -<span style="color: #0000ff;">Class</span> ccm_ClientAgentConfig -<span style="color: #0000ff;">Namespace</span> root\ccm\policy\machine\requestedconfig | <span style="color: #0000ff;">Select</span>-<span style="color: #0000ff;">Object</span> BrandingTitle,PowershellExecutionPolicy</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

This shows me all the policies that are being requested by the SMS Agent, in this example I filtered the output to the “PowerShellExecutionPolicy” and “Branding Title”.
  
The Branding Title is just the “organization name displayed in software center”. This is just for me to distinguish between the two policies.

The output is quite interesting:

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="CCM_ClientAgentConfig" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb7.png" width="316" height="35" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image7.png)
</p>

As I said above, I left the default policy like it is per default and configured my custom settings to bypass. It looks like there’s definitely something happening.
  
These are only the policies that are requested by the SMS Agent, there’s another WMI namespace representing the actual config. Lets see what this one tells us.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb8.png" width="316" height="33" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image8.png)

Well, the execution policy should have changed to Bypass. As I showed you above, it hasn’t.

# Executing Applications

With these settings I tried to run an application which only executes a simple powershell script.
  
I had the idea that maybe the SMS Agent evaluates the client settings on the fly and applies the configured execution policy just in time for the execution of an application or package.

If that was so, I would have seen it in the row “Process” in the listing of my execution policies.

So here’s my script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">get</span>-executionpolicy -List | Out-File c:\temp\executionpolicy.log</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

That’s easy, isn’t it? <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" alt="Zwinkerndes Smiley" src="http://www.david-obrien.net/wp-content/uploads/2013/03/wlEmoticon-winkingsmile.png" />

Well, I wasn’t able to execute it with only the client settings applied and none more. Bummer!

## Sum-up Execution Policy in ConfigMgr

To make this long story short. I can’t make out what this client setting does. The only way I’m able to successfully execute a Powershell script in an application is by using the ExecutionPolicy switch.

The commandline would then look like this:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">powershell.exe -ExecutionPolicy Bypass -file <span style="color: #006080;">".\SomeFile.ps1"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

The above file I’m creating in the temp folder will then look like this:

<p align="center">
  [<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px; display: inline; padding-right: 0px; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/03/image_thumb9.png" width="244" height="108" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/03/image9.png)
</p>

<p align="left">
  But that’s what I expected from the client setting.
</p>

<p align="left">
  Where am I going wrong? Has anyone successfully used this setting and is able to shed a bit of light on this?<br /> I would really like to execute my scripts without using the executionpolicy parameter for every single one of them.
</p>

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

