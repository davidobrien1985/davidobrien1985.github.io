---
id: 761
title: 'How to remove deployments in ConfigMgr&ndash;Powershell'
date: 2013-03-07T09:31:07+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=761
permalink: /2013/03/how-to-remove-deployments-in-configmgrpowershell/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - advertisements
  - automation
  - ConfigMgr
  - Configuration Manager
  - deployments
  - Microsoft
  - Powershell
  - SCCM
  - System Center
---
In preparation to a customer workshop I’m having today, I went through the ConfigMgr 2012 Integration Pack for Microsoft System Center 2012 Configuration Manager.

Cool stuff in there, for example “Deploy a Task Sequence”. Nice, but I also want to be able to delete the deployment again. I couldn’t find it, so what else could I do than write a script myself? (which I will turn into a runbook later)

# Legacy Advertisements from SCCM 2007

One could answer my request with the “Remove-CMDeployment” cmdlet from the ConfigMgr Powershell module. But hey, that’s only for application deployments, not for Task Sequences.

I browsed through my Management Point’s WMI space and found some interesting classes, starting with SMS\_Advertisement, SMS\_AdvertisementInfo and SMS_AdvertisementStatusInformation.

And here I was thinking that the term “Advertisement” is dead and isn’t used anymore with ConfigMgr 2012.

Well, here’s the script which will delete all deployments for a given CollectionName or CollectionID.

```PowerShell
[CmdletBinding()]

param(
[string]$SiteCode,
[Parameter(ParameterSetName='ID',Position=0)]
[string]$CollectionID,
[Parameter(ParameterSetName='Name',Position=0)]
[string]$CollectionName
)

if ($CollectionID)
    {
        $Advertisement = Get-WmiObject -Class SMS_Advertisement -Namespace root\sms\site_$($SiteCode) | Where-Object {$_.CollectionID -eq "$($CollectionID)"}
        if (($Advertisement -eq $null) -or ($Advertisement -eq ""))
            {
                Write-Error "Could not find any deployment on the given collection"
                exit 1
            }

        Write-Verbose "Will delete the Deployment $($Collection).AdvertisementName"
        $Advertisement | Remove-WmiObject
        if ($?)
            {
                Write-Verbose "Successfully deleted the deployment"
            }
        else
            {
                Write-Error -Message "There was an error deleting the deployment"
            }
    }
else
    {
        Write-Verbose "Enumerating the CollectionID"
        $CollectionID = (Get-WmiObject -Class SMS_Collection -Namespace root\sms\site_$($SiteCode) | Where-Object {$_.Name -eq "$($CollectionName)"}).CollectionID
        if (($CollectionID -eq $null) -or ($CollectionID -eq ""))
            {
                Write-Error "The given Collection could not be found"
                exit 1
            }

        $Advertisement = Get-WmiObject -Class SMS_Advertisement -Namespace root\sms\site_$($SiteCode) | Where-Object {$_.CollectionID -eq "$($CollectionID)"}
        if (($Advertisement -eq $null) -or ($Advertisement -eq ""))
            {
                Write-Error "Could not find any deployment on the given collection"
                exit 1
            }

        Write-Verbose "Will delete the Deployment $($Advertisement.AdvertisementName)"
        $Advertisement | Remove-WmiObject
        if ($?)
            {
                Write-Verbose "Successfully deleted the deployment"
            }
        else
            {
                Write-Error -Message "There was an error deleting the deployment"
            }
    }
```