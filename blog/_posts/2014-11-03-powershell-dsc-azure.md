---
id: 2481
title: Powershell DSC on Azure
date: 2014-11-03T06:36:59+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2481
permalink: /2014/11/powershell-dsc-azure/
categories:
  - PowerShell
  - Uncategorized
tags:
  - Azure
  - Desired State Configuration
  - DevOps
  - DSC
  - IaaS
  - Powershell
  - PSDSC
---
After my session at TechEd Australia (Sydney) on Powershell Desired State Configuration where I quickly demoed how DSC runs on your Azure IaaS Virtual Machines I now would like to go into a bit more detail.

Microsoft enables you as an administrator to execute Powershell against your Azure environment, which basically makes it irrelevant where your workload is, you can manage it through Powershell.

I said it before, I will say it again: Powershell is King!

Need more general information on DSC? Go read some of my earlier articles on that topic.

# How does DSC work on Azure?

A while ago Microsoft announced the availability of VM Extensions and one of those extensions is DSC. The way you apply your DSC configuration on an Azure VM however is a bit different to what you’d be used to in your on-premises environment.

There is no such thing as a Pull mode with that VM extension. You can, of course, still deploy a server machine that will act as a DSC Pull Server, but why? (Actually, there might be a couple of arguments, but these are for another article)

DSC on Azure VMs make use of a Powershell script, that will be executed upon first launch of a VM instance and that will then execute the DSC configuration. This is kind of like Push mode, only, a Powershell script does the execution for you. That process is similar to using DSC during OSD deployments, where you would have your unattend.xml execute a Powershell script that will in turn run the Start-DSCConfiguration cmdlet.

# Prepare your DSC configuration for Azure

Before we can use our configuration on Azure, we have to first make it available to our subscription. Remember, I said that on Azure DSC acts a bit like when it’s configured for Push mode, but how would we make custom DSC modules available to a new VM? We don’t. 😉

For DSC on Azure VMs to work we have to upload a compressed (*.zip) version of our configuration. This zip container also needs to contain all custom modules/resources we are referencing in our configuration and also any ConfigurationData we want to use. You can create the zip file yourself or, that’s the way I prefer, have Powershell do it for you.

**Publish-AzureVMDscConfiguration** is a new cmdlet you get with the latest version of the Azure Powershell module and that cmdlet will automatically build the zip package.
  
It will also parse your configuration and will automatically add all custom resources to the package (*.zip file), as long as you’re correctly importing them with the **Import-DSCResource** keyword.

**Gotcha**: The cmdlet doesn’t know about composite resources! For example the **MSFT_xChrome** resource (from the **xChrome** module) uses in itself the **xRemoteFile** resource from the **xPSDesiredStateConfiguration** module. It won’t automatically add any of those composite resources into the zip file. You either have to do it manually or directly reference the resource/module via **Import-DSCResource**. I hope that Microsoft will fix that in an upcoming update.

You can check the zip file before uploading it to an Azure storage account by executing the following command:

<div id="wpshdo_13" class="wp-synhighlighter-outer">
  <div id="wpshdt_13" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_13"></a><a id="wpshat_13" class="wp-synhighlighter-title" href="#codesyntax_13"  onClick="javascript:wpsh_toggleBlock(13)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_13" onClick="javascript:wpsh_code(13)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_13" onClick="javascript:wpsh_print(13)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_13" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Publish<span class="sy0">-</span>AzureVMDscConfiguration <span class="sy0">-</span>ConfigurationPath `
