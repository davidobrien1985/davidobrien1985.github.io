---
title: Building a Multi Regional Web Application with Azure Front Door
date: 2019-07-10T00:01:30
layout: single-github
permalink: /2019/07/multi-regional-azure-front-door
categories:
  - azure
tags:
  - cloud
  - azure
  - azure-front-door
  - multi-region
github_comments_issueid: 7
---

A recent project with a very interesting company and an even more interesting product required us to build an architecture for their app that enabled a global deployment into a large number of Azure regions and have all regions serve requests independently from other regions, at least at the web layer.<br>
A requirement was also to go "all in" on Azure and utilise the platform as much as possible.

## Application architecture

For the purposes of this article we will work with the following application architecture (which only shows three regions).

![azure application architecture](/media/2019/07/app_arch.png)

[Azure Front Door](https://azure.microsoft.com/en-au/services/frontdoor/) (AFD) is used as the first entry point to the application and Azure environment. Front Door was chosen because of its awareness of HTTP workloads, which fits this application perfectly. It does global load balancing, URL based routing and has WAF technology baked in to it.<br>
From here on AFD routes a user's request to the most appropriate region, based on latency, region health and other checks, and sends the request to the region's [Azure Firewall](https://azure.microsoft.com/en-au/services/azure-firewall/), another fully managed Azure networking service.<br>
Azure Firewall is obviously chosen for its Firewall features like threat intelligence-based filtering, and the fact that it is fully managed and fits perfectly into the infrastructure as code approach the customer was requesting for their infrastructure. Azure Firewall is integrated into Azure Monitor which makes it almost too easy to get information out of it, especially when comparing it to other solutions that are based on third party vendor virtual appliances.<br>
The Firewall is configured to use DNAT to forward requests to an Azure internal load balancer that sits in front of the Azure Virtual Machine Scale Set hosting the Windows Server 2019 VMs running IIS and serving the application from the Azure File Share.<br>
Web Servers lend themselves perfectly to being deployed into VM Scale Sets with automated scale rules that make sure that there is always the correct number of servers available to serve your customers' web requests.
This article focuses on the fronting network services, so I'll just ignore the redis cache and SQL databases here.

## Getting Azure Front Door to work

In the process of deploying this infrastructure we hit a few issues that we thought were not super clearly documented and that we were only able to figure out with the great help by the Azure Front Door and Azure Firewall Product Teams.<br>
Here is the main issue that we faced where we found that the documentation was a bit lacking.

### Certificate Problems

Obviously everything is configured to only allow HTTPS traffic, because it's 2019, that's how you do it. HTTP is actually disabled wherever possible.
The Windows Servers running IIS were initially only configured with a self-signed certificate which would be fine for a development environment... you would think. This was all fine when testing access to the web servers by accessing the Azure Firewall's public IP. The browser warns about a certificate issue, you say "continue anyways" and the website loads.<br>
Azure Front Door requires a public endpoint as the next hop, or the so-called backend pool members. So naturally we configured the Azure Firewall's public IPs in each region to be part of the backend pool on Azure Front Door. Unfortunately, that did not work at all and threw http 50x errors all over the place.<br>
It turns out that using HTTPS Azure Front Door performs a certificate name check against whatever is configured in the `backend host name` field, so when we configured the backend to be the Firewalls' IPs, that check obviously failed, as the web servers responded with a certificate that didn't match the backend host name.<br>
The solution to this was twofold, one, we had to configure publicly resolvable DNS names onto the Azure Firewall public IP addresses, two, we then requested certificates for the domain we used on the Azure Firewalls. We installed those certificates on the web servers using the VM Scale Set [secrets](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-faq#how-do-i-securely-ship-a-certificate-to-the-vm) setting. Once we removed the certificate warning when accessing the web site from the Azure Firewall DNS name Azure Front Door also started playing nicely.

![azure front door configuration](/media/2019/07/afd.png)

For non-prod or development environments where you might not want to use real certificates and publicly resolvable DNS names the Azure Front Door API also allows you to turn off the certificate name check by setting `enforceCertificateNameCheckEnabledState` to `Disabled`. You can find more information [here](https://docs.microsoft.com/en-us/rest/api/frontdoorservice/frontdoor/frontdoors/createorupdate#enforcecertificatenamecheckenabledstate) in the official docs.

## Next steps Azure Front Door

Once we figured out the certificate configuration issue everything else fell into place. Initially we were surprised that Front Door would just throw an error and not tell us the actual reason (certificate name mismatch), but then it all started making sense.<br>
As next steps we will enable the [Web Application Firewall](https://docs.microsoft.com/en-us/azure/frontdoor/waf-overview) on Front Door and likely start using more sophisticated routing rules based on the incoming request.<br>
Do you have any questions about Azure Front Door or feedback on the service? Leave a comment below.