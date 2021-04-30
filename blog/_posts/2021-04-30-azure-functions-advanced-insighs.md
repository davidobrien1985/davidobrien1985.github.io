---
title: Advanced Insights on Azure Functions - meet Genie
date: 2021-04-30T00:01:30
layout: single-github
permalink: /2021/04/azure-functions-advanced-insighs
categories:
  - azure
tags:
  - azure
  - azure functions
  - devops
  - cloud
github_comments_issueid: 24
---

I feel like this feature that I am going to talk about here is a real hidden gem and I am not sure how I missed this. I honestly cannot tell you how long it is been around and maybe I am even the last person to learn about it, and if this is the case then this article is purely for me so that I do not forget again.<br>

## Azure Function Metrics

Everybody working on Azure should be familiar with Azure Monitor and Azure Monitor Metrics. The service that allows customers to learn more about the behaviour of their resources by for example showing how much memory or CPU a Virtual Machine is using, how many requests to a Storage Account there have been or how many Azure Functions Executions there have been. You can then draw some nice graphs like this one here.

[![Azure Functions metrics](/media/2021/04/metrics_1.png)](/media/2021/04/metrics_1.png)

These metrics are definitely important (if you use them for meaningful tasks!), but they do not tell the whole story.

## Advanced Azure Functions Monitoring Scenarios

Just a few weeks ago we had some networking issues in our Azure Functions. "What?", I hear you say, "but aren't they serverless?". Hahahaha, hahahaha, yeah... nah.<br>
As part of our application we create many, many outgoing network connections and we saw a quite a few of them fail. We could not see any way of troubleshooting this issue through metrics or logs (we do use Application Insights as well), until one day I stumbled upon "Diagnose and solve problems".<br>
To be fair, this is probably the best-named service on any cloud, anywhere in the universe as this is exactly what this does.

[![Azure Functions Diagnose and solve problems](/media/2021/04/diagnose_1.png)](/media/2021/04/diagnose_1.png)

When you click on it you are greeted by a friendly dialogue where you can select what issues you are having or just ask for some general performance checks. It feels very much like one of those automated phone numbers, "press 1 for Azure Functions network check". This friendly dialogue is called Genie.<br>
Our containers continuously crashed due to those network issues (that ended up being SNAT Port Exhaustion) and in order to actually see information about those crashes we can ask Genie about information.

[![Azure Functions Container Crash](/media/2021/04/container_crash.png)](/media/2021/04/container_crash.png)

Genie can even show us information about the health of our Durable Functions, which I, and my team, find super helpful.

[![Azure Functions Durable Functions health](/media/2021/04/durable-functions.png)](/media/2021/04/durable-functions.png)

I hope you did find this useful. At <a href="https://argos-security.io" target="_blank">ARGOS</a> we use this feature all the time to check the health for more advanced situations.