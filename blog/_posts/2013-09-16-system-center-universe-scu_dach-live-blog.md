---
id: 1270
title: System Center Universe (SCU_DACH) live blog
date: 2013-09-16T08:02:01+00:00
author: "David O'Brien"
layout: single

permalink: /2013/09/system-center-universe-scu_dach-live-blog/
categories:
  - Community
  - ConfigMgr
  - Configuration Manager
  - Event
  - System Center
  - windows server
tags:
  - Bern
  - Community
  - event
  - SysCtr
  - System Center
---
# Blogging live from SCU_DACH in Bern

During the next two days I'll be busy in Bern (Switzerland) attending the "System Center Universe DACH" event in Bern.

![image](/media/2013/09/20130916_085700.jpg)

I'll try covering all the System Center Configuration Manager, Orchestrator and Powershell tracks. Not much of formatting, just what I hear and deem interesting goes into the article.

Travis Wright (Principal PM Manager at Microsoft) talks about 'The Cloud OS' and Microsoft's strategy to solve Cloud problems.
Did you hear about Microsoft's latest transition? Microsoft is becoming a major "Devices and Services" company.

Challenges to Cloud computing:

* regulations (Data Access)
* Connectivity
  * slow connection speeds
  * unreliable
* Loss of Control
* costs
* infrastructure
  * outage of datacenter
* data

`"Cloud computing is not a location. It is a method of computing."`

Project 'Katal'

* provides services for
  * websites
  * databases
  * service bus
  * VMs
  * virtual networks

![image](/media/2013/09/20130916_094215.jpg)


* New name of Katal -> Windows Azure Pack -> shipping with R2 release next month
  * Windows Azure is now running on the same version of hypervisor as Windows Server 2012 is now on
  * Windows Azure Pack demo by Travis Wright showing a user deploying a new SQL database via "Azure-like" web portal

![image](/media/2013/09/20130916_101533.jpg)

* System Center vNext
  * software designed for the cloud
  * drive consistency of Azure and on prem IaaS / PaaS
  * deliver value add services from the cloud
  * it doesn't matter if you use "Cloud" or not, you can have all the benefits of Cloud in your own datacenter

## 14 tips for building your Orchestrator workflows

Pete Zerger (MVP) and Anders Bengtsson (Microsoft PFE) hands out nice tips and tricks to build your Orchestrator runbooks:

* functions as runbooks
* focus on modularity
* reuse runbooks in other runbooks
* use variables, no hard-coded values
* identify those processes that are worth automating
* Orchestrator runbook tester
* runbooks run on local machine
* context: user executing the runbook tester
* build fault-rolerance into runbooks
* error handling
* Implement logging
* don't use logfiles
* don't use send platform event
* don't use activity specific logging
* these would fill up your database with information you never need
* use a Log Database for logging
* use one dedicated runbook for logging of technical runbook events
* Monitoring
* SCOM management pack
* Infront Orchestrator MP for SCOM 2012 (FREE!!!)
* Develop a runbook promotion process

