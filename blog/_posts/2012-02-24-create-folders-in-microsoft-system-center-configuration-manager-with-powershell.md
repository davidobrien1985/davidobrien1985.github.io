---
id: 275
title: Create Folders in Microsoft System Center Configuration Manager 2012 with Powershell
date: 2012-02-24T13:01:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=275
permalink: /2012/02/create-folders-in-microsoft-system-center-configuration-manager-with-powershell/
if_slider_image:
  -
categories:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - Configuration Manager
  - create folders
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2012
  - System Center
---
Just a short article today…

I’m in the middle of a Configuration Manager implementation at a customer’s site and facing the problem of creating lots of folders and collections in those folders.

As you all might know Microsoft got rid of the “subcollections” and gave us collection folders to arrange our collections.

![image](/media/2012/02/image.png "image")

My customer needs round about 150 folders and I am a lazy admin. What does a lazy admin do?

## Write a Powershell script

I wasn’t quite sure how the creation works so I opened up my Configuration Manager console and my server’s SMSProv.log (admin’s little helper!) and just created a folder manually in the console.

This is what I found in the SMSProv.log:
```
CExtUserContext::EnterThread : User=OSDsepago Sid=0x0105000000000005150000000D3DD859871387AF86AA21EB52040000 Caching IWbemContextPtr=0000000005F26770
Process 0xadc (2780)    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: SMSAppName=SMS Administrator Console    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: MachineName=configmgrRC2.osd.local    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: UserName=OSDsepago    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: ObjectLockContext=f770fac9-a526-480a-b6e1-6a0fa1b63f88    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: ApplicationName=Microsoft.ConfigurationManagement.exe    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: ApplicationVersion=5.0.0.0    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: LocaleID=MS�x407    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: __ProviderArchitecture=32    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: __RequiredArchitecture=0 (Bool)    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: __ClientPreferredLanguages=de-DE,de    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Context: __GroupOperationId=16655    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
CExtUserContext: Set ThreadLocaleID OK  1031    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
CSspClassManager::PreCallAction, dbname=CM_PRI    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
PutInstanceAsync SMS_ObjectContainerNode    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
CExtProviderClassObject::DoPutInstanceInstance    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
PutInstance of Folder : script    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
DEBUGGING ObjectType  = 5000    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
Auditing: User OSDsepago created an instance of class  SMS_ObjectContainerNode.    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
CExtUserContext::LeaveThread : Releasing IWbemContextPtr=99772272    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
SMS Provider    24.02.2012 07:56:34    2128 (0x0850)
```

What did this tell me? Actually, a lot!

In line 15 it told me that the WMI Class “SMS_ObjectContainerNode” was used and that it put a new instance there. I also found the name of my folder in the next line 17, I called it “script”.

Line 18 was the last information I needed, the “ObjectType”.

ObjectType = 5000 means that you’re creating a device collection, while ObjectType = 5001 means user collection.

What it’s not telling me here is that I also need the “ParentContainerNodeID”. I forgot that one and the error message told me that I missed that one.

If you want to create a folder beneath the root, then your “ParentContainerNodeID" is “0”, otherwise you will have to evaluate the ID of your parent folder.

## Powershell function

And this is how it looks:

```PowerShell
Function Create-CollectionFolder($FolderName)
{
  $CollectionFolderArgs = @{
    ObjectType = "5000";         # 5000 ist für Collection_Device, 5001 ist für Collection_User
    ParentContainerNodeid = "0" # die ParentContainerNodeID ist dann '0', wenn der Ordner unter der Root hängt, ansonsten muss der ParentOrdner evaluiert werden
  }
  Set-WmiInstance -Class SMS_ObjectContainerNode -arguments $CollectionFolderArgs -namespace "root\SMS\Site_$sitename" | Out-Null
}
  $FolderName = Get-Random   # für Test, setzt einfach eine willkürliche Zahl
  $sitename = "PRI" # an deinen Sitename anpassen!
  Create-CollectionFolder $FolderName
```

If you need some help or got some questions left, just ask!
