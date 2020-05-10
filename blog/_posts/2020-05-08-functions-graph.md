---
title: Query Azure Subscriptions using Resource Graph and Functions
date: 2020-05-08T00:01:30
layout: single-github
permalink: /2020/05/azure-functions-resource-graph
categories:
  - azure
  - serverless
  - graph
tags:
  - cloud
  - devops
  - functions
  - azure resource graph
github_comments_issueid: 16
---

I have been working on a pretty big project lately where I need to query information about many, and I mean many, subscriptions and their resources and then respond to that information.<br>
For a use case like this the [Azure Resource Graph](https://docs.microsoft.com/en-us/azure/governance/resource-graph/overview){:target="_blank"} is a great fit as it is super fast in searching massive amount of resources and querying them based on our requirements.

## Azure Resource Graph

A quick tl;dr of Azure Resource Graph, in case you have not used it before.

> Azure Resource Graph is a service in Azure that is designed to extend Azure Resource Management by providing efficient and performant resource exploration with the ability to query at scale across a given set of subscriptions so that you can effectively govern your environment. These queries provide the following features:
  * Ability to query resources with complex filtering, grouping, and sorting by resource properties.
  * Ability to iteratively explore resources based on governance requirements.
  * Ability to assess the impact of applying policies in a vast cloud environment.
  * Ability to detail changes made to resource properties (preview).

In my case I need to execute Azure Resource Graph queries inside of [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview){:target="_blank"}.<br>
The results of those queries will later on be output onto message queues.

## Azure Function to query Resource Graph

I usually write Azure Functions in python, not because I am an awesome python developer (far from it to be honest), but because I think in the "serverless" / "Functions as a Service" world there is a lot more python and NodeJS going on than other languages. Anyways...<br>

```python
import logging
import os
import azure.functions as func
import azure.mgmt.resourcegraph as rg
from azure.mgmt.resourcegraph.models import QueryRequest, QueryRequestOptions, ResultFormat
from azure.common.credentials import get_azure_cli_credentials
from azure.mgmt.resource import ResourceManagementClient, SubscriptionClient
from msrestazure.azure_active_directory import MSIAuthentication

def main(mytimer: func.TimerRequest) -> None:
    if "MSI_ENDPOINT" in os.environ:
        credentials = MSIAuthentication()
    else:
        credentials, *_ = get_azure_cli_credentials()

    subscription_client = SubscriptionClient(credentials)
    subs = [sub.as_dict() for sub in subscription_client.subscriptions.list()]
    subs_list = []
    for sub in subs:
        subs_list.append(sub.get('subscription_id'))

    client = rg.ResourceGraphClient(credentials)
    options = QueryRequestOptions(result_format=ResultFormat.object_array)

    request = QueryRequest(subscriptions=subs_list, query="resources | where type == 'microsoft.storage/storageaccounts'| where properties.supportsHttpsTrafficOnly == 'false'", options=options)
    sa = client.resources(request)
    for resource in response.data:
        logging.info(resource['id'])
```

This is a [timer triggered](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer?tabs=python){:target="_blank"} Azure Function and is not integrated into any other output bindings, purely used to demonstrate this use case.<br>
The code here also supports local testing by either using the Function's managed identity (`MSI_ENDPOINT`) or the local azure credentials.<br>
Python has a really nice [SDK for Azure Resource Graph](https://docs.microsoft.com/en-us/python/api/azure-mgmt-resourcegraph/?view=azure-python){:target="_blank"} that is super simple to use.

### Python SDK for Azure Resource Graph

Things to note:

* Azure Function needs a managed identity with permissions to read the resources, refer to the [documentation](https://docs.microsoft.com/en-us/azure/governance/resource-graph/overview#permissions-in-azure-resource-graph){:target="_blank"}
* this Function will query **all** subscription the identity has access to, see the `subs_list` object
* the `QueryRequest` contains the actual Resource Graph query based on the powerful KQL syntax
  * I highly recommend checking out the [Azure Resource Graph Explorer](https://docs.microsoft.com/en-us/azure/governance/resource-graph/first-query-portal){:target="_blank"} to build those queries

This Function including the query takes around 2s to execute.

[![azure function monitor insights](/media/2020/05/azure_function.png)](/media/2020/05/azure_function.png)

Obviously, I use pulumi to deploy these Azure Functions (there will be dozens of them in the end) and as of late I also use GitHub Actions to preview and deploy code changes from my repo.

[![pulumi github actions](/media/2020/05/pulumi_gh_actions.png)](/media/2020/05/pulumi_gh_actions.png)

What use cases do you use Azure Resource Graph for? Do you use it in Azure Functions? Let me know in the comments below.