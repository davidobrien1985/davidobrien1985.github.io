---
id: 2979
title: 'Windows PowerShell DSC - classes - resource basics (part 2)'
date: 2015-02-23T08:42:16+00:00

layout: single

permalink: /2015/02/windows-powershell-dsc-classes-resource-basics-part-2/
categories:
  - automation
  - Desired State Configuration
  - DSC
  - Microsoft
  - PowerShell
tags:
  - classes
  - Desired State Configuration
  - Powershell
  - PSDSC
  - WMF5
---
In part one of this miniseries I explained some principals around using the new class keyword in Windows PowerShell DSC resource modules. If you haven't read that article yet, go find it here:[/2015/02/windows-powershell-dsc-classes-introduction-part-1/](/2015/02/windows-powershell-dsc-classes-introduction-part-1/)
This part 2 will concentrate on the **enum** keyword and the three main functions in each resource class.

# Enum -erate input


One of the most important things in every script (no matter what language) is error handling. PowerShell and DSC is no exception here. For me, part of error handling is also to validate input  users can provide your script or application with.
**Enum** is used to implement constant values inside of a variable. A limitation that is currently still present is that you need to implement the enum in the script where you're using it. This is apparently different in the .Net Framework, where they are always available as soon as the class library is loaded.
In a cmdlet based DSC resource we would do something like this:

```
param (
[ValidateSet('Present', 'Absent')]
[string]$Ensure = 'Present'
)
```

Now with the enum keyword that's much easier:

```
enum Ensure {
Present
Absent
}
```

You can have multiple enum in one resource module.

```
enum HouseType {
Tent
House
}

enum HouseSize {
large
small
medium
}
```

The delimiter between values is 'newline', so no comma, semicolon or other fancy stuff.
You can now go and check with PowerShell if a user's input is valid by executing the following:

```
enum HouseSize {
large
small
medium
}
[enum]::IsDefined(([HouseSize]),'tiny')
```

In a class based DSC resource this would look something like this:

```
enum Ensure
{
   Absent
   Present
}

[DscResource()]
class Test
{
   [DscResourceKey()]
   [string] $Test
   [DscResourceMandatory()]
   [Ensure] $Ensure

   [void] Set()

   {
      if($this.Ensure -eq [Ensure]::Present)
      {
        Try
        {
#### and so on...
```

Since the November update of WMF 5 there is a change in how you use variables in the scope of a class. In order to use a variable in one of the class's methods, you need to reference it with the $this scope variable. The $this scope doesn't only apply to the enum keyword, but to all variables used inside a class based DSC resource as well, and, for that matter, all classes used in PowerShell.

For more information on $this, execute _**get-help about\_Automatic\_Variables**_ in your PowerShell.

**As a side note**, make sure you read all the release notes that come with the WMF 5 previews. This is a big change in how to handle variables and a lot of people (including myself) missed that and wondered why their classes didn't work anymore.

# Get, Set, Test your DSC resource

We are talking about DSC and even though we're now talking about class based resources, we do have to remember the three minimum functions our DSC resources must implement as well. We used to call them **Get-TargetResource**, **Set-TargetResource** and **Test-TargetResource**. Not anymore, they are now just **Get()**, **Set()** and **Test()**. Looks a lot like a method, right?
These three methods still do exactly the same as they used to and they also still need to have the following output:

* Get()
  * returns an instance of this class with the updated key properties
* Set()
  * void
* Test()
  * boolean ($true or $false)

The base principle still applies here. All three methods need to be implemented. There are a couple of changes now though. Well, of course there are.

## Parameter implementation

In a cmdlet based resource the three functions needed to accept all parameters that were implemented through the schema.mof file. This sometimes led to very long param () statements in the beginning of each function.
There is no schema.mof file anymore, so how are we going to do it now?


![Windows PowerShell DSC resource class](/media/2015/02/1424380983_full.png)>

We can see that now, instead of defining all the variables inside of each function's scope, we define the variables in the class' scope. This looks a lot tidier and, at least to me, makes much more sense.

You'll see that I used a couple of properties in this param block that might be unfamiliar at first.

* [DscResource()], tells PowerShell that the following class is a DSC resource
* [DscProperty(Key)] , a DSC resource requires at least one Key value. This uniquely identifies the resource instance. It also means that this parameter is required. If it’s not set, DSC will not execute.
* [DscProperty(NotConfigurable)], this is a “read only” parameter which will be set by the Get() method.
* [DscProperty(Mandatory)] , means this parameter is required. Without this the DSC resource will not be executed.

As an example for a class based resource I have migrated my cmdlet based resource to install a ConfigMgr primary site to a class based one. As you can see, inside of the class I can write regular PowerShell. In this case this is the Get() method of that resource.

```
[ConfigMgrClass] Get() {
    $Configuration = [hashtable]::new()
    $Configuration.Add('SiteCode', $this.SiteCode)
    try {
        $CMSite = Get-CimInstance -ClassName SMS_Site -Namespace root\SMS\Site_$($this.SiteCode) -ErrorAction Stop
        if ($CMSite) {
            $Configuration.Add('Ensure','Present')
        }
        else {
            $Configuration.Add('Ensure','Absent')
        }
    }
    catch {
        $exception = $_
        Write-Verbose 'Error occurred'
        while ($exception.InnerException -ne $null)
        {
            $exception = $exception.InnerException
            Write-Verbose $exception.message
        }
    }
    return $Configuration
}
```

As already mentioned above, you can see that I have to use _**$this.SiteCode**_ in order to use its value.

Save the file as **_[classname].psm1_** in a folder in the **$PSModulePath** which is called [classname].

# New-ModuleManifest

From here on there's not a really big difference between working with a cmdlet or class based resource.

Use the New-ModuleManifest cmdlet to create the psd1 file.

```
New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\ConfigMgrClass\ConfigMgrclass.psd1' -DscResourcesToExport 'ConfigMgrClass' -PowerShellVersion 5.0 -Description 'Class based DSC resource to install roles and features of ConfigMgr' -ModuleVersion '1.0.0.0' -Guid $([guid]::NewGuid()) -
```

In my previous article ([/2015/02/windows-powershell-dsc-classes-introduction-part-1/](/2015/02/windows-powershell-dsc-classes-introduction-part-1/) ) I mentioned that Get-DscResource is unable to find class based resource modules. Guess what?! Microsoft changed that with the current February release of WMF5.

In order to find your resource module, though, you need to add a new parameter to your Module Manifest, which is called **DscResourcesToExport**. This will make the class based resource discoverable to Get-DscResource.

In the next part I will walk through my converted ConfigMgr resource and show you a couple of more classes I've implemented into this resource.

Until then, enjoy automating!


