---
id: 751
title: 'The curse of the second hop &amp; PowerShell &ndash; CredSSP'
date: 2013-02-24T01:33:08+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=751
permalink: /2013/02/the-curse-of-the-second-hop-powershell-credssp/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - CredSSP
  - PowerShell
  - SCCM
  - scripting
  - security
  - Windows
tags:
  - ConfigMgr
  - Configuration Manager
  - Credential Security Provider
  - CredSSP
  - Microsoft
  - Powershell
  - SCCM
---
I recently started migrating my PowerShell scripts for ConfigMgr to Orchestrator (read here: [http://www.david-obrien.net/?p=744](http://www.david-obrien.net/?p=744)) and came across this issue I didn’t quite understand at the beginning.

# Credential Security Support Provider

With Windows XP SP3, and then Vista, Microsoft introduced a new provider for credential handling, the Credential Security Support Provider, or CredSSP.
  
This provider is used to delegate your credentials to remote servers, which is why it was at first used for Terminal Services and RDP 6.1.

More information on this provider is available here:

  * [Description of the Credential Security Support Provider (CredSSP) in Windows XP Service Pack 3](http://support.microsoft.com/kb/951608) (Technet)
  * [Security Support Provider Interface](http://en.wikipedia.org/wiki/Security_Support_Provider_Interface) (Wikipedia)
  * [Enable PowerShell "Second-Hop" Functionality with CredSSP](http://blogs.technet.com/b/heyscriptingguy/archive/2012/11/14/enable-powershell-quot-second-hop-quot-functionality-with-credssp.aspx) (Scripting Guy’s blog!)

## How to enable CredSSP?

Well, first, what happens if you don’t enable CredSSP on your servers and try running PowerShell scripts or my Orchestrator runbooks (which basically execute PS scripts)?

Example: I created a runbook which was executed on a ConfigMgr site server and then tried to access information from a ConfigMgr Distribution Point. This was initialized like this:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$session = New-PSSession -ComputerName cm12.do.local -ConfigurationName Microsoft.PowerShell32
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">Invoke-Command -Session $session -ScriptBlock {...}
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

That session is created under the runbook’s service account. No problem so far.
  
The problem arises when I now try to run a cmdlet which tries to access a different remote server, the second-hop. That query/command will fail. Why? Look at the security log of the last server:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/02/image_thumb5.png" width="276" height="211" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/02/image5.png)

This last hop is done with the ANONYMOUS LOGON. That will in most cases, if not all the time, fail.
  
A successful logon would, in our case, have looked something like this:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/02/image_thumb6.png" width="267" height="157" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/02/image6.png)

How do we get it to work? There are a few ways to get it done, I chose GPO and, to be sure, PS cmdlets.

The GPO that needs to be configured is related to the WinRM Client and I configured it this way:

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" alt="image" src="http://www.david-obrien.net/wp-content/uploads/2013/02/image_thumb7.png" width="265" height="78" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/02/image7.png)

More info on that can be found in the linked Technet article above.

Once I ran the following command on my Orchestrator runbook server, I enabled the server to use CredSSP authentication and act as the client role.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">Enable-WSManCredSSP -Role Client -DelegateComputer *.do.local -force
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I then need to run this command now on the ConfigMgr server to enable CredSSP and act as the server role.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">Enable-WSManCredSSP -Role Server -force
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

In order to actually use CredSSP authentication and be able to use it inside the PS Session, I have to open the session with a few extra parameters:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$username = <span style="color: #008000;">'do\adobrien'
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$password = <span style="color: #008000;">'Password'
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">$cred = New-Object System.Management.Automation.PSCredential -ArgumentList @($username,(ConvertTo-SecureString -String $password -AsPlainText -Force))
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">New-PSSession -ComputerName cm12.do.local -ConfigurationName Microsoft.PowerShell32 -Authentication Credssp -Credential $cred
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

I’m basically converting the user’s credentials into a credential object which can be used on the commandline to, for example, open a new PSSession. Then I’m telling the “New-PSSession” to use CredSSP authentication and the credential object.

When I now try to access a third server (second hop) from within my PSSession all is fine and the authentication happens under the user I provided. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


