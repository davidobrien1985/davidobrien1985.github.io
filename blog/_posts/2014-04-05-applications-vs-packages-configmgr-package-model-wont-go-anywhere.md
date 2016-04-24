---
id: 1700
title: Applications vs Packages, why the ConfigMgr Package model will not go anywhere
date: 2014-04-05T10:34:06+00:00
author: "David O'Brien"
layout: single

permalink: /2014/04/applications-vs-packages-configmgr-package-model-wont-go-anywhere/
categories:
  - Applications
  - CM12
  - ConfigMgr
  - Configuration Manager
  - SCCM
tags:
  - Applications
  - ConfigMgr
  - Configuration Manager
  - SCCM
  - System Center
---
During my last projects I came across a lot of issues around Software Deployment, mainly with the not-so-new-anymore Application model of Configuration Manager 2012.
Here's a list of issues with Applications I came across and why I think the 'legacy' package model won't go anywhere very soon:

**Applications don't know what a recurrence schedule is**

Packages can be deployed and configured with a recurring schedule. If you want to have your program run on every Monday morning, just configure the recurrence accordingly.
![image](/media/2014/04/040414_2333_1.png)

You can't do that with Applications. The App model doesn't know what a recurrence pattern is.
![image](/media/2014/04/040414_2333_2.png)

It's debatable if Software / Scripts / whatever that need to be run on a schedule could maybe not also be executed via a different mechanism like a scheduled task or startup script or if 'recurring applications' really don't make any sense, but I heard customers asking for it with sometimes good reasoning 😉
One example of such a good reason is the usage of the Powershell App Deployment Toolkit. WHAT? You don't know the Powershell App Deployment Toolkit? Go look here: [https://psappdeploytoolkit.codeplex.com/](https://psappdeploytoolkit.codeplex.com/)

With it you can configure installation deferrals and let the user decide the time of installation. But how do you 're-execute' the Installation at a certain time? Easily done with Packages, just configure the recurrence schedule. With Applications you need to reconfigure a client-setting to get a similar user experience. If the user decides he doesn't want that software installed right now and defers the installation, the Toolkit exits and 'fails'. At the time of the next 'Application Deployment Evaluation Cycle' which is configured via the Client Settings (default once a day), the ConfigMgr client will evaluate the software to not installed and prompt the user again with the installation.

![image](/media/2014/04/040414_2333_3.png)

![image](/media/2014/04/040414_2333_4.png)

# Applications tend to break OSD task sequences

I’ve seen loads of environments where customers thought using Applications inside of an OSD Task Sequence would make sense, and to be quite honest, why shouldn’t it? It’s a supported way of deploying software to machines.

But the sad reality is that most of the times I’ve seen people do it (even in my own lab) the usage of Applications in an OSD TS causes random failures. Usually the most problems occurred when the device that was built resided in a location where it needed to communicate to a remote Management Point. The biggest issue was that the failures were random. Applications used to fail with an evaluation or Policy download error. If you ran the deployment again on that machine it would probably work.

One customer encountered the infamous ‘SSD issue’ Microsoft now works around by implementing a new timeout variable: SMSTSMPListRequestTimeout

The issue here seems to be that after a reboot Applications would normally fail to download any Policies from their Management Point because the Task Sequence was faster than the initialization of the network stack. This doesn’t happen always and mostly on SSDs and in ‘slowly’ connected locations, but it was a pain to troubleshoot.

The variable only exists from SCCM 2012 R2 on. If you are still on an earlier version, implement a ‘wait’ step of about 3-5 minutes after each reboot before every Application install step.

Although using the app model inside a Task Sequence is a completely supported technique, because of these issues I usually don’t use Applications but Packages. That’s one reason why I wrote this script here: [/2014/01/24/convert-configmgr-applications-packages-powershell/](/2014/01/24/convert-configmgr-applications-packages-powershell/)

Using packages always solved all the problems I had with applications.

I know a lot of other people that don’t use the application model AT ALL in Task Sequences. What is your take here?

## Applications are out of your control – are they?

That’s not true. With applications you have far more control over who gets which deployment type or where what is installed, but what if you, in a Task Sequence, want to explicitly choose a Deployment Type? Well, that doesn’t work. That’s not how applications work. I guess there can be a few scenarios where the configured requirements for an application’s deployment type are not yet met inside of a Task Sequence but you want to have that specific Deployment Type installed anyway, but this is probably the exception, not the rule.

If you want to install an application inside of a Task Sequence you must keep in mind that all of the application model’s rules are still valid inside the Task Sequence. That means dependencies and requirements must be met to have a deployment type evaluated to be applicable and get it installed.

If you want to pre-deploy applications to an user’s primary device then just set the User Device Affinity (UDA) in the TS. How? See this blog post by Peter van der Woude: [http://www.petervanderwoude.nl/post/pre-provision-user-applications-based-on-group-membership-during-os-deployment-via-orchestrator-and-configmgr-2012/](http://www.petervanderwoude.nl/post/pre-provision-user-applications-based-on-group-membership-during-os-deployment-via-orchestrator-and-configmgr-2012/)

## Applications cause unnecessary overhead

Many environments have packages that for example copy files, set registry keys, configure local groups, basically do anything but installing software. Some even don’t have any content that’s being copied, these packages only execute command lines. Again, it might be argued that these tasks could be done otherwise. Startup scripts, scheduled tasks, GPO/GPP or whatever you like, but using packages is still not a bad way to go.

Would it be that clever to use the app model for something like that? I don’t think so. For these tasks the app model will absolutely cause unnecessary overhead or maybe even some problems actually creating the application. Detection methods will probably be the biggest problem for something like that. Of course you can use Powershell scripts to create detection methods for every scenario you have, but that’s sometimes just too much for ‘small’ tasks.

## Conclusion

Why did I write this article? That’s what I just asked myself as well. I think that the new app model gives you awesome features to deploy software to machines and users (like granular requirements, supersedence rules), but the app model still gives me a feeling of ‘beta’ stadium. It sometimes still behaves in ways I would not expect it to behave.

It is still not too intuitive to do any reporting or scripting with applications. Feedback to users is still a bit flawed, also I would love to see a “single point of entry” for users to install and uninstall applications. We now have the Application Catalog, Software Center and the company portal. How should a user know what to find where?

I believe what I want to say is, think before running to the app model and neglecting packages. It might be worthwhile while moving away from the package model to check each package if it would be better of as an application or maybe something completely else.

What is your opinion on the app model? What problems did you encounter I did not pick up here?

