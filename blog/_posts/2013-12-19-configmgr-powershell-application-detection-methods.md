---
id: 1505
title: ConfigMgr Powershell Application Detection Methods
date: 2013-12-19T02:20:12+00:00
author: "David O'Brien"
layout: single

permalink: /2013/12/configmgr-powershell-application-detection-methods/
categories:
  - CM12
  - ConfigMgr
  - Configuration Manager
  - PowerShell
  - SCCM
  - System Center
tags:
  - Applications
  - CM12
  - ConfigMgr
  - Configuration Manager
  - Detection Methods
  - Powershell
  - SCCM
  - System Center
---
I am being asked this quite a lot, so I thought I might also write about it a bit.

Already a while back a colleague asked me what needs to be done to make Application model Detection Methods work with Custom Powershell scripts.

![Powershell detection Method SCCM](/media/2013/12/image.png)

I believed it to be really straight forward, but actually in the beginning it was a bit weird.

## Application model Detection Methods

At that time there wasn’t much documentation on that topic around, so we had to test a bit around on how Detection Methods work in general and how they work with custom scripts. Now this is pretty well documented on [TechNet (How to Create Applications in Configuration Manager)](http://technet.microsoft.com/en-us/library/gg682159.aspx#BKMK_Step4) , but here’s a quick recap.

In general, in order for an Application Deployment to work, you would need to have at least one Deployment Type configured for that Application. Based on certain requirements (configurable) the Application decides which Deployment Type needs to be chosen. Now that Deployment Type also needs to have a Detection Method which evaluates if that Application is already installed or not. If it’s the latter then it has to be installed. The easiest way to do a Detection Method is when you’re deploying an MSI and can use the MSI Product Code to detect the installed application. ConfigMgr will even create that all for you. (which is great for automation by the way! see [/2013/07/10/create-new-configmgr-applications-from-script-with-powershell/](/2013/07/10/create-new-configmgr-applications-from-script-with-powershell/))

The above TechNet article shows that you can not only use MSI Product Code, but also loads of other ways, like does a certain file exist and does it also have a specific file size.

![SCCM Detection Method](/media/2013/12/image1.png)

If that is not enough you can check for Registry Keys and if even that doesn’t go far enough you can write your own scripts to detect an installed application, and this is where it gets interesting.

## Powershell, VBScript and JSharp as CM12 Detection Methods

You can chose between three script languages for your Detection Methods –> Powershell, VBScript and JSharp. I’m only really fluent in Powershell, so that’s the one I chose.

I won’t give you a generic script (which doesn’t exist), only what you need to know when writing such Detection Method Scripts, no matter which language you chose.

What’s important with Detection Methods is that they are used to detect if an Application is already **INSTALLED**. That is all it really cares about. What does that mean?

```
if (test-path C:\Apps\Test.html)
   {
        Write-Host "Installed"
   }
else
   {
        Write-Host "Not Installed"
   }
```

This Detection Method will always tell the “Appdiscovery.log” and the ConfigMgr Agent that this Application is already installed.

```
if (test-path C:\Apps\Test.html)
   {
        $true
   }
else
   {
        $false
   }
```

Even this won’t do.

Looking at the TechNet Article from above we see the following table which explains a lot.

<table width="763" border="6" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="113">
      <strong>Script exit code </strong>
    </td>

    <td valign="top" width="166">
      <strong>Data read from STDOUT</strong>
    </td>

    <td valign="top" width="161">
      <strong>Data read from STDERR</strong>
    </td>

    <td valign="top" width="91">
      <strong>Script result</strong>
    </td>

    <td valign="top" width="221">
      <strong>Application detection state </strong>
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
    </td>

    <td valign="top" width="166">
      Empty
    </td>

    <td valign="top" width="161">
      Empty
    </td>

    <td valign="top" width="91">
      Success
    </td>

    <td valign="top" width="221">
      Not installed
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
    </td>

    <td valign="top" width="166">
      Empty
    </td>

    <td valign="top" width="161">
      Not empty
    </td>

    <td valign="top" width="91">
      Failure
    </td>

    <td valign="top" width="221">
      Unknown
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
    </td>

    <td valign="top" width="166">
      Not empty
    </td>

    <td valign="top" width="161">
      Empty
    </td>

    <td valign="top" width="91">
      Success
    </td>

    <td valign="top" width="221">
      Installed
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
    </td>

    <td valign="top" width="166">
      Not empty
    </td>

    <td valign="top" width="161">
      Not empty
    </td>

    <td valign="top" width="91">
      Success
    </td>

    <td valign="top" width="221">
      Installed
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
      Non-zero value
    </td>

    <td valign="top" width="166">
      Empty
    </td>

    <td valign="top" width="161">
      Empty
    </td>

    <td valign="top" width="91">
      Failure
    </td>

    <td valign="top" width="221">
      Unknown
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
      Non-zero value
    </td>

    <td valign="top" width="166">
      Empty
    </td>

    <td valign="top" width="161">
      Not empty
    </td>

    <td valign="top" width="91">
      Failure
    </td>

    <td valign="top" width="221">
      Unknown
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
      Non-zero value
    </td>

    <td valign="top" width="166">
      Not empty
    </td>

    <td valign="top" width="161">
      Empty
    </td>

    <td valign="top" width="91">
      Failure
    </td>

    <td valign="top" width="221">
      Unknown
    </td>
  </tr>

  <tr>
    <td valign="top" width="113">
      Non-zero value
    </td>

    <td valign="top" width="166">
      Not empty
    </td>

    <td valign="top" width="161">
      Not empty
    </td>

    <td valign="top" width="91">
      Failure
    </td>

    <td valign="top" width="221">
      Unknown
    </td>
  </tr>
</table>

&nbsp;

This tells us that instead of one of the above scripts, we need to do this:

```
if (Test-Path C:\Apps\Test.html)
    {
        Write-Host "Installed"
    }
else
    {
    }
```

If the Agent can’t find that file in that Path it won’t write anything back to the Console or STDOUT and the agent knows that this Application hasn’t been installed yet.

In the end it’s really not too complicated using Powershell for your Detection Methods and I actually like using it a lot.


