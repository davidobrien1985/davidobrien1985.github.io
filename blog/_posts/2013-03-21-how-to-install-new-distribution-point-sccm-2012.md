---
id: 809
title: 'How to install new Distribution Point&ndash;SCCM 2012'
date: 2013-03-21T00:20:11+00:00
author: "David O'Brien"
layout: single

permalink: /2013/03/how-to-install-new-distribution-point-sccm-2012/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
tags:
  - automation
  - CM12
  - ConfigMgr
  - Configuration Manager
  - DP
  - Powershell
  - SCCM
  - System Center
---
Nearly a year ago (last June) I had a mission, I wanted to deploy new site systems via script. I wrote an article about it here ([/2012/06/08/install-distribution-point-for-configuration-manager-2012/](/2012/06/08/install-distribution-point-for-configuration-manager-2012/)) saying that I was able to install the site system, but it wasn’t ready to be used. I still had problems with the PXE cert and PXE itself. Months later ConfigMgr 2012 SP1 has been released and I find myself again at the task of deploying some Distribution Points. Not thinking about this problem for a while helps looking at it from a new perspective and I finally got it to work. Thanks again to Raphael Perez ([@dotraphael](https://twitter.com/dotraphael)) who pointed me into the direction of two properties I was missing while configuring the DP. Raphael scripts a lot in ConfigMgr and uploads his scripts to  [https://cm12automation.codeplex.com](https://cm12automation.codeplex.com) .

## TSMediaApi.dll and Microsoft.ConfigMgr.PXEAuth

In order to make the DP/PXE work, our new site system needs a certificate. I’m using self-signed certificates and to create them I need the TSMediaApi.dll from the ConfigMgr 2012 SP1 SDK, which you will find here: [http://www.microsoft.com/en-us/download/details.aspx?id=29559](http://www.microsoft.com/en-us/download/details.aspx?id=29559) After registering this dll a new ComObject becomes available, the Microsoft.ConfigMgr.PXEAuth. This object has a method called “CreateIdentity” which helps us to create a new self-signed certificate which can be used for our new PXE. (For more info: [http://msdn.microsoft.com/en-us/library/jj902795.aspx](http://msdn.microsoft.com/en-us/library/jj902795.aspx)) The certificate has been created. The next step is to bind that certificate to the new site system. That’s what the WMI method SubmitRegistrationRecord is for. This method is part of the SMS_Site class. (For more info: [http://msdn.microsoft.com/en-us/library/hh949501.aspx](http://msdn.microsoft.com/en-us/library/hh949501.aspx))

# Install a ConfigMgr Distribution Point via Powershell Script

The rest of the script hasn’t changed that much. To execute the script, copy the TSMediaApi.dll from the SDK into the same folder as the script and run the script with the needed parameters:

```
.\new-Distributionpoint.ps1 -SiteCode PR1 -server xa-deploy.do.local
```

That’s it. Take a look at the configurable items IN the script regarding the distribution point. I support a lot of features, which can easily be configured, but not all. I will extend the script soon to add some more error handling and more configurations like choosing the drive letter for the DP. Because of the TSMediaApi.dll and the ConfigMgr 2012 cmdlets thare are used, you’ll need to run this script in a x86 shell. Here’s the installation script, which can easily be extended to read a list of DPs and install them one by one. (an Orchestrator runbook for this will follow very soon!)

```
<#########

 This script installs a Microsoft System Center Configuration Manager 2012 Distribution Point Server Role

 Author: David O'Brien

 date: 01.06.2012

 History: 20.03.2013 - David O'Brien, www.david-obrien.net, added functionality

#########>

[CmdletBinding()]

param (

[string]$SiteCode,

[string]$NewDPServerName,

[string]$DPGroupName,

[string]$MPServer

)

[array]$global:roleproperties = @()

[array]$global:properties =@()

Function Set-Property

{

    PARAM(

        $MPServer,

        $SiteCode,

        $PropertyName,

        $Value,

        $Value1,

        $Value2

    )

    $embeddedproperty_class = [wmiclass]""

    $embeddedproperty_class.psbase.Path = "\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"

    $embeddedproperty = $embeddedproperty_class.createInstance()

    $embeddedproperty.PropertyName = $PropertyName

    $embeddedproperty.Value = $Value

    $embeddedproperty.Value1 = $Value1

    $embeddedproperty.Value2 = $Value2

    return $embeddedproperty

}

Function new-DistributionPoint {

############### Create Site System ################################################

# connect to SMS Provider for Site

$role_class = [wmiclass]""

$role_class.psbase.Path ="\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_SCI_SysResUse"

$role = $role_class.createInstance()

#create the SMS Site Server

$role.NALPath     = "[`"Display=\\$NewDPServerName\`"]MSWNET:[`"SMS_SITE=$SiteCode`"]\\$NewDPServerName\"

$role.NALType     = "Windows NT Server"

$role.RoleName     = "SMS SITE SYSTEM"

$role.SiteCode     = "$($SiteCode)"

#####

#filling in properties

#$IsProtected = @("IsProtected",1,"","")  # 0 to disable fallback to this site system, 1 to enable

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsProtected" -value 1 -value1 '' -value2 '')

#set-property $IsProtected[0] $IsProtected[1] $IsProtected[2] $IsProtected[3]

#$role.Props = $roleproperties

$role.Put()

################ Deploy New Distribution Point #####################################

# connect to SMS Provider for Site

$role_class             = [wmiclass]""

$role_class.psbase.Path = "\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_SCI_SysResUse"

$role                     = $role_class.createInstance()

#create the SMS Distribution Point Role

$role.NALPath     = "[`"Display=\\$NewDPServerName\`"]MSWNET:[`"SMS_SITE=$SiteCode`"]\\$NewDPServerName\"

$role.NALType     = "Windows NT Server"

$role.RoleName     = "SMS DISTRIBUTION POINT"

$role.SiteCode     = "$($SiteCode)"

# Certificate creation

$TSMediaCommand = "$($env:windir)\SysWOW64\regsvr32.exe /s .\TsMediaAPI.dll"

Invoke-Expression -Command $TSMediaCommand

$pxeauth    = new-object -comobject Microsoft.ConfigMgr.PXEAuth

if (!$pxeauth -is [Object]) {

    "PXEAuth Object OK"

}

$CertSubject = [System.Guid]::NewGuid().toString() # toString('B')

$CertSMSID   = [System.Guid]::NewGuid().toString() # toString('B')

$StartTime  = [DateTime]::Now.ToUniversalTime()

$EndTime    = $StartTime.AddYears(1)

$ident        = $pxeauth.CreateIdentity($CertSubject, $CertSubject, $CertSMSID, $StartTime, $EndTime)

# Certificate registration

$siteclass = [wmiclass]("\\$($MPServer)\root\sms\site_$SiteCode" + ":SMS_Site")

$inParams = $siteclass.GetMethodParameters("SubmitRegistrationRecord")

$inParams["SMSID"] = $CertSMSID

$inParams["Certificate"] = $ident[1]

$inParams["CertificatePFX"] = $ident[0]

$inParams["Type"] = 2

$inParams["ServerName"] = $NewDPServerName

$inParams["UdaSetting"] = '2'

$inParams["IssuedCert"] = '1'

$outParams = $siteclass.InvokeMethod("SubmitRegistrationRecord", $inParams, $null)

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsPXE" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsActive" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "SupportUnknownMachines" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UDASetting" -value 2 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "BITS download" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "Server Remote Name" -value 0 -value1 $NewDPServerName -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "PreStagingAllowed" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "SslState" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "AllowInternetClients" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsAnonymousEnabled" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DPDrive" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "MinFreeSpace" -value 50 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "InstallInternetServer" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "RemoveWDS" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "BindPolicy" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "ResponseDelay" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IdentityGUID" -value 0 -value1 $CertSMSID -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "CertificatePFXData" -value 0 -value1 ($ident[0]) -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "CertificateContextData" -value 0 -value1 ($ident[1]) -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "PXEPassword" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "CertificateType" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "CertificateExpirationDate" -value 0 -value1 ([String]$EndTime.ToFileTime()) -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "CertificateFile" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DPShareDrive" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsMulticast" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DPMonEnabled" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DPMonSchedule" -value 0 -value1 '00011700001F2000' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DPMonPriority" -value 4 -value1 '' -value2 '')

$role.Put()

if ($DPGroupName)

    {

        # this script needs to run in a x86 shell, but we need to access the x64 reg-hive to get the AdminConsole install directory

        $Hive = "LocalMachine"

        $ServerName = "$($MPServer)"

        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]$Hive,$ServerName,[Microsoft.Win32.RegistryView]::Registry64)

        $Subkeys = $reg.OpenSubKey('SOFTWARE\Microsoft\SMS\Setup\')

        $AdminConsoleDirectory = $Subkeys.GetValue('UI Installation Directory')

        switch (Test-Path $AdminConsoleDirectory)

           {

                $true { Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1" }

                $false {

                            Write-Verbose "$($AdminConsoleDirectory) does not exist. Trying alternate path under ProgramFilesx86"

                            $AdminConsoleDirectory = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole"

                            Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1"

                        }

            }

        #CM12 cmdlets need to be run from the CM12 drive

        Set-Location "$($SiteCode):"

        sleep -Seconds 5

        $DPID = (Get-WmiObject -Class SMS_DistributionPointInfo -Namespace root\sms\site_$($SiteCode) -ComputerName $($MPServer) | Where-Object {$_.Name -eq "$($NewDPServerName)"}).ID

        $DPID

        Add-CMDistributionPointToGroup -DistributionPointId $DPID -DistributionPointGroupName $DPGroupName

    }

}

$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "GetSessionHandle" -ComputerName $MPServer

Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "RefreshSCF" -ArgumentList $SiteCode -ComputerName $MPServer

new-distributionpoint $NewDPServerName

Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "CommitSCF" $SiteCode -ComputerName $MPServer

$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "ReleaseSessionHandle" -ArgumentList $SiteControlFile.SessionHandle -ComputerName $MPServer
```


