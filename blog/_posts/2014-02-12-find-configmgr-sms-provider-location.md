---
id: 1626
title: How to find the ConfigMgr SMS Provider Location
date: 2014-02-12T12:46:09+00:00

layout: single

permalink: /2014/02/find-configmgr-sms-provider-location/
categories:
  - ConfigMgr
  - Configuration Manager
  - PowerShell
  - SCCM
  - WMI
tags:
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - SMS Provider
  - System Center
  - WMI
---
In my role as a technical consultant I sometimes need to visit customer sites where there are already ConfigMgr environments in place and I need to quickly find my way around.

One cool way of getting a quick overview would be my [Inventory Script for Configuration Manager](/2014/01/update-inventory-script-makes-configmgr-life-easier/).

I now had to quickly find all the SMS Providers that were installed in a site.

# ConfigMgr SMS Provider

What’s the SMS Provider you ask? Quoting [http://technet.microsoft.com/en-us/library/gg712282.aspx]("http://technet.microsoft.com/en-us/library/gg712282.aspx" http://technet.microsoft.com/en-us/library/gg712282.aspx)

```
The SMS Provider is the interface between the Configuration Manager console and the site database. This role is installed when you install a central administration site or primary site. Secondary sites do not install the SMS Provider. You can install the SMS Provider on the site server, the site database server (unless the site database is hosted on a clustered instance of SQL Server), or on another computer. You can also move the SMS Provider to another computer after the site is installed, or install multiple SMS Providers on additional computers. To move or install additional SMS Providers for a site, run Configuration Manager Setup, select the option **Perform site maintenance or reset the Site**, click **Next** , and then on the **Site Maintenance** page, select the option **Modify SMS Provider configuration**.

**Note**

The SMS Provider is only supported on computers that are in the same domain as the site server.
```

# Site Properties in SCCM Admin Console

To find all the SMS Providers in your environment you can check via the Console by looking at the Administration Node –> Site Configuration –> Sites and open up the Site’s properties.

![SCCM Site Properties](/media/2014/02/image3.png)

You see that I have two SMS Providers in my environment.

# Check SMS Provider Locations via WMI with Powershell

As an alternative you can just open up a Powershell on one SMS Provider you know (you always know at least one) and execute the following query:

```
(Get-WmiObject -class SMS_ProviderLocation -Namespace root\SMS).Machine
```

This will give you something like this:

![SMS_ProviderLocation](/media/2014/02/image4.png)