<span class="st0">'C:\temp\DSC_Demo_ChromeConfig.ps1'</span> `
<span class="sy0">-</span>ConfigurationArchivePath <span class="st0">'C:\temp\DSC_Demo_ChromeConfig.ps1.zip'</span> <span class="kw5">-Force</span></pre>
  </div>
</div>

This command will take the PS1 file in C:\temp and create a zip file. In my case that zip file looks like this:

It zipped the Configuration .ps1 and added all referenced modules as well.

As long as you’re connected / authenticated to your Azure subscription, you can now go and upload the zip file to your storage account.

<div id="wpshdo_14" class="wp-synhighlighter-outer">
  <div id="wpshdt_14" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_14"></a><a id="wpshat_14" class="wp-synhighlighter-title" href="#codesyntax_14"  onClick="javascript:wpsh_toggleBlock(14)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_14" onClick="javascript:wpsh_code(14)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_14" onClick="javascript:wpsh_print(14)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_14" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">Publish<span class="sy0">-</span>AzureVMDscConfiguration <span class="sy0">-</span>ConfigurationPath ‘C:\temp\DSC_Demo_ChromeConfig.ps1<span class="st0">' -Verbose -Force</span></pre>
  </div>
</div>

A quick jump onto your Azure Storage Account will confirm the new container:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer.png', '']);" class="broken_link"><img class="img-responsive aligncenter wp-image-2491 size-large" src="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer-1024x182.png" alt="2014-11-03 06_15_36-Storage - Windows Azure - Internet Explorer" width="800" height="142" srcset="/media/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer-300x53.png 300w, /media/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer-1024x182.png 1024w, /media/2014/11/2014-11-03-06_15_36-Storage-Windows-Azure-Internet-Explorer-250x44.png 250w" sizes="(max-width: 800px) 100vw, 800px" /></a>

# Scenario 1: DSC on a new VM

While setting up your VM in Powershell, I always recommend using the Powershell ISE by the way, you also have to enable the VM extension.

In order to do that there is a new cmdlet available in the Azure Powershell SDK called **Set-AzureVMDSCExtension** . This cmdlet will cause the VM to install the DSC extension and configure it to apply the configuration specified.

<div id="wpshdo_15" class="wp-synhighlighter-outer">
  <div id="wpshdt_15" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_15"></a><a id="wpshat_15" class="wp-synhighlighter-title" href="#codesyntax_15"  onClick="javascript:wpsh_toggleBlock(15)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_15" onClick="javascript:wpsh_code(15)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_15" onClick="javascript:wpsh_print(15)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_15" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="re0">$vm</span> <span class="sy0">=</span> New<span class="sy0">-</span>AzureVMConfig <span class="kw5">-Name</span> <span class="st0">'DOPSDSC'</span> <span class="sy0">-</span>InstanceSize Small <span class="sy0">-</span>ImageName `
<span class="st0">'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201409.01-en.us-127GB.vhd'</span> <span class="kw5">-Verbose</span>
&nbsp;
<span class="re0">$vm</span> <span class="sy0">=</span> Add<span class="sy0">-</span>AzureProvisioningConfig <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>Windows <span class="sy0">-</span>AdminUsername <span class="st0">'User'</span> <span class="sy0">-</span>Password <span class="st0">'P@ssw0rd'</span> <span class="kw5">-Verbose</span>
&nbsp;
<span class="re0">$vm</span> <span class="sy0">=</span> Add<span class="sy0">-</span>AzureEndpoint <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="kw5">-Name</span> <span class="st0">'HTTP'</span> <span class="sy0">-</span>Protocol <span class="st0">'tcp'</span> <span class="sy0">-</span>PublicPort 80 <span class="sy0">-</span>LocalPort 8080 
&nbsp;
<span class="re0">$vm</span> <span class="sy0">=</span> Set<span class="sy0">-</span>AzureVMDSCExtension <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>ConfigurationArchive <span class="st0">'DSC_Demo_ChromeConfig.ps1.zip'</span> `
<span class="sy0">-</span>ConfigurationName <span class="st0">'GoogleChrome'</span> <span class="kw5">-Verbose</span> <span class="kw5">-Force</span>
&nbsp;
New<span class="sy0">-</span>AzureVM <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>Location <span class="st0">'West US'</span> <span class="sy0">-</span>ServiceName <span class="st0">'DOPSDSC-svc'</span> <span class="sy0">-</span>WaitForBoot <span class="kw5">-Verbose</span></pre>
  </div>
</div>

I am first creating a new VM configuration, specifying the image I want Azure to deploy, I add the Provisioning Configuration, an endpoint for HTTP, because the xChrome resource downloads the Chrome sources from the internet and finally I configure DSC.

I need to specify the zip file and the Configuration I want DSC to apply. The ConfigurationName has to be the exact same name that is being used in the ps1 file, otherwise it won’t work.

New-AzureVM will then create the VM just as we have configured it to be.

## Powershell DSC &#8211; What’s happening in the background?

What are we doing here? That is a valid question. How does that VM know that it should apply that DSC configuration?

I can only assume at this point. It might be this:

## unattend.xml

You might have seen blog posts where people explain how to leverage DSC ‘during’ OS Deployment. That’s exactly what Microsoft is doing here as well. They are injecting a bit of code into the machines unattend.xml, so that during the specialization phase it knows that it should execute a task that will initiate the DSC run. Pretty clever.
  
This approach, however, wouldn&#8217;t work on an existing VM.

Jumping onto a VM that has the DSC extension installed and already executed our configuration, we can see the following:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png', '']);" class="broken_link"><img class="img-responsive aligncenter wp-image-2501 size-large" src="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-1024x255.png" alt="2014-11-03 06_19_59-DSCTest - DSCTest-q34vo21d.cloudapp.net_3389 - Remote Desktop Connection" width="800" height="199" srcset="/media/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-1024x255.png 1024w, /media/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-250x62.png 250w, /media/2014/11/2014-11-03-06_19_59-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png 1321w" sizes="(max-width: 800px) 100vw, 800px" /></a>That path and its parent has quite a lot of stuff in there which executes DSC.

# Scenario 2: DSC on an existing VM

Instead of applying a DSC configuration to a new VM (non-existing yet), you might want to apply a configuration to an existing one.

Microsoft was so kind to give us a cmdlet for that as well.

The process for that looks like this:

<div id="wpshdo_16" class="wp-synhighlighter-outer">
  <div id="wpshdt_16" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_16"></a><a id="wpshat_16" class="wp-synhighlighter-title" href="#codesyntax_16"  onClick="javascript:wpsh_toggleBlock(16)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_16" onClick="javascript:wpsh_code(16)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_16" onClick="javascript:wpsh_print(16)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_16" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;"><span class="re0">$vm</span> <span class="sy0">=</span> Get<span class="sy0">-</span>AzureVM –ServiceName <span class="st0">'DOPSDSCAUTechEd-svc'</span> –Name <span class="st0">'DOPSDSC'</span>
&nbsp;
<span class="re0">$vm</span> <span class="sy0">=</span> Set<span class="sy0">-</span>AzureVMDSCExtension <span class="sy0">-</span>VM <span class="re0">$vm</span> <span class="sy0">-</span>ConfigurationArchive <span class="st0">'DSC_Demo_ChromeConfig.ps1.zip'</span> `
<span class="sy0">-</span>ConfigurationName <span class="st0">'GoogleChrome'</span> <span class="kw5">-Verbose</span> <span class="kw5">-Force</span>
&nbsp;
Update<span class="sy0">-</span>AzureVM <span class="sy0">-</span>VM <span class="re0">$VM</span> <span class="sy0">-</span>ServiceName <span class="st0">'DOPSDC-svc'</span> <span class="kw5">-Verbose</span></pre>
  </div>
