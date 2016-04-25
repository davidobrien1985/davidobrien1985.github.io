---
id: 480
title: Deploy RES WorkspaceManager 2012 Client with Configuration Manager 2012
date: 2012-09-28T15:55:49+00:00

layout: single

permalink: /2012/09/deploy-res-workspacemanager-2012-client-with-configuration-manager-2012/
categories:
  - automation
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - RES
  - SCCM
tags:
  - automation
  - ConfigMgr2012
  - Configuration Manager
  - Configuration Manager 2012
  - RES
  - SCCM
  - SCCM 2012
  - Workspace Manager
---
A quick article, as I’m in the middle of building my demo RES environment and wanted to include the RES Workspace Manager 2012 client in my Operating System Deployment for my demo machines in MS System Center Configuration Manager 2012 SP1 (beta).

# Application or Package?

With ConfigMgr 2012 we now have the option to create Applications. Applications are much more intelligent than Packages, which are nearly as intelligent as a stone.

Furthermore I believe that “Packages” are quite legacy.

That’s why I’m going with ‘Application’. One more reason is that the RES WM Client installer comes as an MSI and creating an ‘application’ out of an MSI really is as easy as it gets.

# Create the Application

Copy the RES-WM-2012.msi to a share of your choice and make sure that you can access it from your ConfigMgr client.

Start creating a new Application, it’s really just a few clicks.

![RESWM Application](/media/2012/09/RESWM_Application_11.jpg "RESWM_Application_1")

In the next window you are asked to further configure the installation.

![image](/media/2012/09/image6.png "image" )

My installation program looks like this:

`msiexec /i "RES-WM-2012.msi" DBTYPE=MSSQL DBSERVER=SQL01 DBNAME=WorkspaceManager DBUSER=WorkspaceManager DBPASSWORD=%Password% /qn`

For more information on deploying the Client, refer to the Admin Guide on ressoftware.com: [http://tinyurl.com/c9nurso]("http://tinyurl.com/c9nurso" http://tinyurl.com/c9nurso)

# Install and uninstall

That’s it! Now all you need to do is either integrate the application into a Task Sequence or deploy it directly to a collection and the receiving machine will install the Client and show up in the RES WM console right away.

Same goes for uninstall. Unfortunately the client won’t get deleted in the RES Database, this is something I will have to build myself.




