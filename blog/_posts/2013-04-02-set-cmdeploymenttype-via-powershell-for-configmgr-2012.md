---
id: 891
title: Set-CMDeploymentType via Powershell for ConfigMgr 2012
date: 2013-04-02T21:25:15+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=891
permalink: /2013/04/set-cmdeploymenttype-via-powershell-for-configmgr-2012/
categories:
  - Applications
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - SCCM
  - scripting
  - WMI
tags:
  - ConfigMgr
  - Configuration Manager
  - lazy properties
  - Powershell
  - SCCM
  - scripting
  - System Center
  - WMI
---
A reader of my blog asked me something about one of the new Powershell cmdlets for ConfigMgr / SCCM 2012 and wanted me to check if I see the same behaviour (error) as he did.

Doing the following executed with no visible error, but the property wasn’t set:

`Set-CMDeploymentType -ApplicationName appname -DeploymentTypeName appname -MsiOrScriptInstaller -AllowClientsToUseFallbackSourceLocationForContent $True`


So what to do?

# Application model SDK for ConfigMgr 2012

After some digging around and testing and trying a colleague and I found the app model SDK for ConfigMgr 2012 and a nice blog article on MSDN for this: [http://blogs.msdn.com/b/one_line_of_code_at_a_time/archive/2012/01/17/microsoft-system-center-configuration-manager-2012-package-conversion-manager-plugin.aspx](http://blogs.msdn.com/b/one_line_of_code_at_a_time/archive/2012/01/17/microsoft-system-center-configuration-manager-2012-package-conversion-manager-plugin.aspx)

This was still not exactly what I was looking for, but it helped a lot!

## SMS_Application and XML (**SDMPackageXML)**

We obviously want to configure something inside of an application, so that’s where we start!

```
$application = Get-WmiObject SMS_Application -Namespace root\sms\site_$($SiteCode) |  where {($_.LocalizedDisplayName -eq "$($ApplicationName)") -and ($_.IsLatest)}
```

We now have $application filled with one of our applications. We can see lots of interesting and not so interesting properties.

![image](/media/2013/04/image.png)

![image](/media/2013/04/image1.png)

The most interesting is “**SDMPackageXML**”. ([http://msdn.microsoft.com/en-us/library/hh949251.aspx](http://msdn.microsoft.com/en-us/library/hh949251.aspx) )

On MSDN they define it as follows:

”Digest XML that defines the application.”

So all the properties we want to configure are somewhere in there! MSDN further tells us that this is another [lazy property](/2012/12/02/create-a-new-software-update-group-in-configmgr/) (more info on them here: [/2012/12/02/create-a-new-software-update-group-in-configmgr/](/2012/12/02/create-a-new-software-update-group-in-configmgr/))

In order to get to SDMPackageXML we need to get a direct reference to our application, we do the following:

```
$application = [wmi](Get-WmiObject SMS_Application -Namespace root\sms\site_$($SiteCode) |  where {($_.LocalizedDisplayName -eq "$($ApplicationName)") -and ($_.IsLatest)}).__PATH
```

Now we can have a look at $Application.SDMPackageXML (not a beauty, I know):

![image](/media/2013/04/image2.png)

Someone, sometime ago could have said, well, let the people just write here, but they didn’t. We can’t just do stuff here (right now!).

## DeSerialize and Serialize

The above mentioned MSDN article shows us how to DeSerialize this XML in order to do something with it.

[Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer] helps us here and that’s as deep as I will go in this article. For more info: [http://msdn.microsoft.com/en-us/library/jj154381.aspx](http://msdn.microsoft.com/en-us/library/jj154381.aspx)

Now after DeSerializing the XML, we can set the DeploymentType’s properties, but beware, PLEASE test the script in your environment. I doubt that you can use my script without testing and planning and also a bit of tuning.

In the end, after we set all the properties, we have to write them back into our application.

Just serialize your XML again and write it back to $application.SDMPackageXML. That’s it!

## How to use the PowerShell script

Here’s the script, you just need to provide it three parameters:

SiteCode

MPServer (your Management Point)

ApplicationName

Inside the script is a block where I set the content properties, these are the ones I provide:

Location  = new UNC path to source location

FallbackToUnprotectedDP = can be $true or $false

OnSlowNetwork = can be "Download" or "DoNothing"

PeerCache = can be $true or $false (enable for BranchCache)

PinOnClient = can be $true or $false (keep persistant on client)

For testing I also give you one more, but this, I believe, is only available for MSI / Script installer deployment types. I don’t have any AppV packages, so I can’t test it for other deployment types, so please beware:

Installer.InstallCommandLine = new commandline if you like

I’d love to hear some feedback of you. Did this script or any other help you? Do you have any comments?

Script can also be downloaded via [my Codeplex repository](http://davidobrien.codeplex.com/SourceControl/changeset/view/e10007c575bfdbc6953b295174b96a9f130f34f1#set-DeploymentType.ps1).

```
<#

took some input for this script from http://blogs.msdn.com/b/one_line_of_code_at_a_time/archive/2012/01/17/microsoft-system-center-configuration-manager-2012-package-conversion-manager-plugin.aspx

This script can change some basic settings for ConfigMgr 2012 Applications or their DeploymentTypes.

In this version I can set some basic stuff regarding content behaviour.

You can, as an alternative, always try the Set-CMDeploymentType, but that one has a bug regarding the Fallback to unprotected DPs.

#>

param(

[string]$SiteCode,

[string]$MPServer,

[string]$ApplicationName

)

function Get-ExecuteWqlQuery($siteServerName, $query)

{

  $returnValue = $null

  $connectionManager = new-object Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlConnectionManager

  if($connectionManager.Connect($siteServerName))

  {

      $result = $connectionManager.QueryProcessor.ExecuteQuery($query)

      foreach($i in $result.GetEnumerator())

      {

        $returnValue = $i

        break

      }

      $connectionManager.Dispose()

  }

  $returnValue

}

function Get-ApplicationObjectFromServer($appName,$siteServerName)

{

    $resultObject = Get-ExecuteWqlQuery $siteServerName "select thissitecode from sms_identification"

    $siteCode = $resultObject["thissitecode"].StringValue

    $path = [string]::Format("\\{0}\ROOT\sms\site_{1}", $siteServerName, $siteCode)

    $scope = new-object System.Management.ManagementScope -ArgumentList $path

    $query = [string]::Format("select * from sms_application where LocalizedDisplayName='{0}' AND ISLatest='true'", $appName.Trim())

    $oQuery = new-object System.Management.ObjectQuery -ArgumentList $query

    $obectSearcher = new-object System.Management.ManagementObjectSearcher -ArgumentList $scope,$oQuery

    $applicationFoundInCollection = $obectSearcher.Get()

    $applicationFoundInCollectionEnumerator = $applicationFoundInCollection.GetEnumerator()

    if($applicationFoundInCollectionEnumerator.MoveNext())

    {

        $returnValue = $applicationFoundInCollectionEnumerator.Current

        $getResult = $returnValue.Get()

        $sdmPackageXml = $returnValue.Properties["SDMPackageXML"].Value.ToString()

        [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($sdmPackageXml)

    }

}

 function Load-ConfigMgrAssemblies()

 {

     $AdminConsoleDirectory = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin"

     $filesToLoad = "Microsoft.ConfigurationManagement.ApplicationManagement.dll","AdminUI.WqlQueryEngine.dll", "AdminUI.DcmObjectWrapper.dll"

     Set-Location $AdminConsoleDirectory

     [System.IO.Directory]::SetCurrentDirectory($AdminConsoleDirectory)

      foreach($fileName in $filesToLoad)

      {

         $fullAssemblyName = [System.IO.Path]::Combine($AdminConsoleDirectory, $fileName)

         if([System.IO.File]::Exists($fullAssemblyName ))

         {

             $FileLoaded = [Reflection.Assembly]::LoadFrom($fullAssemblyName )

         }

         else

         {

              Write-Host ([System.String]::Format("File not found {0}",$fileName )) -backgroundcolor "red"

         }

      }

 }

Load-ConfigMgrAssemblies

$application = [wmi](Get-WmiObject SMS_Application -Namespace root\sms\site_$($SiteCode) |  where {($_.LocalizedDisplayName -eq "$($ApplicationName)") -and ($_.IsLatest)}).__PATH

$applicationXML = Get-ApplicationObjectFromServer "$($ApplicationName)" $MPServer

if ($applicationXML.DeploymentTypes -ne $null)

    {

        foreach ($a in $applicationXML.DeploymentTypes)

            {

                #change content properties

                $a.Installer.Contents[0].Location = "\\srv1\sources\Software\RE" # new UNC path to source location

                $a.Installer.Contents[0].FallbackToUnprotectedDP = $false #can be $true or $false

                $a.Installer.Contents[0].OnSlowNetwork = "DoNothing" # can be "Download" or "DoNothing"

                $a.Installer.Contents[0].PeerCache = $false # can be $true or $false

                $a.Installer.Contents[0].PinOnClient = $true #keep persistent on client, can be true or false

                #change basic DeploymentType properties

                #$a.Installer.InstallCommandLine = "msiexec /i `"RES-WM-2012.msi`"" #new commandline if you like

            }

    }

$newappxml = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::Serialize($applicationXML, $false)

$application.SDMPackageXML = $newappxml

$application.Put() | Out-Null
```