</div>

This will cause the VM to apply the new configuration straight away.

# Scenario 3: Azure DSC from preview portal

You can, if for whatever weird reason, you don&#8217;t like/want to use Powershell, use the Azure preview portal to add the VM Extension and add configuration to VMs.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_26_48-Microsoft-Azure-Internet-Explorer.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_26_48-Microsoft-Azure-Internet-Explorer.png', '']);" class="broken_link"><img class="img-responsive aligncenter wp-image-2511 size-large" src="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_26_48-Microsoft-Azure-Internet-Explorer-1024x747.png" alt="2014-11-03 05_26_48-Microsoft Azure - Internet Explorer" width="800" height="583" /></a><a href="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer.png', '']);" class="broken_link"><img class="img-responsive aligncenter wp-image-2521 size-large" src="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer-1024x694.png" alt="2014-11-03 05_34_51-Microsoft Azure - Internet Explorer" width="800" height="542" srcset="/media/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer-300x203.png 300w, /media/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer-1024x694.png 1024w, /media/2014/11/2014-11-03-05_34_51-Microsoft-Azure-Internet-Explorer-221x150.png 221w" sizes="(max-width: 800px) 100vw, 800px" /></a>

# Powershell 5 Preview on Azure

Quick fun fact:
  
The Windows Server 2012 R2 image that I am deploying in above snippets has already got the Powershell 5 preview installed. So you can now use all the great, new Powershell DSC features on your Azure VMs out of the box!

<a href="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png', '']);" class="broken_link"><img class="img-responsive aligncenter wp-image-2531 size-large" src="http://www.david-obrien.net/wp-content/uploads/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-1024x852.png" alt="2014-11-03 06_28_46-DSCTest - DSCTest-q34vo21d.cloudapp.net_3389 - Remote Desktop Connection" width="800" height="665" srcset="/media/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-300x249.png 300w, /media/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection-1024x852.png 1024w, /media/2014/11/2014-11-03-06_28_46-DSCTest-DSCTest-q34vo21d.cloudapp.net_3389-Remote-Desktop-Connection.png 1034w" sizes="(max-width: 800px) 100vw, 800px" /></a>

## Summary

I hope this level 300-ish overview of DSC on Azure gave you a good idea of how you can use and manage DSC on your IaaS Azure environments.

<a href="http://www.twitter.com\david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.comdavid_obrien', '-David']);" target="_blank" class="broken_link">-David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Azure,Desired+State+Configuration,DevOps,DSC,IaaS,Powershell,PSDSC" data-count="vertical" data-url="http://www.david-obrien.net/2014/11/powershell-dsc-azure/">Tweet</a>
</div>
