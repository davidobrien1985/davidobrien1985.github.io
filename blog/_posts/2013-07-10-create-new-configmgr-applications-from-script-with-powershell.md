---
id: 1061
title: Mass import of ConfigMgr applications from script with Powershell
date: 2013-07-10T21:03:56+00:00
author: "David O'Brien"
layout: single

permalink: /2013/07/create-new-configmgr-applications-from-script-with-powershell/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012 R2
  - Configuration Manager
  - PowerShell
  - System Center
  - Uncategorized
tags:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Powershell
  - SCCM
  - SysCtr
  - System Center
---
# How to do a mass import of Applications into ConfigMgr

Some days ago I was asked if I had a script that could create new Configuration Manager 2012 applications (like in the new App model) from script. At that time I did not, but this just changed.

With the new cmdlets most scripts aren't that long anymore, so is this, quite short.

This script won't create all the application types that could be created, like MacOSX, AppV, Android or such. This script can only create deployment types for MSI and basic "script installers".

MSI is easy, I just did a "automatic import" for MSIs. So not too much to do here, at least for me. If you need to append some switches/parameters to the commandline, you will have to do that manually after mass import.

Script installer is a bit more complicated. The Add-CMDeploymentType won't allow you to add any other detection method than detection by script. You can't add a detection by file / registry / folder / ... via the powershell cmdlet.

In this import script I used a placeholder for the detection script, that way the cmdlet will work but you will need to go into these deployment types and reconfigure the detection method to your liking.

Here's an example of how to import AppV applications. It's german, but if you look at the script I guess you'll get the idea.

## Import via XML

I had to find a way to define my applications outside of ConfigMgr to be able to import them via script. I first thought of a CSV file, but that would have meant to have different CSV files for MSI apps and others. Because of that I went with an XML file.

I will upload an example XML file. You should be able to extend this file in order to import your own applications and deployment types.

```
<Applications>
  <Application>
    <Name>RES Workspace Manager</Name>
    <Description>RES WM Client</Description>
    <Manufacturer>RES</Manufacturer>
    <SoftwareVersion>2012</SoftwareVersion>
    <AutoInstall>true</AutoInstall>
    <DeploymentTypes>
      <DeploymentType>
        <MsiInstaller>true</MsiInstaller>
        <AutoIdentifyFromIntallationFile>true</AutoIdentifyFromIntallationFile> -->
        <InstallationFileLocation>\\srv1\sources\Software\RES\RES-WM-2012.msi</InstallationFileLocation>
      </DeploymentType>
    </DeploymentTypes>
  </Application>
  <Application>
    <Name>ThinKiosk2</Name>
    <Description>TK3</Description>
    <Manufacturer>Andy Morgan</Manufacturer>
    <SoftwareVersion>3</SoftwareVersion>
    <AutoInstall>true</AutoInstall>
    <DeploymentTypes>
      <DeploymentType>
        <MsiInstaller>true</MsiInstaller>
        <InstallationFileLocation>\\srv1\sources\Software\ThinKiosk\Kiosk-Installer.msi</InstallationFileLocation>
      </DeploymentType>
      <DeploymentType>
        <ScriptInstaller>true</ScriptInstaller>
        <DeploymentTypeName>Install Thinkiosk</DeploymentTypeName>
        <InstallationProgram>msiexec /i \\srv1\sources\Software\ThinKiosk\Kiosk-Installer.msi /qn</InstallationProgram>
        <InstallationBehaviorType>InstallForSystem</InstallationBehaviorType>   <!-- InstallForSystem; InstallForUser; InstallForSystemIfResourceIsDeviceOtherwiseInstallForUser -->
        <ContentLocation>\\srv1\sources\Software\ThinKiosk\</ContentLocation>
        <LogonRequirementType>OnlyWhenNoUserLoggedOn</LogonRequirementType>     <!-- OnlyWhenNoUserLoggedOn; OnlyWhenUserLoggedOn; WhereOrNotUserLoggedOn -->
      </DeploymentType>
    </DeploymentTypes>
  </Application>
</Applications>
```

Here's the script:

```
[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" ) ]
param(
[string]$SiteCode,
 [ValidateScript({Test-Path $(Split-Path $_) -PathType 'Container'})]
 [string]$Path
)

#Set-Location \\srv1\sources\Tools\scripts

[xml]$Applications = Get-Content $Path

Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length – 5) + '\ConfigurationManager.psd1') | Out-Null

#CM12 cmdlets need to be run from the CM12 drive
Set-Location "$($SiteCode):" | Out-Null
if (-not (Get-PSDrive -Name $SiteCode))
    {
        Write-Error "There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive."
        exit 1
    }

foreach ($App in $Applications.Applications.Application)
    {
        if ($App.AutoInstall)
            {
                $NewApp = New-CMApplication -Name "$($App.Name)" -Description "$($App.Description)" -SoftwareVersion "$($App.SoftwareVersion)" -AutoInstall $true
            }
        else
            {
                $NewApp = New-CMApplication -Name "$($App.Name)" -Description "$($App.Description)" -SoftwareVersion "$($App.SoftwareVersion)"
            }

        foreach ($DeploymentType in $App.DeploymentTypes)
            {
                if ($DeploymentType.DeploymentType.MsiInstaller)
                    {
                        "Adding DT for MSI Installer"
                        Add-CMDeploymentType -ApplicationName "$($NewApp.LocalizedDisplayName)" -InstallationFileLocation "$($DeploymentType.DeploymentType.InstallationFileLocation)" -MsiInstaller -AutoIdentifyFromInstallationFile -ForceForUnknownPublisher $true
                    }
                if ($DeploymentType.DeploymentType.ScriptInstaller)
                    {
                        "Adding DT for Script Installer"
                        [string]$ContentLocation = ($DeploymentType.DeploymentType.ContentLocation)
                        $ContentLocation = $ContentLocation.Trim()
                        Add-CMDeploymentType -ApplicationName "$($NewApp.LocalizedDisplayName)" -ScriptInstaller -DeploymentTypeName "$($DeploymentType.DeploymentType.DeploymentTypeName)" -InstallationProgram "$($DeploymentType.DeploymentType.InstallationProgram)" -InstallationBehaviorType "$($DeploymentType.DeploymentType.InstallationBehaviorType)" -LogonRequirementType "$($DeploymentType.DeploymentType.LogonRequirementType)" -ContentLocation "$($ContentLocation)" -ManualSpecifyDeploymentType -DetectDeploymentTypeByCustomScript -ScriptType Powershell -ScriptContent "$($env:computername)"
                    }
                else
                    {
                        "There's no further deployment type defined."
                    }
            }
    }

Set-Location C:\
```

This is how you execute the script:

```
 .\New-Applications.ps1 -SiteCode PR1 -Path \\%PathToXMLFile%
```

Make sure you run this script on a server with an installed Admin Console and one that can access the XML file.

I hope this article gives you an idea of how to accomplish the task of mass import of applications into your ConfigMgr environment.

Comments and questions are welcome as always!


