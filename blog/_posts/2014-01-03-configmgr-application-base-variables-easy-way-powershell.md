---
id: 1537
title: 'ConfigMgr - Application Base variables the easy way with Powershell'
date: 2014-01-03T23:28:00+00:00

layout: single

permalink: /2014/01/configmgr-application-base-variables-easy-way-powershell/
categories:
  - ConfigMgr 2012
  - Configuration Manager
  - MDT
  - PowerShell
  - SCCM
  - System Center
tags:
  - automation
  - ConfigMgr
  - MDT
  - Microsoft Deployment Toolkit
  - Powershell
  - SCCM
  - scripting
---
This article I planned on writing for some time now (as a lot of others) but didn’t find the time yet. The topic itself isn’t new, it’s the solution that’s cool (although itself also not too new).

# Install Applications according to dynamic variable list {.}

There is more than one way of how you can install applications (and packages) during a Task Sequence and each of them has its pros and cons.

There is the “Install Application” step which lets you chose the applications you want to have installed:

![image](/media/2015/01/1422405870_full.png)

This is really easy, as long as you don’t want to install more than nine (9) applications in one step.

![image](/media/2015/01/1422405911_full.png)

The tenth application you want to install needs to be put into a second “Install Application” step.

![image](/media/2015/01/1422405952_full.png)

Not too handy I would say.

The alternative?

