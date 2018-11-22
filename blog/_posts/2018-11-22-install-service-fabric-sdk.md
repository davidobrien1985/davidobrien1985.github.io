---
title: How to install Azure Service Fabric SDK
date: 2018-11-22T12:01:30
layout: single
permalink: /2018/11/install-service-fabric-sdk
categories:
  - Azure
  - Microsoft
  - cloud
tags:
  - azure
  - cloud
  - devops
  - service fabric
  - automation
---

This is a quick one but it cost me quite a bit of time to solve this little puzzle, which ended up being a not too difficult one after all.<br>
I was asked to create an Azure pipeline which would create a new Azure DevOps build agent based on a Windows Server 2016 VM.<br>

## Azure DevOps build agent

Build agents usually require specific software to be installed on them so that applications can be built, compiled, packaged, whatever you want to call it. As did this one.<br>
One of those applications was the `Azure Service Fabric SDK`.<br>
The official way of installing this SDK is through the Web Platform Installer (WebPI). I have always used the `webpicmd.exe` to install features unattended (as you should), so it came a bit as a surprise to me when the installation of the Azure Service Fabric SDK repeatedly failed on a vanilla Windows Server 2016 Datacenter.

## Silent install of Azure Service Fabric SDK

First I had to install the WebPI on the server, which was fairly easy using [chocolatey](https://chocolatey.org) with the following command:

```
choco install webpicmd -y
```

Please check the chocolatey documentation for more information. The `-y` parameter automatically acknowledges any prompts for example.<br>
Once this out of the way I searched wide and far and found this command line here:<br>
`webpicmd.exe /Install /AcceptEula /SuppressReboot /Products:MicrosoftAzure-ServiceFabric-CoreSDK`
An alternative to that one, and one that I'm going to use going forward, is using chocolatey to install it for us:<br>
`choco install MicrosoftAzure-ServiceFabric-CoreSDK --source webpi -y`

Here's an excerpt of the error message repeatedly thrown:
```
        " [Web Platform Installer] Started installing: 'Microsoft Azure Service Fabric Runtime - 6.3.176'",
        "Microsoft Azure Service Fabric Runtime - 6.3.176",
        " [Web Platform Installer]  .  ",
        " [Web Platform Installer]  .. ",
        " [Web Platform Installer]  ...",
        " [Web Platform Installer]  .  ",
        " [Web Platform Installer]  .. ",
        " [Web Platform Installer]  ...",
        " [Web Platform Installer]  .  ",
        " [Web Platform Installer]  .. ",
        " [Web Platform Installer] Install completed (Failure): 'Microsoft Azure Service Fabric Runtime - 6.3.176'",
        " [Web Platform Installer] ServiceFabricRuntime_6_3_CU1 : Failed.",
        " [Web Platform Installer] DependencyFailed : Microsoft Azure Service Fabric SDK - 3.2.176",
        " [Web Platform Installer] DependencyFailed : Microsoft Azure Service Fabric SDK - 3.2.176",
        " [Web Platform Installer] Verifying successful installation...",
        " [Web Platform Installer] Microsoft Visual C++ 2012 SP1 Redistributable Package (x64) True",
        " [Web Platform Installer] Microsoft Visual C++ Redistributable Package for Visual Studio 2017 (x64) True",
        " [Web Platform Installer] Microsoft Azure Service Fabric Runtime - 6.3.176   False",
        " [Web Platform Installer]     Log Location: %temp%\\InstallFabricRuntime.log",
        " [Web Platform Installer] Microsoft Azure Service Fabric SDK - 3.2.176       False",
        " [Web Platform Installer] Microsoft Azure Service Fabric SDK - 3.2.176       False",
        " [Web Platform Installer] Install of Products: FAILURE"
```

So the `ServiceFabricRuntime_6_3_CU1` failed. Looking at the log file in `%temp%\\InstallFabricRuntime.log` it turns out that the installer fails to set the PowerShell execution policy for the current user to `RemoteSigned`.<br>
I've seen a lot of articles online with workarounds to the above error that download all MSIs directly and call them from `msiexec` causing lots of other issues (like hard coding the URLs into the scripts) where the solution to the problem is:

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
choco install MicrosoftAzure-ServiceFabric-CoreSDK --source webpi -y
```
<br>
This will successfully install the Azure Service Fabric SDK.
![Azure Service Fabric SDK installation](/media/2018/11/asf_success.png)