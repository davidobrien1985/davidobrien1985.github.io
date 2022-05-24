---
title: Azure Static Web Apps - What happened to my Storage?
date: 2022-05-22T00:01:30
layout: single-github
permalink: /2022/05/azure-static-web-apps-storage
categories:
  - azure
tags:
  - azure
  - static web apps
  - storage
  - devops
github_comments_issueid: 27
---

I recently started developing a new SaaS application and while I was looking for hosting options for this application people pointed me towards <a href="https://docs.microsoft.com/en-us/azure/static-web-apps/overview" target="_blank">Azure Static Web Apps</a> (SWA).<br>
Where before in order to host an app I might have used an Azure Storage Account Static Web hosting and Azure Functions for the APIs or an AWS equivalent (S3 and AWS Lambda) with SWA Azure takes care of hosting the frontend, including CDN, and automatically deploying the backend APIs on managed Azure Functions. The deployment and hosting is all managed via a yaml description file and seamlessly integrates with GitHub Actions or Azure DevOps. I don't even have to deploy the Azure Function App, Storage Account, and I get custom domain support, all for free. <a href="https://azure.microsoft.com/en-us/pricing/details/app-service/static/" target="_blank">Pricing</a> is pretty amazing to be honest.

## Storage is important

Most applications are built using similar building blocks. One very common building block is storage. Files are either being uploaded to an app, the app might create reports that can be downloaded or stores logs as flat files in storage. Whatever it is, storage is almost always involved.<br>
Same is true for this SaaS I am working on. People using the SaaS will be able to click a button and download a PDF, on demand. The idea was to respond to the "button click" with a message to the person acknowledging the action and then asynchronously creating the PDF. It gets stored in an Azure Storage Container as a blob and the requestor gets notified that the file is ready to be downloaded.<br>
This (storing a file from an Azure Function) is super simple using an <a href="https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-blob-output?tabs=in-process%2Cextensionv5&pivots=programming-language-csharp" target="_blank">output binding</a>. When adding this in C# the following package gets referenced in your code: `Microsoft.Azure.WebJobs.Extensions.Storage`.<br>
The code will work just fine when run locally, no issues whatsoever, but local is not the cloud, and we can talk "serverless" as much as we want, we will always have to worry about the infrastructure.<br>
So, once I deployed that code, the app broke. `/sadface`<br>

## Azure Functions Startup Error

[![Azure Function Startup Error](/media/2022/05/dryloc.png)](/media/2022/05/dryloc.png)

```bash
DryIoc.Microsoft.DependencyInjection.DryIocAdapter+<>c__DisplayClass3_0.<RegisterDescriptor>b__0
```

What an annoying error, and not really anything that made sense to me. Especially because the app was fine locally. So why was this happening?<br>
After a lengthy back and forth with Azure Support it turns out that Azure Static Web Apps do not, under any circumstances, like having a dependency on Azure Storage. Any reference to Storage will break the app. The managed Functions in SWA do not have any Storage mapped to them, note also the missing Storage related app configuration on those Functions that we are familiar with from "regular" Azure Functions.<br>
There are two solutions to this problem:

- remove any and all references to Storage from the application. I changed the async action to create the PDF in memory to a synchronous call to offer the download right away to the requestor.
- change the Azure Functions hosting option from "managed" to "Bring your own". However, this also requires the "Standard" SKU for SWA and you will likely pay quite a bit more overall.
