---
id: 957
title: 'Delete whole folder structure in ConfigMgr 2012&ndash;Powershell'
date: 2013-06-20T14:12:40+00:00

layout: single

permalink: /2013/06/delete-whole-folder-structure-in-configmgr-2012powershell/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - System Center
  - WMI
tags:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - WMI
---
During my tests with scripts I sometimes create whole folder structures with software packages inside the Configuration Manager 2012 Admin Console. Of course I also don’t get it right the first time around.

Did you ever need to delete more than a few packages at once? In more than one folder? You can’t select more than one package at a time for deletion and the same goes for folders. This can become a major pain if you don’t have a way to automate it.

That’s why I wrote this small script.

# How to delete folders and packages in ConfigMgr 2012

The script is totally independent of the ConfigMgr 2012 Powershell cmdlets, it’s all done via WMI.

**PLEASE USE THIS SCRIPT WITH CAUTION!!!!!!!!!**

It will ask you once and only once if you want to continue deleting any content and if you type “true”, then that’s that, all gone!

Lets say you have this folder structure:

![image](/media/2013/06/image.png)

If you want to delete all folders and packages beneath “LogiX_Test”, then you would have to execute the script like this:

```
.\Delete-FolderStructure -SiteCode $YourSiteCode -ManagementPoint $YourManagementPoint -FolderPath "LogiX_Test"
```

Now we have this:

![image](/media/2013/06/image1.png)

and you want to delete all content beneath “Tools”:

```
.\Delete-FolderStructure -SiteCode $YourSiteCode -ManagementPoint $YourManagementPoint -FolderPath "LogiX_Test\Tools"
```

This is how the script looks like:

```
<#

.SYNOPSIS

    Deletes packages and folders beneath a given folder structure.

.DESCRIPTION

    Deletes packages and folders beneath a given folder structure.

.PARAMETER SiteCode

    ConfigMgr Site SiteCode

    This parameter is mandatory!

    This parameter has an alias of SC.

.PARAMETER ManagementPoint

    FQDN of a ManagementPoint in this hierarchy.

    This parameter is mandatory!

    This parameter has an alias of MP.

.PARAMETER FolderPath

    This parameter expects the path to the folder UNDER which you want to delete ALL packages and ALL folders.

    This parameter is mandatory!

    This parameter has an alias of FP.

.EXAMPLE

    PS C:\PSScript > .\delete-folderstructure.ps1 -SiteCode PR1 -ManagementPoint CM12.do.local -FolderPath "Software\HelpDesk"

    This will use PR1 as Site Code.

    This will use CM12.do.local as Management Point.

    This will use "Software\HelpDesk" as the path to the folder under which you want to delete content. ALL content beneath the folder HelpDesk and ALL packages will be deleted. USE WITH CAUTION!!!

.INPUTS

    None.  You cannot pipe objects to this script.

.OUTPUTS

    No objects are output from this script.  This script creates a Word document.

.LINK

    http://www.david-obrien.net

.NOTES

    NAME: delete-folderstructure.ps1

    VERSION: 1.0

    

    LASTEDIT: June 20, 2013

    Change history:

.REMARKS

    To see the examples, type: "Get-Help .\delete-folderstructure.ps1 -examples".

    For more information, type: "Get-Help .\delete-folderstructure.ps1 -detailed".

    This script will only work with Powershell 3.0.

#>

[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" ) ]

param(

[parameter(

    Position = 1,

    Mandatory=$true )

    ]

    [Alias("SC")]

    [ValidateNotNullOrEmpty()]

    [string]$SiteCode="",

    [parameter(

    Position = 2,

    Mandatory=$true )

    ]

    [Alias("MP")]

    [ValidateNotNullOrEmpty()]

    [string]$ManagementPoint="",

    [parameter(

    Position = 3,

    Mandatory=$true )

    ]

    [Alias("FP")]

    [ValidateNotNullOrEmpty()]

    [string]$FolderPath=""

)

<#

#Import the CM12 Powershell cmdlets

Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length – 5) + '\ConfigurationManager.psd1') | Out-Null

#CM12 cmdlets need to be run from the CM12 drive

Set-Location "$($SiteCode):" | Out-Null

if (-not (Get-PSDrive -Name $SiteCode))

    {

        Write-Error "There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive."

        exit 1

    }

#>

$Packages = @()

$ChildFolders = @()

$Children = $null

$IDPath = @()

$GreatChildFolders = $null

$ChildFolders = $null

$Folders = $null

[array]$Folders = $FolderPath.Split("\")

$i = 0

foreach ($Folder in $Folders)

    {

        $FolderID = $null

        if ($i -eq 0)

            {

                $RootFolder = "0"

            }

        $FolderID = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "Name = '$($Folder)' and ObjectType = '2' and ParentContainerNodeID = '$($RootFolder)'").ContainerNodeID

        $RootFolder = $FolderID

        $IDPath += $FolderID

        $i++

    }

$ParentFolder = $StartFolder = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "ContainerNodeID = '$($IDPath[-1])'").ContainerNodeID

$Children = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "ParentContainerNodeID = '$($ParentFolder)'").ContainerNodeID

$ChildFolders += $Children

foreach ($Child in $ChildFolders)

    {

        try

            {

                $GreatChildFolders = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "ParentContainerNodeID = '$($Child)'").ContainerNodeID

            }

        catch [System.Management.Automation.PropertyNotFoundException]

            {

                Write-Verbose "This was the last folder."

            }

        $ChildFolders += $GreatChildFolders

    }

Write-Host "Folders to be deleted: $($ChildFolders)"

foreach ($ChildFolder in $ChildFolders)

    {

        try

            {

                $Packages += (Get-WmiObject -Class SMS_ObjectContainerItem -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "ContainerNodeID = '$($ChildFolder)'").InstanceKey

            }

        catch [System.Management.Automation.PropertyNotFoundException]

            {

                Write-Verbose "This was the last Package."

            }

    }

Write-Host "Packages to be deleted: $($Packages)"

if ((Read-Host -Prompt "Are you sure you want to delete these folders and packages? [true]") -eq $true)

    {

        foreach ($Pkg in $Packages)

            {

                try

                    {

                        $Pkg = (Get-WmiObject -Class SMS_Package -Namespace root\sms\site_$SiteCode -Filter "PackageID = '$($Pkg)'").__PATH

                        Remove-WmiObject -Path $Pkg

                    }

                catch [System.Management.Automation.PropertyNotFoundException]

                    {

                        Write-Verbose "This was the last Package."

                    }

            }

        foreach ($Fld in $ChildFolders)

            {

                try

                    {

                        $Fld = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace root\SMS\site_$($SiteCode) -ComputerName $($ManagementPoint) -Filter "ContainerNodeID = '$($Fld)'").__PATH

                        Remove-WmiObject -Path $Fld -ErrorAction SilentlyContinue

                    }

                catch [System.Management.Automation.PropertyNotFoundException]

                    {

                        Write-Verbose "This was the last folder."

                    }

            }

    }
```

Download the script from Codeplex:

[Delete-FolderStructure.ps1](https://davidobrien.codeplex.com/SourceControl/latest#Delete-FolderStructure.ps1)

Feedback or questions welcome.



