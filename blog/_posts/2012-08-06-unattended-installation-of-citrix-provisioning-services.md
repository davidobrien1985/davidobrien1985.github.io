---
id: 419
title: Unattended installation of Citrix Provisioning Services
date: 2012-08-06T15:45:14+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=419
permalink: /2012/08/unattended-installation-of-citrix-provisioning-services/
categories:
  - automation
  - Citrix
  - Provisioning Services
  - PVS
tags:
  - automation
  - Citrix
  - Provisioning Services
  - PVS
---
As I always say/write **‘automation is key’.** It’s important to me and also to a lot of customers/companies.

That’s why I had and still have the task to automate Citrix’s Provisioning Services.

# What’s been asked for?

Citrix PVS farms need to be installed, created, configured and maintained. No more ;-)

Doesn’t sound that much to ask for, bearing in mind that it’s 2012 and almost all products nowadays can easily be automated.

# Provisioning Services sounds promising

When looking at an already installed server and the Citrix eDocs, you find loads of information about how to automate stuff.

You can for example use the MCLI or Powershell equivalent. But these aren’t available before installation. So they won’t help you with installing the servers.

# configwizard.exe

Then there’s the configwizard.exe which is used to create or configure a PVS farm or a single server. The configwizard.exe gives you the power to even configure the services PVS installs on the server.

When running `configwizard.exe /c` a configwizard.out file is created under `C:\ProgramData\Citrix\Provisioning Services`.

That .out file contains all valid parameters with description to silently run the configwizard.exe.

```PowerShell
Monday, July 23, 2012 11:16:38
ConfigWizard version 6.1, © 2001-2012 Citrix Systems, Inc. All rights reserved.
IP Address Assignement Service
  IPServiceType=n       If n is 0, uses Microsoft DHCP.
                        If n is 2, uses Provisioning Services BOOTP service.
                        If n is 3, uses Other BOOTP or DHCP service.
PXE Service Type
  PXEServiceType=n      If this not found, uses another device.
                        If n is 0, uses Microsoft DHCP.
                        If n is 1, uses Provisioning Services PXE.
Farm Configuration
  FarmConfiguration=x        x is 0 for already configured, 1 for create farm, or 2 for join existing farm.
Database Server
  DatabaseServer=x        x is the name of the server.
  DatabaseInstance=x      x is the name of the instance.
  FailoverDatabaseServer=x    x is the name of the failover server.
  FailoverDatabaseInstance=x  x is the name of the failover instance.
Existing Farm
  FarmExisting=x        x is the name of the Farm.
Site
  Site=x        x is the name of the new site.
  Collection=x  x is the default path of the new site.
  ExistingSite=x  x is the name of the site selected.
Store
  Store=x        x is the name of the new store.
  DefaultPath=x  x is the default path of the new store.
  ExistingStore=x  x is the name of the store selected.
New Farm
  DatabaseNew=x       x is the name of the new database.
  FarmNew=x           x is the name of the new farm.
  SiteNew=x           x is the name of the new site.
  CollectionNew=x     x is the name of the new collection.
  ADGroup=x           x is is the Active Directory group.
  Group=x             x is is the Windows group.
New Store
  Store=x        x is the name of the new store.
  DefaultPath=x  x is the default path of the new store.
License Server Name
  LicenseServer=x        x is the name of the server.
  LicenseServerPort=x    x is the port number.
Stream Service User Account
  UserName=x  x is a user account name.
  UserPass=x  x is the password (not encrypted) for the user account.
  UserName2=x x is the password (encrypted) for the user account.
    UserPass or UserName2 can be used for the password.
  Network=1   Network is used for the 'Network service account' choice.
  Database=1  Configure the database the database for the account.
PasswordManagement
  PasswordManagementInterval=x        x is the day internal between password resets.
Stream Service Network Cards
  StreamNetworkAdapterIP=x  x is a comma delimited IP address list.
    Uses first card if not found.
Management Services First and Last Port
  ManagementFirstPort=n n is first port number.  6905 if not found.
  ManagementLastPort=n  n is the last port number.  6909 if not found.
TFTP and Bootstrap File
  BootstrapFile=x        x is file.  TFTP and Bootstrap not used, if not found.
Boot Servers
  LS#=ip,subnet,gateway,port  # is the number of the server, 1 is the first.
    If not found, uses the first in the database or
    if none in the database, the first card found.
    if none in the database, the first card found.
  AdvancedVerbose=x           x is 1 when verbose mode is turned on.
  AdvancedInterrultSafeMode=x x is 1 when interrupt safe mode is turned on.
  AdvancedMemorySupport=x     x is 1 when advanced memory support is turned on.
  AdvancedRebootFromHD=x      x is 1 when reboot from hard drive on fail.
  AdvancedRecoverSeconds=x    x is the number of seconds to reboot to hard drive after fail.
  AdvancedLoginPolling=x      x is the number of milliseconds for login polling timeout.
  AdvancedLoginGeneral=x      x is the number of milliseconds for login general timeout.
Start Services
  NoStartServices=1     Do not start services if exists.
```

If you like you can also run the configwizard with the `/s` switch. The wizard opens and lets you configure all you want and at the end creates the configwizard.ans (also under `C:\ProgramData\Citrix\Provisioning Services` ) file which then can be used to repeat what you have just configured on other servers.

