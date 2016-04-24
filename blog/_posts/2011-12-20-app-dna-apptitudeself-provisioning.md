---
id: 236
title: App-DNA AppTitude–Self Provisioning
date: 2011-12-20T18:24:00+00:00
author: "David O'Brien"
layout: single

permalink: /2011/12/app-dna-apptitudeself-provisioning/
if_slider_image:
  -
categories:
  - APP-DNA
  - Applications
  - Citrix
  - Common
  - migration
  - Operating System
  - Windows 7
  - x64
tags:
  - App-DNA
  - APPDNA
  - AppTitude
  - Citrix
---
I just came from a customer project with AppTitude where I faced the requirement that the department that was responsible for the AppTitude environment didn’t want to give the other departments the right to log on to the AppTitude console.

Why? Well, various reasons, all quite understandable!

Number one reason was that they wanted to let every department to the work they were supposed to do, not more. The software department should be responsible for the software installation and the department responsible for AppTitude should bother about analysis and report creation.

## Everybody’s AppTitude – Self Provisioning for everybody

How does one let users or other departments work with AppTitude without really doing anything in AppTitude?

App-DNA created a nice tool called “Self Provisioning Client”. This client can be installed onto any machine (physical or virtual), managed or unmanaged, doesn’t matter.
You only need to follow a workflow now presented to you by Bob (AppTitude admin) and Carla (Software development):

* Carla: copies the install sources into any network share
* Carla: tells (via any way imaginable: call, mail, web-frontend) Bob where to find the install sources
* Bob: opens up the AppTitude console and goes to “Self Provisioning”

![overview](/media/2012/01/overview.jpg "overview")

* Bob: selects the install file, in the folder that Carla just told him, with which the App is going to be installed (e.g.: setup.exe)

![selected app](/media/2012/01/selected_app.jpg "selected_app")

* Bob: if necessary he can change some configurations in the execution profile for this specific application
* Bob: if finished with last minute changes to the execution profile, then press “publish”
** the app’s status changes from ready to published and a description file is being created

![published app](/media/2012/01/published_app.jpg "published_app")

* Bob: the path to the description file has to be sent to Carla, either by pressing “Export” or by pressing “Manifest list”
* the first will give you the opportunity to give Carla a way to do her installation “offline”
* the latter will create a “SelfProvisioning.txt” with the location of the description file</ul>

![export app](/media/2012/01/export_app.jpg "export_app")

* Carla: opens up the “AppCapture.exe” on her client

![appcapture](/media/2012/01/appcapture.jpg "appcapture")

* Carla: enters the path to the description file and presses “Play”

** the description file is read and interpreted by the AppCapture.exe and we now see the configured command line (the .exe) and execution profile (in this case without Before Snapshot!)

![appcapture descending](/media/2012/01/appcapture_desc_read.jpg "appcapture_desc_read")

* after another press on play the exe is launched and monitored

![appcapture install started](/media/2012/01/appcapture_installstarted.jpg "appcapture_installstarted")



* any change to the OS and App will now be monitored until the started install process is terminated and the “After Snapshot” is run
* Carla: when the “After Snapshot” is done she again tells Bob that she’s finished and the App is ready to be imported
* Bob: loads the results and after that the App is ready to be “moved to import” for further processing

![load results](/media/2012/01/load_results.jpg "load_results")
![finished](/media/2012/01/finished.jpg "finished")

** from here on the App is no different than any other MSI

## Benefit of SelfProvisioning

In my opinion the nice thing about SelfProvisioning is that the AppTitude admin doesn’t have to worry about the installation or configuration of applications. This is the sole responsibility of the software department and not the AppTitude admin.
This way the software department can make their applications “AppTitude ready” without access to the AppTitude console.




