---
id: 275
title: Create Folders in Microsoft System Center Configuration Manager 2012 with Powershell
date: 2012-02-24T13:01:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.de/?p=275
permalink: /2012/02/create-folders-in-microsoft-system-center-configuration-manager-with-powershell/
if_slider_image:
  - 
categories:
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - PowerShell
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - Configuration Manager
  - create folders
  - Microsoft
  - Powershell
  - SCCM
  - SCCM 2012
  - System Center
---
Just a short article today…

I’m in the middle of a Configuration Manager implementation at a customer’s site and facing the problem of creating lots of folders and collections in those folders.

As you all might know Microsoft got rid of the “subcollections” and gave us collection folders to arrange our collections.

<a href="http://www.david-obrien.de/wp-content/uploads/2012/02/image.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.de/wp-content/uploads/2012/02/image.png', '']);" class="broken_link"><img style="background-image: none; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; margin-right: auto; padding-top: 0px; border: 0px;" title="image" alt="image" src="http://www.david-obrien.de/wp-content/uploads/2012/02/image_thumb.png" width="244" height="147" border="0" /></a>

My customer needs round about 150 folders and I am a lazy admin. What does a lazy admin do?

## Write a Powershell script

I wasn’t quite sure how the creation works so I opened up my Configuration Manager console and my server’s SMSProv.log (admin’s little helper!) and just created a folder manually in the console.

This is what I found in the SMSProv.log:

<div class="csharpcode">
  <pre class="alt"><span class="lnum"> 1: </span>CExtUserContext::EnterThread : User=OSDsepago Sid=0x0105000000000005150000000D3DD859871387AF86AA21EB52040000 Caching IWbemContextPtr=0000000005F26770 <span class="kwrd">in</span> Process 0xadc (2780)    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 2: </span>Context: SMSAppName=SMS Administrator Console    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 3: </span>Context: MachineName=configmgrRC2.osd.local    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 4: </span>Context: UserName=OSDsepago    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 5: </span>Context: ObjectLockContext=f770fac9-a526-480a-b6e1-6a0fa1b63f88    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 6: </span>Context: ApplicationName=Microsoft.ConfigurationManagement.exe    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 7: </span>Context: ApplicationVersion=5.0.0.0    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 8: </span>Context: LocaleID=MS�x407    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 9: </span>Context: __ProviderArchitecture=32    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 10: </span>Context: __RequiredArchitecture=0 (Bool)    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 11: </span>Context: __ClientPreferredLanguages=de-DE,de    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 12: </span>Context: __GroupOperationId=16655    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 13: </span>CExtUserContext : <span class="kwrd">Set</span> ThreadLocaleID OK <span class="kwrd">to</span>: 1031    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 14: </span>CSspClassManager::PreCallAction, dbname=CM_PRI    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 15: </span>PutInstanceAsync SMS_ObjectContainerNode    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 16: </span>CExtProviderClassObject::DoPutInstanceInstance    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 17: </span>PutInstance of Folder : script    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 18: </span>DEBUGGING ObjectType  = 5000    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 19: </span>Auditing: User OSDsepago created an instance of <span class="kwrd">class</span> SMS_ObjectContainerNode.    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre><span class="lnum"> 20: </span>CExtUserContext::LeaveThread : Releasing IWbemContextPtr=99772272    SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
  
  <pre class="alt"><span class="lnum"> 21: </span>SMS Provider    24.02.2012 07:56:34    2128 (0x0850)</pre>
</div>

What did this tell me? Actually, a lot!

In line 15 it told me that the WMI Class “SMS_ObjectContainerNode” was used and that it put a new instance there. I also found the name of my folder in the next line 17, I called it “script”.
  
Line 18 was the last information I needed, the “ObjectType”.

ObjectType = 5000 means that you’re creating a device collection, while ObjectType = 5001 means user collection.

What it’s not telling me here is that I also need the “ParentContainerNodeID”. I forgot that one and the error message told me that I missed that one.

If you want to create a folder beneath the root, then your “ParentContainerNodeID" is “0”, otherwise you will have to evaluate the ID of your parent folder.

## Powershell function

And this is how it looks:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; border-top: silver 1px solid; font-family: 'Courier New', courier, monospace; border-right: silver 1px solid; border-bottom: silver 1px solid; padding-bottom: 4px; direction: ltr; text-align: left; padding-top: 4px; padding-left: 4px; margin: 20px 0px 10px; border-left: silver 1px solid; line-height: 12pt; padding-right: 4px; max-height: 200px; width: 97.5%; background-color: #f4f4f4">
  <div id="codeSnippet" style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">
    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">﻿<span style="color: #0000ff">Function</span> Create-CollectionFolder($FolderName)</pre>
    
    <p>
      <!--CRLF-->
      
      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">{</pre>
      
      <p>
        <!--CRLF-->
        
        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    $CollectionFolderArgs = @{</pre>
        
        <p>
          <!--CRLF-->
          
          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    Name = $FolderName;</pre>
          
          <p>
            <!--CRLF-->
            
            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    ObjectType = <span style="color: #006080">"5000"</span>;         # 5000 ist für Collection_Device, 5001 ist für Collection_User</pre>
            
            <p>
              <!--CRLF-->
              
              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    ParentContainerNodeid = <span style="color: #006080">"0"</span> # die ParentContainerNodeID ist dann <span style="color: #008000">'0', wenn der Ordner unter der Root hängt, ansonsten muss der ParentOrdner evaluiert werden</span></pre>
              
              <p>
                <!--CRLF-->
                
                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    }</pre>
                
                <p>
                  <!--CRLF-->
                  
                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    <span style="color: #0000ff">Set</span>-WmiInstance -<span style="color: #0000ff">Class</span> SMS_ObjectContainerNode -arguments $CollectionFolderArgs -<span style="color: #0000ff">namespace</span> <span style="color: #006080">"root\SMS\Site_$sitename"</span> | Out-Null</pre>
                  
                  <p>
                    <!--CRLF-->
                    
                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">}</pre>
                    
                    <p>
                      <!--CRLF-->
                      
                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                      
                      <p>
                        <!--CRLF-->
                        
                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$FolderName = <span style="color: #0000ff">Get</span>-Random   # für Test, setzt einfach eine willkürliche Zahl</pre>
                        
                        <p>
                          <!--CRLF-->
                          
                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$sitename = <span style="color: #006080">"PRI"</span> # an deinen Sitename anpassen!</pre>
                          
                          <p>
                            <!--CRLF-->
                            
                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                            
                            <p>
                              <!--CRLF-->
                              
                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">Create-CollectionFolder $FolderName</pre>
                              
                              <p>
                                <!--CRLF--></div> </div> 
                                
                                <p>
                                  &nbsp;
                                </p>
                                
                                <p>
                                  If you need some help or got some questions left, just ask! 
                                  
                                  <div style="float: right; margin-left: 10px;">
                                    <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Configuration+Manager,create+folders,Microsoft,Powershell,SCCM,SCCM+2012,System+Center" data-count="vertical" data-url="http://www.david-obrien.net/2012/02/create-folders-in-microsoft-system-center-configuration-manager-with-powershell/">Tweet</a>
                                  </div>

