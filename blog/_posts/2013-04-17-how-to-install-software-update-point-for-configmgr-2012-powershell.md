---
id: 904
title: 'How to install Software Update Point for ConfigMgr 2012 - Powershell'
date: 2013-04-17T23:49:04+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=904
permalink: /2013/04/how-to-install-software-update-point-for-configmgr-2012-powershell/
categories:
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - scripting
  - Software Update Point
  - WSUS
---
This has been on my agenda quite a while now. How to install a SUP for ConfigMgr 2012 with Powershell. This wasn’t too easy since I wanted to accomplish this also with the help of some of the new built-in cmdlets and so again I had to do some switching between x64 and x86 powershell sessions.

# Prerequisites for Software Update Point

The script will first check if the WSUS component is installed on the local client and if not installs and configures it. That’s all for prereqs, there are no more for a Windows Server 2012.

I do however configure the WSUS to use a SQL database and the SUP to use ports 8530 and 8531.

# Calling 32bit powershell from 64bit

You’ll see that I will at one stage use the Get-CMSiteSystemServer and New-CMSiteSystem cmdlets and for that to work I need to be in a 32bit powershell. All the rest of my scripts will be executed inside a 64bit session.

So how am I doing the switch?

I tried the following:

`Start-Job -Runas32 -Scriptblock { Do-Something $args } -ArgumentList $args`

But Start-Job just wouldn’t recognize my parameters, but I bet there’s someone around who can get it to work.

The –Runas32 switch (I believe that’s new for Powershell v3) runs the Backgroundjob as a 32bit process, which is exactly what I want. As I said, if you know how to make my process work with “Start-Job” I’m happy to get some feedback.

My workaround now is that I’m going to explicitly call the powershell.exe inside of C:\windows\SysWoW64\WindowsPowershell\v1.0\ and execute a second script just with the function I’d like to have called with the Start-Job.

# Install WSUS and SUP for ConfigMgr 2012

So here are the two scripts. Just place them inside the same folder and execute it like this:

```
.\New-SUP.ps1 -SiteCode PR1 -NewSUPServerName srv1.do.local -MPServer CM12 -DBServerName sql01 -DBServerInstance CM12 -WSUSContentPath "\\srv1\sources\Updates"
```

It’s important to use the server’s FQDN for “NewSUPServerName”, I’m not checking for it, so if you get an error in the script, it might be the FQDN.

New-SUP.ps1:

```
[CmdletBinding()]

param (

[string]$SiteCode,

[string]$NewSUPServerName,

[string]$MPServer,

[string]$DBServerName,

[string]$DBServerInstance,

[string]$WSUSContentPath

)

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

Function new-SUP {

############### Create Site System ################################################

#CM12 built-in cmdlets need to run in x86 powershell, that's why it's called directly from here via another script

C:\windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -file ".\new-sitesystem.ps1" -SiteCode $SiteCode -MPServer $MPServer -NewSUPServerName $NewSUPServerName

# connect to SMS Provider for Site

$role_class             = [wmiclass]""

$role_class.psbase.Path = "\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_SCI_SysResUse"

$role                     = $role_class.createInstance()

#create the SMS Distribution Point Role

$role.NALPath     = "[`"Display=\\$NewSUPServerName\`"]MSWNET:[`"SMS_SITE=$SiteCode`"]\\$NewSUPServerName\"

$role.NALType     = "Windows NT Server"

$role.RoleName     = "SMS Software Update Point"

$role.SiteCode     = "$($SiteCode)"

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseProxy" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "ProxyName" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "ProxyServerPort" -value 80 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "AnonymousProxyAccess" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UserName" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseProxyForADR" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsIntranet" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "Enabled" -value 1 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DBServerName" -value 0 -value1 '' -value2 '$($DBServerName\$DBServerInstance)')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "NLBVIP" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSIISPort" -value 8530 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSIISSSLPort" -value 8531 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "SSLWSUS" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseParentWSUS" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSAccessAccount" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsINF" -value 0 -value1 '' -value2 '')

$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "PublicVIP" -value 0 -value1 '' -value2 '')

$role.Put()

}

Function Install-WSUS {

if (-not (Get-WindowsFeature -Name UpdateServices).Installed -eq $true)

    {

        Install-WindowsFeature -Name UpdateServices-DB, UpdateServices-Ui -IncludeManagementTools -LogPath C:\Windows\System32\LogFiles\WSUSInstall.log

        $command = ". `"$env:ProgramFiles\Update Services\Tools\WsusUtil.exe`" PostInstall SQL_INSTANCE_NAME=$DBServerName\$DBServerInstance CONTENT_DIR=$WSUSContentPath"

        Invoke-Expression -Command $command

        Write-Host "WSUS installed and configured"

    }

else

    {

        Write-Host "WSUS is already installed and configured"

    }

}

######################### Main script starts here ###################

Install-WSUS

$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "GetSessionHandle" -ComputerName $MPServer

Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "RefreshSCF" -ArgumentList $SiteCode -ComputerName $MPServer | Out-Null

new-SUP

Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "CommitSCF" $SiteCode -ComputerName $MPServer | Out-Null

$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "ReleaseSessionHandle" -ArgumentList $SiteControlFile.SessionHandle -ComputerName $MPServer
```

New-SiteSystem.ps1:

```
param (

[string]$SiteCode,

[string]$NewSUPServerName,

[string]$MPServer

)

Function New-System {

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

#CM12 cmdlets need to be run from the CM12 site drive

Set-Location "$($SiteCode):"

if (-not (Get-CMSiteSystemServer -SiteSystemServerName $NewSUPServerName -SiteCode $SiteCode))

    {

        New-CMSiteSystemServer -ServerName $NewSUPServerName -SiteCode $SiteCode

        # built-in cmdlets have no real error handling, so try a Get-CMSiteSystemServer again

        if (-not (Get-CMSiteSystemServer -SiteSystemServerName $NewSUPServerName -SiteCode $SiteCode))

            {

                Write-Error "The Site System $($NewSUPServerName) has not been created. Please check the logs for further information"

                exit 1

            }

    }

}

New-System
```

Both scripts are also available for download from my Codeplex site:

New-SUP.ps1 : [https://davidobrien.codeplex.com/SourceControl/changeset/view/4d169b271787b39781306381ef1e11239256be28#New-SUP.ps1](https://davidobrien.codeplex.com/SourceControl/changeset/view/4d169b271787b39781306381ef1e11239256be28#New-SUP.ps1)

New-SiteSystem.ps1 : [https://davidobrien.codeplex.com/SourceControl/changeset/view/4d169b271787b39781306381ef1e11239256be28#new-sitesystem.ps1](https://davidobrien.codeplex.com/SourceControl/changeset/view/4d169b271787b39781306381ef1e11239256be28#new-sitesystem.ps1)
