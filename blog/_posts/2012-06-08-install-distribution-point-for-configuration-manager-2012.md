---
id: 359
title: Install Distribution Point for Configuration Manager 2012
date: 2012-06-08T23:35:45+00:00

layout: single

permalink: /2012/06/install-distribution-point-for-configuration-manager-2012/
categories:
  - Applications
  - Cloud
  - Common
  - Community
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
  - WMI
tags:
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Install Distribution Point
  - Installation
  - Powershell
  - SCCM 2012
  - SCCM2012
  - Script
  - silent
  - System Center
  - unattended
---
# or: documentation would have been nice!

I like automating as much as possible, as you might have already learned from my other articles. My next plan was to script the installation of a site system role in Microsoft System Center Configuration Manager 2012, to be more precise, I wanted to deploy a Distribution Point. With no access to the GUI, totally scripted, with Powershell!

And here comes the problem kicking you somewhere bad  ;)
There’s no documentation on how to do this. The only thing around is the ConfigMgr 2012 SDK PreRelease, and even there not everything is covered.

# automation with Powershell

Today I’m going to show you my script as far as I have come up until now.

## What will the script do?

* create a Site System
  * configure whether it’s protected or not
* create a Distribution Point on that Site System
  * configure this Distribution Point with properties that I’ve found in the Site Control file (which is now inside of the Site Database)
  * and fill these properties with values, that I’ve also found in the Site Control file and also guessed a lot

## What are the script’s prereqs?

* installed Windows Deployment Server (WDS)
* installed IIS
  * although there is this property “InstallInternetServer”, this didn’t seem to work
    * maybe wrong values?

## Which problems am I facing?

A Distribution Point usually has a certificate on it, whether it’s self-signed or previously created and imported doesn’t matter. This is the problem! My script is unable to create a certificate.

I can’t find anything on how to create/import a certificate and bind it to a Distribution Point. **For Update see below!**

~~There has been a COM Object in ConfigMgr 2007, but this seems to have vanished. There was also a WMI method which is also gone.~~  SMSProv.log tells me nothing, I used ProcMon and API monitors and I’m as wise as before… :-(
What I did find out is, that it uses the local server’s crypto API.

~~Might be I’m just overlooking something, but this is driving me nuts.~~

## ~~Assumptions~~

~~After creating a Distribution Point with my script I can see it in the ConfigMgr console and inside the database’s Site Control file (without the certificate properties!)~~

![image] /media/2012/06/image.png "image")

~~As soon as I open up it’s properties inside the console the “Apply” (german: “Übernehmen”) button is active, without me doing anything!~~

![image](/media/2012/06/image1.png "image")

~~When I press the button, only that, nothing else, the window closes and ConfigMgr creates a self-signed certificate and assigns it to the Distribution Point, which can then be seen in the Site Control File.~~

~~I’d like the community to have a look at my script and tell me what’s wrong ;-) ~~
~~Now, here it comes: (old, not functioning script…)~~

