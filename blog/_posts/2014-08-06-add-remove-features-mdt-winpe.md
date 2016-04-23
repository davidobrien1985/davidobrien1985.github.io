---
id: 1894
title: Add or remove features in MDT WinPE
date: 2014-08-06T15:56:35+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=1894
permalink: /2014/08/add-remove-features-mdt-winpe/
categories:
  - automation
  - Deployment
  - MDT
  - Windows
tags:
  - automation
  - DISM
  - FeatureNames
  - MDT
  - MDT 2013
  - WinPE
  - XML
---
Not going too deep here, just something I found the other day.

In your MDT 2013 Deploymentshare, if you go to the share's properties, you will find the WinPE Tab and the WinPE's features:

![image](/media/2014/12/image11.png)

In here you can add components to your boot images. These components are either in _C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools_ (like DaRT: [http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx](http://www.deploymentresearch.com/Research/tabid/62/EntryId/131/Adding-DaRT-8-1-from-MDOP-2013-R2-to-ConfigMgr-2012-R2.aspx) ) or in your ADK install directory here: _C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs_

If you take a look at the latter, you might see that there are components in there that don't show up in that list in your MDT Deploymentshare, for example WinPE-FMAPI.cab (File Management API).

Why is that?

That list is being built off of an XML file (like MDT uses a lot of XML files), which is _C:\Program Files\Microsoft Deployment Toolkit\Bin\FeatureNames.XML_

![image](/media/2014/12/image12.png)

That file lists all the components MDT knows how to handle (don't know how to else say it) and also defines whether or not that component will be included or excluded in that list. Obviously, WinPE-FMAPI is excluded (don't know why!).

If you want to have it in your GUI as a component you can add and maybe at the same time take away the possibility to add some language packs, just change the XML to this:

![image](/media/2014/12/image13.png)

Restart your MDT Deployment Workbench, go back to the Deploymentshare's properties and be happy ;-)

![image](/media/2014/12/image14.png)

Have fun deploying your WinPEs!

- [David](http://www.twitter.com/david_obrien)