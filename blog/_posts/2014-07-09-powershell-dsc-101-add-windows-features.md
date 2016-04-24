---
id: 1845
title: 'Powershell DSC 101 - How to add Windows Features'
date: 2014-07-09T22:04:48+00:00
author: "David O'Brien"
layout: single

permalink: /2014/07/powershell-dsc-101-add-windows-features/
categories:
  - automation
  - PowerShell
  - scripting
tags:
  - automation
  - Desired State Configuration
  - DSC
  - Powershell
  - Windows Features
---
Powershell Desired State Configuration is a very powerful feature of Powershell 4.0 and Windows Server 2012 R2. Coming from a very strong Microsoft System Center Configuration Manager background I like to think of it a bit as Compliance Settings. I'm configuring a state I want a Server to be in and DSC makes sure it ends up looking like that (and even stays like that - remediation!). And all that, if you like, without the "overhead" of any additional infrastructure (and even for Linux!) Crazy?!

More information around DSC can be found here: [http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx](http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx) and [http://technet.microsoft.com/en-us/library/dn249912.aspx](http://technet.microsoft.com/en-us/library/dn249912.aspx)

# WindowsFeature resource in DSC

Being based on Powershell, DSC knows certain keywords you can use in your configuration file. I won't go too much into detail for all of them, but here's a high-level view on a very simple DSC configuration.

```
Configuration SimpleDSC
{
  param ( $NodeName )
  Node $NodeName
  {
    WindowsFeature WebServer
    {
        Ensure = "Present"
        Name = "Web-Server"
    }
  }
}
```

Just by configuring this I am telling DSC to ensure that the Windows Feature "Web-Server" is present on that Node.

You can find all the Feature Names you can use here by executing

`Get-WindowsFeature | Out-GridView`

![image](/media/2014/07/2014-07-09-21_48_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg)

After adding in all the Windows Features you would like to have on that server, compiling the MOF and pushing the setting onto the server, you can see the results in your Powershell console:

![image](/media/2014/07/2014-07-09-21_53_35-SMAWorker01-on-NB-DOBRIEN-Virtual-Machine-Connection.jpg)

Adding that one Windows Feature (Web-Server) and a child feature (Web-Basic-Auth) to the server only took DSC 36 seconds, very nice.

You can find more information about the "WindowsFeature" DSC resource here: <http://technet.microsoft.com/en-us/library/dn282127.aspx>

In the next article I am going to show you how to leverage this basic knowledge here to deploy some cool custom Server Roles in your environment!

I hope this short trip into DSC-land was already enough to get you hooked (if you're not already) onto the new Powershell features that came with Powershell 4.

