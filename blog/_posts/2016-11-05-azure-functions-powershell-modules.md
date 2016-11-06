---
title: Azure Functions - BYO PowerShell modules
date: 2016-11-05T12:30:30
layout: single
permalink: /2016/11/azure-functions-byo-powershell-modules/
categories:
  - Azure
tags:
  - serverless computing
  - PowerShell
  - Azure Functions
---

# BYO PowerShell modules to Azure Functions

The previous articles introduced you to Azure Functions and how it executes PowerShell code. This article will explain how  Azure Functions can be extended by bringing your own PowerShell modules.
As we have seen in this [introductory article](/2016/07/azure-functions-PowerShell/) there are already a few PowerShell modules present in the Azure Functions runtime environment but especially when we have to be a bit more special then we quickly end up in a situation where we need access to custom modules.

<!--more-->

## Load a PowerShell module in Azure Functions

For a current side-project of mine (Slack Bot to get aviation related weather and flight status) I wrote a custom PowerShell module.
You can find the code for this here: <https://github.com/davidobrien1985/slackbot_flightinfo>
It does not really matter if the module in question is one that you wrote yourself or one from a 3rd party, the way you will load it will be the same.

Azure Functions is open source and available on [Github](https://github.com/davidobrien1985/azure-webjobs-sdk-script) and this is another example where open source really shines. 
I wondered how modules are handled and by checking out `.\azure-webjobs-sdk-script\src\WebJobs.Script\Description\PowerShell\PowerShellFunctionInvoker.cs` and the method `InvokePowerShellScript` from line 73 onwards we can understand how they build up the PowerShell runtime.
For example we can see that the ExecutionPolicy is set to `Unrestricted`.

The interesting bit starts in line 90 with the method `GetModuleFilePaths` where the Function runtime is told to start looking for all the module files available in the context of the currently running function. This method is implemented in the same file from line 260 onwards.

![azure_functions_modules_dir](/media/2016/11/azure_functions_modules_dir.png)

If you want to follow the code even further you will end up in this file: `.\azure-webjobs-sdk-script\src\WebJobs.Script\Description\PowerShell\PowerShellConstants.cs` in line 9. Now you will understand that Azure Functions will check for the existence of a folder called `modules` underneath the root of each function.
Example:

```
├───.vscode
├───entry
├───flightStatus
│   └───modules
├───get_ICAO_from_IATA
└───metarslackbot
    └───modules
``` 

This same `PowerShellConstants.cs` file will tell us what files the runtime is looking for.

- psm1
- psd1
- dll

If the currently executed Function was the `flightstatus` Function the runtime will run `Import-Module` for each of the files with any of those extensions in the `flightstatus/modules` folder. See `PowerShellFunctionInvoker.cs` line 93 for this.

So to reiterate, custom modules need to be copied into a directory underneath each Function and are always automatically loaded.

## Write a PowerShell module for Azure Functions

> Q: So what does this mean for us when writing our own modules? <br>
> A: Not much, initially.

Writing the module still adheres to the same common principles as always. 

```
.
│   function.json
│   run.ps1
│
└───modules
        PSFlightAware.psd1
        PSFlightAware.psm1
```

Taking my PSFlightAware module as an example I would create the module's manifest with `New-ModuleManifest` and write the `.psm1` file with the module's code.
I then need to copy the module as it is, just the files that are needed for the module, to the function's `modules` directory.

## Performance implications 

Every good and easy thing naturally has its Cons and with the current approach of Azure Functions (as of 05/11/2016 in version 0.8) there are some performance implications when it comes to the behaviour as described above.
All modules are automatically imported, whether you need them or not. There is no known limitation as to how many modules you can potentially have in your modules directory, just always keep in mind that the intent of Azure Functions is to have code execute fast and with as little overhead as possible. 
Let's pretend that you have got a function that accepts input parameters from a Slackbot (did somebody say ChatOps?) and would then deploy a new AWS CloudFormation stack (did somebody say cross-cloud Ops?).

Before actually calling the AWS API I like to validate the user's input for correctness and only if all the input is valid I go and pass the values on to the API.

Sort of like this:

```
If (values all correct) {
  Import-Module AWSPowerShell
  Call API
}
else {
  tell user what is wrong
}
```

If anything was wrong then I would not need to import the module and save time. How much time?

```
Measure-Command {Import-Module -Name AWSPowerShell} | Select-Object Minutes, Seconds, Milliseconds
Minutes Seconds Milliseconds
------- ------- ------------
      0       3         298
```

Sometimes admins like to get a lot of output and either add the `-Verbose` parameter to the `Import-Module` call or add a `$VerbosePreference = 'Continue'` to their script. This would here result in a load time for the AWSPowerShell module of 8 times of the time it takes without the verbose.

```
Measure-Command {Import-Module -Name AWSPowerShell -Verbose} | Select-Object Minutes, Seconds, Milliseconds
Minutes Seconds Milliseconds
------- ------- ------------
      0      24          105
```

If a Slack command does not get a return in under 3,000ms (3s) then it assumes that something went wrong and will throw a timeout error.
Take this idea a bit further. Your Function reacts to a user pushing a button on a website. Even if the actual calculation / execution takes longer you still want to give the user some kind of feedback. Otherwise what do users do when they do not get instant feedback? They click again, and again...

## Maintenance of modules on Azure Functions

If you checked out my slackbot code on Github you will notice that I copied the code to two Functions. This makes maintaining these Functions harder as I am basically manually taking a copy of my module and pasting it into the `modules` folder. Whenever I now make an update to this module I have to remember where I have used this module and I need to remember to change it in all those places hoping to not miss one.
Essentially I now have to not maintain one module, but multiple modules. So to speak.

C# and F# Functions support the delivery of dependencies via a `project.json` file where the developer of a Function can reference nuget packages that will be imported before compiling the code.
For PowerShell this will be impractical as PowerShell does not execute compiled executables but scripts. Hooking up the `run.ps1` with the PowerShellGallery for example would potentially mean that every time a Function executes the module would be downloaded and imported which would make the whole process impractically slow.

A way around this issue would be to not use the "Continuous Integration" (CI) functionality of Azure Functions where you configure Azure to watch your Github repository and automatically update your Functions with new code commits but instead use a CI tool (Jenkins, TeamCity, even Azure Automation or a different Azure Function maybe) that would build your Function by reading a `project.json` file for PowerShell dependencies, package the Function and upload it to Azure.
This will be part of my next hands on blog article.

Until then, enjoy bringing your custom PowerShell modules to Azure Functions.