```PowerShell
########
 # This script installs a Microsoft System Center Configuration Manager 2012 Distribution Point Server Role
# 
# date: 01.06.2012
########

Function global:Set-Property(

$PropertyName,
$Value,
$Value1,
$Value2,
$roleproperties
)

{
  $embeddedproperty_class = [wmiclass]""
  $embeddedproperty_class.psbase.Path = "\.ROOTSMSSite_S01:SMS_EmbeddedProperty"
  $embeddedproperty = $embeddedproperty_class.createInstance()
  $embeddedproperty.PropertyName = $PropertyName
  $embeddedproperty.Value = $Value
  $embeddedproperty.Value1 = $Value1
  $embeddedproperty.Value2 = $Value2
  $global:roleproperties += [System.Management.ManagementBaseObject]$embeddedproperty
}

Function global:new-DistributionPoint {

 ############### Create Site System ################################################

$global:roleproperties = @()
 $global:properties =@()

# connect to SMS Provider for Site
$role_class = [wmiclass]""

$role_class.psbase.Path ="\.ROOTSMSSite_S01:SMS_SCI_SysResUse"
$script:role = $role_class.createInstance()

 #create the SMS Site Server

 $role.NALPath = "[`"Display=\$server`"]MSWNET:[`"SMS_SITE=$sitename`"]\$server"

 $role.NALType = "Windows NT Server"

 $role.RoleName = "SMS SITE SYSTEM"

 $role.SiteCode = "S01"

#####
#filling in properties
 $IsProtected = @("IsProtected",1,"","") # 0 to disable fallback to this site system, 1 to enable

set-property $IsProtected[0] $IsProtected[1] $IsProtected[2] $IsProtected[3]

$role.Props = $roleproperties

$role.Put()

 ################ Deploy New Distribution Point #####################################
$role = ""
 $global:properties = @()
$global:roleproperties = @()

 # connect to SMS Provider for Site

$role_class = [wmiclass]""
$role_class.psbase.Path = "\.ROOTSMSSite_S01:SMS_SCI_SysResUse"
 $role = $role_class.createInstance()

#create the SMS Distribution Point Role

$role.NALPath = "[`"Display=\$server`"]MSWNET:[`"SMS_SITE=$sitename`"]\$server"

$role.NALType = "Windows NT Server"
$role.RoleName = "SMS DISTRIBUTION POINT"
$role.SiteCode = "S01"
# filling in the properties
$ServerRemoteName = ,@("Server Remote Name","","","$server") #FQDN of server
$BITS = ,@("BITS download",1,"","") # is BITS going to be enabled
$SslState = ,@("SslState",0,"","") # HTTP (0) or HTTPS (63) connections?
$IsMulticast = ,@("IsMulticast",0,"","") # is Multicast enabled? if 1, then also the SMS Multicast Role has to be configured

$UseMachineAccount = ,@("UseMachineAccount",0,"","") # in case of multicast, use machine account to connect to database
$IsPXE = ,@("IsPXE",1,"","") # is PXE going to be enabled?
#$PXEPassword = ,@("PXEPassword","0","","") # no idea how to put an encrypted string in there
$SupportUnknownMachines = ,@("SupportUnknownMachine",0,"","") # PXE unknown computer support enabled?
$IsAnonymousEnabled = ,@("IsAnonymousEnabled",0,"","") # are clients allowed to make anonymous connections? only for HTTP
$AllowInternetClients = ,@("AllowInternetClients",0,"","") # self explaining
$IsActive = ,@("IsActive",1,"","") # is PXE active? requires it to be enabled!
$InstallInternetServer = ,@("InstallInternetServer",1,"","") # shall IIS be installed & configured?
$RemoveWDS = ,@("RemoveWDS",0,"","")
$UDASetting = ,@("UDASetting",0,"","") # User Device Affinity enabled?
$MinFreeSpace = ,@("MinFreeSpace",444,"","") # minimum free space on DP
PreStagingAllowed = ,@("PreStagingAllowed",0,"","") # DP enabled for PreStaging of files?
$ResponseDelay = ,@("ResponseDelay",5,"","") # how many seconds shall PXE wait until answering, between 0 and 32 seconds
$DPShareDrive = ,@("DPShareDrive","","","") # where does the DP Share reside (primary and secondary), e.g "C:,D:"
$DPDrive = ,@("DPDrive","","","") # which is the DP content library drive
#$global:properties = @()
$properties = $ServerRemoteName + $DPDrive + $DPShareDrive + $ResponseDelay + $BITS + $UseMachineAccount + $IsPXE + $IsAnonymousEnabled + $IsActive + $InstallInternetServer + $IsMulticast + $SslState + $RemoveWDS + $SupportUnknownMachines + $AllowInternetClients + $MinFreeSpace + $PreStagingAllowed + $UDASetting# + $PXEPassword
#$global:roleproperties = @()

foreach ($property in $properties)
{
  $PropertyName = $property[0]
  $Value = $property[1]
  $Value1 = $property[2]
  $Value2 = $property[3]
  Set-Property $PropertyName $Value $Value1 $Value2 $roleproperties
}
$role.Props = $roleproperties
$role.Put()
}

