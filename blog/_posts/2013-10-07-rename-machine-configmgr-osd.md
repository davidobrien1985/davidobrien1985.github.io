---
id: 1382
title: How to rename machine during ConfigMgr OSD
date: 2013-10-07T13:05:58+00:00
author: "David O'Brien"
layout: single

permalink: /2013/10/rename-machine-configmgr-osd/
categories:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
tags:
  - CM12
  - ConfigMgr
  - Powershell
  - SCCM
  - SQL
  - System Center
  - WinPE
---
I just came across a scenario where I had to do a migration from Windows XP to Windows 7. The “old” environment had no naming convention for its clients and we had to change that.

We thought about using LiteTouch (MDT) with UDI to set the new computername, but didn’t go for that because we did not want users to to anything during the task sequence. Also the users don’t know the new computername. Using the MDT database could’ve been possible, but the new database is also supposed to be used by other applications as an asset management database.

That’s why we set up a custom SQL database which kind of looks like this:

![image](/media/2013/10/image3.png)

![image](/media/2013/10/image4.png)

# How to Query SQL Database from WinPE

To easily query that database I added Powershell to my WinPE image. There are examples of how to query a database via VBS, but hey, I’m a Powershell guy, so I’m sticking to it.

WinPE is a Workgroup client, thus makes it a bit more complicated authenticating against our database. We can’t impersonate our SQL connection with a domain user and certainly cannot use the system account. We therefore need to use SQL authentication, which I personally don’t like, but this is the only way I found to get this to work.

Do you know a different way of authenticating against this database from within WinPE? If so, please share!!!

```
$SqlServer = "SQL01.DO.LOCAL"

$SQLInstance = "CM12"

$DBName = "DB_ComputerName"

$DBUserName = "SQLUser"

$DBPassword = "SQLPassword"

$MACAddress = Get-WmiObject -Class "Win32_NetworkAdapter" | where {$_.macaddress -ne $null} | select macaddress

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $SqlServer\$SQLInstance; Database = $DBName; User ID = $DBUserName; Password = $DBPassword"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = "SELECT * FROM NameMapping WHERE MACAddress = '$($MACAddress.macaddress)'"

$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter

$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet

$SqlAdapter.Fill($DataSet)

$SqlConnection.Close()

$OSDComputerName = ($DataSet.Tables[0] | select NewComputerName).NewComputerName
```

If you take a look at my database table you’ll see that the primary identifier for my machines is the MAC Address, so I need to get that MAC address of the device that script is running on. I would also need to filter out all the wireless NICs via my script, as the database will only contain the wired NICs. That filter here is ok for my Lab.

The last line of the script will set the Powershell variable $OSDComputerName to the value from the database table column “NewComputerName”.

## How to set Computername during Task Sequence

Nice, we now have the new name inside a variable. What now?

Devices during an install or refresh scenario will get the name of the data record inside the CM12 database, which matches them.

So if you’re using PXE boot you probably pre-imported the device information into your site with the MAC address and name. During the Task Sequence the client will fetch that name and use that during installation.

If you’re using “Unknown Computer support” there is no matching entry in the database and by default your computername will be set to something similar to MININT-xxx.

You can however set a new variable on your “All Unknown Computers” collection:

* Name: OSDComputerName
* Value: <empty>

This will cause the available, non-required Task Sequence to ask you for a computername and use that for installation.

You can also use MDT integration or lots of other nice ways available on the internet to get the name set. They all come around to set the built-in variable **OSDComputerName** to the new name.

I’m here doing this via script, because I wanted total zero-touch.

```
$var = New-Object -ComObject Microsoft.SMS.TSEnvironment
$var.Value("OSDComputerName") = "$OSDComputerName"
```

I already used this in another script of mine here to set the name of a new image during Build & Capture: [/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/](/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/)

This powershell script has to run quite early, before the OS gets installed.

![image](/media/2013/10/image5.png)

## Alternative: How to rename Computer after installation

```
$SqlServer = "SQL01.DO.LOCAL"

$SQLInstance = "CM12"

$DBName = "DB_ComputerName"

$MACAddress = Get-WmiObject -Class "Win32_NetworkAdapter" | where {$_.macaddress -ne $null} | select macaddress

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $SqlServer\$SQLInstance; Database = $DBName;Trusted_Connection = true"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = "SELECT * FROM NameMapping WHERE MACAddress = '$($MACAddress.macaddress)'"

$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter

$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet

$SqlAdapter.Fill($DataSet)

$SqlConnection.Close()

$OSDComputerName = ($DataSet.Tables[0] | select NewComputerName).NewComputerName

$SecurePassword = ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force

$creds = New-Object System.Management.Automation.PSCredential ("UserWithRenamePermissions", $SecurePassword)

Rename-Computer -ComputerName localhost -NewName $OSDComputerName -DomainCredential $creds -Force
```

Here I assume that you did not want to use SQL authentication and did not find a way to use Windows authentication to access the database during WinPE.

This Powershell script I would run after the CM12 client got installed, but still during the Task Sequence. Here we can run a command line in another user’s context. This user should have read permissions to the database. Just like before, we query the database and set the Powershell variable $OSDComputerName to the value in our database.

We can now use the Powershell cmdlet “Rename-Computer” ([http://technet.microsoft.com/en-us/library/hh849792.aspx](http://technet.microsoft.com/en-us/library/hh849792.aspx)) to rename the localhost to its new name.

In order for this to work we need a domain user with permission to do so and create a new PSCredential object out of this user. See lines 2 and 3 from the bottom.

You need to reboot after this step in order to rename the computer and just be advised, the name change does take a while to appear in the CM12 database, depending on your discovery intervals.

### Wrap-Up

I know that this could have all been quite a lot easier with UDI or MDT database integration, but this was just not possible (or am I missing something?).

Looking forward to your comments!


