---
id: 3273
title: Continuous Integration with PowerShell, TeamCity and Git
date: 2016-01-30T21:31:19+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=3273
permalink: /2016/01/continuous-integration-with-teamcity-powershell-and-git/
categories:
  - Cloud
  - DevOps
  - Git
  - PowerShell
  - TeamCity
tags:
  - Continuous Deployment
  - Continuous Integration
  - DevOps
  - git
  - github
  - Powershell
---
On Twitter I was following a conversation where someone said that he needed an easier way to publish PowerShell modules to the Microsoft PowerShell Gallery. His issue was that there were too many manual steps involved in publishing to the Gallery. Actually, publishing is really easy, but all those tests (Lint tests, Unit Tests, Script Guides, etc.) take some time to run manually. This is where automation helps.
  
This article will focus on the tools and the configuration used (in MY environment) to accomplish Continuous Integration.

<a href="/media/2016/01/1454145901_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2016/01/1454145901_full.png', '']);" target="_blank"><img class="img-responsive aligncenter" src="/media/2016/01/1454145901_thumb.png" alt="" align="middle" /></a><!--more-->

#  <span style="color: inherit; font-family: open_sanssemibold, sans-serif; font-size: 26px;">Continuous Integration for PowerShell modules</span>

If you haven&#8217;t yet heard of Continuous Integration (CI) then this Wikipedia article will give you a good overview of what is involved in CI: https://en.wikipedia.org/wiki/Continuous_integration

Continuous Integration is something Developers are already used to do for a long time (or should be at least) and companies or teams claiming to be (not do!) DevOps should also do CI, to an extent.

