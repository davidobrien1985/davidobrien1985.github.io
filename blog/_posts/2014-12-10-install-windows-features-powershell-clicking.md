---
id: 2844
title: 'Install Windows features through PowerShell - by clicking'
date: 2014-12-10T14:56:23+00:00

layout: single

permalink: /2014/12/install-windows-features-powershell-clicking/
categories:
  - automation
  - PowerShell
  - Windows
tags:
  - automation
  - Powershell
  - Script
---
# Rebuilding my home lab with PowerShell

I am currently rebuilding my home lab (again! This time properly, I promise.) and my goal is to use as much PowerShell as possible.

I am building everything on a Dell XPS 15 laptop with a 1TB Samsung SSD and 16GB RAM. Enough for a mid-size mobile lab. The host runs Windows Server 2012 R2, what else? On top of that I have also installed the [Windows Management Framework 5 November Preview](http://blogs.msdn.com/b/powershell/archive/2014/11/18/windows-management-framework-5-0-preview-november-2014-is-now-available.aspx) in order to use all the latest and greatest features of PowerShell, for example Desired State Configuration in its latest version.

Of course, I have also downloaded the [DSC Resource Kit](http://blogs.msdn.com/b/powershell/archive/2014/10/28/powershell-dsc-reskit-wave-8-now-with-100-resources.aspx) in its latest Wave, number 8.

I started out using DSC to deploy my DNS Server and Active Directory Domain Services, after that I thought to myself, “Which Roles and Features do I need?”. That’s the moment I usually go and run the following PowerShell command on my Server OS:

`Get-WindowsFeature | Out-GridView`

On Windows Client you’d have to run:

`Get-WindowsOptionalFeature -Online | Out-GridView`

## Out-GridView

Out-GriedView (<http://technet.microsoft.com/en-us/library/hh849920.aspx>) is a very handy cmdlet first introduced in PowerShell v2 already. It will take an input object and display it in an external grid view.

Did you know that this cmdlet also has an –OutputMode parameter?

```
-OutputMode<OutputModeOption>

Send items from the interactive window down the pipeline as input to other commands. By default, this cmdlet does not generate any output. To send items from the interactive window down the pipeline, click to select the items and then click OK.

The values of this parameter determine how many items you can send down the pipeline.

— None: No items. This is the default value.

— Single: Zero items or one item. Use this value when the next command can take only one input object.

— Multiple: Zero, one, or many items. Use this value when the next command can take multiple input objects. This value is equivalent to the Passthru parameter.

This parameter is introduced in Windows PowerShell 3.0.
```

What does that mean? Well, we can use the Windows which opens to select items and use them as InputObjects on the cmdline. Cool, right?

# Click your way through PowerShell

This is nothing you would run in a script, but definitely handy to know. So instead of writing a long DSC configuration, which I could, but that would take me time and I would have to remember all the FeatureNames, or writing an even longer script, I just run this:

```
Install-WindowsFeature -Name @((Get-WindowsFeature).Where({$PSItem.InstallState –ne ‘Installed’}) | Out-GridView -OutputMode Multiple) -IncludeManagementTools –Verbose
```

![image](/media/2014/12/PS.png)

This command will open up a window presenting you with all the available Features and Roles on that system, which not have been installed yet.

The trick here is that Install-WindowsFeature accepts an array of “Name”, which will have all the Role and Feature names in it that need to be installed.

This way I can easily go and install all the Windows Roles and Features I like in just one go.

Have fun!


