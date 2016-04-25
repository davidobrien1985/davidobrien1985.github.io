---
id: 2760
title: Recover deleted users in Azure Active Directory
date: 2014-12-04T20:12:31+00:00

layout: single

permalink: /2014/12/recover-deleted-users-azure-active-directory/
categories:
  - Azure
  - Office365
  - PowerShell
tags:
  - AAD
  - active directory
  - Azure
  - O365
  - Office365
  - Powershell
---
You know of the [recycle bin in Active Directory](http://technet.microsoft.com/en-us/library/dd392261%28v=ws.10%29.aspx), right?

I guess this feature has probably saved a bunch of people already big time. Anyways, even the cloud can’t save you from stupidity, failures or “Are you sure? Of course I’m sure!” situations when, for whatever reason, user accounts get deleted when they should not have been deleted.

This scenario will specifically show how you can recover deleted user accounts both from Office 365 and also from Azure Active Directory.

# Azure Active Directory

You can’t view deleted users in your Azure Portal (unless you can show me where!), too bad. Gone is gone.

PowerShell to the rescue.

Connect your PowerShell session to your Azure Active Directory by using the MSOnline module.

![image](/media/2014/12/image.png)

You can use the following function to easily connect yourself to MSOnline:

```
#region Functions
Function Save-Password
{
  Param
  (
    [parameter(Mandatory = $true)]
    [String]
    $FilePath,

    [parameter(Mandatory = $false)]
    [Switch]
    $PassThru
  )

  $secure = Read-Host -AsSecureString 'Enter your Azure organization ID password.'
  $encrypted = ConvertFrom-SecureString -SecureString $secure
  $result = Set-Content -Path $FilePath -Value $encrypted -PassThru

  if (!$result)
  {
    throw "Failed to store encrypted string at $FilePath."
  }
  if ($PassThru)
  {
    Get-ChildItem $FilePath
  }
}

#endregion Functions
#region connect to MSOnline
try {
  if (-not (Get-Module -Name MSOnline)) {
    $null = Import-Module -Name MSOnline
  }
}
catch {
  Write-Error -Message {0} -f $PSItem;
}

$FilePath = Save-Password -FilePath 'C:\Users\David\OneDrive\Scripts\Azure\Password_MSOL.txt' -PassThru
$userName = 'david@dopsftw.onmicrosoft.com'
$securePassword = ConvertTo-SecureString (Get-Content -Path $FilePath)
$msolcred = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

connect-msolservice -credential $msolcred
```

Logged on to your Azure Portal (<https://manage.windowsazure.com> ) you can view all your users in your Domains.

![image](/media/2014/12/image1.png)

What you can’t do via this GUI/website is, view a recycle bin. If you go and delete a user from here, that user is gone from your view.

The way you restore a user account in this situation is very simple using PowerShell.

`Get-MsolUser -ReturnDeletedUser`

![image](/media/2014/12/image2.png)

This will show all user accounts that have been previously deleted.

`Get-MsolUser -ReturnDeletedUsers | foreach {$PSItem | fl * -Force}`

This will show you even more information on that deleted user. For example if you have a look at the ‘SoftDeletionTimestamp’ property. The first picture is from the user before we deleted it, the second after we deleted it.

![image](/media/2014/12/image3.png)

![image](/media/2014/12/image4.png)

Use the following command to restore deleted accounts:

`Restore-MsolUser -UserPrincipalName 'TestUser01@dopsftw.onmicrosoft.com'`

# Office 365 Admin Portal – deleted users

The Office 365 Admin Portal (<https://portal.office.com> ) makes it a bit easier for the common administrator to restore deleted user accounts.

![image](/media/2014/12/image5.png)

![image](/media/2014/12/image6.png)

Still, the MSOnline cmdlets work both for Azure Active Directory and for users in your Office365 Active Directory.



