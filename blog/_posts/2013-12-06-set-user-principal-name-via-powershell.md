---
id: 1495
title: Set User Principal Name via Powershell
date: 2013-12-06T22:08:01+00:00
author: "David O'Brien"
layout: post
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

<div id="codeSnippetWrapper" style="margin: 20px 0px 10px; padding: 4px; border: 1px solid silver; width: 97.5%; text-align: left; line-height: 12pt; overflow: auto; font-family: 'Courier New', courier, monospace; font-size: 8pt; cursor: text; direction: ltr; max-height: 200px; background-color: #f4f4f4;">
  <div id="codeSnippet" style="padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">
    <pre style="margin: 0em; padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: white;"><span style="color: #0000ff;">Get</span>-ADUser -Filter * -SearchBase 'ou=nonAdmins,ou=User,ou=Administration,dc=<span style="color: #0000ff;">do</span>,dc=local' -Properties userPrincipalName | foreach { <span style="color: #0000ff;">Set</span>-ADUser $_ -UserPrincipalName <span style="color: #006080;">"$($_.samaccountname)@david.test"</span>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

You will need to change the –SearchBase property to reflect the path to that OU in your Active Directory where the users are for whom you want to change the UPN. You also need to change <“@david.test>” to the UPN you want to use.

This command needs to run on a server where the Active Directory module is installed. You might need to run

<div id="codeSnippetWrapper" style="margin: 20px 0px 10px; padding: 4px; border: 1px solid silver; width: 97.5%; text-align: left; line-height: 12pt; overflow: auto; font-family: 'Courier New', courier, monospace; font-size: 8pt; cursor: text; direction: ltr; max-height: 200px; background-color: #f4f4f4;">
  <div id="codeSnippet" style="padding: 0px; width: 100%; text-align: left; color: black; line-height: 12pt; overflow: visible; font-family: 'Courier New', courier, monospace; font-size: 8pt; direction: ltr; background-color: #f4f4f4;">
    <p>
      Import-<span style="color: #0000ff;">Module</span> ActiveDirectory
    </p>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

first. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

