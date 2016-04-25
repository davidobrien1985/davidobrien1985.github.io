---
id: 493
title: Create a Network Access Account–Configuration Manager 2012
date: 2012-10-03T21:58:43+00:00

layout: single

permalink: /2012/10/create-a-network-access-accountconfiguration-manager-2012/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
  - WMI
tags:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - NAA
  - Network Access Account
  - Powershell
  - System Center
  - System Center Configuration Manager
  - WMI
---
Today was a bank holiday in Germany and rainy weather, so what better could there be than scripting a bit in Configuration Manager?

Personally I’d say a lots of things, unfortunately the wife is sick and I have nothing better to do :-/

# Where is the Network Access Account?

There are a lot of people on the internet asking where the Network Access Account (NAA) is configured, because they just can’t seem to find it.

Well, it’s in “Configure Site Components” under Software Distribution Component Properties. There you can go and configure your NAA.

![image](/media/2012/10/image.png "image")

It’s not that complicated ;-)

But yesterday, while running through the woods, I thought that this should also be put into a script and today was the day I did it.

# 2 steps to success

Unfortunately, as always, Configuration Manager won’t just give you a Powershell cmdlet or a WMI Method to create the NAA. No, you have to do it in two, or even three, steps.

## Step 1: Create the user

While you can go and create the new or existing user for your NAA right through the AdminConsole, it’s not that easy via Script.

First you need to create a user, which is going to be your Network Access Account. This user can be any domain user with access to your sources/Distribution Point. ([About the Network Access Account (Microsoft Technet)](http://technet.microsoft.com/en-us/library/bb680398.aspx))

To be able to create the user, you have to encrypt the user’s password, which is done via a WMI method of the SMS_Site class. (EncryptDataEx)

After that we use a WMI class which it seems even Microsoft forgot to document, `SMS\_SCI\_Reserved`. This class is used to create a new instance, which will become our new user.

I found out about this class by looking at the `SMSProv.log`, which tells you nearly everything that goes through the SMS Provider.

## Step 2: Make the user the Network Access Account

The last step is to take the newly created user account and make it your Network Access Account.

To achive this we use the SMS\_SCI\_ClientComp WMI class. This class describes all the Client components of your site, like “Software Updates”, “System Health Agent” and also “Software Distribution”, which is the one we need.

Every item of this class has properties or in this case “Props”, which are put together by the “SMS_EmbeddedProperty” class.

We now just need to fill the right values into the right Props and everything’s fine.

At the end you can check in the GUI and also via the Powershell cmdlet `Get-CMAccount` if it worked:

![image](/media/2012/10/image1.png "image")

![image](/media/2012/10/image2.png "image")

Here’s the script! If the script helped you or you have any comments, I’d love to hear it!

```PowerShell
#######

# Purpose: This script creates a new user in your Microsoft System Center Configuration Manager 2012 Site and makes it your Network Access Account

#

# 

#

# Created: 03.10.2012

#

#######

param (

[string]$SiteCode,

[string]$UserDomain,

[string]$UserName,

[string]$unencryptedPassword

)

#encrypt the Password

$SMSSite = "SMS_Site"

$class_PWD = [wmiclass]""

$class_PWD.psbase.Path = "ROOTSMSsite_$($SiteCode):$($SMSSite)"

$Parameters = $class_PWD.GetMethodParameters("EncryptDataEx")

$Parameters.Data = $unencryptedPassword

$Parameters.SiteCode = $SiteCode

$encryptedPassword = $class_PWD.InvokeMethod("EncryptDataEx", $Parameters, $null)

# create the user in your site as a site local user account

$SMSSCIReserved = "SMS_SCI_Reserved"

$class_User = [wmiclass]""

$class_User.psbase.Path ="ROOTSMSSite_$($SiteCode):$($SMSSCIReserved)"

$user = $class_User.createInstance()

$user.ItemName = "$($UserDomain)$($UserName)|0"

$user.ItemType = "User"

$user.UserName = $UserDomain+""+$UserName

$user.Availability = "0"

$user.FileType = "2"

$user.SiteCode = $SiteCode

$user.Reserved2 = $encryptedPassword.EncryptedData.ToString()

$user.Put() | Out-Null

# make the created user account your new Network Access Account

$component = gwmi -class SMS_SCI_ClientComp -Namespace rootsmssite_$SiteCode  | Where-Object {$_.ItemName -eq "Software Distribution"}

$props = $component.Props

$prop = $props | where {$_.PropertyName -eq "Network Access User Name"}

$prop.Value = 0

$prop.Value1 = "REG_SZ"

$prop.Value2 = $UserDomain+""+$UserName

$component.Props = $props

$component.Put() | Out-Null
```