$script:sitename = "S01"
$script:server = "AppV01.do.local" #FQDN of server, which is going to be installed as a new server role

new-distributionpoint $server
```

~~Where am I going wrong? Already asked that on Twitter (@david_obrien) and Linkedin!~~

# [UPDATE] Certificate gets created!!!

A clever Microsoft employee gave me a real good hint to use a dll, which comes with the ConfigMgr 2007 SDK, the tsmediaapi.dll.

This .dll needs to be registered on the ConfigMgr server you run it on in a x86 environment (%windir%syswow64cmd.exe regsvr32.exe tsmediaapi.dll)

The whole powershell script then needs to be executed from a x86 powershell to use this API.

Here’s the working script:

```PowerShell
########
This script installs a Microsoft System Center Configuration Manager 2012 Distribution Point Server Role
# 
 # date: 01.06.2012
########
Function global:Set-Property($PropertyName,$Value,$Value1,$Value2,$roleproperties)
{
  $embeddedproperty_class             = [wmiclass]""
  $embeddedproperty_class.psbase.Path = "\.ROOTSMSSite_S01:SMS_EmbeddedProperty"
  $embeddedproperty                     = $embeddedproperty_class.createInstance()
  $embeddedproperty.PropertyName  = $PropertyName
  $embeddedproperty.Value         = $Value
  $embeddedproperty.Value1        = $Value1
  $embeddedproperty.Value2        = $Value2
  $global:roleproperties += [System.Management.ManagementBaseObject]$embeddedproperty
}

