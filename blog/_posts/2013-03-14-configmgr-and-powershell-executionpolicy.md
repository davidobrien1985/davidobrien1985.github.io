---
id: 787
title: ConfigMgr and Powershell ExecutionPolicy
date: 2013-03-14T22:40:10+00:00
author: "David O'Brien"
layout: single

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

![image](/media/2013/03/image.png "image")

This defaults to “restricted”, just like the “normal” execution policy does aswell.

Now I usually set the execution policy via GPO, but there you’re unable to target the setting to a specific scope. This is, by the way, the same with ConfigMgr, it looks like it’s a device setting.

I reset my GPO to “not configured”, which should mean that the execution policy is set to restricted again. I can verify that in the registry.

![image](/media/2013/03/image1.png "image")

Now I want to set my Execution policy via the Client settings to be able to execute powershell scripts in applications, packages and task sequences.

Therefore I created a new client setting device policy and configured the execution policy to Bypass.

![image](/media/2013/03/image2.png "image")

I deployed this policy to one of my device collections in order to reconfigure my computer’s execution policy.

![image](/media/2013/03/image3.png "image")

Before updating my client’s policy I checked all the execution policies on the client by running

`Get-ExecutionPolicy –List`

and got back this:

![image](/media/2013/03/image4.png "image")

Like I expected. “MachinePolicy” is my unconfigured GPO, which sets it to undefined/restricted and I believe LocalMachine is the default client setting.

Now after updating the client’s machine policy I find the following settings.

Registry (still the same):

![image](/media/2013/03/image5.png "image")

Powershell query (still the same):

![image](/media/2013/03/image6.png "image")

Executing the following WMI query on the client tells me a bit more about the ConfigMgr client settings:

```
get-wmiobject -Class ccm_ClientAgentConfig -Namespace root\ccm\policy\machine\requestedconfig | Select-Object BrandingTitle,PowershellExecutionPolicy
```

This shows me all the policies that are being requested by the SMS Agent, in this example I filtered the output to the “PowerShellExecutionPolicy” and “Branding Title”.

The Branding Title is just the “organization name displayed in software center”. This is just for me to distinguish between the two policies.

The output is quite interesting:

![image](/media/2013/03/image7.png "image")

As I said above, I left the default policy like it is per default and configured my custom settings to bypass. It looks like there’s definitely something happening.

These are only the policies that are requested by the SMS Agent, there’s another WMI namespace representing the actual config. Lets see what this one tells us.

![image](/media/2013/03/image8.png "image")

Well, the execution policy should have changed to Bypass. As I showed you above, it hasn’t.

# Executing Applications

With these settings I tried to run an application which only executes a simple powershell script.

I had the idea that maybe the SMS Agent evaluates the client settings on the fly and applies the configured execution policy just in time for the execution of an application or package.

If that was so, I would have seen it in the row “Process” in the listing of my execution policies.

So here’s my script:

```
get-executionpolicy -List | Out-File c:\temp\executionpolicy.log
```

That’s easy, isn’t it? ;-)

Well, I wasn’t able to execute it with only the client settings applied and none more. Bummer!

## Sum-up Execution Policy in ConfigMgr

To make this long story short. I can’t make out what this client setting does. The only way I’m able to successfully execute a Powershell script in an application is by using the ExecutionPolicy switch.

The commandline would then look like this:

```
powershell.exe -ExecutionPolicy Bypass -file ".\SomeFile.ps1"
```

The above file I’m creating in the temp folder will then look like this:

![image](/media/2013/03/image9.png "image")

But that’s what I expected from the client setting.

Where am I going wrong? Has anyone successfully used this setting and is able to shed a bit of light on this? I would really like to execute my scripts without using the executionpolicy parameter for every single one of them.


