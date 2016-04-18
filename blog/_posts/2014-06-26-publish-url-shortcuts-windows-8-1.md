---
id: 1840
title: How to publish URL shortcuts to Windows 8.1
date: 2014-06-26T21:36:29+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=1840
permalink: /2014/06/publish-url-shortcuts-windows-8-1/
categories:
  - Deployment
  - Microsoft
  - Windows
  - Windows 8
  - Windows 8.1
tags:
  - deployment
  - Powershell
  - Start Menu
  - Start Screen
  - Windows
  - Windows 8.1
---
A customer of mine asked me to create a new Windows 8.1 Enterprise SOE (golden image, standard image, whatever) and also customise the Start Menu and Start Screen layout.
  
This customer is pretty easy as most of their applications are web apps. Therefor I only have to deploy all the shortcuts to their web applications. Job done. Easy.

I asked the customer to give me all their shortcuts so that I can then copy them to the default user&#8217;s profile during deployment (in this case MDT 2013 stand alone, but that doesn&#8217;t matter).

All the shortcuts looked like this:

> &#8220;%programfiles%\Internet Explorer\iexplore.exe&#8221; <a href="https://www.google.com.au" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://www.google.com.au', 'https://www.google.com.au']);" >https://www.google.com.au</a>

Regular shortcut you&#8217;d think, right?

The special thing here is that this customer also likes to have custom icons for each of their shortcuts, just so that users easily recognise the app they need. For demo&#8217;s sake I created a shortcut to Google.com.au in my environment, it would&#8217;ve also worked with Bing.com or any other search engine of your choice. <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="$wlEmoticon-winkingsmile[2].png" alt="Winking smile" />

<a href="http://www.david-obrien.net/wp-content/uploads/2014/06/image.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/06/image.png', '']);" class="broken_link"><img class="img-responsive aligncenter size-full wp-image-1830" src="http://www.david-obrien.net/wp-content/uploads/2014/06/image.png" alt="image.png" width="369" height="344" /></a>

The Google shortcut in the file system also shows the custom icon.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/06/image1.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/06/image1.png', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1832" src="http://www.david-obrien.net/wp-content/uploads/2014/06/image1.png" alt="image.png" width="445" height="207" srcset="/media/2014/06/image1-300x139.png 300w, /media/2014/06/image1-250x116.png 250w, /media/2014/06/image1.png 784w" sizes="(max-width: 445px) 100vw, 445px" /></a>

I now needed to pin all these custom shortcuts to the Start Screen and then export the Start Screen layout.

# Export and Import custom Start Screen with Powershell

I don&#8217;t want to repeat everything other intelligent community members wrote on this topic, so I will just give you the Powershell cmdlet I used to export the Start Layout:

> Export-StartLayout -As BIN -Path $Servername\CustomStartLayout.bin
  
> Export-StartLayout -As XML -Path $Servername\CustomStartLayout.xml

You only need the BIN file to then use

> Import-StartLayout -LayoutPath .\CustomStartLayout.bin -MountPath C:\

I started pinning the custom shortcuts to Start and when I navigated back to the Start Screen I found this:

<a href="http://www.david-obrien.net/wp-content/uploads/2014/06/image2.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/06/image2.png', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1834" src="http://www.david-obrien.net/wp-content/uploads/2014/06/image2.png" alt="image.png" width="452" height="410" /></a>

Where is my custom icon? It&#8217;s there when I look at the shortcut via &#8220;All Apps&#8221;, but it&#8217;s gone as soon as I pin the app to the Start Screen. Strange.

It took me a while to find the issue, although I can only speculate on the why.

# Shortcuts and Internet Shortcuts

The reason why the shortcuts behaved strange was because they were configured to launch an application, they were actually launching iexplore.exe and that is probably why the live tile thinks it should show the ugly Internet Explorer icon.

There is another type of shortcuts, called Internet Shortcuts, which you can deploy just the same as a regular shortcut by copying the LNK file or via GPP.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/06/image3.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/06/image3.png', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1836" src="http://www.david-obrien.net/wp-content/uploads/2014/06/image3.png" alt="image.png" width="476" height="123" srcset="/media/2014/06/image3-300x77.png 300w, /media/2014/06/image3.png 809w" sizes="(max-width: 476px) 100vw, 476px" /></a>After I created an Internet shortcut, assigned the custom icon and pinned it to the Start Screen it now looks as expected &#8211; nearly.

<a href="http://www.david-obrien.net/wp-content/uploads/2014/06/image4.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/wp-content/uploads/2014/06/image4.png', '']);" class="broken_link"><img class="img-responsive aligncenter  wp-image-1838" src="http://www.david-obrien.net/wp-content/uploads/2014/06/image4.png" alt="image.png" width="482" height="401" srcset="/media/2014/06/image4-300x249.png 300w, /media/2014/06/image4-180x150.png 180w, /media/2014/06/image4.png 748w" sizes="(max-width: 482px) 100vw, 482px" /></a>

The icon works and I can now deploy the custom Start Layout.

## How to change the background colour of tiles?

Last issue that remains, and I still haven&#8217;t found a solution for it, is the background colour of the tiles. For whatever reason they all take that ugly grey-ish background. If there&#8217;s anybody reading this that knows how to change it, that would be very appreciated.

&#8211; <a href="http://twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://twitter.com/david_obrien', '@David_OBrien']);" target="_blank">@David_OBrien</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="deployment,Powershell,Start+Menu,Start+Screen,Windows,Windows+8.1" data-count="vertical" data-url="http://www.david-obrien.net/2014/06/publish-url-shortcuts-windows-8-1/">Tweet</a>
</div>
