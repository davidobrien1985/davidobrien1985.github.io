---
title: Azure Functions - the what and why
date: 2016-07-16T01:30:30
layout: single
permalink: /2016/07/azure-functions-what-and-why/
categories:
  - Azure
tags:
  - Azure
  - ARM
  - Microsoft
  - PowerShell
  - serverless
---

# Evolution of IT

Evolution is everywhere, nature has it and so has IT. Every other day there is that next new thing that kind of popped up out of nowhere and where people go like "wow, that changes everything."
IT networks went from disconnected machines to small local networks to the internet, we had datacentres and then the cloud. Cloud started as IaaS and evolved to SaaS and PaaS.
Where before "cloud" you were very constraint in what you were able to do (unforeseen spike in customer transactions on your website? Bye bye website. Bye bye revenue.), you can now scale up as fast as you want, and maybe more importantly, scale down again and not spend money on a huge infrastructure.
What will the next big leap be?
<!--more-->

## Serverless compute - Azure Functions

Really? Let's get one thing out of the way. There is no serverless compute. Your code / app has to run on something and that something is usually a computer somewhere. In the case of this article that somewhere is Azure and whenever marketing people say "serverless compute" they mean an environment that is so abstracted away from you that all you have to worry about is to "bring your code" and get it executed.
All the rest is someone else's job to worry about, here Microsoft.
For the sake of the search engines of the world I'll still use serverless compute a few more times throughout the article though ;)

This article is part 1 of a series of articles on Azure Functions, a "new" PaaS offering on Microsoft's cloud.

What is Azure Functions then?
It means that you use Azure's platform to execute code. You can choose from various languages to write your code:

- Bash
- Batch (really?)
- C#
- F#
- JavaScript
- PHP
- PowerShell (yay!)
- Python

This should pretty much cover most people's preferred language. Having a runtime with PowerShell at hand is, for me, a big deal, as I am still not intelligent enough to really know anything else. (I'm working on Python.)
The awesome thing about Azure Functions (or AWS Lambda for that matter) is that you don't have to manage / maintain any of the infrastructure that you would traditionally need to execute code.
If you are familiar with Azure Automation, then this should be a well-known concept to you.
Functions however go beyond what Azure Automation provides you with. Automation is limited to PowerShell and can really only be triggered by a webhook or the Azure SDK (API or CLI). 
Functions are meant to execute functions, not full-blown workflows. You are expected to write primitives, not monoliths. Your primitive should be fast, light really fast. 

![Azure Functions overview](/media/2016/07/azure_functions_overview.png)

Why fast? You are, like with traditional IaaS, only paying for the time you are actually using your compute. The pricing overview for Functions (date: 16/07/2016) can be found here: <https://azure.microsoft.com/en-us/pricing/details/functions/>
This means, as a small to medium shop, depending on your requirements for Functions, you can get quite a lot of execution time for very small money.
Remember, you are charged by the 100ms. The faster your function, the less you pay. 

## Scenarios that will be covered

Over the next few articles I will go through a couple of scenarios where using Functions would make sense and I will try to show how you can use Functions yourself, as a PowerShell guy.
I will demonstrate how an Azure Functions environment is set up, what it looks like, how to use it and some "good practices" (very much my own opinion, as this feature is REALLY new) around Functions.

**Caveat**
Azure Functions PowerShell is, when this article was written (16/07/2016) still in an experimental phase. This means that things WILL change. Currently there is no documentation on the PowerShell features in Azure Functions available, which is why I will try to capture a few things in this series that I found out through try and error and with the help of the Functions Product Group.

## Open Source

By the way, it's Open Source: <https://github.com/azure/azure-webjobs-sdk-script> 

