---
id: 756
title: 'Remove direct membership rules &ndash; ConfigMgr'
date: 2013-02-24T23:04:32+00:00

layout: single

permalink: /2013/02/remove-direct-membership-rules-configmgr/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
tags:
  - automation
  - Collections
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SCCM
  - System Center
---
This is a quick one. A reader of my blog asked me if I had a solution for his problem.

The Configuration Manager 2012 SP1 PowerShell cmdlet “Remove-CMDeviceCollectionDirectMembershipRule” needs at least two mandatory parameters, usually one defining the collection which is to be modified and one defining the collection member which is to be removed from the collection.

# Error handling of SCCM cmdlets

Unfortunately most of the now built-in PowerShell cmdlets in ConfigMgr lack error handling. No matter what you try, you won’t get an error back from the cmdlet.

An example would be:

`Remove-CMDeviceCollectionDirectMembershipRule -CollectionID PR10000A -ResourceName XA-01`

XA-01 is a member of the collection, but it wasn’t added via a direct membership rule, it’s there because of a query membership rule. Remove-CMDeviceCollectionDirectMembershipRule won’t throw an error in this case.

```
PS PR1:\
$?
True
```

That’s why my script doesn’t really do error handling.

There is already a connect feedback opened: [https://connect.microsoft.com/ConfigurationManagervnext/feedback/details/779832/powershell-cmdlets-output-and-error-handling](https://connect.microsoft.com/ConfigurationManagervnext/feedback/details/779832/powershell-cmdlets-output-and-error-handling)

# Remove Direct Membership rules

The script gets all the collection members and tries the above mentioned cmdlet against every member, thus removing all members that are there because of a direct membership rule.

The only parameters you need to provide are the SiteCode and a CollectionID.

```
[CmdletBinding()]

param (

[string]$SiteCode,

[string]$CollectionID

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

        $members = (Get-WmiObject SMS_CollectionMember_a -Namespace root\SMS\Site_$($SiteCode) | where {$_.CollectionID -eq "$($CollectionID)"}).Name

        foreach ($member in $members)

            {

                Remove-CMDeviceCollectionDirectMembershipRule -CollectionID $CollectionID -ResourceName $member -force

            }

    }

else

    {

        Write-Error "This Script needs to be executed in a 32-bit Powershell"

        exit 1

    }
```

Another approach would be to directly use the WMI method DeleteMembershipRule in the class SMS_Collection, but as we all should try to use the new cmdlets, I didn’t bother to use WMI ;-)

Remember to execute the script in a 32bit PowerShell, otherwise the script won’t run.