```PowerShell
FarmConfiguration=1
DatabaseServer=SQL01
DatabaseInstance=
DatabaseNew=DB_TEST
FarmNew=TEST_FARM
SiteNew=TEST_SITE
CollectionNew=COLL_TEST
ADGroup=do.local/Groups/AdminGroups/ADM_PVS
Store=STORE_TEST
DefaultPath=c:\temp
LicenseServer=srv1
LicenseServerPort=27000
UserName=do\adobrien
UserName2=ppnfpjhhokjqqipoilofbgddnelsqibsprclcnbegeknkhnmckod
Database=1
PasswordManagementInterval=7
StreamNetworkAdapterIP=172.16.0.30
IpcPortBase=6890
IpcPortCount=20
SoapPort=54321
BootstrapFile=C:\ProgramData\Citrix\Provisioning Services\Tftpboot\ARDBP32.BIN
LS1=172.16.0.30,0.0.0.0,0.0.0.0,6910
AdvancedVerbose=0
AdvancedInterrultSafeMode=0
AdvancedMemorySupport=1
AdvancedRebootFromHD=0
AdvancedRecoverSeconds=50
AdvancedLoginPolling=5000
AdvancedLoginGeneral=30000
```

Looking at this configwizard.ans file and the above parameters you can see that a new farm should be created, telling the wizard which database server, instance and database to use, what the name of the admingroup is, under which account the streaming service shall run and much more.

Well, the problem is:

If you do all this via the configwizard, then everything is fine. The database gets created and the server joins the new farm.

If you install the server and then run `configwizard.exe /a:%PathToANSfile%` nothing happens. No database created and nothing configured.

# Database creation

After a bit of searching you will come across the DBScript.exe. This exe empowers you to create a sql script which will create a database, create all necessary tables and also create the farm in this database.

This script actually does what it’s supposed to do, but again when running `configwizard.exe /a:%PathToANSfile%` the server won’t join the farm.

The logfile `C:\ProgramData\Citrix\Provisioning Services\configwizard.out` claims that the “DefaultPath” parameter is missing, although I clearly provided one.The same goes for `C:\ProgramData\Citrix\Provisioning Services\Logs\ConfigWizard.log`.

It’s weird that the same thing done manually via the configwizard.exe works, but if I use the configwizard.ans file for the first server, then it doesn’t.

Apparently this is what Citrix says:

[http://support.citrix.com/proddocs/topic/provisioning-61/pvs-install-silent-conf-wiz.html](http://support.citrix.com/proddocs/topic/provisioning-61/pvs-install-silent-conf-wiz.html)

## Prerequisite

The Configuration Wizard must first be run on any Provisioning Server in the farm that has the configuration settings that will be used in order to create the Provisioning Services database and to configure the farm.

If I understand that correctly, then the first server in a new PVS farm has to be configured manually, which is quite a bummer…

# [UPDATE] It works!

I promised an update as soon as I’d know anything more, and here it is. It works and it’s a bit strange.

I tend to write scripts or edit them in Notepad ++ or just Notepad and it seems as if that caused the problem. Looking at an original unedited “configwizard.ans” you will notice that it’s in Unicode, which is fine. It’s also what I saw when looking at it in Notepad ++, but not what my notebook did to it. After editing it, it saved it as ANSI, but continued to show Unicode. Looking at it from a different notebook one could see it was in ANSI.

I don’t know why my machine would do that and it doesn’t matter anymore, that was the Windows 7 time, now is Windows 8 time and all is fine!!! 

# Powershell to set encoding

I’m doing the whole installation and configuration of Citrix Provisioning Services in one Powershell script and that’s also the place where I now build the “configwizard.ans” file in.

It looks like this:

```
$installstring ="FarmConfiguration=1
DatabaseServer=$DBServer
DatabaseInstance=$DBInstance
DatabaseNew=$DBName
FarmNew=$FarmName
SiteNew=$SiteName
CollectionNew=$CollectionName
ADGroup=$AdminGroup
Store=$StoreName
 DefaultPath=$StorePath
LicenseServer=$LicSrv
LicenseServerPort=27000
UserName=rzixtecabitpvsdbuser
UserPass=TQlYjCDnuvqJu1FthjdU
Database=1
PasswordManagementInterval=7
StreamNetworkAdapterIP=$IP
IpcPortBase=6890
IpcPortCount=20
SoapPort=54321
BootstrapFile=C:ProgramDataCitrixProvisioning ServicesTftpbootARDBP32.BIN
LS1=$IP,0.0.0.0,0.0.0.0,6910
AdvancedVerbose=0
AdvancedInterrultSafeMode=0
AdvancedMemorySupport=1
AdvancedRebootFromHD=0
AdvancedRecoverSeconds=50
AdvancedLoginPolling=5000
AdvancedLoginGeneral=30000
NoStartServices=1
}
if (-not (Test-Path $(join-path $installpathServer configwizard.ans)))
{
  New-Item -Path $(join-path $installpathServer configwizard.ans) -ItemType File
}
Set-Content -Path $(join-path $installpathServer configwizard.ans) -Value $installstring -Encoding Unicode
```

Line 37 is the one where I set the right Encoding and that’s how it works! Despite what Citrix says in their edocs, this way you’re even able to join the first server to a farm.

**What are your experiences? Did you get it to work?**

# Sum up

I thought nowadays to automate a software would be easier. When searching the internet you don’t find a lot of people who install PVS unattended (or they don’t speak about it) and if you find something it’s nearly always about some problems they have.

Take a look at Simon Pettit’s blog article about automating PVS with RES Automation Manager if you don’t want to use Powershell ;-) [http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/](http://virtualengine.co.uk/2012/automating-citrix-provisioning-server-install-with-res-am/)
