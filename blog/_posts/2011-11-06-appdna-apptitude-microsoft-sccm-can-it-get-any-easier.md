---
id: 210
title: 'AppDNA Apptitude &#038; Microsoft SCCM – can it get any easier?'
date: 2011-11-06T18:20:00+00:00

layout: single

permalink: /2011/11/appdna-apptitude-microsoft-sccm-can-it-get-any-easier/
if_slider_image:
  -
categories:
  - APP-DNA
  - Common
  - migration
  - Operating System
  - SCCM
  - x64
tags:
  - APPDNA
  - AppTitude
  - ConfigMgr
  - Netinstall
  - SCCM
  - SCCM 2007
  - SCCM 2012
---
Usually the biggest problem when executing a Launchpad or an AppTitude deployment is getting all the apps into AppTitude. What I mean is, and what I already said in an earlier blog post, no customer has MSIs ONLY! If that were so, then we wouldn’t have any problem importing these apps.

But most of the times we do have these kinds of problems:

* what Apps do I have?
* where are these Apps?
* how are they installed?
You can count yourself lucky if you or your customer is using SCCM 2007, because Apptitude’s got a neat little feature which imports your data from SCCM.


![import sccm](/media/2011/11/import_sccm.jpg "import_sccm")

![import sccm](/media/2011/11/sccm_import.jpg "sccm_import")

You can import your SCCM collections and, most important, your packages. Depending on your environment your working in or your user’s rights, you can chose between connecting to a SCCM Management Point’s WMI namespace or a SCCM Database.

## What do you get?

Hitting “Start Import” will start a connection with either your SCCM site server or the database to import your data. Depending on how many packages you’ve got in your environment this process can take a few minutes.
When import is complete you will find new entries under “Deployed Packages”.

![deployed packages](/media/2011/11/deployed_packages.jpg "deployed_packages")

This looks a bit off the same as we already know it from “Import Applications”, only now, because we imported not only the packages but also the programs, we get the install command and the correct source location as well.

Next we have to chose whether we want those programs that install MSIs via msiexec are being imported via “direct MSI import” or if these programs should also be imported via “install capture”, doing so by ticking or unticking the box “Use direct MSI import”.

As a last step we need to configure which execution profile we’re going to use for those apps that need to be imported via “install capture”. It’s “Snapshot” by default, but we can always configure our own (we’ll get to that later!).
You find your applications ready for import at the usual place from where you can monitor your import process.

## SCCM2012

For now Apptitude only supports import from SCCM2007 databases and does not support SCCM 2012. We’ll have to wait for the next releases to see this feature.

## The Others

But what about the other software deployment tools like Altiris or Netinstall (Frontrange DSM)? Unfortunately they don’t have this nice integration into AppTitude. But surely you can export your packages from any software deployment tool of your choice and import them with the matching command line into AppTitude.





