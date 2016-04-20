---
id: 1382
title: How to rename machine during ConfigMgr OSD
date: 2013-10-07T13:05:58+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1382
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

[<img class="img-responsive aligncenter wp-image-1376 size-thumbnail" src="/media/2013/10/image3-150x150.png" alt="image.png" width="150" height="150" />](/media/2013/10/image3.png)[<img class="img-responsive aligncenter wp-image-1378 size-thumbnail" src="/media/2013/10/image4-150x150.png" alt="image.png" width="150" height="150" />](/media/2013/10/image4.png)

## How to Query SQL Database from WinPE

To easily query that database I added Powershell to my WinPE image. There are examples of how to query a database via VBS, but hey, I’m a Powershell guy, so I’m sticking to it.

WinPE is a Workgroup client, thus makes it a bit more complicated authenticating against our database. We can’t impersonate our SQL connection with a domain user and certainly cannot use the system account. We therefore need to use SQL authentication, which I personally don’t like, but this is the only way I found to get this to work.

Do you know a different way of authenticating against this database from within WinPE? If so, please share!!!

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlServer = <span style="color: #006080;">"SQL01.DO.LOCAL"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SQLInstance = <span style="color: #006080;">"CM12"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$DBName = <span style="color: #006080;">"DB_ComputerName"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$DBUserName = <span style="color: #006080;">"SQLUser"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$DBPassword = <span style="color: #006080;">"SQLPassword"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$MACAddress = <span style="color: #0000ff;">Get</span>-WmiObject -<span style="color: #0000ff;">Class</span> <span style="color: #006080;">"Win32_NetworkAdapter"</span> | where {$_.macaddress -ne $null} | <span style="color: #0000ff;">select</span> macaddress</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlConnection = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlConnection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlConnection.ConnectionString = <span style="color: #006080;">"Server = $SqlServer\$SQLInstance; Database = $DBName; User ID = $DBUserName; Password = $DBPassword"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlCmd = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlCommand</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlCmd.CommandText = <span style="color: #006080;">"SELECT * FROM NameMapping WHERE MACAddress = '$($MACAddress.macaddress)'"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlCmd.Connection = $SqlConnection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlAdapter = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlDataAdapter</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlAdapter.SelectCommand = $SqlCmd</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$DataSet = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.DataSet</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlAdapter.Fill($DataSet)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlConnection.Close()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$OSDComputerName = ($DataSet.Tables[0] | <span style="color: #0000ff;">select</span> NewComputerName).NewComputerName</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

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

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$var = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> -ComObject Microsoft.SMS.TSEnvironment</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$var.Value(<span style="color: #006080;">"OSDComputerName"</span>) = <span style="color: #006080;">"$OSDComputerName"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I already used this in another script of mine here to set the name of a new image during Build & Capture: [http://www.david-obrien.net/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/](http://www.david-obrien.net/2012/10/13/easy-versioning-of-imagesconfiguration-manager-and-powershell/)

This powershell script has to run quite early, before the OS gets installed.

[<img class="img-responsive aligncenter size-thumbnail wp-image-1380" src="/media/2013/10/image5-150x150.png" alt="image.png" width="150" height="150" />](/media/2013/10/image5.png)

## Alternative: How to rename Computer after installation

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlServer = <span style="color: #006080;">"SQL01.DO.LOCAL"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SQLInstance = <span style="color: #006080;">"CM12"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$DBName = <span style="color: #006080;">"DB_ComputerName"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$MACAddress = <span style="color: #0000ff;">Get</span>-WmiObject -<span style="color: #0000ff;">Class</span> <span style="color: #006080;">"Win32_NetworkAdapter"</span> | where {$_.macaddress -ne $null} | <span style="color: #0000ff;">select</span> macaddress</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlConnection = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlConnection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlConnection.ConnectionString = <span style="color: #006080;">"Server = $SqlServer\$SQLInstance; Database = $DBName;Trusted_Connection = true"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlCmd = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlCommand</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlCmd.CommandText = <span style="color: #006080;">"SELECT * FROM NameMapping WHERE MACAddress = '$($MACAddress.macaddress)'"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlCmd.Connection = $SqlConnection</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlAdapter = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.SqlClient.SqlDataAdapter</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlAdapter.SelectCommand = $SqlCmd</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$DataSet = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Data.DataSet</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$SqlAdapter.Fill($DataSet)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SqlConnection.Close()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$OSDComputerName = ($DataSet.Tables[0] | <span style="color: #0000ff;">select</span> NewComputerName).NewComputerName</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">$SecurePassword = ConvertTo-SecureString <span style="color: #006080;">"PlainTextPassword"</span> -AsPlainText -Force</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">$creds = <span style="color: #0000ff;">New</span>-<span style="color: #0000ff;">Object</span> System.Management.Automation.PSCredential (<span style="color: #006080;">"UserWithRenamePermissions"</span>, $SecurePassword)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;">Rename-Computer -ComputerName localhost -NewName $OSDComputerName -DomainCredential $creds -Force</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Here I assume that you did not want to use SQL authentication and did not find a way to use Windows authentication to access the database during WinPE.

This Powershell script I would run after the CM12 client got installed, but still during the Task Sequence. Here we can run a command line in another user’s context. This user should have read permissions to the database. Just like before, we query the database and set the Powershell variable $OSDComputerName to the value in our database.
  
We can now use the Powershell cmdlet “Rename-Computer” ([http://technet.microsoft.com/en-us/library/hh849792.aspx](http://technet.microsoft.com/en-us/library/hh849792.aspx)) to rename the localhost to its new name.
  
In order for this to work we need a domain user with permission to do so and create a new PSCredential object out of this user. See lines 2 and 3 from the bottom.
  
You need to reboot after this step in order to rename the computer and just be advised, the name change does take a while to appear in the CM12 database, depending on your discovery intervals.

### Wrap-Up

I know that this could have all been quite a lot easier with UDI or MDT database integration, but this was just not possible (or am I missing something?).

Looking forward to your comments! 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

