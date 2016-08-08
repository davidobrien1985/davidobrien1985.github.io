---
title: Azure Functions - Continuous Integration
date: 2016-08-04T01:30:30
layout: single
permalink: /2016/08/azure-functions-ci/
categories:
  - Azure
tags:
  - Azure
  - ARM
  - Microsoft
  - PowerShell
  - serverless
---

# Continuous Integration with Azure Functions

After playing around a bit with Azure Functions over the last few articles it is now time to do it properly.
So far we have logged on to the Azure portal and navigated to the Functions App (<https://functions.azure.com>). We then selected the Function and edited it live in the online portal. <br>
Nice experience to get started quickly, but if your app consists of multiple functions and if you want to follow best practices and have your code in source control, then we need to approach this product differently.

<!--more-->

## I've got the Function - now what?

I usually develop my PowerShell code locally on my laptop (one reason why I went back to a Windows laptop actually) and then push the code to a git repository (either Github or Gitlab). <br>
So with our code finalised on my laptop and pushed to git, how do I get it into Azure? 
Azure Functions, or better, the Web App surrounding the Azure Function can integrate with multiple source code repositories. This can be a VSTS repository, a Github repo or a local Azure git repository. <br>
For this article I am going to demonstrate integration with Github.

## Git folder structure

The Function App expects a specific folder structure to identify separate functions. <br>
Every function needs to be in its own subdirectory and needs to consist at least of the two following files.

- `function.json`
- `run.ps1`

Azure will create a function for each subdirectory it detects. This is shown in the following two screenshots.<br>

![Azure Function CI Folders](/media/2016/08/git_structure.png)
<br>
![Azure Function](/media/2016/08/azure_functions.png)

## function.json

We have not yet spoken about the `function.json` file, but, as you can imagine, this is the metadata for each Azure Function.
Microsoft has released the following developer reference for the `function.json` file: <https://azure.microsoft.com/en-us/documentation/articles/functions-reference/> <br>
Refer to this link for latest documentation. <br>
In the Azure console you can inspect your files by selecting the Function and then clicking on the `View files` link under the code.

![Azure Functions view files](/media/2016/08/azure_function_view_files.png)

Azure will automatically read in the file and create a Function according to the configuration with the correct trigger (if any), input and output parameters and any other configuration available at the time you are reading this. 

## Github and Azure Functions

Setting everything up with an already existing Github repository is a matter of 1-2 minutes and really not complicated. I here assume that you have already pushed your local code to a Github repository (both private and public are supported). <br>
In the Azure portal, inside of your Function App, select the `Function app settings`.

![Azure Function app settings](/media/2016/08/function_app_setting.png)

Now select `Configure Continuous Integration` and walk through the required settings like selecting the type of source code repository (Github, local git, VSTS, etc), which repository and which branch to deploy from (I deploy from `master` branch). <br>
Azure will also ask you to authorise it to access your repository. In most cases it automatically knows how to do this, so this should not be an issue.

![Azure Functions Github](/media/2016/08/azurefunctions_ci.png)

Each Function App can only be deployed from one source code repository, obviously. <br>
As soon as the connection is set up Azure will do an initial sync with it and in under a minute you should already see all your functions.

### Azure Functions CI logs

Should something be not the way you expected it to be, Azure will provide you with log files of each "CI sync". 

![Azure Functions Deployment logs](/media/2016/08/azure_functions_deployment_logs.png)

Every commit to your repository, or rather to the branch you selected in your deployment, will trigger a new deployment to Azure Functions and will show up in the portal, including the deployment log files, duration of deployment and "reason", which is your commit message. <br>
Should you ever need to revert a `git commit` you can even use a `git revert` and Azure will happily pick up your change.

![Azure Functions git revert](/media/2016/08/azure_functions_git_revert.png)

I have not yet tested rewriting git history, but I rarely do this anyway (who rewrites history on a public branch???), so not too dramatic.

## Conclusion

The whole CI setup is really easy and fricking fast. I love it and have already set it up for all my demo Functions and if you don't already have a CI/CD server in place for web apps then I definitely recommend checking this out.
In one of my next articles I will check out the "Performance Test" feature which is currently in public preview and is able to run automated performance tests against your API/Function with every commit. Sounds awesome? I think so too. So this is high on my "to do list". 