Use a dynamic list to define which applications need to be installed. This concept is far from new, you might have already seen it being used with Packages in CM07. Here is a TechNet description of it: [http://technet.microsoft.com/en-us/library/hh846237.aspx#BKMK_InstallApplication](http://technet.microsoft.com/en-us/library/hh846237.aspx#BKMK_InstallApplication)

![image](/media/2015/01/1422405995_full.png)

I here now told the Task Sequence to install all Applications that are members of the dynamic variable list named “BasisVariable”. You can pick any name you like here.

In order for this to work now I need to deploy that Task Sequence to a collection and build that dynamic list. This is done via Collection variables.

If you don’t know how to work with Collection Variables, have a look at some previous articles of mine on that topic: [How do Variables in ConfigMgr work? Part 1](/2013/01/12/how-do-variables-in-configuration-manager-2012-work-part-1/) , [Part 2](/2013/01/13/how-do-variables-in-configuration-manager-2012-work-part-2/), [Part 3](/2013/01/15/how-do-variables-in-configuration-manager-2012-work-part-3/)

My collection now looks like this:

![image](/media/2015/01/1422406032_full.png)

I could continue this list up to 99 as long as I don’t break the count – and that’s the tricky bit. The list might be good enough for some time, but what if you have to remove PDFCreator from that deployment?

PDFCreator is the value of the variable “BasisVariable03” and if you go ahead and just delete that variable then nothing else after “GoogleChrome” or “BasisVariable02” would be installed, regardless of how many variables would follow. All because the count is interrupted.

Then you say, well I just go and edit the variable names. Not possible 😉 You can’t edit the names of existing variables! Why? Don’t know. Stupid, right?

Only way to fix that is to delete ALL VARIABLES and rebuild the count from scratch. If you hate somebody really much, then give him or her that task 😉

So, what now?

## ZTICoalesce.wsf from MDT {.}

Microsoft is aware of this problem. In fact, they already gave you a script to workaround this problem. The Microsoft Deployment Toolkit (MDT) offers you a script called [ZTICoalesce.wsf](http://systemscenter.ru/mdt2012.en/zticoalescewsf.htm) which takes the name of the Dynamic Variable List and repairs any gaps in the count.

That script is written in VBScript and I think VBScript is legacy and I’m really, I mean really, not good at it. That’s why I wanted to rebuild that whole “repair my dynamic variable list” into Powershell.

## Correct Dynamic Variable List via Powershell {.}

I wrote a script called Correct-BaseVars.ps1 which will accept two arguments on the commandline.

```
Argument 1: $NameOfBaseVariable
Argument 2: $LengthSuffix
```

The second argument should, for now (maybe forever) be 2. That’s because if you want to use a dynamic variable list with Applications, then you need to use a suffix with the length of 2. For Packages, which I ignored, that suffix has a length of 3. For the time being it’s always 2.

![image](/media/2015/01/1422406070_full.png)

I copied my script into my MDT Package in the Scripts folder, that way it will always be copied down to the client and I can call it via the %ScriptRoot% variable. If you are not using MDT (why not?), you can still call that script from any other package.

The script will also write a Logfile to the CCM Client Log path called CorrectBaseVars.Log

If anything goes wrong during install, have a look here if the variable screwed up.

Here’s an example of the Log:

![image](/media/2015/01/1422406104_full.png)

### Issues with the script

I didn’t find a way to delete the Base Variables from the client’s WMI namespace. It’s no problem at all to add new variables, but how do I delete them?

In my example the list will end up with orphaned entries at the end of the list. These shouldn’t cause any problems or multiple content download as each application will check, because that’s the way they work, if it needs to be installed (Detection Methods). In this case, if there is more than one entry for an application, the second entry won’t fire off.

Anyway, it feels nicer if one could delete the entry entirely. Any ideas?

Download the script here: [correct-BaseVars](/media/2014/01/correct-BaseVars.zip)

Here’s the script:

```
<#
        Function: This script will fix any issues with gaps in a dynamic variable list used to install ConfigMgr / SCCM applications.
        Usage: .\correct-BaseVars.ps1 $NameOfBaseVariable $LengthSuffix
        $LengthSuffix should usually be 2 if you use Applications

        
        Date: 02.01.2014
#>

if ($args.Count -eq 1)
{
    $BaseVariableName = $args[0]
}
elseif ($args.Count -eq 2)
{
    $BaseVariableName = $args[0]
    $LengthSuffix = $args[1]
}
Function Write-Message
{
     param
     (
         [parameter(Mandatory=$true)]
         [ValidateSet('Info', 'Warning', 'Error', 'Verbose')]
         [string]
         $Severity,
         [parameter(Mandatory=$true)]
         [string]
         $Message
     )

    if((Test-Path -Path  $LogFile))
    {
        Add-Content -Path "$($LogFile)" -Value "$(([System.DateTime]::Now).ToString()) $Severity - $Message"
    }
    else
    {
        New-Item -Path $LogFile -ItemType File
    }
    Switch ($Severity)
    {
        'Info'        {$FColor='gray'}
        'Warning'    {$FColor='yellow'}
        'Error'        {$FColor='red'}
        'Verbose'    {$FColor='green'}
        Default        {$FColor='gray'}
    }
    Write-Output "$(([System.DateTime]::Now).ToString()) $Severity - $Message" -fore $FColor
}

$BaseVariableList = @()
#$BaseVariableName = "BasisVariable"
#$LengthSuffix = 2

$objSMSTS = New-Object -ComObject Microsoft.SMS.TSEnvironment

$SMSTSVars = $objSMSTS.GetVariables()
$SMSTSLogPath = $objSMSTS.Value('_SMSTSLogPath')

if (Test-Path $SMSTSLogPath)
{
    $LogFile = $(Join-Path $SMSTSLogPath CorrectBaseVars.log)
}
#Writing the Variables to Logfile
Write-Message -Severity Info -Message 'This is the Dynamic Variable List BEFORE rebuilding it.'

foreach ($Var in $objSMSTS.GetVariables())
{
    if ( $Var.ToUpper().Substring(0,$var.Length-$LengthSuffix) -eq $BaseVariableName)
    {
        Write-Message -Severity Info -Message "$($Var) = $($objSMSTS.Value($Var))"
        $BaseVariableList += @{$Var=$objSMSTS.Value($Var)}
    }
}
$objects = @()
$fixed = @()
$objects = $BaseVariableList
[int]$x = 1
# Writing the variables to Logfile after being reordered
Write-Message -Severity Info -Message '------------------------------------------------------'
Write-Message -Severity Info -Message ''
Write-Message -Severity Info -Message 'This is the Dynamic Variable List AFTER rebuilding it.'

foreach ($i in $objects)
{
    $Name = "$($BaseVariableName){0:00}" -f $x
    $Value = "$($i.Values)"
    $fixed += @{$Name=$Value}
    Write-Message -Severity Info -Message "$($Name) = $($Value)"

    $x++
    $Name = ''
    $Value = ''
}

$BaseVariableListFixed = @()
$BaseVariableListFixed += $fixed

foreach ($BaseVariable in $BaseVariableListFixed)
{
    $objSMSTS.Value("$($BaseVariable.Keys)") = "$($BaseVariable.Values)"
}
 ```


