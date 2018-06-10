---
title: Configure diagnostics on Microsoft Azure SQL
date: 2018-06-10T12:01:30
layout: single
permalink: /2018/06/azure-sql-diagnostics/
categories:
  - Azure
  - cloud
tags:
  - azure
  - arm
  - azure resource manager
  - cloud
  - devops
---

# Azure SQL - Logs and metrics

Right click - deploy. <br>
Copy a file to the server. <br>
Lift and shift your on-premises server to the cloud. <br>
What do these practices usually have in common? <br>
Yes, the lack of production readiness in the cloud. Lack of service logging and metrics collection. <br>
Something as important as this is usually either overlooked, not done at all, or overcomplicated, by using 3rd party tools that are "cloud-ready", all you need to do is just install this agent here on all your machines so it can forward data to this other server which then forwards all the data to another server. Wow! <br>
Azure makes log and metrics collection super easy on most services, with an almost turnkey solution to forward logs and metrics to an Azure Storage Account, Event Hub or Log Analytics. <br>
All three targets should be an ideal source for any cloud based SIEM tool to ingest data from, if you decided to use a 3rd party.

## Azure SQL diagnostics

Continuing on from my last technical article on [deploying and configuring Azure SQL](/2018/05/azure-arm-sql/) this article will focus on configuring the diagnostic settings on an Azure SQL database. <br>
After successful deployment of an Azure SQL database you will find the `diagnostics` tab to show the following content.
<br>
![azure-sql-diagnostics](/media/2018/06/logs_metrics.png)
<br>
With a bit of digging I found out that the diagnostics setting is a nested resource of type `providers/diagnosticSettings` on the `Microsoft.Sql/servers/databases` resource, and not just there, but on every other resource that supports diagnostic logs and metrics. <br>
So, in the end, to configure my Azure SQL databases to forward all of the above logs and metrics to a storage account I had to add the following snippet to each database resource. <br>
Now ingesting that data into a SIEM becomes super easy.

{% gist c16470b2a4a7e1971451e037eb381a68 %}