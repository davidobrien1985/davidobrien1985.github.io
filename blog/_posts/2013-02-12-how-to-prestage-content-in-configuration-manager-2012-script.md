---
id: 733
title: 'How to prestage content in Configuration Manager 2012 &ndash; Script'
date: 2013-02-12T09:44:36+00:00
author: "David O'Brien"
layout: single

permalink: /2013/02/how-to-prestage-content-in-configuration-manager-2012-script/
categories:
  - automation
  - CM12
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - automation
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Distribution Point
  - Powershell
  - SCCM
---
This article won’t go into details on what content prestaging in SCCM 2012 is, there are a lot of good articles around, here just a few of them:

  * [http://blogs.technet.com/b/inside_osd/archive/2011/04/11/configuration-manger-2012-content-prestaging.aspx](http://blogs.technet.com/b/inside_osd/archive/2011/04/11/configuration-manger-2012-content-prestaging.aspx)
  * [http://blog.coretech.dk/kea/configuration-manager-2012-prestage-content-on-distribution-points/]("http://blog.coretech.dk/kea/configuration-manager-2012-prestage-content-on-distribution-points/" http://blog.coretech.dk/kea/configuration-manager-2012-prestage-content-on-distribution-points/) (by MVP Kent Agerlund [@agerlund](https://twitter.com/agerlund) )
  * [http://technet.microsoft.com/en-us/library/gg682083.aspx#BKMK_PrestagingContent]("http://technet.microsoft.com/en-us/library/gg682083.aspx#BKMK_PrestagingContent" http://technet.microsoft.com/en-us/library/gg682083.aspx#BKMK_PrestagingContent)

## SCCM 2012 SP1 brings Powershell

I already wrote an article about the Powershell module and how you load it into your session ( [/2012/09/15/ms-system-center-configuration-manager-2012-sp1-beta-powershell/](/2012/09/15/ms-system-center-configuration-manager-2012-sp1-beta-powershell/) ), so I’m not going into this topic too much either ;-)

I am however going a bit into detail on the problems I first had to solve.

## CM12 Powershell is x86

When launching the Powershell from the ConfigMgr console and checking its bitness, you’ll see that it’s 32bit and so must be the Powershell we will be running our script in, because we’re going to use some of the new Powershell cmdlets integrated into ConfigMgr 2012 SP1.

To successfully execute our script we need to import the ConfigMgr Powershell module which is located inside the Adminconsole installation folder. But where’s that?

AdminConsole setup writes a registry key pointing to its installation folder and from there on we can go and find the powershell module to load it.

The path to this reg key is ‘HKLM\Software\Microsoft\SMS\Setup\’ and the value is ‘UI Installation Directory’. Easy…

The problem is, that registry key is written inside the x64 part of the registry and we are running a x86 Powershell. When we are now trying to query anything under ‘HKLM\Software\…’ we’re actually looking inside ‘HKLM\Software\Wow6432Node\…’.

In case you don’t know what I’m talking about, take a look at [http://msdn.microsoft.com/en-us/library/windows/desktop/ms724072(v=vs.85).aspx]("http://msdn.microsoft.com/en-us/library/windows/desktop/ms724072(v=vs.85).aspx" http://msdn.microsoft.com/en-us/library/windows/desktop/ms724072(v=vs.85).aspx)

In Powershell 3 there is a way to query the 64bit part of registry out of a 32bit Powershell, it was tricky and it’s not my code to be honest. It’s a shame I can’t remember the site where I got it from, so if anyone recognizes the code as his, please say so and I give you full credit on this one ;-)

```PowerShell
$Hive = "LocalMachine"
$ServerName = "localhost"
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]$Hive,$ServerName,[Microsoft.Win32.RegistryView]::Registry64)
```

## Publish-CMPreStageContent cmdlet

The script I wrote basically needs only a few parameters to execute the ConfigMgr 2012 native cmdlet Publish-CMPreStageContent, which then will go and create a ‘*.pkgx’ file which then can be extracted at a remote site distribution point.

For the full syntax of this cmdlet have a look at [http://technet.microsoft.com/en-us/library/jj821974.aspx]("http://technet.microsoft.com/en-us/library/jj821974.aspx" http://technet.microsoft.com/en-us/library/jj821974.aspx) or use

`get-help Publish-CMPreStageContent`

The following script was written because I was asked if it’s possible to create prestaged content files automatically.

Short answer: Yes, see above cmdlet.

Long answer: My script.

I wrote it to do the following job:

Create prestaging files for any **application, package, driver package**, **boot image** or **OS image** in any given folder.

Or if you want it to, it creates one prestaging file out of any one of the above in a given folder.

Example:

![image](/media/2013/02/image.png "image")

```
.\prestage-Content.ps1 -Application -ApplicationFolderName Eval -SiteCode PR1 -ExportFolder \\srv1\sources\Software\PreStagedContent -SourceDistributionPoint sysctr.do.local
```

This command will create one prestaging file per each application in the folder “Eval”. We have to tell the script on which Source Distribution Point it will find the files and where we want to have the pkgx files created (Exportfolder).

```
.\prestage-Content.ps1 -Application -ApplicationFolderName Eval -AllInOneFile -ExportFileName PreStagedApplications -SiteCode PR1 -ExportFolder \\srv1\sources\Software\PreStagedContent -SourceDistributionPoint sysctr.do.local
```

This command will create only one pkgx file for all applications in the folder “Eval”.

## Powershell Parameter Sets

This script knows 15 parameters to execute. Fortunately we only need a few of them for each time we run it, depending on what we’re trying to do.

If you use Powershell Intellisense you will see that depending on which parameter you provide, those parameters you won’t need, will become inactive.

Example: When providing the parameter ‘-Application’, only those parameters related to application will stay available and those for the other scenarios (packages and so on) become unavailable.

This concept is called “Parameter Sets” and is quite a handy feature I just came across yesterday while writing the script.

More information can be found here:

  * [http://blogs.technet.com/b/heyscriptingguy/archive/2011/06/30/use-parameter-sets-to-simplify-powershell-commands.aspx](http://blogs.technet.com/b/heyscriptingguy/archive/2011/06/30/use-parameter-sets-to-simplify-powershell-commands.aspx) (by Scripting Guy Ed Wilson)
  * [http://msdn.microsoft.com/en-us/library/windows/desktop/dd878348(v=vs.85).aspx]( http://msdn.microsoft.com/en-us/library/windows/desktop/dd878348(v=vs.85).aspx)

## ExtractContent.exe to extract prestaged content

What to do with the prestaged files once they’re packed?

Copy them onto any media (USB, Hard Drive, DVD,…) and ship them to your remote location. On your remote distribution point (which is configured to accept prestaged content) you execute the following commandline:

```
extractcontent.exe /P:%PrestagedFileLocation%\%PrestagedFileName% /S
```

This command will extract the prestaged file onto the distribution point. You’ll find the extractcontent.exe in the following location:

’%Distribution Point%\SMS_DP$\sms\Tools’

This is the help for the ExtractContent.exe:

```
C:\SMS_DP$\sms\Tools>ExtractContent.exe /?

DESCRIPTION:

Extract Content tool manually imports content from one or more prestaged

content files to a Configuration Manager 2012 central administration site,

primary site, secondary site or distribution point. The content is added to

the content library and registered with the site server.

USAGE:

==============================================================================

ExtractContent.exe /P:<path> [/C]  [/S]  [/I]  [/?]

WHERE:

/P - Path to a prestaged file or to a folder containing one or more

     prestaged files

/C - Validate the content without prestaging it

/F - Force prestaging of content even when it already exists on the site

/S - Skip prestaging of content when the same version or a later version

     already exists on the server

/I - Display the metadata information for the content

/? - Display the command-line parameters for this tool

==============================================================================
```

## Script to automate Content PreStaging on Distribution Point

And here’s the script :-)

```
[CmdletBinding()]

Param(

    [Parameter(ParameterSetName='Package',Position=0)]

    [switch]$Package,

    [Parameter(ParameterSetName='Package',Position=0)]

    [string]$PackageFolderName,

    [Parameter(ParameterSetName='Application',Position=0)]

    [switch]$Application,

    [Parameter(ParameterSetName='Application',Position=0)]

    [string]$ApplicationFolderName,

    [Parameter(ParameterSetName='OS',Position=0)]

    [switch]$OS,

    [Parameter(ParameterSetName='OS',Position=0)]

    [string]$OSFolderName,

    [Parameter(ParameterSetName='BootImage',Position=0)]

    [switch]$BootImage,

    [Parameter(ParameterSetName='BootImage',Position=0)]

    [string]$BootImageFolderName,

    [Parameter(ParameterSetName='DriverPackage',Position=0)]

    [switch]$DriverPackage,

    [Parameter(ParameterSetName='DriverPackage',Position=0)]

    [string]$DriverPackageFolderName,

    [Parameter(ParameterSetName='AllInOne')]

    [Parameter(ParameterSetName='Package')]

    [Parameter(ParameterSetName='Application')]

    [Parameter(ParameterSetName='OS')]

    [Parameter(ParameterSetName='BootImage')]

    [Parameter(ParameterSetName='DriverPackage')]

    [switch]$AllInOneFile,

    [Parameter(ParameterSetName='AllInOne')]

    [Parameter(ParameterSetName='Package')]

    [Parameter(ParameterSetName='Application')]

    [Parameter(ParameterSetName='OS')]

    [Parameter(ParameterSetName='BootImage')]

    [Parameter(ParameterSetName='DriverPackage')]

    [string]$ExportFileName,

    [Parameter(Position=1,

        Mandatory=$True,

        ValueFromPipeline=$True)]

    [string]$SiteCode,

    [Parameter(Position=2,

        Mandatory=$True,

        ValueFromPipeline=$True)]

    [string]$ExportFolder,

    [Parameter(Position=3,

        Mandatory=$True,

        ValueFromPipeline=$True)]

    [string]$SourceDistributionPoint

 )

if (-not [Environment]::Is64BitProcess)

    {

        # this script needs to run in a x86 shell, but we need to access the x64 reg-hive to get the AdminConsole install directory

        $Hive = "LocalMachine"

        $ServerName = "localhost"

        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]$Hive,$ServerName,[Microsoft.Win32.RegistryView]::Registry64)

        $Subkeys = $reg.OpenSubKey('SOFTWARE\Microsoft\SMS\Setup\')

        $AdminConsoleDirectory = $Subkeys.GetValue('UI Installation Directory')

        #Import the CM12 Powershell cmdlets

        Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1"

        #CM12 cmdlets need to be run from the CM12 drive

        Set-Location "$($SiteCode):"

        if ($Package)

            {

                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($PackageFolderName)") -and ($_.ObjectType -eq "2")}).ContainerNodeID

                $PackageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)

                    {

                        Publish-CMPrestageContent -PackageId $PackageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                    }

                else

                    {

                        foreach ($SinglePackageID in $PackageIDs)

                            {

                              $PackageName = (gwmi -Class SMS_Package -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SinglePackageID)"}).Name

                              Publish-CMPrestageContent -PackageId $SinglePackageID -FileName $(Join-Path $ExportFolder "$PackageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                            }

                    }

            }

        if ($Application)

            {

                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($ApplicationFolderName)") -and ($_.ObjectType -eq "6000")}).ContainerNodeID

                $ApplicationIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)

                    {

                        foreach ($AppID in $ApplicationIDs)

                            {

                                $IDs = @()

                                $ApplicationID = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($AppID)"}).ModelID

                                $IDs += $ApplicationID

                            }

                        Publish-CMPrestageContent -ApplicationId $IDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                    }

                else

                    {

                        foreach ($SingleApplicationID in $ApplicationIDs)

                            {

                                $ApplicationID = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($SingleApplicationID)"}).ModelID

                                $ApplicationName = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($SingleApplicationID)"}).LocalizedDisplayName

                                Publish-CMPrestageContent -ApplicationId $ApplicationID -FileName $(Join-Path $ExportFolder "$ApplicationName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                            }

                    }

            }

        if ($OS)

            {

                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($OSFolderName)") -and ($_.ObjectType -eq "18")}).ContainerNodeID

                $OSIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)

                    {

                        Publish-CMPrestageContent -OperatingSystemImageId $OSIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                    }

                else

                    {

                        foreach ($SingleOSID in $OSIDs)

                            {

                                $OSName = (gwmi -Class SMS_ImagePackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleOSID)"}).Name

                                Publish-CMPrestageContent -OperatingSystemImageId $SingleOSID -FileName $(Join-Path $ExportFolder "$OSName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                            }

                    }

            }

        if ($BootImage)

            {

                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($BootImageFolderName)") -and ($_.ObjectType -eq "19")}).ContainerNodeID

                $BootImageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)

                    {

                        Publish-CMPrestageContent -BootImageId $BootImageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                    }

                else

                    {

                        foreach ($SingleBootImageID in $BootImageIDs)

                            {

                                $BootImageName = (gwmi -Class SMS_BootImagePackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleBootImageID)"}).Name

                                Publish-CMPrestageContent -BootImageId $SingleBootImageID -FileName $(Join-Path $ExportFolder "$BootImageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                            }

                    }

            }

        if ($DriverPackage)

            {

                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($DriverPackageFolderName)") -and ($_.ObjectType -eq "23")}).ContainerNodeID

                $DriverPackageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)

                    {

                        Publish-CMPrestageContent -DriverPackageID $DriverPackageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                    }

                else

                    {

                        foreach ($SingleDriverPackageID in $DriverPackageIDs)

                        {

                            $DriverPackageName = (gwmi -Class SMS_DriverPackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleDriverpackageID)"}).Name

                            Publish-CMPrestageContent -DriverPackageID $SingleDriverPackageID -FileName $(Join-Path $ExportFolder "$DriverPackageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null

                        }

                    }

            }

    }

else

    {

        Write-Error "This Script needs to be executed in a 32-bit Powershell"

        exit 1

    }
```

The script can also be found on [davidobrien.codeplex.com](http://davidobrien.codeplex.com)


