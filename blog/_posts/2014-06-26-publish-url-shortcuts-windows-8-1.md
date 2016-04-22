---
id: 1840
title: How to publish URL shortcuts to Windows 8.1
date: 2014-06-26T21:36:29+00:00
author: "David O'Brien"
layout: single
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

I asked the customer to give me all their shortcuts so that I can then copy them to the default user's profile during deployment (in this case MDT 2013 stand alone, but that doesn't matter).

All the shortcuts looked like this:

> "%programfiles%\Internet Explorer\iexplore.exe" [https://www.google.com.au](https://www.google.com.au)

Regular shortcut you'd think, right?

The special thing here is that this customer also likes to have custom icons for each of their shortcuts, just so that users easily recognise the app they need. For demo's sake I created a shortcut to Google.com.au in my environment, it would've also worked with Bing.com or any other search engine of your choice. <img class="img-responsive wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="$wlEmoticon-winkingsmile[2].png" alt="Winking smile" />

[<img class="img-responsive aligncenter size-full wp-image-1830" src="/media/2014/06/image.png" alt="image.png" width="369" height="344" />](/media/2014/06/image.png)

The Google shortcut in the file system also shows the custom icon.

[<img class="img-responsive aligncenter  wp-image-1832" src="/media/2014/06/image1.png" alt="image.png" width="445" height="207" srcset="/media/2014/06/image1-300x139.png 300w, /media/2014/06/image1-250x116.png 250w, /media/2014/06/image1.png 784w" sizes="(max-width: 445px) 100vw, 445px" />](/media/2014/06/image1.png)

I now needed to pin all these custom shortcuts to the Start Screen and then export the Start Screen layout.

# Export and Import custom Start Screen with Powershell

I don't want to repeat everything other intelligent community members wrote on this topic, so I will just give you the Powershell cmdlet I used to export the Start Layout:

> Export-StartLayout -As BIN -Path $Servername\CustomStartLayout.bin
  
> Export-StartLayout -As XML -Path $Servername\CustomStartLayout.xml

You only need the BIN file to then use

> Import-StartLayout -LayoutPath .\CustomStartLayout.bin -MountPath C:\

I started pinning the custom shortcuts to Start and when I navigated back to the Start Screen I found this:

[<img class="img-responsive aligncenter  wp-image-1834" src="/media/2014/06/image2.png" alt="image.png" width="452" height="410" />](/media/2014/06/image2.png)

Where is my custom icon? It's there when I look at the shortcut via "All Apps", but it's gone as soon as I pin the app to the Start Screen. Strange.

It took me a while to find the issue, although I can only speculate on the why.

# Shortcuts and Internet Shortcuts

The reason why the shortcuts behaved strange was because they were configured to launch an application, they were actually launching iexplore.exe and that is probably why the live tile thinks it should show the ugly Internet Explorer icon.

There is another type of shortcuts, called Internet Shortcuts, which you can deploy just the same as a regular shortcut by copying the LNK file or via GPP.

[<img class="img-responsive aligncenter  wp-image-1836" src="/media/2014/06/image3.png" alt="image.png" width="476" height="123" srcset="/media/2014/06/image3-300x77.png 300w, /media/2014/06/image3.png 809w" sizes="(max-width: 476px) 100vw, 476px" />](/media/2014/06/image3.png)After I created an Internet shortcut, assigned the custom icon and pinned it to the Start Screen it now looks as expected - nearly.

[<img class="img-responsive aligncenter  wp-image-1838" src="/media/2014/06/image4.png" alt="image.png" width="482" height="401" srcset="/media/2014/06/image4-300x249.png 300w, /media/2014/06/image4-180x150.png 180w, /media/2014/06/image4.png 748w" sizes="(max-width: 482px) 100vw, 482px" />](/media/2014/06/image4.png)

The icon works and I can now deploy the custom Start Layout.

## How to change the background colour of tiles?

Last issue that remains, and I still haven't found a solution for it, is the background colour of the tiles. For whatever reason they all take that ugly grey-ish background. If there's anybody reading this that knows how to change it, that would be very appreciated.

- [@David_OBrien](http://twitter.com/david_obrien) 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>


