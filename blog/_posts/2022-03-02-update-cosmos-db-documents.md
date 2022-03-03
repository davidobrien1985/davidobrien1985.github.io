---
title: How To Update Millions of Azure Cosmos DB Documents
date: 2022-03-01T00:01:30
layout: single-github
permalink: /2022/03/update-millions-cosmos-db
categories:
  - azure
tags:
  - azure
  - cosmos db
  - saas
  - cloud
github_comments_issueid: 25
---

When working with large data sets you sometimes end up having interesting issues. For example, at <a href="https://argos-security.io" target="_blank">ARGOS Cloud Security</a> we recently had to add a property to all documents within an Azure Cosmos DB container.<br>
Overall, we had to update approx. 4,000,000 documents, and we had to do it as quickly as possible, to minimise the impact on our customers.

## Option 1: Azure Cosmos DB SDK

Initially, I thought about using the SDK. Get the documents that need to be updated, update them one by one and then upload them back to service. However, testing showed that this would take many hours and might be quite error-prone. I did not want to run this from my laptop, so I planned on running the actual code on an Azure Function. This would require a lot of memory, a fairly costly Azure Functions SKU. Testing showed that an initial code version would require 12GB of memory and would probably run for roughly 6hrs.<br>
I decided this was no good solution.

## Option 2: Cosmos DB Stored Procedure

Instead of running code locally or within an Azure Function I wanted to run the code server side, on the Cosmos DB service. Cosmos DB supports the execution of <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/sql/how-to-write-stored-procedures-triggers-udfs?tabs=javascript" target="_blank">Stored Procedures</a> that run within the service and are written in Javascript. I am surely no Javascript developer, but I managed to get it done using plenty of examples and the documentation.<br>
There were just two little problems I had to solve:

- Stored Procedures time out after 5 seconds and have a 4MB page size limit
- by default, they only return 100 results each time, although this is <a href="https://docs.microsoft.com/en-us/javascript/api/@azure/cosmos/feedoptions?view=azure-node-latest#maxItemCount" target="_blank">configurable</a>

So, I had to implement pagination (follow the continuation token) and make sure each time I call the Stored Procedure I return the continuation token so the next iteration of the Stored Procedure knows where to pick up from. However, because of the 5 second timeout I could not go and just have the Stored Procedure loop over the 4,000,000 documents. That would not have worked.<br>
Instead, I wrote a little PowerShell script that can be executed locally or in <a href="https://shell.azure.com" target="_blank">Azure Cloud Shell</a> that executes the Stored Procedure for me.

## Creating the Cosmos DB Stored Procedure

Please check the official documentation on <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/sql/how-to-write-stored-procedures-triggers-udfs?tabs=javascript" target="_blank">Stored Procedures</a> to learn how to create a Stored Procedure.<br>

The following Stored Procedure will execute these steps:

- line 27: query the container for documents that do not have `r.inventoryStatus` defined. Make sure you update this for your use case.
- line 37: for each of the documents without said property it will here create the property and set its value to `active`. Again, make sure you update this for your case.
- It will then, depending on whether there are more documents to work on, continue in the loop (line 47) and if that fails because of the limitations mentioned above (i.e. timeout) it will return the number of documents it updated so far and also the continuation token for the next API call.

{% gist 79fa2d322f082563f566d97e8c7978a3 %}

## Calling Cosmos DB Stored Procedure with PowerShell

Now, how do we call this? I like to use PowerShell, but the concept is the same really no matter how you call it.<br>
Essentially we run a loop for as long as we get a continuation token back from the Stored Procedure. Once that stops we can be assured that all documents have been updated.<br>

> Make sure your container has enough RUs available. The <a href="https://github.com/PlagueHO/CosmosDB" target="_blank">CosmosDB PowerShell module</a> that I am using here has built in retry, but has had some issues during testing for us where the retry would not work and we had to start the script again.

```powershell
$cosmosDbAccountName = ''
$cosmosDbResourceGroupName = ''
$cosmosDbDatabaseName = ''
$collectionId = ''
$storedProcId = ''
$partitionKey = ''

$key = Get-CosmosDbAccountMasterKey -Name $cosmosDbAccountName -ResourceGroupName $cosmosDbResourceGroupName
$cosmosDbContext = New-CosmosDbContext -Account $cosmosDbAccountName -Database $cosmosDbDatabaseName -Key $key

$result =  Invoke-CosmosDbStoredProcedure -Context $cosmosDbContext -CollectionId $collectionId -Id $storedProcId -PartitionKey $partitionKey -Verbose
while ($null -ne $result.continuation) {
    $result =  Invoke-CosmosDbStoredProcedure -Context $cosmosDbContext -CollectionId $collectionId -Id $storedProcId -PartitionKey $partitionKey -StoredProcedureParameter $result.continuation
} 

Write-Host "In total we updated $($result.count) documents."
```

And this is how we updated approx. 4 million Cosmos DB documents for <a href="https://argos-security.io" target="_blank">ARGOS Cloud Security</a> with a new property without any customer impact.

Credit to <a href="https://vincentlauzon.com/2018/06/27/cosmos-db-stored-procedures-handling-continuation/" target="_blank">Vincent Lauzon</a> who inspired a big chunk of this solution.