In a nutshell CI means that as a developer (You write PowerShell? You&#8217;re a developer!) you commit your code into Source Control (like git, bitbucket, TFS or VSO), that commit triggers a job (or pipeline) on your CI server (something like Jenkins, TeamCity, GoCD or AppVeyor). This job usually runs some Unit Tests (Pester), validates your code against scripting guidelines (PSScriptAnalyzer) and if all tests pass it will create a &#8220;build artefact&#8221; that then can be pushed to an artefact repository (like Nexus, Artefactory, NuGet or the PowerShell Gallery).

This build artefact can now be picked up by tools like Bamboo, Octopus Deploy, Ansible, Chef or Puppet.

# PowerShell module good practices

In this chapter I don&#8217;t really want to talk about how to structure your PowerShell module, but just some things that I found over time that make it a lot easier to get your module through your build pipeline.

  * add your test files to the source code 
      * githubconnect.Tests.ps1 is the script that gets automatically executed by our Pester step. (later more)

<a href="/media/2016/01/1454146307_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2016/01/1454146307_full.png', '']);" target="_blank"><img class="img-responsive aligncenter" src="/media/2016/01/1454146307_thumb.png" alt="" align="middle" /></a>

  * use your IDE to trim whitespace from line endings 
      * most decent IDEs will have a function in them to remove whitespace. This will prevent some Code Styleguide checks from failing.
      * I use VS Code for my development and use this extension.
  * I&#8217;d recommend having a generic pipeline for your modules. Have a &#8220;policy&#8221; that says that your module needs at least the Pester test script.
  * You either use one Source Code Repository for all your modules, each module is in its own subfolder, or have multiple pipelines where each pipeline monitors only one repository and builds only one module. Alternatively one could also add multiple VCS roots to a pipeline, if your CI tool supports that.

# Continuous Integration pipeline structure

My basic CI pipeline is split into four stages:

  1. Preparation 
      1. Here I make sure that the build agent is configured the way I need it to be.
  2. Validation 
      1. In this stage all the tests are run.
  3. Build 
      1. The artefact is created. In some special cases this stage might be empty or disabled.
  4. Upload 
      1. The artefact is uploaded to the configured repositories. (NuGet, PowerShell Gallery, Artefactory, Nexus, etc.)

## Preparation stage

This stage is special. This is the very first stage in my CI pipeline, it kicks everything else off. I mentioned that ideally Continuous Integration builds an artefact from every commit (at least from commits to your master or release branch in source control, however you do it). So we need to tell Teamcity that a commit to Source Control triggers the build. This is really easy, so I won&#8217;t show more than a screenshot here.

The actual action that gets executed is fairly dull. It uses the PackageManagement module to bootstrap nugget.exe onto your system, that&#8217;s it. **Caveat: **Your machine needs internet connectivity to download the executable.

<div id="wpshdo_49" class="wp-synhighlighter-outer">
  <div id="wpshdt_49" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_49"></a><a id="wpshat_49" class="wp-synhighlighter-title" href="#codesyntax_49"  onClick="javascript:wpsh_toggleBlock(49)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_49" onClick="javascript:wpsh_code(49)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_49" onClick="javascript:wpsh_print(49)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_49" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Get<span class="sy0">-</span>PackageProvider <span class="kw5">-Name</span> NuGet <span class="sy0">-</span>ForceBootstrap</pre>
  </div>
</div>

<img class="img-responsive size-full wp-image-3279 alignleft" src="/media/2016/01/TC-PrepStep.png" alt="TC-PrepStep" width="1163" height="829" srcset="/media/2016/01/TC-PrepStep-300x214.png 300w, /media/2016/01/TC-PrepStep-768x547.png 768w, /media/2016/01/TC-PrepStep-1024x730.png 1024w, /media/2016/01/TC-PrepStep.png 1163w" sizes="(max-width: 1163px) 100vw, 1163px" />

## Validation stage

The validation stage consists of two steps in my case.

  * ScriptAnalyzer
  * Pester

The ScriptAnalyzer step runs the command &#8220;Invoke-ScriptAnalyzer&#8221; and checks if there are any obvious issues with code. We don&#8217;t have to add anything to our code in order to run these Style tests, those test definitions are built in to the PSScriptAnalyzer PowerShell module.

<img class="img-responsive aligncenter size-full wp-image-3282" src="/media/2016/01/tc-scriptanalyzer.png" alt="tc-scriptanalyzer" width="1522" height="967" srcset="/media/2016/01/tc-scriptanalyzer-300x191.png 300w, /media/2016/01/tc-scriptanalyzer-768x488.png 768w, /media/2016/01/tc-scriptanalyzer-1024x651.png 1024w, /media/2016/01/tc-scriptanalyzer.png 1522w" sizes="(max-width: 1522px) 100vw, 1522px" />

<div id="wpshdo_50" class="wp-synhighlighter-outer">
  <div id="wpshdt_50" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_50"></a><a id="wpshat_50" class="wp-synhighlighter-title" href="#codesyntax_50"  onClick="javascript:wpsh_toggleBlock(50)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_50" onClick="javascript:wpsh_code(50)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_50" onClick="javascript:wpsh_print(50)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_50" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">try <span class="br0">&#123;</span>
    <span class="kw3">if</span> <span class="br0">&#40;</span>Get<span class="sy0">-</span>Module PSScriptAnalyzer<span class="br0">&#41;</span> <span class="br0">&#123;</span>
        Import<span class="sy0">-</span>Module <span class="kw5">-Name</span> PSScriptAnalyzer <span class="kw5">-ErrorAction</span> Stop
    <span class="br0">&#125;</span>
    <span class="kw3">else</span> <span class="br0">&#123;</span>
        Install<span class="sy0">-</span>Module PSScriptAnalyzer <span class="kw5">-Force</span>
    <span class="br0">&#125;</span>
<span class="br0">&#125;</span>
catch <span class="br0">&#123;</span>
    <span class="kw1">Write-Error</span> <span class="kw5">-Message</span> <a href="about:blank"><span class="kw6">$_</span></a>
    exit 1
<span class="br0">&#125;</span>
&nbsp;
try <span class="br0">&#123;</span>
    <span class="re0">$rules</span> <span class="sy0">=</span> Get<span class="sy0">-</span>ScriptAnalyzerRule <span class="sy0">-</span>Severity Warning<span class="sy0">,</span>Error <span class="kw5">-ErrorAction</span> Stop
    <span class="re0">$results</span> <span class="sy0">=</span> Invoke<span class="sy0">-</span>ScriptAnalyzer <span class="kw5">-Path</span> <span class="sy0">%</span>system.teamcity.build.checkoutDir<span class="sy0">%</span> <span class="sy0">-</span>IncludeRule <span class="re0">$rules</span>.RuleName <span class="kw5">-Recurse</span> <span class="kw5">-ErrorAction</span> Stop
    <span class="re0">$results</span>
<span class="br0">&#125;</span>
catch <span class="br0">&#123;</span>
    <span class="kw1">Write-Error</span> <span class="kw5">-Message</span> <a href="about:blank"><span class="kw6">$_</span></a>
    exit 1
<span class="br0">&#125;</span>
<span class="kw3">if</span> <span class="br0">&#40;</span><span class="re0">$results</span>.Count <span class="kw4">-gt</span> 0<span class="br0">&#41;</span> <span class="br0">&#123;</span>
    <span class="kw1">Write-Host</span> <span class="st0">"Analysis of your code threw $($results.Count) warnings or errors. Please go back and check your code."</span>
    exit 1
<span class="br0">&#125;</span>
<span class="kw3">else</span> <span class="br0">&#123;</span>
    <span class="kw1">Write-Host</span> <span class="st0">'Awesome code! No issues found!'</span> <span class="kw5">-Foregroundcolor</span> green
<span class="br0">&#125;</span></pre>
  </div>
</div>

The code should be pretty self-explanatory. Only if there are neither Warnings nor Errors in my modules do I move on to running the Pester tests in the next step.

<img class="img-responsive aligncenter size-full wp-image-3283" src="/media/2016/01/tc-pester.png" alt="tc-pester" width="1515" height="908" srcset="/media/2016/01/tc-pester-300x180.png 300w, /media/2016/01/tc-pester-768x460.png 768w, /media/2016/01/tc-pester-1024x614.png 1024w, /media/2016/01/tc-pester.png 1515w" sizes="(max-width: 1515px) 100vw, 1515px" />

<div id="wpshdo_51" class="wp-synhighlighter-outer">
  <div id="wpshdt_51" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_51"></a><a id="wpshat_51" class="wp-synhighlighter-title" href="#codesyntax_51"  onClick="javascript:wpsh_toggleBlock(51)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_51" onClick="javascript:wpsh_code(51)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_51" onClick="javascript:wpsh_print(51)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_51" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">try <span class="br0">&#123;</span>
  <span class="kw3">if</span> <span class="br0">&#40;</span>Get<span class="sy0">-</span>Module Pester<span class="br0">&#41;</span> <span class="br0">&#123;</span>
    Import<span class="sy0">-</span>Module <span class="kw5">-Name</span> Pester <span class="kw5">-ErrorAction</span> Stop
  <span class="br0">&#125;</span>
  <span class="kw3">else</span> <span class="br0">&#123;</span>
    Install<span class="sy0">-</span>Module Pester <span class="kw5">-Force</span>
  <span class="br0">&#125;</span>
  <span class="re0">$checkoutdir</span> <span class="sy0">=</span> <span class="st0">"%system.teamcity.build.checkoutDir%"</span>
  <span class="re0">$pester_xml</span> <span class="sy0">=</span> <span class="kw1">Join-Path</span> <span class="re0">$checkoutdir</span> pester_xml.xml
  <span class="re0">$result</span> <span class="sy0">=</span> Invoke<span class="sy0">-</span>Pester <span class="sy0">-</span>OutputFile <span class="re0">$pester_xml</span> <span class="sy0">-</span>OutputFormat NUnitXml <span class="kw5">-PassThru</span> <span class="kw5">-Strict</span> <span class="kw5">-ErrorAction</span> Stop
&nbsp;
  <span class="kw3">if</span> <span class="br0">&#40;</span><span class="re0">$result</span>.FailedCount <span class="kw4">-gt</span> 0<span class="br0">&#41;</span> <span class="br0">&#123;</span>
    <span class="kw3">throw</span> <span class="st0">"{0} tests did not pass"</span> <span class="kw4">-f</span> <span class="re0">$result</span>.FailedCount
  <span class="br0">&#125;</span>
<span class="br0">&#125;</span>
catch <span class="br0">&#123;</span>
  <span class="re0">$msg</span> <span class="sy0">=</span> <a href="about:blank"><span class="kw6">$_</span></a>
  <span class="kw1">Write-Error</span> <span class="kw5">-ErrorRecord</span> <span class="re0">$msg</span>
  exit <span class="nu0">1</span>
<span class="br0">&#125;</span></pre>
  </div>
</div>

Just as with ScriptAnalyzer, if it&#8217;s not installed, TeamCity will make sure that Pester gets installed on the machine first.

Invoke-Pester will search all .Tests. files and execute them. We are also telling Pester to output to an XML file. Pester supports the NUnitXml format that TeamCity also understands and is able to interpret and visualise the results on the TeamCity website.

<img class="img-responsive aligncenter size-full wp-image-3284" src="/media/2016/01/tc-pester-feature.png" alt="tc-pester-feature" width="1583" height="388" srcset="/media/2016/01/tc-pester-feature-300x74.png 300w, /media/2016/01/tc-pester-feature-768x188.png 768w, /media/2016/01/tc-pester-feature-1024x251.png 1024w, /media/2016/01/tc-pester-feature.png 1583w" sizes="(max-width: 1583px) 100vw, 1583px" />

With these two steps have we already done quite a bit. Nice!

## Build and upload

In the case of these PowerShell modules I am keeping my &#8220;Build&#8221; stage empty, as I can run the next step from my direct git clone. If you however decide to pack your PowerShell module into a NuGet package, a zip file or any other artefact type, then this Build stage would be the place to do exactly that.

The &#8220;Upload&#8221; stage is where I publish my artefact to the world for other systems to pick up and deploy from.

<img class="img-responsive aligncenter size-full wp-image-3285" src="/media/2016/01/tc-publish.png" alt="tc-publish" width="1586" height="723" srcset="/media/2016/01/tc-publish-300x137.png 300w, /media/2016/01/tc-publish-768x350.png 768w, /media/2016/01/tc-publish-1024x467.png 1024w, /media/2016/01/tc-publish.png 1586w" sizes="(max-width: 1586px) 100vw, 1586px" />

The magic happens with &#8220;Publish-Module&#8221;, which automatically creates a deployable artefact out of the PowerShell module and uploads it to the Microsoft PowerShell Gallery.

I obviously don&#8217;t want to put my PowerShell Gallery API Key into my scripts which is why I am using some TeamCity environment variables.

# Summary

To sum this up I can show you a run of one build where the Pester Unit tests failed and where TeamCity notified me of a failed build.

<img class="img-responsive aligncenter size-full wp-image-3286" src="/media/2016/01/tc-result.png" alt="tc-result" width="1579" height="268" srcset="/media/2016/01/tc-result-300x51.png 300w, /media/2016/01/tc-result-768x130.png 768w, /media/2016/01/tc-result-1024x174.png 1024w, /media/2016/01/tc-result.png 1579w" sizes="(max-width: 1579px) 100vw, 1579px" />

With this configuration in TeamCity we achieved actual CI, Continuous Integration. Every time someone commits / checks-in code to our Git repository&#8217;s Master branch TeamCity will notice this change and trigger a job. If everything is fine then all we have to do is wait and after a successful run worry about deployment.

I hope this overview will get you started with configuring your own TeamCity pipeline / project for your PowerShell code. If not, hit me up on Twitter or here and ask. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Continuous+Deployment,Continuous+Integration,DevOps,git,github,Powershell" data-count="vertical" data-url="http://www.david-obrien.net/2016/01/continuous-integration-with-teamcity-powershell-and-git/">Tweet</a>
</div>
