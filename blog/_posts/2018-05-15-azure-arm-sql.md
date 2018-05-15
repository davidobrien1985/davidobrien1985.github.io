---
title: Deploy and configure an Azure SQL database with ARM template
date: 2018-05-15T12:01:30

layout: single
permalink: /2018/05/azure-arm-sql/
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

# Deploying an Azure SQL database

I just recently had to deploy an Azure SQL database and was faced with a strange issue, none of the documentation seemed to tell me the whole story.<br>
My goal was to deploy an actual production ready Azure SQL database, not just a demo environment which all the blogs or documentation that I could find seemed to be targeting. <br>
What do I mean by this? <br>
I needed a multi-region Azure SQL, geo-replicating, with "Long Term Retention" (LTR) policies, with "Auditing", and with Azure AD integration configured. All of this deployed and configured via Azure Resource Manager (ARM) templates. Not too much to ask for, right? <br>

## First stop - documentation

Like every good infracoder I went to the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/servers) first and was a bit disappointed. I could see how to deploy the SQL server, how to deploy the databases, but neither how to configure the Long Term Backup Retention policies nor the Azure AD integration.<br>
I found some PowerShell examples, but they were either outdated or just wouldn't work.

## Debug to the rescue

If you don't know [resources.azure.com](https://resources.azure.com) then two things are true, you're missing out and you won't find the full answer there either. Sorry.<br>
There is a PowerShell cmdlet to _get_ the Long Term Retention policies, at the time of writing this article the _set_ seems to have a bug. That cmdlet is [Get-AzureRmSqlDatabaseLongTermRetentionPolicy](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-long-term-backup-retention-configure#use-powershell-to-configure-long-term-retention-policies-and-restore-backups) and when run with the `-Debug` switch it, and all other AzureRm cmdlets for that matter, will print out *ALL* the API calls that are being made. From that information I could derive the required `type` which was required for the LTR policies, plus the required properties.
To get there I manually configured what I wanted via the UI, called the `Get-AzureRmSqlDatabaseLongTermRetentionPolicy` cmdlet against that DB server and et voila, done.<br>
The AAD implementation was a bit easier as there is a working PowerShell cmdlet `Set-AzureRmSqlServerActiveDirectoryAdministrator` that I was able to use and through the `-Debug` switch again figure out what to reference in the ARM template.<br>

## ARM template to deploy Azure SQL

Unfortunately, the documentation for Azure SQL wasn't of much help, so take all of my code with a grain of salt. It works, but it also might stop working at any given time, shouldn't, but might.<br>
Deploying this template *WILL* incur cost! Other than that, use it, feed it with parameters and have fun!

{% gist 3b6a438150f015a5d9ff5784a0ec64ba %}