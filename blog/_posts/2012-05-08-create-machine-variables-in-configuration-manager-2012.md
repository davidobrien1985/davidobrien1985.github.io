---
id: 665
title: Create Machine variables in Configuration Manager 2012
date: 2012-05-08T12:25:00+00:00

layout: single

permalink: /2012/05/create-machine-variables-in-configuration-manager-2012/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - SCCM
  - System Center Configuration Manager
tags:
  - ConfigMgr
  - Configuration Manager
  - SCCM
  - variables
---
I scripted quite a lot these last few days/weeks and needed to use, as a good scripter like me would (\*g\*), lots of variables. Variables in Configuration Manager can come real handy when executing Task Sequences. You can set variables on collections and machines.

# Real life example

A company would like to implement a OSD task sequence that’s totally, 100% generic. Any device has to get installed by this single task sequence. ;)
You all probably know that this is something customers/companies would like to see. Of course there are a lot of reasons not to to everything in only one task sequence (ie usability, size limitation of TS, etc) Out of this requirement came the following idea to set all needed variables via script. It’s surprisingly easy! A bit more info: The script which I’m going to show you below is part of a workflow during which some more scripts are called and thus all sorts of different environment/script/Powershell variables are set and inherited by this script. To make understanding the script a bit easier I tried to make the script as generic as possible.

# XML is the key

I chose to set all the variables I need per machine basis. In the fully automated environment we could use collection variables which set some default variables per collection and then set machine specific variables via script. Where do I define the variables I want to set on my machines? I thought about parameters I could use with the script, but that’s kind of too far away from user friendly, ini files are really oldschoooooool and not always easy to understand (at least I think so) and then I came across XML files. Then I thought, Powershell has some really cool ways of working with XML files. So I went ahead with defining my variables in an XML file which looks like this:

```
 figMgrMachineVariables&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varName&gt;OS&lt;/varName&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varValue&gt;$computerOS&lt;/varValue&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;IsMasked&gt;false&lt;/IsMasked&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varname&gt;AuftragsID&lt;/varname&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varvalue&gt;$AuftragsID&lt;/varvalue&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;IsMasked&gt;false&lt;/IsMasked&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varname&gt;Passwort&lt;/varname&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varvalue&gt;1234567890&lt;/varvalue&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;IsMasked&gt;true&lt;/IsMasked&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;

      <p>
        <!--CRLF-->
      </p>

      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">&lt;/ConfigMgrMachineVariables&gt;

      <p>
        <!--CRLF-->
      </p>
    </div>
  </div>
</div>

Easy, isn’t it? The variable “OS” is defined from line 2 to line 6. That’s it!  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" alt="Winking smile" src="http://www.sepago.de/sites/default/files/livewriterupload/wlEmoticon-winkingsmile_1.png" />Line no. 9 is something special. I can go and use environment variables during my XML interpretation and that’s really cool. This way I don’t have to hardcode everything into the XML file.

# Interpret XML

This is the script that interprets the above XML file:

```PowerShell
function create-Variable {
  $MachineSettings = Get-WMIObject -Namespace "Root\SMS\Site_$sitename" -class "SMS_MachineSettings" -Filter $ResourceID
  # Create new instance of MachineSettings if not found
  If (!$MachineSettings) {
    $NewMachineSettingsInstance = $([wmiclass]"\\.\Root\SMS\Site_$($sitename):SMS_MachineSettings").CreateInstance()
    $NewMachineSettingsInstance.ResourceID = $ResourceID
    $NewMachineSettingsInstance.SourceSite = $sitename
    $NewMachineSettingsInstance.LocaleID = 1033
    $NewMachineSettingsInstance.psbase
    $NewMachineSettingsInstance.psbase.Put()
    $MachineSettings += $NewMachineSettingsInstance
  }

  ForEach ($Server in $MachineSettings) {
    $Server.psbase.Get()
    $MachineVariables = $Server.MachineVariables
    [xml]$varfile = Get-Content .\configmgrmachvar.xml
    ForEach ($ConfigMgrMachineVariable in $varfile.ConfigMgrMachineVariables.ConfigMgrMachineVariable) {
      $ConfigMgrVar = $([wmiclass]"Root\SMS\Site_$($sitename):SMS_MachineVariable").CreateInstance()
      $ConfigMgrVar.Name = $ConfigMgrMachineVariable.varName
      $ConfigMgrVar.Value = $ExecutionContext.InvokeCommand.ExpandString($ConfigMgrMachineVariable.varValue)
      #$ConfigMgrVar.IsMasked = [Int]$($ConfigMgrMachineVariable.IsMasked)
      [System.Management.ManagementBaseObject[]]$MachineVariables += $ConfigMgrVar
    }
    $Server.MachineVariables = $MachineVariables
    $Server.psbase.Put()
  }
}
create-Variable
```

Lines 1 to 15 are mainly blabla, the interesting part is below! I’m going through the whole XML file (line 19) and then taking every variable block (as said above that’s from `<ConfigMgrMachineVariable>` to `</ConfigMgrMachineVariable>`) I pipe the values into a newly created WMI instance to create a new machine variable. I will soon try to integrate this script into my [ConfigMgr Admin GUI](http://www.sepago.de/e/david/2012/04/23/release-of-my-configuration-manager-admin-gui), to make setting machine variables easier than it already is.



