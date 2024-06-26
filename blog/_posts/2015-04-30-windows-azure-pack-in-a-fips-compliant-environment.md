---
id: 3039
title: Windows Azure Pack in a FIPS compliant environment
date: 2015-04-30T23:46:18+00:00

layout: single

permalink: /2015/04/windows-azure-pack-in-a-fips-compliant-environment/
categories:
  - Azure
  - WAP
tags:
  - Azure
  - FIPS
  - GPO
  - IIS
  - WAP
  - WAPack
  - Windows Azure Pack
---
I am just about to deploy a Windows Azure Pack (WAP) express installation in an environment where they have to turn on FIPS compliancy.

There are companies that turn everything in GPOs on that have "security" in the name or description field, but actually don't really need it, and then there are companies that actually need it.

# Windows Azure Pack configuration fails

Usually installation and configuration of a Windows Azure Pack installation is really easy and straight forward, especially when using the Express install, which puts every feature on one server (only for really small / limited PoCs!). I've done that multiple times already, but this time the configuration failed.

![image](/media/2015/04/1430397278_full.png)

The eventlog (Application and Services log for Windows Azure Pack) will tell you the exact reason for that:

```
Get-WinEvent -LogName Microsoft-WindowsAzurePack-MgmtSvc-ConfigSite/Operational -MaxEvents 1 | fl *
```

```
\##### Application_Error: Exception=System.Web.HttpException (0x80004005): Failed to configure databases and services: Exception has been thrown by the target of an invocation. -> System.Management.Automation.CmdletInvocationException: Exception has been thrown by the target of an invocation. -> System.Reflection.TargetInvocationException: Exception has been thrown by the target of an invocation. -> System.InvalidOperationException: This implementation is not part of the Windows Platform FIPS validated cryptographic algorithms.
at System.Security.Cryptography.SHA256Managed..ctor()
```

The reason for that can quite possibly be a GPO that forces algorithms to be FIPS compliant.

This policy is configured in "Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies/Security Options\System Cryptography\System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing" and set to enabled.

# Workaround for 500 Internal Server Error and FIPS

Fellow [MVP Kevin Greene](http://kevingreeneitblog.blogspot.com.au) made me aware of a workaround he (and a lot of other people) used in such scenarios. However, he, and as far as I can tell, nobody else had to use it for Windows Azure Pack so far.

Add `<enforceFIPSPolicy enabled="false" />` to the `web.config` file of the MgmtSvc-ConfigSite application (something like C:\inetpub\MgmtSvc-ConfigSite) under the <runtime> block:

```
<runtime>
<enforceFIPSPolicy enabled="false"/>
<assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1&#8243;>
<dependentAssembly>
<assemblyIdentity name="System.Web.Mvc" publicKeyToken="31bf3856ad364e35&#8243;/>
<bindingRedirect oldVersion="0.0.0.0-4.0.0.1&#8243; newVersion="4.0.0.1&#8243;/>
</dependentAssembly>
</assemblyBinding>
</runtime>
```

However, this didn't work for me. I am still troubleshooting and awaiting some more feedback from the community (and Microsoft hopefully) to get this working.

The only way I got past this point was to temporarily disable that GPO for that server (or move it into a different OU), run the WAP configuration and then re-enable the GPO.

So far I didn't encounter any problems re-enabling the GPO on the WAP server, however, I am only using a limited number of WAP features (mainly Automation).

## Community Feedback

Have you come across this issue? Were you able to fix this? Add your comments to the article or contact me on [Twitter](http://www.twitter.com/david_obrien)



