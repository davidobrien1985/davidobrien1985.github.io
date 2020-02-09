---
title: Azure Front Door to Support Deployments
date: 2020-02-09T00:01:30
layout: single-github
permalink: /2020/02/azure-front-door-deployments
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

**INSERT DRAWING OF AFD CONFIG**

The frontend is configured as `davidobrien.azurefd.net` with one backend configured as the web servers URI hosting the web site, then there is one routing rule that points all requests to `/` to said backend. Easy and straight forward.<br>
AFD will send every request to `https://davidobrien.azurefd.net` to the configured backend.<br>
I have seen companies have a "spare" Virtual Machine deployed which sole purpose is to serve the maintenance web site telling users to "have patience, come back later". That's a pretty expensive maintenance web site.

## Maintenance Web Site on Azure Storage

If you are not aware of it, [Azure Storage Accounts](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website) can host and serve static html web sites. Maintenance websites, at least the ones I usually come across, are fairly static, so they are a perfect fit for being served from Azure Storage. This will be at almost no cost to you.<br>

## Bringing it all together

If you like to follow this scenario in your test environment (Note: This will cost money!) then use this template here:

{% gist 491b9531c264f8dc84af43bf7ce31a01 %}

All you need to do is provide the template with two parameters for the Azure Front Door and Storage Account names. This template will then deploy an Azure Front Door with one Frontend, two backend pools and one routing rule. Once deployed you will find that one backend is configured to a _custom host_ "david-obrien.net" and another backend is configured to point to the web endpoint of the Storage Account. You now need to enable the static website support on the Storage Account and upload an `index.html` file to the container called `$web`.<br>
You can use the following simple html for this example:

```html
<html>
  <body>
    This website is under maintenance. Come back later.
  </body>
</html>
```

The Azure Front Door designer will look something like this.

[![Front Door configuration](/media/2020/02/afd-config.png)](/media/2020/02/afd-config.png)

Now we can browse to the Front Door endpoint and see our app (or my blog if we didn't change the template). For a change to the maintenance website all we need to do is point the routing rule to the maintenance backend and save the config. About a minute later this configuration change will have populated globally and we will see the maintenance site.<br>
To change it back we only have to reconfigure the routing rule again and point it to our application's backend. Easy as!<br>
<br>
Do you think this is helpful? I am a big fan of Azure Front Door and are constantly being surprised by new scenarios it can help us with.