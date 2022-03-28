---
title: Cosmos DB - Defender for Cloud
date: 2022-03-28T00:01:30
layout: single-github
permalink: /2022/03/cosmos-db-defender-for-cloud
categories:
  - azure
tags:
  - azure
  - cosmos db
  - security
  - cloud security
github_comments_issueid: 26
---

For our cloud security product <a href="https://argos-security.io" target="_blank">ARGOS</a> we use <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/introduction" target="_blank">Azure Cosmos DB</a> as our backend database.<br>
Of course, I made sure we had all the common security practices applied. For example, we use managed identities wherever possible to communicate with Cosmos DB, instead of using keys, which have a tendency to leak via code commits for example. We ensure that our Cosmos DB Account is also not accessible by everyone on the internet, using Firewall rules and virtual network integrations.<br>
All of this helps with good security posture and helps to protect from most of the things "we know" about.

## Defender for Cloud - Cosmos DB

What about the threats we do not know about though? We already use Defender for Cloud (formerly known as Security Center) quite heavily from a Threat Protection point of view, and now this is also available (as preview) for our Cosmos DB Accounts.

[![Azure Cosmos DB Defender](/media/2022/03/defender-enable1.png)](/media/2022/03/defender-enable1.png)

For now, this is only available if you are using the SQL API for Cosmos DB. See more on the <a href="https://docs.microsoft.com/en-us/azure/defender-for-cloud/concept-defender-for-cosmos#availability" target="_blank">official docs</a>. The threat types that our databases and our customer data is now protected against are:

- Potential SQL injection attacks:
  - Due to the structure and capabilities of Azure Cosmos DB queries, many known SQL injection attacks can’t work in Azure Cosmos DB. However, there are some variations of SQL injections that can succeed and may result in exfiltrating data from your Azure Cosmos DB accounts. Defender for Azure Cosmos DB detects both successful and failed attempts, and helps you harden your environment to prevent these threats.
- Anomalous database access patterns:
  - For example, access from a TOR exit node, known suspicious IP addresses, unusual applications, and unusual locations.
- Suspicious database activity:
  - For example, suspicious key-listing patterns that resemble known malicious lateral movement techniques and suspicious data extraction patterns.

If any of these events fire we will receive an alert right away and we can quickly investigate the issue.<br>
As Microsoft runs their detections off the service's telemetry and not "in the middle" of transactions there is no performance impact and no change to any code required.

## Enable Defender for Cloud by Default

You can also enable Defender for Cosmos DB by default at the Subscription level. Go to <a href="https://portal.azure.com/#blade/Microsoft_Azure_Security/SecurityMenuBlade/EnvironmentSettings" target="_blank">Defender Settings</a> and enable Defender for all Cosmos DB Accounts.

[![Azure Cosmos DB Defender Plans](/media/2022/03/defender-plans.png)](/media/2022/03/defender-plans.png)

I hope you'll have a much better sleep now that your databases are protected by Defender for Cloud.
