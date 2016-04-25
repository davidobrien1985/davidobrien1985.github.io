---
id: 1562
title: Reports not working after upgrade to ConfigMgr 2012 R2
date: 2014-01-13T15:32:30+00:00

layout: single

permalink: /2014/01/reports-working-upgrade-configmgr-2012-r2/
categories:
  - ConfigMgr
  - Configuration Manager
  - Reporting
  - SCCM
tags:
  - ConfigMgr
  - Configuration Manager
  - reporting
  - SCCM
---
At today’s ConfigMgr User Group meeting Wally Mead (Microsoft Product Group) mentioned something to check after upgrading from ConfigMgr 2012 SP1 to R2.

Besides leaving the Setup Screen open (which fellow MVP Peter Daalmans also mentions here: [http://configmgrblog.com/2014/01/07/quick-configmgr-2012-r2-installation-tip-wally-mead/](http://configmgrblog.com/2014/01/07/quick-configmgr-2012-r2-installation-tip-wally-mead/) ) Wally also suggested checking if your reports still work.

# Check reports node in ConfigMgr console

In order to do this, just open up your updated Admin Console and go to your Monitoring – Reporting – Reports node.

![SCCM Reports](/media/2014/01/image9.png)

Then just run ANY report you like, for example “All Collections”. If no window opens, I mean actually nothing happens after selecting “Run”, then the Reportviewer hasn’t been installed correctly. If that is the case, go into your [\\$server\SMS_$SiteCode\tools\ConsoleSetup](file://\\$server\SMS_$SiteCode\tools\ConsoleSetup) share and manually reinstall “ReportViewer.exe”.

If the window opens, but after that nothing happens, then this is maybe no fix for you.

Maybe you are running into this issue and this helps you.



