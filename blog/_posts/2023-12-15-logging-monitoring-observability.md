---
title: Logging, Monitoring and Observability - Same same, or different?
date: 2023-12-14T00:01:30
layout: single-github
permalink: /2023/12/logging-monitoring-observability
categories:
  - cloud
tags:
  - logging
  - monitoring
  - observability
github_comments_issueid: 33
---

Understanding the nuances of system management is crucial for maintaining efficiency and reliability.<br>
Three key concepts – monitoring, logging, and observability – play pivotal roles in this domain. While they are often used interchangeably, each serves a unique purpose in cloud management, and my pedantic inner-person tends to come out at that point.<br>
This article introduces these concepts, exploring their differences, interrelations, and collective importance in the cloud.

## What is Monitoring?

Monitoring in cloud computing involves continuously tracking and analysing the performance and health of cloud resources. It's similar to all the gauges in a car, providing real-time insights into how well your cloud systems are functioning.<br>
Key metrics like CPU usage, network bandwidth, and memory utilisation are monitored to preemptively identify issues and ensure optimal performance.<br>
Tools like Amazon CloudWatch or Azure Monitor offer comprehensive monitoring solutions, enabling cloud admins to keep a close eye on their infrastructure. This happens pretty much automatically, we just need to configure where those metrics should be stored.

## What is Logging?

Logging, on the other hand, is the process of recording events and transactions that occur within your cloud environment and applications. These logs serve as a detailed chronicle of activities, offering insights into system behaviour, user actions, and any anomalies.<br>
Whether it's tracking API calls or recording system errors, logs are invaluable for debugging and post-incident analysis.<br>
Tools like ELK Stack (Elasticsearch, Logstash, Kibana), Splunk, Azure Log Analytics, or similar, provide powerful logging capabilities, transforming raw data into actionable intelligence.

## What is Observability?

Observability extends beyond monitoring and logging. It's a comprehensive approach to understanding cloud systems, emphasising the importance of telemetry data (metrics, logs, and traces) to gain deep insights.<br>
Observability enables you to answer not just what is happening within your systems, but why it's happening. It's about making the system's internal states observable from the outside, allowing for more effective problem-solving and optimisation.<br>
Solutions like Prometheus for metrics, combined with Jaeger for tracing, illustrate the multifaceted nature of observability tools. Cloud native solutions like Azure Application Insights or AWS CloudWatch and X-Ray offer tightly integrated services with the cloud platform that are easy to onboard to.

## Comparison

While monitoring provides immediate insights into system health, logging offers a historical record of events, and observability presents a holistic view of the system's internal state.<br>
Each has its strengths and limitations.<br>
Monitoring alone might tell you that a system is underperforming, but not why.<br>
Logging can offer details on events but lacks real-time analysis.<br>
Observability brings depth and context, but requires more sophisticated tooling and expertise.<br>
The true power lies in their integration, offering a full spectrum of insights for robust cloud application management.

## Poo in, Poo out

As with most other things it is important to know how to ask the right questions. What is it that one wants to know about an application? I strongly believe this is the most important question. What does it mean for an application to function normally?<br>
I always wonder when I see infrastructure alerts that fire when CPUs go above 70% usage. In the cloud, that's probably where you want CPU and memory to be at, otherwise you sized your services too big.<br>
Also, is that a good information point to identify if something wrong is going on in your application? Really, that's what we should care about, no? The application running on top of whatever infrastructure was deployed.<br>
As I sometimes tell people, bad input means bad output, or something along those lines. If we don't know what to ask, the info we get will likely tell us nothing.<br>
What do you think?