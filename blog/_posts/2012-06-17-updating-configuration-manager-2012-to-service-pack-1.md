---
id: 399
title: Updating Configuration Manager 2012 to Service Pack 1
date: 2012-06-17T10:36:05+00:00

layout: single

permalink: /2012/06/updating-configuration-manager-2012-to-service-pack-1/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
  - System Center Configuration Manager
  - Windows 8
tags:
  - ADK
  - ConfigMgr
  - ConfigMgr 2012
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - Microsoft
  - System Center
  - System Center Configuration Manager
  - Windows 8
---
You most probably already know that the “Service Pack 1 Customer Technology Preview 2” for System Center Configuration Manager 2012 has been released a few days ago. If not, here: [http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx](http://blogs.technet.com/b/servicemanager/archive/2012/06/15/announcing-the-availability-of-system-center-2012-sp1-community-technology-preview-2.aspx)

It’s an early sunday morning, the fiancee is still asleep and I wanted to “quickly” update my virtual ConfigMgr 2012 environment to SP1, and got stuck…

# New Prerequisites

As there are new features (see previous article: [http://www.david-obrien.de/?p=369](http://www.david-obrien.de/?p=369)), there are also new prerequisites you need to fulfil before being able to update your site.

![image](/media/2012/06/image2.png "image")

Go download and install the [Windows 8 Assessment and Deployment Kit (ADK)](http://www.microsoft.com/en-us/download/details.aspx?id=28997), this in itself is just under 1MB size but it will download a huge amount of data during installation (approx. 3GB, depending on what features you install).

You also need to run the setupdl.exe (found in “smssetupbinx64”) or download the prerequisites from the GUI. This won’t download the ADK!

It will, for example, download the Silverlight 5 binaries.

If any of your sites have a language pack installed, you will need to uninstall it before updating your site.

![image](/media/2012/06/image3.png "image")

Do this by running setup again and chose “site maintenance” and then “modify language settings”.

# Update the site

Before updating my sites I had a look at the buildnumbers:

![build number](/media/2012/06/image4.png "build number")

The update is quite straightforward, here some screenshots of it:

![image](/media/2012/06/image5.png "image")
![image](/media/2012/06/image6.png "image")
![image](/media/2012/06/image7.png "image")

No errors, only warnings from my virtual environment…
The whole update took about 40minutes (in my virtual environment):

![image](/media/2012/06/image8.png "image")

Updated the CAS:

![CAS updated](/media/2012/06/image9.png "CAS updated")

I don’t want to get into details (that’s for another article), but the Boot images got updated to “Windows 8”.

![image](/media/2012/06/image10.png "image")