Function global:new-DistributionPoint {
  ############### Create Site System ################################################
  $global:roleproperties = @()
  $global:properties =@()
  # connect to SMS Provider for Site
  $role_class = [wmiclass]""
  $role_class.psbase.Path ="\.ROOTSMSSite_S01:SMS_SCI_SysResUse"
  $script:role = $role_class.createInstance()
  #create the SMS Site Server
  $role.NALPath     = "[`"Display=\$server`"]MSWNET:[`"SMS_SITE=$sitename`"]\$server"
  $role.NALType     = "Windows NT Server"
  $role.RoleName     = "SMS SITE SYSTEM"
  $role.SiteCode     = "S01"
  #####
  #filling in properties
  $IsProtected                    = @("IsProtected",1,"","")  # 0 to disable fallback to this site system, 1 to enable
  set-property $IsProtected[0] $IsProtected[1] $IsProtected[2] $IsProtected[3]
  $role.Props = $roleproperties
  $role.Put()
  ################ Deploy New Distribution Point #####################################
  $role         = ""
  $global:properties = @()
  $global:roleproperties = @()
  # connect to SMS Provider for Site
  $role_class             = [wmiclass]""
  $role_class.psbase.Path = "\.\ROOT\SMS\Site_S01:SMS_SCI_SysResUse"
  $role                     = $role_class.createInstance()
  #create the SMS Distribution Point Role
  $role.NALPath     = "[`"Display=\$server`"]MSWNET:[`"SMS_SITE=$sitename`"]\$server"
  $role.NALType     = "Windows NT Server"
  $role.RoleName     = "SMS DISTRIBUTION POINT"
  $role.SiteCode     = "S01"
  # Certificate creation
  $pxeauth    = new-object -comobject Microsoft.ConfigMgr.PXEAuth
  if (!$pxeauth -is [Object]) {
    "PXEAuth Object OK"
  }
  $strSubject = [System.Guid]::NewGuid().toString() # toString('B')
  $strSMSID   = [System.Guid]::NewGuid().toString() # toString('B')
  $StartTime  = [DateTime]::Now.ToUniversalTime()
  $EndTime    = $StartTime.AddYears(5)
  $TargetPXEServerFQDN = $server
  $ident        = $pxeauth.CreateIdentity($strSubject, $strSubject, $strSMSID, $StartTime, $EndTime)
  "Subject: " + $strSubject
  "SMSID: " + $strSMSID
  # Certificate registration
  $siteclass = [wmiclass]("\.rootsmssite_$sitename" + ":SMS_Site")
  $intResult = $siteclass.SubmitRegistrationRecord($strSMSID, $ident[1], $ident[0], 2, $server)
  if ($intResult.StatusCode -eq 0) {
    "Certificate Registration OK"
  } else {
    ("Certificate Registration failed, error: " + $intResult)
  }
  # filling in the properties
  $ServerRemoteName       = ,@("Server Remote Name",0,"$server","") #FQDN of server
  $BITS                     = ,@("BITS download",1,"","")         # is BITS going to be enabled
  $SslState                = ,@("SslState",0,"","")             # HTTP (0) or HTTPS (63) connections?
  $IsMulticast             = ,@("IsMulticast",0,"","")           # is Multicast enabled? if 1, then also the SMS Multicast Role has to be configured
  $UseMachineAccount         = ,@("UseMachineAccount",0,"","")     # in case of multicast, use machine account to connect to database
  $IsPXE                    = ,@("IsPXE",1,"","")                 # is PXE going to be enabled?
  #$PXEPassword             = ,@("PXEPassword","0","","")           # no idea how to put an encrypted string in there
  $SupportUnknownMachines = ,@("SupportUnknownMachine",0,"","") # PXE unknown computer support enabled?
  $IsAnonymousEnabled     = ,@("IsAnonymousEnabled",0,"","")    # are clients allowed to make anonymous connections? only for HTTP
  $AllowInternetClients      = ,@("AllowInternetClients",0,"","")  # self explaining
  $IsActive                 = ,@("IsActive",1,"","")              # is PXE active? requires it to be enabled!
  $InstallInternetServer     = ,@("InstallInternetServer",1,"","") # shall IIS be installed & configured?
  $RemoveWDS                = ,@("RemoveWDS",0,"","")
  $UDASetting                = ,@("UDASetting",0,"","")            # User Device Affinity enabled?
  $MinFreeSpace             = ,@("MinFreeSpace",444,"","")        # minimum free space on DP
  $PreStagingAllowed        = ,@("PreStagingAllowed",0,"","")     # DP enabled for PreStaging of files?
  $ResponseDelay          = ,@("ResponseDelay",5,"","")        # how many seconds shall PXE wait until answering, between 0 and 32 seconds
  $DPShareDrive           = ,@("DPShareDrive","","","")     # where does the DP Share reside (primary and secondary), e.g "C:,D:"
  $DPDrive                = ,@("DPDrive","","","")          # which is the DP content library drive
  $CertificateType        = ,@("CertificateType",0,"","")
  $CertificateExpiration  = ,@("CertificateExpirationDate",0,([String]$EndTime.ToFileTime()),"")
  $CertificateFile        = ,@("CertificateFile",0,"","")
  $PXECertGUID            = ,@("PXECertGUID",0,$strSMSID,"")
  #$global:properties = @()
  $properties = $CertificateType + $CertificateExpiration + $CertificateFile + $PXECertGUID + $ServerRemoteName + $DPDrive + $DPShareDrive + $ResponseDelay + $BITS + $UseMachineAccount + $IsPXE + $IsAnonymousEnabled + $IsActive + $InstallInternetServer + $IsMulticast + $SslState + $RemoveWDS + $SupportUnknownMachines + $AllowInternetClients + $MinFreeSpace + $PreStagingAllowed + $UDASetting# + $PXEPassword
  #$global:roleproperties = @()

  foreach ($property in $properties)
  {
    $PropertyName     = $property[0]
    $Value            = $property[1]
    $Value1            = $property[2]
    $Value2            = $property[3]
    Set-Property $PropertyName $Value $Value1 $Value2 $roleproperties
  }
  $role.Props = $roleproperties
  $role.Put()
}

$script:sitename = "S01"
$script:server = "AppV01.do.local" #FQDN of server, which is going to be installed as a new server role
new-distributionpoint $server
```

Looking forward to your feedback via comments, tweets or mail!



