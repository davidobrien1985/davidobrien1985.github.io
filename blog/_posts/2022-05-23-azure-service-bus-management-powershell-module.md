---
title: Azure Service Bus PowerShell Module
date: 2022-05-22T00:01:30
layout: single-github
permalink: /2022/05/azure-service-bus-management-powershell-module
categories:
  - azure
  - powershell
tags:
  - azure
  - service bus
  - powershell development
  - devops
github_comments_issueid: 28
---

I recently worked with Azure Service Bus again. Service Bus was the messaging system of the microservice we were building for a customer. As part of that design we needed to test the performance of our application and we needed to make this simple, and flexible.<br>

## Azure Service Bus PowerShell Module

Our tests consisted of adding and removing messages onto Azure Service Bus Topics, many of them. It was okay for those messages to be all identical.<br>
Unfortunately, the `Az.ServiceBus` PowerShell module does not contain any cmdlets to send a message to a topic, and also none to "delete" them. So I got to work and developed my own module.

> Tl;Dr find the module <a href="https://github.com/davidobrien1985/AzureServiceBusManagement" target="_blank">here</a>

For now, the module consists of only two public cmdlets:

- `Send-SbTestMessage`
  - Send a message once or many times over and over to your Service Bus Topic
- `Receive-SbMessage`
  - Receive a single message or many messages. The received message will also be "deleted" from the Topic.

### Authentication

This module depends on an authenticated user session that has access to the Service Bus, depending on the cmdlet used the `Azure Service Bus Data Receiver` or `Azure Service Bus Data Sender` role is required.<br>

#### Special case: Azure Cloud Shell

Whenever I can I recommend people use <a href="https://docs.microsoft.com/en-us/azure/cloud-shell/overview" target="_blank">Cloud Shell</a> to interact with their Azure cloud. For this module though there is a requirement for a user to be able to get an Azure Bearer token for a specific API endpoint. This usually works well locally, but because Cloud Shell by default uses MSI (Managed System Identity) to authenticate to Azure there is an extra step required for this module to work.

`Connect-AzAccount -DeviceCode`

This will ensure one is properly logged in to a session and won't get the following error message:

```
ManagedIdentityCredential authentication failed: Service request failed.
Status: 400 (Bad Request)
```

## Installation

The module is easily installed from the PowerShell Gallery using the following simple one-liner:

`Install-Module -Name AzureServiceBusManagement -Scope CurrentUser`

## PowerShell Runspaces

I attempted to develop the module with performance in mind. PowerShell Runspaces are being used to parallelise the sending or retrieving of messages. Service Bus itself should be absolutely fine with the amount of messages per second one sends or requests from it, so I felt this was good design.

## Feedback / Contribution

Feel free to leave feedback here, on the GitHub repo <a href="https://github.com/davidobrien1985/AzureServiceBusManagement" target="_blank">itself</a> or get in touch with me on Twitter.
