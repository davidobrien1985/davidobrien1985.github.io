---
id: 1495
title: Set User Principal Name via Powershell
date: 2013-12-06T22:08:01+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1495
permalink: /2013/12/set-user-principal-name-via-powershell/
categories:
  - Active Directory
  - ConfigMgr 2012 R2
  - Configuration Manager
  - Intune
  - PowerShell
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - Intune
  - Powershell
  - SCCM
  - Windows Intune
---
A while ago I implemented Windows Intune into my ConfigMgr 2012 R2 lab and during that process I also had to set a User Principal Name (UPN) for my users’ Active Directory Account.

In case you need to do that for more than one user at a time, then you might find this little Powershell line helpful:

```
Get-ADUser -Filter * -SearchBase 'ou=nonAdmins,ou=User,ou=Administration,dc=do,dc=local' -Properties userPrincipalName | foreach { Set-ADUser $_ -UserPrincipalName "$($_.samaccountname)@david.test"}
```

You will need to change the –SearchBase property to reflect the path to that OU in your Active Directory where the users are for whom you want to change the UPN. You also need to change <“@david.test>” to the UPN you want to use.

This command needs to run on a server where the Active Directory module is installed. You might need to run

`Import-Module ActiveDirectory`

first.