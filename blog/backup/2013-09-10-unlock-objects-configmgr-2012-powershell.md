---
id: 1264
title: How to unlock objects in ConfigMgr 2012 with Powershell
date: 2013-09-10T20:52:48+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1264
permalink: /2013/09/unlock-objects-configmgr-2012-powershell/
categories:
  - CM12
  - ConfigMgr 2012
  - Configuration Manager
  - PowerShell
  - System Center
tags:
  - automation
  - ConfigMgr
  - Configuration Manager
  - Powershell
  - SysCtr
  - System Center
---
# Unlocking packages or apps in ConfigMgr 2012

<a href="http://www.david-obrien.net/wp-content/uploads/2013/09/image.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2013/09/image.png', '']);" class="broken_link"><img style="float: none; margin-left: auto; display: block; margin-right: auto; border-width: 0px;" title="locked object in SCCM" alt="locked object in SCCM" src="http://www.david-obrien.net/wp-content/uploads/2013/09/image_thumb.png" width="320" height="153" border="0" /></a>

Crap! Do you know this message? Most probably your console just crashed a minute ago while you were editing this application and you’re trying to open up this application again. Well, too bad, please wait for 30 minutes and then come back please.
  
This is because your lock on that object has not been released the moment your console crashed.

For more information on this, use the search engine of your choice (google \*g\*) and look for SEDO (**S**erialized **E**diting of **D**istributed **O**bjects) or try this site: <a href="http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx', 'http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx']);" >http://blogs.technet.com/b/sudheesn/archive/2012/10/28/sedo-serialized-editing-of-distributed-objects-configmgr-2012.aspx</a>

## Unlocking objects (before Powershell)

At least I hate waiting, even more if it’s 30 minutes because of a stupid lock I don’t want to have anymore. So what could be done? Wait… or go to your database and delete the lock. Not the best solution!!! Microsoft hates admins who directly touch and alter the database. But for a very long time this was the only solution to this problem: <a href="http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/', 'http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/']);" >http://myitforum.com/myitforumwp/2013/02/22/unlocking-configmgr-2012-objects/</a>

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;"> </span><span style="color: #0000ff;">select</span> * <span style="color: #0000ff;">from</span> SEDO_LockState <span style="color: #0000ff;">where</span> LockStateID &lt;&gt; 0</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;"> </span><span style="color: #0000ff;">DELETE</span> <span style="color: #0000ff;">from</span> SEDO_LockState <span style="color: #0000ff;">where</span> LockID = ‘&lt;LockID <span style="color: #0000ff;">of</span> the record identified <span style="color: #0000ff;">in</span> the previous query&gt;’</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

&nbsp;

## Unlocking objects (with Powershell)

<span style="font-family: 'Trebuchet MS';">So what can be done now that we don’t want to touch the database directly?</span>

<span style="font-family: 'Trebuchet MS';">Powershell to the rescue! Since ConfigMgr 2012 SP1 we have the following cmdlet:</span>

> PS PRI:\> get-help Unlock-CMObject -Full
> 
> NAME
  
> Unlock-CMObject
> 
> SYNTAX
  
> Unlock-CMObject \[-InputObject] <IResultObject[]> [-WhatIf\] \[-Confirm\]  [<CommonParameters>]
> 
> PARAMETERS
  
> -Confirm
> 
> Required?                    false
  
> Position?                    Named
  
> Accept pipeline input?       false
  
> Parameter set name           (All)
  
> Aliases                      cf
  
> Dynamic?                     false
> 
> -InputObject <IResultObject[]>
> 
> Required?                    true
  
> Position?                    0
  
> Accept pipeline input?       true (ByPropertyName)
  
> Parameter set name           ByValue
  
> Aliases                      None
  
> Dynamic?                     false
> 
> -WhatIf
> 
> Required?                    false
  
> Position?                    Named
  
> Accept pipeline input?       false
  
> Parameter set name           (All)
  
> Aliases                      wi
  
> Dynamic?                     false
> 
> <CommonParameters>
  
> This cmdlet supports the common parameters: Verbose, Debug,
  
> ErrorAction, ErrorVariable, WarningAction, WarningVariable,
  
> OutBuffer, PipelineVariable, and OutVariable. For more information, see
  
> about_CommonParameters (<a href="http://go.microsoft.com/fwlink/?LinkID=113216)" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://go.microsoft.com/fwlink/?LinkID=113216)', 'http://go.microsoft.com/fwlink/?LinkID=113216)']);" >http://go.microsoft.com/fwlink/?LinkID=113216)</a>.
> 
> INPUTS
  
> Microsoft.ConfigurationManagement.ManagementProvider.IResultObject[]
> 
> OUTPUTS
  
> System.Object
> 
> ALIASES
  
> None

&nbsp;

Usage is pretty easy. Our Application named “7-zip” is locked, so this is our commandline:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> Unlock-CMObject -InputObject $(<span style="color: #0000ff;">Get</span>-CMApplication -Name 7-zip)</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

Of course the cmdlet won’t give us any feedback, but well, what did I expect? But now we are able to work on that application again.

## Lock objects with Powershell

What can be done can also be undone, or something like that.

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> Lock-CMObject -InputObject $(<span style="color: #0000ff;">Get</span>-CMApplication -Name 7-zip)</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

This command will lock the application, just like before.

Locking and unlocking works for applications, packages, driver packages, operating system images, boot images and task sequences.

Use these cmdlets to get the InputObjects:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 97.5%; direction: ltr; text-align: left; margin: 20px 0px 10px; line-height: 12pt; max-height: 200px; background-color: #f4f4f4; border: silver 1px solid; padding: 4px;">
  <div id="codeSnippet" style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;">
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum1" style="color: #606060;">   1:</span> <span style="color: #0000ff;">Get</span>-CMApplication</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum2" style="color: #606060;">   2:</span> <span style="color: #0000ff;">Get</span>-CMPackage</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum3" style="color: #606060;">   3:</span> <span style="color: #0000ff;">Get</span>-CMDriverPackage</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum4" style="color: #606060;">   4:</span> <span style="color: #0000ff;">Get</span>-CMOperatingSystemImage</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: white; border-style: none; padding: 0px;"><span id="lnum5" style="color: #606060;">   5:</span> <span style="color: #0000ff;">Get</span>-CMBootImage</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="overflow: visible; font-size: 8pt; font-family: 'Courier New', courier, monospace; width: 100%; color: black; direction: ltr; text-align: left; margin: 0em; line-height: 12pt; background-color: #f4f4f4; border-style: none; padding: 0px;"><span id="lnum6" style="color: #606060;">   6:</span> <span style="color: #0000ff;">Get</span>-CMTaskSequence</pre>
    
    <p>
      <!--CRLF-->
    </p>
  </div>
</div>

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,ConfigMgr,Configuration+Manager,Powershell,SysCtr,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2013/09/unlock-objects-configmgr-2012-powershell/">Tweet</a>
</div>
