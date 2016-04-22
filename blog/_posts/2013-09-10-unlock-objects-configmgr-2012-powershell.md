---
id: 1264
title: How to unlock objects in ConfigMgr 2012 with Powershell
date: 2013-09-10T20:52:48+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1264
permalink: /2013/09/unlock-objects-configmgr-2012-powershell/
categories:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - System Center
tags:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SysCtr
  - System Center
---
# Unlocking packages or apps in ConfigMgr 2012

![locked object sccm](/media/2013/09/image.png)

Crap! Do you know this message? Most probably your console just crashed a minute ago while you were editing this application and you’re trying to open up this application again. Well, too bad, please wait for 30 minutes and then come back please.

This is because your lock on that object has not been released the moment your console crashed.

For more information on this, use the search engine of your choice (google \*g\*) and look for SEDO (**S**erialized **E**diting of **D**istributed **O**bjects) or try this site: [http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx](http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx)

## Unlocking objects (before Powershell)

At least I hate waiting, even more if it’s 30 minutes because of a stupid lock I don’t want to have anymore. So what could be done? Wait… or go to your database and delete the lock. Not the best solution!!! Microsoft hates admins who directly touch and alter the database. But for a very long time this was the only solution to this problem: [http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/](http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/)

`select * from SEDO_LockState where LockStateID  0`
`DELETE from SEDO_LockState where LockID = ‘%LockID of the record identified in the previous query%'`

## Unlocking objects (with Powershell)

So what can be done now that we don’t want to touch the database directly?

Powershell to the rescue! Since ConfigMgr 2012 SP1 we have the following cmdlet:

```
 PS PRI:\> get-help Unlock-CMObject -Full

 NAME

 Unlock-CMObject

 SYNTAX

 Unlock-CMObject \[-InputObject] <IResultObject[]> [-WhatIf\] \[-Confirm\]  [<CommonParameters>]

 PARAMETERS

 -Confirm

 Required?                    false

 Position?                    Named

 Accept pipeline input?       false

 Parameter set name           (All)

 Aliases                      cf

 Dynamic?                     false

 -InputObject <IResultObject[]>

 Required?                    true

 Position?                    0

 Accept pipeline input?       true (ByPropertyName)

 Parameter set name           ByValue

 Aliases                      None

 Dynamic?                     false

 -WhatIf

 Required?                    false

 Position?                    Named

 Accept pipeline input?       false

 Parameter set name           (All)

 Aliases                      wi

 Dynamic?                     false

  <CommonParameters>

 This cmdlet supports the common parameters: Verbose, Debug,

 ErrorAction, ErrorVariable, WarningAction, WarningVariable,

 OutBuffer, PipelineVariable, and OutVariable. For more information, see

 about_CommonParameters ([http://go.microsoft.com/fwlink/?LinkID=113216)](http://go.microsoft.com/fwlink/?LinkID=113216)).

 INPUTS

 Microsoft.ConfigurationManagement.ManagementProvider.IResultObject[]

 OUTPUTS

 System.Object

 ALIASES

 None
```

Usage is pretty easy. Our Application named “7-zip” is locked, so this is our commandline:

`Unlock-CMObject -InputObject $(Get-CMApplication -Name 7-zip)`

Of course the cmdlet won’t give us any feedback, but well, what did I expect? But now we are able to work on that application again.

## Lock objects with Powershell

What can be done can also be undone, or something like that.

`Lock-CMObject -InputObject $(Get-CMApplication -Name 7-zip)`

This command will lock the application, just like before.

Locking and unlocking works for applications, packages, driver packages, operating system images, boot images and task sequences.

Use these cmdlets to get the InputObjects:

```
Get-CMApplication
Get-CMPackage
Get-CMDriverPackage
Get-CMOperatingSystemImage
Get-CMBootImage
Get-CMTaskSequence
```
