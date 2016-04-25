---
id: 1434
title: Start-CMApplicationDeployment takes forever to complete in ConfigMgr
date: 2013-11-02T17:45:59+00:00

layout: single

permalink: /2013/11/start-cmapplicationdeployment-takes-forever-complete-configmgr/
categories:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - scripting
tags:
  - ConfigMgr
  - Powershell
  - SCCM
  - System Center
---
I recently had to create about 300 ConfigMgr 2012 Application Deployments for a customer migrating from NetInstall to Microsoft Configuration Manager 2012 SP1 (CM12).

That customer was a bit scared of the manual work involved by creating all the deployments (install and uninstall), so I told them “Hey, no problem. There’s a built-in Powershell cmdlet that can do it for you.”

I sat down and wrote a script to parse through all the existing applications and create a deployment for each of it.

Start-CMApplicationDeployment ([http://technet.microsoft.com/en-us/library/jj821911(v=sc.10).aspx](http://technet.microsoft.com/en-us/library/jj821911(v=sc.10).aspx)) looked really promising and easy to use, unfortunately it presented a huge problem.

`Start-CMApplicationDeployment –CollectionName %Collectionname% –Name %Applicationname% -DeployAction Uninstall -DeployPurpose Required -UserNotification HideAll`

In this CM12 SP1 CU3 environment it took the cmdlet 13 minutes for each application to create a deployment, although I was telling it the specific ApplicationName.

Seeing that I had to create an install and uninstall deployment for 300 apps in total that would’ve been 130 hrs or 5,5 days of waiting.

I had a look at SMSProv.log then and saw that the cmdlet looks like it’s going through all your applications and deployment types until it finds the right one to deploy.

Other people already confirmed this problem and I actually had to go and use WMI again to create the deployment.

Using WMI each deployment creation took only about 5 seconds. So what’s the deal here? I don’t know but I already filed a bug on connect for that. If you’re experiencing the same issue, then go on connect.microsoft.com and add some information to the bug. –> [https://connect.microsoft.com/ConfigurationManagervnext/feedback/details/807564/mvp-start-cmapplicationdeployment-takes-a-very-long-time](https://connect.microsoft.com/ConfigurationManagervnext/feedback/details/807564/mvp-start-cmapplicationdeployment-takes-a-very-long-time)

Here’s part of the script I used to create and application via WMI.

```
DeploymentClass = [wmiclass] "\\localhost\root\sms\site_$($SiteCode):SMS_ApplicationAssignment"

$Deployment = $DeploymentClass.CreateInstance()
$Deployment.ApplicationName                 = "PDFCreator"
$Deployment.AssignmentName                  = "Deploy PDFCreator"
$Deployment.AssignedCIs                     = 16781957
$Deployment.CollectionName                  = "All Systems"
$Deployment.DesiredConfigType               = 2 # 1 means install, 2 means uninstall
$Deployment.LocaleID                        = 1043
$Deployment.NotifyUser                      = $true
$Deployment.OfferTypeID                     = 2 # 0 means required, 2 means available
$Deployment.OverrideServiceWindows          = $false
$Deployment.RebootOutsideOfServiceWindows   = $false
$Deployment.SourceSite                      = "PRI"
$Deployment.StartTime                       = "20131001120000.000000+***"
$Deployment.SuppressReboot                  = $true
$Deployment.TargetCollectionID              = "SMS00001"   # CollectionID where to deploy it to
$Deployment.WoLEnabled                      = $false
$Deployment.UseGMTTimes                     = $true
$Deployment.Put()
```

More info on this WMI class here on MSDN:

SMS_ApplicationAssignment [http://msdn.microsoft.com/en-us/library/hh949469.aspx](http://msdn.microsoft.com/en-us/library/hh949469.aspx)

SMS_CIAssignmentBaseClass [http://msdn.microsoft.com/en-us/library/hh949014.aspx](http://msdn.microsoft.com/en-us/library/hh949014.aspx)