![image](/media/2013/09/20130916_112711.jpg)
* while exporting runbooks with variables, the export process exports ALL variables in the environment, not only the ones used in the runbook
  * alternative: don't use global variables, use variables in SQL Database
    * implement permissions on runbooks
      * you can only set permissions on runbooks, nothing else
            * Publish permission means "Start Runbook"
            * use SCSM to optimize self-service
                * implement source control & versioning
                    * Orchestrator does not do built-in versioning
                    * Use Powershell!
                        * Orchestrator vNext (the one after R2) will be a Powershell Engine
                        * RUnbook Commander
                            * integrate runbooks as right-click tools in ConfigMgr 2012 admin console
                                * available on TEchNet Gallery
                                * Use community tools
                                    * Microsoft does not support them, but helps you as best as they can!
                                    * check for best practices
                                        * Runbook best Practices Validator (community)
                                            * [www.contoso.se](http://www.contoso.se)
                                                                                                                                    ## SCVMM Networking

I'm now in the SCVMM Networking: From Zero to Hero in two hours session with [Thomas Maurer](http://www.thomasmaurer.ch/) (MVP), [Michel Luescher](http://www.server-talk.eu/) (Microsoft), [Damian Flynn](http://damianflynn.com/) (MVP) and [Kevin Greene](http://kevingreeneitblog.blogspot.ch/) (MVP).

                                                                                                                                     ![image](/media/2013/09/20130916_121104.jpg)

* Official support for NIC Teaming in Windows Server 2012
  * Network QoS policies
  * new in Windows Server 2012 R2
  * SMB Bandwidth limit in 3 categories
  * default
* VMs
  * live migration
  * deploy VMM agents to existing hosts
  * the agent learns the host's config and doesn't even need a restart after install
* Networks:
  * logical network
* configuration of physical network
* VM networks
  * networks the VMs talk to
    * like father and child
      * Father: Logical Network
      * Son: VM Network
    * Logical Switch
      * consist of
        * Uplink & Port Profiles
        * Classification
        * Virtual Switch
      * Network Teaming
      * try using the predefined templates and go on from there
      * QoS: recommendation using weights, but not exceeding a weight of 100
      * Logical switches combine QoS, port profiles, teaming, uplink profiles all in one place
    * IPAM (IP Address Management)
      * centralized management of all DNS / DHCP servers
      * integrates with VMM R2 to manage virtual IP address spaces
      * create a new Network Service in VMM for IPAM
      * audits server configuration changes
      * ability to create virtual network in IPAM and automatically create them in VMM

## What's new in ConfigMgr 2012 R2

Lunch break is over and although I liked the SCVMM part 1, as a ConfigMgr person, I have to attend [Kent Agerlund's](http://blog.coretech.dk/author/kea/) session about "What's new in ConfigMgr 2012 R2".

![image](/media/2013/09/20130916_142947.jpg)

* configure database placement during initial site setup
  * I agree that's nice, but it's better, like Kent said, to pre-create the DB in SQL
* client reassignment
  * "move" client from Site A to Site B
  * no disaster recovery
  * both sites need to be working
* ConfigMgr calculates the "speed" it can use sending out content to distribution points and prioritizes the fastest in following distributions
* cancel content distribution from the console
  * in case you sent out content to places you don't want it to be
* distribution point usage report
  * enables you to see how much data has been requested on a DP
* VHD management
  * create a VHD file to upload from the ConfigMgr Console to SCVMM
  * needs the console to be installed on a Hyper-V host
  * asked if Kent heard anything about plans on supporting "remote creation of VHD files", because I know customers who don't want to install the admin console on their Hyper-V hosts
    * nothing planned (at least nothing known)
* three former MDT steps now integrated into ConfigMgr Task Sequence
  * set dynamic variables
  * run powershell script
  * check readiness
* new deployment type
  * web application
* Trigger VPN connection from ModernStyle applications
  * requires a VPN profile being deployed to the device
  * only for Windows 8.1 (RT) and iOS and Android
* Role based administration for reports
  * built-in
  * nothing to configure

## Managing Microsoft Updates with ConfigMgr 2012 R2

Kent Agerlund is doing another ConfigMgr session about configuring Update Management in ConfigMgr 2012.

![image](/media/2013/09/20130916_155221.jpg)

* Coretech shutdown tool
  * based on last reboot date this tool "forces" a restart
  * [http://blog.coretech.dk/kea/new-version-of-the-coretech-shutdown-tool/](http://blog.coretech.dk/kea/new-version-of-the-coretech-shutdown-tool/)
* Coretech Update Manager 2013
  * tool to deploy Software Updates in a specific order to different collections
  * link follows
* Kent showed some best practices on collection design for Update Management
* You want to know how many updates your ADR will download?
  * in R2: There's a preview button in the ADR creation wizard
  * pre R2: look at the ruleengine.log
    * it will show you in clear text how many updates it will download
* SCUP - System Center Updates Publisher
  * Authoring Tool
  * Publishing Tool
  * Kent has a blog article describing how to configure SCUP and how to deploy 3rd party app updates
    * [http://blog.coretech.dk/kea/the-complete-scup-2011-installation-and-configuration-guide/](http://blog.coretech.dk/kea/the-complete-scup-2011-installation-and-configuration-guide/)
* Secunia Corporate Software Inspector 7 can fully integrate into ConfigMgr console and help you easily deploy update packages
  * [http://secunia.com/vulnerability_scanning/](http://secunia.com/vulnerability_scanning/)

## Day 2 at SCU_DACH

Yesterday closed with a great networking party. I'd like to thank all sponsors and speakers for an awesome first day.
Today starts for me with Pete Zerger's and Anders Bengtsson's session "Iron Chef Cloud", where they are showing some cool demos of Orchestrator and Service Manager.

* how to copy notes from one Service Manager manual activity to another
  * use Orchestrator runbooks
* how to update a SLA
* You should try implementing SCSM along with Orchestrator, at least as a "Orchestratror UI"
* don't use the Orchestrator Web Console, it's crap
  * you can't validate any user input in the web console
* How to Schedule Server Reboots
  * requires SCSM Integration Pack
* demo of a Service Request which reboots a server at a given time, plus checking the server after reboot

My second session is a german (well, swiss guys talking german 😉 ) one where a customer is talking about his real-life experiences with System Center 2012 and Hyper-V virtualization. Heard some interesting figures.

Thomas Maurer now shows us '10 tools every IT Pro should know about'.

* OneNote
  * use OneNote to share notes with your colleagues
  * able to search for text even in pictures and audio files
* Windows Password Recovery
  * replace Utilman.exe in windows\system32 with cmd.exe to reset forgotten password
  * boot into WinRE
  * after that boot into OS and the lower left icon now starts cmd.exe
  * net user changes password
* how to extend the Win + X menu
* User Account Control
  * use icacls.exe to change integrity level of files
* test-netconnection to test a lot of properties of your network connection
* Powershell script to update your sysinternal installation
* desktops.exe to launch parallel desktop processes

Lunch done and next up on stage is [Jeff Wouters](jeffwouters.nl) talking about Powershell Desired State Configuration.

![image](/media/2013/09/20130917_142212.jpg)&nbsp;

## Powershell Desired State Configuration

What is DSC?

![image](/media/2013/09/20130917_143150.jpg)

* based on MOF files
* requires PS4.0 with DSC Engine
* Jeff showed some nice demos where he did some DSC configurations
* install Web-Server Features via DSC to multiple nodes at once
* he plans on writing DSC to provision his whole demo environment
* DSC looks really powerful to enforce configurations in your environment
* this could easily help with compliancy settings in ConfigMgr in the future
* if you're starting with DSC, have a look at the Powershell DSC Cheat Sheet [http://blogs.technet.com/b/stefan_stranger/archive/2013/08/26/powershell-v4-desired-state-configuration-cheat-sheet.aspx](http://blogs.technet.com/b/stefan_stranger/archive/2013/08/26/powershell-v4-desired-state-configuration-cheat-sheet.aspx)

## Configuration Manager automation with Powershell and Orchestrator

There has been a cancellation of a session and I jumped in. A huge opportunity to speak at such a large event.

## Summary

Thanks to [Marcel Zehner](http://marcelzehner.ch/) and itNetX for organizing this great event. There will be a SCU_DACH next year again.
It was great meeting so many experts on System Center topics and talking with them.
As far as I know all the sessions got recorded and will be put online soon.



