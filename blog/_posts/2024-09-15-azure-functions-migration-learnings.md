---
title: Azure Functions - Migration Learnings
date: 2024-09-15T00:01:30
layout: single-github
permalink: /2024/09/azure-functions-migration-learnings
categories:
  - azure
  - azure-functions
  - serverless
  - migration
  - dotnet
tags:
  - azure
github_comments_issueid: 37
---

For the last 4 years we have been running ARGOS Cloud Security, the cloud assessment product for Consultants, on Azure Functions. ARGOS has always been a dotnet core application. Due to Microsoft's decision of "public by default" for most Azure PaaS services and Azure Functions Consumption not supporting any virtual network integration (so much for security first!), we had to deploy ARGOS on Elastic Premium plan. This was a costly affair and we were looking for ways to reduce the cost. We decided to migrate ARGOS to Azure Functions Flex Consumption plan. This post is about the learnings from the migration.<br>
Over the last 2 months we have probably learned more about Azure Functions than we did in the last 4 years. Here are some of the learnings:<br>

- Azure Functions Flex Consumption plan is Linux only, and expects dotnet 8 as a minimum.
  - This means we had to upgrade our application from dotnet 6 to dotnet 8.
  - This was required anyways as dotnet 6 is going out of support in November 2024.

We decided initially to deploy the upgraded application to the existing Elastic Premium plan to ensure that the application was stable. We encountered a several issues during the upgrade:

- Locally, the upgrade to dotnet 8 was a breeze. However, when we deployed the application to Azure Functions, we started seeing complete failures of our app.
  - When running the application locally from Visual Studio we did not encounter any issues, no abnormal memory or CPU spikes.
  - The moment we deployed the application to Azure, the app would not start. A Microsoft Sev A support ticket was raised. Almost 2 weeks of 24/7 debugging and all we were told was "there's some memory or CPU spike happening in your app".
  - We learned that supposedly running the Functions runtime from Visual Studio doesn't actually run the same runtime as Azure Functions. This was a big surprise to us. Support said we should only use the official docker Functions runtime to test our app.
  - "Unfortunately", the app worked without any issues within the docker runtime. The language worker process started without any issues. We were none the wiser as to why the app was failing in Azure Functions.
- We, with Microsoft Support, did notice that AutoMapper was the last thing that was being initialized before the app crashed.
- We improved the loading of AutoMapper and initially still had no luck.
- Even though locally we still only had a memory footprint of way less than 1GB and the app was running on Azure Functions EP2 with 7GB of memory, the app would not start.
- One day, we deployed the app again, and it started working. We still don't know why it started working. We did not change anything in the code or the deployment.

Takeaways:

- Yes, we should have deployed to application to a deployment slot first. We did not do this as we were under the impression that the app was stable.
- When things go wrong before an application starts, it's very difficult to debug. We were not able to get any logs from the app, and even Support had troubles finding out what was going on. Even though we had 24/7 support, really we only had support from one engineer in the US. Everybody else just referred us back to that engineer.
- We are now making sure that rolling back to a previous version is fast and easy.

Once the app was running on the Elastic Premium plan, we decided to migrate to Azure Functions Flex Consumption plan.

- Deploying the new infrastructure was relatively easy using Pulumi.
- Unfortunately, GitHub Actions at the time of writing, is having issues with deploying to Azure Functions Flex Consumption plan. We had to use Visual Studio Code to deploy the app to the new infrastructure.
- We were able to deploy using the Azure Functions extension in Visual Studio Code. This was a breeze. But...
- The app didn't start. The same code that works on Elastic Premium would not work on Flex Consumption. All we got was `WarmUp`. We had no idea what was going on. We had no logs. We had no idea what was going on. There is no access to Kudu for Azure Functions Flex Consumption plan. There were no logs in Application Insights.
- As Flex Consumption is (at time of writing) in preview, we were not able to raise a support ticket. We were stuck. Until one very friendly and helpful Microsoft engineer responded to my tweet and helped out.
- They raised an internal support ticket for us and soon enough we learned about `WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED`. We set that environment variable and the app started working right away. It seems as if that environment variable results in the app starting in a different way by skipping some cold start checks.