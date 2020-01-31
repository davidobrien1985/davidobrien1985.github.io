---
title: Azure Front Door to Support Deployments
date: 2020-01-31T00:01:30
layout: single-github
permalink: /2020/01/azure-front-door-deployments
categories:
  - azure
tags:
  - cloud
  - devops
  - operations
  - azops
  - azurefrontdoor
github_comments_issueid: 12
---

Sadly, application deployments that require downtime of your environment are still a common practice, sometimes it is because people do not know better and sometimes because technically that is just what it is.<br>
In those cases the question usually pops up "how do we tell our users about this?". Take the application offline and have users run into errors? Easy, but certainly not ideal. The more common approach is to display a maintenance website to the user by configuring a DNS redirect to the maintenance page.<br>
The issue with the DNS approach is that this redirect might not always work straight away due to DNS caching and users still get to see an error. Again, not ideal.

## Azure Front Door Configuration

I have been deploying [Azure Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview) for multiple customers now to achieve global load balancing, WAF and routing capabilities way beyond what [Azure Traffic Manager](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) can do.<br>
Azure Front Door (AFD) usually has one or more backends configured that tell the resource where to route requests to.<br>
Let's take this over-simplified architecture here.

INSERT DRAWING OF AFD CONFIG

The frontend is configured as `product.david-obrien.net` with one backend configured as the web servers' load balancer hosting the web site, then there is one routing rule that points all requests to `/` to said load balancer. Easy and straight forward.<br>
AFD will send every request to `https://product.david-obrien.net` to the load balancer.<br>
I have seen companies have a "spare" Virtual Machine deployed which sole purpose is to serve the maintenance web site telling users to "have patience, come back later". That's a pretty expensive maintenance web site.

## Maintenance Web Site on Azure Storage

If you are not aware of it, [Azure Storage Accounts](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website) can host and serve static html web sites. 