---
id: 665
title: Create Machine variables in Configuration Manager 2012
date: 2012-05-08T12:25:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=665
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

A company would like to implement a OSD task sequence that’s totally, 100% generic. Any device has to get installed by this single task sequence.  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" alt="Winking smile" src="http://www.sepago.de/sites/default/files/livewriterupload/wlEmoticon-winkingsmile_1.png" />You all probably know that this is something customers/companies would like to see. Of course there are a lot of reasons not to to everything in only one task sequence (ie usability, size limitation of TS, etc) Out of this requirement came the following idea to set all needed variables via script. It’s surprisingly easy! A bit more info: The script which I’m going to show you below is part of a workflow during which some more scripts are called and thus all sorts of different environment/script/Powershell variables are set and inherited by this script. To make understanding the script a bit easier I tried to make the script as generic as possible.

# XML is the key

I chose to set all the variables I need per machine basis. In the fully automated environment we could use collection variables which set some default variables per collection and then set machine specific variables via script. Where do I define the variables I want to set on my machines? I thought about parameters I could use with the script, but that’s kind of too far away from user friendly, ini files are really oldschoooooool and not always easy to understand (at least I think so) and then I came across XML files. Then I thought, Powershell has some really cool ways of working with XML files. So I went ahead with defining my variables in an XML file which looks like this:

<div class="csharpcode">
  <div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
    <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">&lt;ConfigMgrMachineVariables&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varName&gt;OS&lt;/varName&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varValue&gt;$computerOS&lt;/varValue&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;IsMasked&gt;<span style="color: #0000ff;">false</span>&lt;/IsMasked&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varname&gt;AuftragsID&lt;/varname&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varvalue&gt;$AuftragsID&lt;/varvalue&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;IsMasked&gt;<span style="color: #0000ff;">false</span>&lt;/IsMasked&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;varname&gt;Passwort&lt;/varname&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        &lt;varvalue&gt;1234567890&lt;/varvalue&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        &lt;IsMasked&gt;<span style="color: #0000ff;">true</span>&lt;/IsMasked&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    &lt;/ConfigMgrMachineVariable&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
      
      <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">&lt;/ConfigMgrMachineVariables&gt;</pre>
      
      <p>
        <!--CRLF-->
      </p>
    </div>
  </div>
</div>

Easy, isn’t it? The variable “OS” is defined from line 2 to line 6. That’s it!  <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" alt="Winking smile" src="http://www.sepago.de/sites/default/files/livewriterupload/wlEmoticon-winkingsmile_1.png" />Line no. 9 is something special. I can go and use environment variables during my XML interpretation and that’s really cool. This way I don’t have to hardcode everything into the XML file.

# Interpret XML

This is the script that interprets the above XML file:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; width: 97.5%; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">function</span> create-Variable {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">$MachineSettings = <span style="color: #0000ff;">Get</span>-WMIObject -<span style="color: #0000ff;">Namespace</span> <span style="color: #006080;">"Root\SMS\Site_$sitename"</span> -<span style="color: #0000ff;">class</span> <span style="color: #006080;">"SMS_MachineSettings"</span> -Filter $ResourceID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"># Create <span style="color: #0000ff;">new</span> instance of MachineSettings <span style="color: #0000ff;">if</span> <span style="color: #0000ff;">not</span> found</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"><span style="color: #0000ff;">If</span> (!$MachineSettings) {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $NewMachineSettingsInstance = $([wmiclass]<span style="color: #006080;">"\\.\Root\SMS\Site_$($sitename):SMS_MachineSettings"</span>).CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    $NewMachineSettingsInstance.ResourceID = $ResourceID</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $NewMachineSettingsInstance.SourceSite = $sitename</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    $NewMachineSettingsInstance.LocaleID = 1033</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $NewMachineSettingsInstance.psbase</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    $NewMachineSettingsInstance.psbase.Put()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $MachineSettings += $NewMachineSettingsInstance</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">ForEach ($Server <span style="color: #0000ff;">in</span> $MachineSettings) {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    $Server.psbase.<span style="color: #0000ff;">Get</span>()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $MachineVariables = $Server.MachineVariables</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    [xml]$varfile = <span style="color: #0000ff;">Get</span>-Content .\configmgrmachvar.xml</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    ForEach ($ConfigMgrMachineVariable <span style="color: #0000ff;">in</span> $varfile.ConfigMgrMachineVariables.ConfigMgrMachineVariable) {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        $ConfigMgrVar = $([wmiclass]<span style="color: #006080;">"Root\SMS\Site_$($sitename):SMS_MachineVariable"</span>).CreateInstance()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        $ConfigMgrVar.Name = $ConfigMgrMachineVariable.varName</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">        $ConfigMgrVar.Value = $ExecutionContext.InvokeCommand.ExpandString($ConfigMgrMachineVariable.varValue)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        #$ConfigMgrVar.IsMasked = [Int]$($ConfigMgrMachineVariable.IsMasked)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;"></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">        [System.Management.ManagementBaseObject[]]$MachineVariables += $ConfigMgrVar</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">    $Server.MachineVariables = $MachineVariables</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">    $Server.psbase.Put()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: white; border-style: none; padding: 0px;">}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; width: 100%; background-color: #f4f4f4; border-style: none; padding: 0px;">create-Variable</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Lines 1 to 15 are mainly blabla, the interesting part is below! I’m going through the whole XML file (line 19) and then taking every variable block (as said above that’s from <ConfigMgrMachineVariable> to </ConfigMgrMachineVariable>) I pipe the values into a newly created WMI instance to create a new machine variable. I will soon try to integrate this script into my [ConfigMgr Admin GUI](http://www.sepago.de/e/david/2012/04/23/release-of-my-configuration-manager-admin-gui), to make setting machine variables easier than it already is. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

