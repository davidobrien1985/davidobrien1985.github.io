---
id: 285
title: Microsoft Configuration Manager 2012 and Powershell–Part 2
date: 2012-02-25T16:42:00+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.de/?p=285
permalink: /2012/02/microsoft-configuration-manager-2012-and-powershellpart-2/
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
  - Configuration Manager 2012
  - Microsoft
  - Powershell
  - System Center
---
Just wanted to keep you up-to-date regarding my task to automatically build a folder-collection structure in a customer’s Configuration Manager 2012 environment. (see also article [http://www.david-obrien.de/?p=275](http://www.david-obrien.de/?p=275))

## Create Configuration Manager device collections

We already know how to create folders underneath the collections node. Now we need to create the collections our clients will one day be members of.
  
This isn’t too hard a task, so here’s my script:

<div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; border-top: silver 1px solid; font-family: 'Courier New', courier, monospace; border-right: silver 1px solid; border-bottom: silver 1px solid; padding-bottom: 4px; direction: ltr; text-align: left; padding-top: 4px; padding-left: 4px; margin: 20px 0px 10px; border-left: silver 1px solid; line-height: 12pt; padding-right: 4px; max-height: 200px; width: 97.5%; background-color: #f4f4f4">
  <div id="codeSnippet" style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">
    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#####</pre>
    
    <p>
      <!--CRLF-->
      
      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#Functionality: creates a ConfigMgr collection</pre>
      
      <p>
        <!--CRLF-->
        
        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#Author: David O<span style="color: #008000">'Brien</span></pre>
        
        <p>
          <!--CRLF-->
          
          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#<span style="color: #0000ff">date</span>: 25.02.2012</pre>
          
          <p>
            <!--CRLF-->
            
            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#####</pre>
            
            <p>
              <!--CRLF-->
              
              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4"><span style="color: #0000ff">Function</span> Create-Collection($CollectionName)</pre>
              
              <p>
                <!--CRLF-->
                
                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">{</pre>
                
                <p>
                  <!--CRLF-->
                  
                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    $CollectionArgs = @{</pre>
                  
                  <p>
                    <!--CRLF-->
                    
                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    Name = $CollectionName;</pre>
                    
                    <p>
                      <!--CRLF-->
                      
                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    CollectionType = <span style="color: #006080">"2"</span>;         # 2 means Collection_Device, 1 means Collection_User</pre>
                      
                      <p>
                        <!--CRLF-->
                        
                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    LimitToCollectionID = <span style="color: #006080">"SMS00001"</span></pre>
                        
                        <p>
                          <!--CRLF-->
                          
                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    }</pre>
                          
                          <p>
                            <!--CRLF-->
                            
                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    <span style="color: #0000ff">Set</span>-WmiInstance -<span style="color: #0000ff">Class</span> SMS_Collection -arguments $CollectionArgs -<span style="color: #0000ff">namespace</span> <span style="color: #006080">"root\SMS\Site_$sitename"</span> | Out-Null</pre>
                            
                            <p>
                              <!--CRLF-->
                              
                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">}</pre>
                              
                              <p>
                                <!--CRLF-->
                                
                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                  
                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$CollectionName = <span style="color: #0000ff">Get</span>-Random   # creates a random number <span style="color: #0000ff">for</span> testing</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                    
                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$sitename = <span style="color: #006080">"PRI"</span> </pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                      
                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                      
                                      <p>
                                        <!--CRLF-->
                                        
                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">Create-Collection $CollectionName</pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            You all know that we’ve got “Limiting collections” now in Configuration Manager 2012, so we need to provide our script with the limiting collection’s ID. In this example it’s the “All Systems” device collection.
                                          </p>
                                          
                                          <h2>
                                            Move Configuration Manager device collections
                                          </h2>
                                          
                                          <p>
                                            The thing with collections and folders is a bit tricky. While creating a collection it always gets created in the collection node’s root. This is why we can’t provide our target folder during collection creation.<br /> It’s a two-step process!
                                          </p>
                                          
                                          <p>
                                            After creation we can now move our collection away from the root into a known folder.<br /> Either hardcode the “ObjectContainerNodeID” of your target folder into the script, or better, evaluate it during script execution depending on your collection and folder name.<br /> The latter will be very easy when you stick to a naming convention like<br /> $Folder name = %abbreviation for remote site% like “CGN” for Cologne<br /> $Collection Name = $Folder name_Clients…
                                          </p>
                                          
                                          <p>
                                            Just go ahead and split your collection name until it matches your folder name and go ahead like this:
                                          </p>
                                          
                                          <div id="codeSnippetWrapper" style="overflow: auto; cursor: text; font-size: 8pt; border-top: silver 1px solid; font-family: 'Courier New', courier, monospace; border-right: silver 1px solid; border-bottom: silver 1px solid; padding-bottom: 4px; direction: ltr; text-align: left; padding-top: 4px; padding-left: 4px; margin: 20px 0px 10px; border-left: silver 1px solid; line-height: 12pt; padding-right: 4px; max-height: 200px; width: 97.5%; background-color: #f4f4f4">
                                            <div id="codeSnippet" style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">
                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">﻿param (</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                                
                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">[<span style="color: #0000ff">string</span>]$sitename,</pre>
                                                
                                                <p>
                                                  <!--CRLF-->
                                                  
                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">[<span style="color: #0000ff">string</span>]$CollectionName</pre>
                                                  
                                                  <p>
                                                    <!--CRLF-->
                                                    
                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">)</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                      
                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                      
                                                      <p>
                                                        <!--CRLF-->
                                                        
                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                        
                                                        <p>
                                                          <!--CRLF-->
                                                          
                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#####</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                            
                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#Functionality: creates a ConfigMgr collection</pre>
                                                            
                                                            <p>
                                                              <!--CRLF-->
                                                              
                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#Author: David O<span style="color: #008000">'Brien</span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                                
                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#<span style="color: #0000ff">date</span>: 25.02.2012</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                  
                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#####</pre>
                                                                  
                                                                  <p>
                                                                    <!--CRLF-->
                                                                    
                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4"><span style="color: #0000ff">Function</span> Create-Collection($CollectionName)</pre>
                                                                    
                                                                    <p>
                                                                      <!--CRLF-->
                                                                      
                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">{</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                        
                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    $CollectionArgs = @{</pre>
                                                                        
                                                                        <p>
                                                                          <!--CRLF-->
                                                                          
                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    Name = $CollectionName;</pre>
                                                                          
                                                                          <p>
                                                                            <!--CRLF-->
                                                                            
                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    CollectionType = <span style="color: #006080">"2"</span>;         # 2 means Collection_Device, 1 means Collection_User</pre>
                                                                            
                                                                            <p>
                                                                              <!--CRLF-->
                                                                              
                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    LimitToCollectionID = <span style="color: #006080">"SMS00001"</span></pre>
                                                                              
                                                                              <p>
                                                                                <!--CRLF-->
                                                                                
                                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">    }</pre>
                                                                                
                                                                                <p>
                                                                                  <!--CRLF-->
                                                                                  
                                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">    <span style="color: #0000ff">Set</span>-WmiInstance -<span style="color: #0000ff">Class</span> SMS_Collection -arguments $CollectionArgs -<span style="color: #0000ff">namespace</span> <span style="color: #006080">"root\SMS\Site_$sitename"</span> | Out-Null</pre>
                                                                                  
                                                                                  <p>
                                                                                    <!--CRLF-->
                                                                                    
                                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">}</pre>
                                                                                    
                                                                                    <p>
                                                                                      <!--CRLF-->
                                                                                      
                                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                                                      
                                                                                      <p>
                                                                                        <!--CRLF-->
                                                                                        
                                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#####</pre>
                                                                                        
                                                                                        <p>
                                                                                          <!--CRLF-->
                                                                                          
                                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#Functionality: moves a ConfigMgr collection from one folder <span style="color: #0000ff">to</span> an other</pre>
                                                                                          
                                                                                          <p>
                                                                                            <!--CRLF-->
                                                                                            
                                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#Author: David O<span style="color: #008000">'Brien</span></pre>
                                                                                            
                                                                                            <p>
                                                                                              <!--CRLF-->
                                                                                              
                                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">#<span style="color: #0000ff">date</span>: 25.02.2012</pre>
                                                                                              
                                                                                              <p>
                                                                                                <!--CRLF-->
                                                                                                
                                                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#####</pre>
                                                                                                
                                                                                                <p>
                                                                                                  <!--CRLF-->
                                                                                                  
                                                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white"><span style="color: #0000ff">function</span> move-Collection($SourceContainerNodeID,$collID,$TargetContainerNodeID)</pre>
                                                                                                  
                                                                                                  <p>
                                                                                                    <!--CRLF-->
                                                                                                    
                                                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">{</pre>
                                                                                                    
                                                                                                    <p>
                                                                                                      <!--CRLF-->
                                                                                                      
                                                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$Computer = <span style="color: #006080">"."</span></pre>
                                                                                                      
                                                                                                      <p>
                                                                                                        <!--CRLF-->
                                                                                                        
                                                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$<span style="color: #0000ff">Class</span> = <span style="color: #006080">"SMS_ObjectContainerItem"</span></pre>
                                                                                                        
                                                                                                        <p>
                                                                                                          <!--CRLF-->
                                                                                                          
                                                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$Method = <span style="color: #006080">"MoveMembers"</span></pre>
                                                                                                          
                                                                                                          <p>
                                                                                                            <!--CRLF-->
                                                                                                            
                                                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                                                                            
                                                                                                            <p>
                                                                                                              <!--CRLF-->
                                                                                                              
                                                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$MC = [WmiClass]<span style="color: #006080">"\\$Computer\ROOT\SMS\site_$($sitename):$Class"</span></pre>
                                                                                                              
                                                                                                              <p>
                                                                                                                <!--CRLF-->
                                                                                                                
                                                                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                                                                                
                                                                                                                <p>
                                                                                                                  <!--CRLF-->
                                                                                                                  
                                                                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$InParams = $mc.psbase.GetMethodParameters($Method)</pre>
                                                                                                                  
                                                                                                                  <p>
                                                                                                                    <!--CRLF-->
                                                                                                                    
                                                                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                                                                                    
                                                                                                                    <p>
                                                                                                                      <!--CRLF-->
                                                                                                                      
                                                                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$InParams.ContainerNodeID = $SourceContainerNodeID #usually 0 <span style="color: #0000ff">when</span> newly created Collection</pre>
                                                                                                                      
                                                                                                                      <p>
                                                                                                                        <!--CRLF-->
                                                                                                                        
                                                                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$InParams.InstanceKeys = $collID</pre>
                                                                                                                        
                                                                                                                        <p>
                                                                                                                          <!--CRLF-->
                                                                                                                          
                                                                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$InParams.ObjectType = <span style="color: #006080">"5000"</span> #5000 <span style="color: #0000ff">for</span> Collection_Device, 5001 <span style="color: #0000ff">for</span> Collection_User</pre>
                                                                                                                          
                                                                                                                          <p>
                                                                                                                            <!--CRLF-->
                                                                                                                            
                                                                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$InParams.TargetContainerNodeID = $TargetContainerNodeID #needs <span style="color: #0000ff">to</span> be evaluated</pre>
                                                                                                                            
                                                                                                                            <p>
                                                                                                                              <!--CRLF-->
                                                                                                                              
                                                                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                                                                                              
                                                                                                                              <p>
                                                                                                                                <!--CRLF-->
                                                                                                                                
                                                                                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4"><span style="color: #006080">"Calling SMS_ObjectContainerItem. : MoveMembers with Parameters :"</span></pre>
                                                                                                                                
                                                                                                                                <p>
                                                                                                                                  <!--CRLF-->
                                                                                                                                  
                                                                                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$inparams.PSBase.properties | <span style="color: #0000ff">select</span> name,Value | format-Table</pre>
                                                                                                                                  
                                                                                                                                  <p>
                                                                                                                                    <!--CRLF-->
                                                                                                                                    
                                                                                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                                                                                                    
                                                                                                                                    <p>
                                                                                                                                      <!--CRLF-->
                                                                                                                                      
                                                                                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)</pre>
                                                                                                                                      
                                                                                                                                      <p>
                                                                                                                                        <!--CRLF-->
                                                                                                                                        
                                                                                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">} </pre>
                                                                                                                                        
                                                                                                                                        <p>
                                                                                                                                          <!--CRLF-->
                                                                                                                                          
                                                                                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                                                                                                          
                                                                                                                                          <p>
                                                                                                                                            <!--CRLF-->
                                                                                                                                            
                                                                                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">create-collection $CollectionName</pre>
                                                                                                                                            
                                                                                                                                            <p>
                                                                                                                                              <!--CRLF-->
                                                                                                                                              
                                                                                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                                                                                                              
                                                                                                                                              <p>
                                                                                                                                                <!--CRLF-->
                                                                                                                                                
                                                                                                                                                <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">#evaluate newly created Collection properties, <span style="color: #0000ff">in</span> this <span style="color: #0000ff">case</span> $_.CollectionID <span style="color: #0000ff">is</span> sufficient</pre>
                                                                                                                                                
                                                                                                                                                <p>
                                                                                                                                                  <!--CRLF-->
                                                                                                                                                  
                                                                                                                                                  <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$collection = gwmi -<span style="color: #0000ff">Namespace</span> root\sms\site_$sitename -<span style="color: #0000ff">Class</span> SMS_Collection | where {$_.Name -eq <span style="color: #006080">"$collectionName"</span>}</pre>
                                                                                                                                                  
                                                                                                                                                  <p>
                                                                                                                                                    <!--CRLF-->
                                                                                                                                                    
                                                                                                                                                    <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$collID = $collection.CollectionID</pre>
                                                                                                                                                    
                                                                                                                                                    <p>
                                                                                                                                                      <!--CRLF-->
                                                                                                                                                      
                                                                                                                                                      <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">&nbsp;</pre>
                                                                                                                                                      
                                                                                                                                                      <p>
                                                                                                                                                        <!--CRLF-->
                                                                                                                                                        
                                                                                                                                                        <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">$SourceContainerNodeID = <span style="color: #006080">"0"</span> #usually 0 <span style="color: #0000ff">when</span> newly created Collection</pre>
                                                                                                                                                        
                                                                                                                                                        <p>
                                                                                                                                                          <!--CRLF-->
                                                                                                                                                          
                                                                                                                                                          <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">$TargetContainerNodeID = #Needs <span style="color: #0000ff">to</span> be evaluated, depending <span style="color: #0000ff">on</span> where you want <span style="color: #0000ff">to</span> put the collection!</pre>
                                                                                                                                                          
                                                                                                                                                          <p>
                                                                                                                                                            <!--CRLF-->
                                                                                                                                                            
                                                                                                                                                            <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: #f4f4f4">&nbsp;</pre>
                                                                                                                                                            
                                                                                                                                                            <p>
                                                                                                                                                              <!--CRLF-->
                                                                                                                                                              
                                                                                                                                                              <pre style="border-top-style: none; overflow: visible; font-size: 8pt; border-left-style: none; font-family: 'Courier New', courier, monospace; border-bottom-style: none; color: black; padding-bottom: 0px; direction: ltr; text-align: left; padding-top: 0px; border-right-style: none; padding-left: 0px; margin: 0em; line-height: 12pt; padding-right: 0px; width: 100%; background-color: white">move-collection $SourceContainerNodeID $collID $TargetContainerNodeID</pre>
                                                                                                                                                              
                                                                                                                                                              <p>
                                                                                                                                                                <!--CRLF--></div> </div> 
                                                                                                                                                                
                                                                                                                                                                <p>
                                                                                                                                                                  Now you’ve got two independent functions and need to combine them into one script.
                                                                                                                                                                </p>
                                                                                                                                                                
                                                                                                                                                                <p>
                                                                                                                                                                  Any questions? Just comment here, send me a mail or contact me on twitter (@david_obrien) 
                                                                                                                                                                  
                                                                                                                                                                  <div style="float: right; margin-left: 10px;">
                                                                                                                                                                    [Tweet](https://twitter.com/share)
                                                                                                                                                                  </div>

