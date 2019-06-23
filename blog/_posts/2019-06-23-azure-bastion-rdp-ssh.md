---
title: Azure Bastion for RDP and SSH Access
date: 2019-06-23T00:01:30
layout: single-github
permalink: /2019/06/azure-bastion-rdp-ssh-access
categories:
  - azure
tags:
  - cloud
  - bastion
  - azure
  - jumpbox
  - terraform
  - pulumi
github_comments_issueid: 5
---
# Azure Bastion Service for RDP and SSH Access to Virtual Machines

A very common problem to solve in the public cloud is secure access to Virtual Machines (VM). There are almost no reasons why Virtual Machines should be directly exposed to the internet with a public IP.<br>
So how do we then access Virtual Machines?<br>

## VPN

A common pattern is to trust whoever comes in via a VPN. If you're inside the network authenticated via whatever means then you're good to access any VM.<br>
However, that, without any other configuration, means that all VMs need to allow remote access via either RDP (port `3389`) or SSH (port `22`) inbound from the whole internal network.<br>
This is impractical, overcomplicates routing, is insecure and what does "internal network" in the public cloud mean anyways?!

## Jumpboxes or Bastion Hosts

The better solution is to deploy gateway or proxy servers, also known as jumpboxes or bastion hosts.<br>
In the Windows world everybody most likely is familiar with Remote Desktop Services (RDS) Gateway which is the entrypoint to the network, allows secure communications and every target server (Windows only) behind the RDS Gateway can be configured to only accept inbound connections from the RDS Gateway, forcing everybody to go through this "secured" channel. It can even enforce things like Multi Factor Authentication (MFA).<br>
Most of this sounds great, however, here are my cons:

- you need to manage a VM (or multiple VMs)
  - including patching, responding to failures / outages etc
- most people will recommend joining the RDS Gateway to a domain, that's usually a con for me
- it's not easy to automate end to end, including all the policies and things like MFA
- Windows only, you'll need another solution for Linux targets

For Linux a lot of people just went and deployed a hardened Linux VM and then used the local `ssh` client to jump via a jumphost to the desired target. Example configuration can be found [here](https://wiki.gentoo.org/wiki/SSH_jump_host).<br>
Very simple to deploy and automate and even works for multiple OS as you can tunnel RDP via SSH, as I show [here on 4sysops.com](https://4sysops.com/archives/deploying-an-azure-jumpbox-jump-server/) and here the [example code on GitHub](https://github.com/davidobrien1985/azure-jumpbox-pattern).

## Azure Bastion

Microsoft saw all of this and the need for a platform solution to these problems. Their offering to their customers is [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview) (in preview at the time of publication). It's a fully managed service, offering RDP and SSH access to any VM, directly from the portal, without the need to deploy any Gateways, VPNs or other jumpbox/bastion VMs. The connection is made to the VM's private IP address without any configuration required on any of the VMs.<br>

![connect to azure bastion](media/2019/06/azure-bastion-connect.png)

To deploy the Bastion Service one can follow the documentation linked to above and click your way through the portal, or, if you're serious about cloud, you can use infrastructure as code in the form of ARM templates, terraform or pulumi (to name a few).<br>
I have put together both a terraform and a pulumi example to get everybody started with this.

* terraform: [https://github.com/xirus-au/terraform-azure-bastion](https://github.com/xirus-au/terraform-azure-bastion)
* pulumi: [https://github.com/xirus-au/pulumi-azure-bastion](https://github.com/xirus-au/pulumi-azure-bastion)

Those examples can be used as they are and should work without issues. At the moment, during preview, there aren't any terraform or pulumi resources available for the actual Bastion resource, that is why I am using an ARM template inside of the examples, which is something that regularly happens with new features, or features that aren't used very often. This is another reason why I always recommend, even if your infrastructure as code tool isn't ARM templates, that you need to still know how to write an ARM template. There's always that one thing where you'll need them.<br>
<br>
Why do I like Azure Bastion?

* it's fully managed
  * no need to deploy and maintain any VMs
* it's relatively cheap
  * around the price of a small VM, however, no cost to actually maintain the VM
* users don't have to configure VPNs on their devices, or certificates, or other custom config
* users are logged / audited out of the box (everything on Azure is tracked)
  * this is something people sometimes forget with their custom baked VMs
* MFA out of the box
  * you do enforce MFA when users log in to the Azure portal, right?
* Right now no AAD login supported, but this won't be far off I suppose

Let me know your thoughts about this new service.