---
title: Azure Functions - KUDU console and API
date: 2016-07-31T01:30:30
layout: single
permalink: /2016/07/azure-functions-kudu/
categories:
  - Azure
tags:
  - Azure
  - ARM
  - Microsoft
  - PowerShell
  - serverless
  - KUDU
---

# KUDU - advanced console for Azure Functions

In [part 1](/2016/07/azure-functions-what-and-why/) I introduced the Azure Functions service to you and briefly explained what serverless computing means. In [part 2](/2016/07/azure-functions-PowerShell/) I further explained what the runtime environment of Azure Functions looks like and showed an example of a small PowerShell based Azure Function.
This part will demonstrate the KUDU console. An alternative way to to manage your Azure Functions runtime environment.

## Project KUDU

The idea behind a PaaS offering is that you do not have to worry about anything that you should not need to worry about, like the operating system or just stuff in general that does not give you actual business benefit.
However, sometimes you do need to access the actual environment you are running code on, usually those are the moments you are either developing a new solution or you need to troubleshoot something that went wrong.
KUDU was developed as a way to access a Microsoft Azure Web Apps environment, which includes Azure Functions, as this runs on Web Apps.
With KUDU you can get access to log files, environment information/variables and also the actual file system on the runner instance that was assigned to your Azure Function.

## Accessing KUDU via web browser

Accessing your KUDU console is easily done via the following URL: `https://dotest.scm.azurewebsites.net`
Replace `dotest` with the name of your web app which can be found here:

![Azure Function](/media/2016/07/functions_name.png)

Upon login you will get some general information about your Azure Web Sites environment. Just to reiterate, Azure Functions run as part of Azure Web Sites. This will be a lot clearer in a minute.

![Azure Function KUDU](/media/2016/07/azure_functions_kudu.png)

From here you can access the environment information including what OS you are running on (at the moment this is Windows Server 2012, 6.2.9200.0), what environment variables you have access to and a lot lot more.

## Troubleshooting your environment

A very, very handy aspect of KUDU is that it will give you actual file system access to your Function environment via a shell by browsing to `https://dotest.scm.azurewebsites.net/DebugConsole/?shell=powershell` (again, replace `dotest` with your app's name).
This is something a lot of AWS Lambda users "miss", as currently the only way to access the underlying system is "by executing a function that accesses the system".
From this online PowerShell and the interactive file system browser you can start navigating and exploring the environment your Functions will run in.   

![Azure Function KUDU PowerShell](/media/2016/07/kudu_powershell.png)

If you are familiar with Internet Information Services (IIS) then this will not be new to you. You are browsing a shared (or dedicated, depending on your App Service Plan) IIS instance.
Browse to `D:\home\wwwroot` and you will see all your already configured functions as subdirectories with at least two files in each folder, by default a PowerShell Function will have a `run.ps1` and `function.json`. 
The `function.json` file is the file that describes your function (input/output params, authentication, names, etc) and the `run.ps1` is the file that by default contains your PowerShell code.
Depending on the nature of your function you might use this shell to execute your function from here and test it or temporarily create some content to make sure everything is fine.
In my opinion this is a really neat way of getting access to the actual environment without constantly updating and redeploying your code. Let's face it, even with serverless computing you still sometimes need to access your server, even if it's only during development phase.

![Azure Function KUDU Diagnostics](/media/2016/07/kudu_diagnostics.png)

## Advanced troubleshooting

As you can see in above screenshot there are way more tools available to make sense of your web app environment which I will cover in one of the next articles.

More info on KUDU can be found here: <https://blogs.msdn.microsoft.com/benjaminperkins/2014/03/24/using-kudu-with-windows-azure-web-sites/>
The official wiki is here: <https://github.com/projectkudu/kudu/wiki>