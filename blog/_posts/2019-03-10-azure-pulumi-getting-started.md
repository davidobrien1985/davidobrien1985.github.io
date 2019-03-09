---
title: Getting started with Pulumi on Azure
date: 2019-03-10T00:01:30
layout: single-github
permalink: /2019/03/azure-pulumi-getting-started
categories:
  - azure
  - pulumi
  - devops
tags:
  - pulumi
  - azure
  - automation
  - devops
  - open source
github_comments_issueid: 2
---

# Getting started with Pulumi on Azure

Pulumi? Someone the other day didn't quite hear me right and asked "Haloumi?". Well, I can't blame them, Pulumi is still a new player, started in 2017 by two former Microsoft employees.<br>
What does Pulumi do? Well, they took Infrastructure as Code **VERY** literal and developed their product also called Pulumi. If tools like ARM or Terraform are Infrastructure as Code then Pulumi is Infrastructure as _real_ Code with support for quite a few programming languages already, mainly Javascript and Typescript (using the nodejs runtime) in a stable release, and Python and Go as a preview release.<br>
This means we are getting out of YAML hell or the need to know "yet another DSL". <br>
Pulumi is currently on version `0.17.1`, it's open source hosted on [GitHub](https://github.com/pulumi/pulumi) under the Apache 2.0 license and has very frequent releases.

## Support for Azure

Pulumi has some great support for [Azure](https://github.com/pulumi/pulumi-azure) and it is super easy to get started, as the "barrier to entry" is really low.

## Local installation

For this article I will assume the following things:

- local OS is Windows 10
- we will use NodeJS
- you have an existing Azure subscription
- you have already created an account on [https://pulumi.com](https://pulumi.com)

If you use a different OS or want to use Python or Go, be my guest, it'll be easy for you to follow.
<br>
You should also have already installed the [NodeJS runtime](https://nodejs.org/en/download/) on your machine, that way writing the InfraCode will be super easy.
<br>
Next thing is installing the actual Pulumi CLI. You can find the process for that on the [official Pulumi website](https://pulumi.io/quickstart/install.html). I personally installed Pulumi into a docker container that I run on my machine, and I recommend you do the same, but in the end it's up to you.<br>

## First Pulumi project

Before we write any code we need to create a [Pulumi project](https://pulumi.io/reference/project.html). A project is a directory which stores the `Pulumi.yaml` file. Yes, a yaml file, however, it's "just" a definition file, not much more.<br>
We can use the Pulumi CLI to create the project and select our runtime.
Alright, my local development directory is called `c:\dev\pulumi`, so inside that directory I execute 

```
pulumi new
```

This will load a list of templates to choose from. I will select the `azure-javascript` template and follow the prompts.

![New Pulumi Azure project](/media/2019/03/new-pulumi-project.png)

The command will eventually pause and wait for our input. The template also created a template `index.js` file with two resources in it, a Resource Group and a Storage Account. Let's say `no` for now.

![Initial Pulumi deployment](/media/2019/03/initial-deployment.png)

When opening the local directory in our favourite IDE VS Code then we can see the following:

![Local Pulumi development directory](/media/2019/03/local-dev-dir.png)

## Pulumi on Azure

If you have any sort of programming background, javascript, C#, python, PowerShell, any, then you won't have any issues getting used to developing your Pulumi code.
To get started on Azure we already have all the prerequisites installed by selecting the azure template. This automatically installed the `@pulumi/azure` npm package into our local `node_modules` directory, so we don't have to take care of that and we can start writing our code straight away in `index.js`.<br>
You can easily see how resources get created and referenced. In the case of Azure all resources are created from the `azure` object. So creating a new Virtual Machine is as easy as starting to type and essentially following the Intellisense of our IDE.

![Creating a new Virtual Machine](/media/2019/03/animated-gif.gif)

For this first step to Pulumi I will stick to our template though. Creating more complex resources will be the topic of the next article.

## Pulumi State

Before we deploy this code we need to talk about state. Pulumi stores state, fortunately though, you don't have to worry about that state. It's stored on the Pulumi side so you don't have to go and create Storage Accounts that aren't part of your infracode or hacked into it after the fact. That said, if for whatever reason you want to manage your Pulumi state you can absolutely store it in your own environment.<br>
Pulumi will always tell you, based on what it knows and what Azure tells it, what it has deployed and what your changes to the project will mean if they get deployed. Sort of like your `terraform plan`.<br>

## Deploy the Pulumi code

In order for Pulumi to be able to write to the state file we will need to first log in with `pulumi login`. This will either open up a browser where we log in to our Pulumi account, or we can also paste an access token in that we could've created previously in our account. Either way, once logged in, we're ready to go.<br>
The `azure` provider can be configured in a few ways to authenticate to Azure, the most common way is likely going to be "from the environment" where something else has already run `az login` (or the PowerShell equivalent) and retrieved AzureRM access tokens. Alternatively, users can also configure the `azure` provider with [SPN details](https://pulumi.io/quickstart/azure/index.html#configuration).<br>

> Make sure you run `az account set --subscription <subscriptionName or ID>` if you have access to more than one subscription!

`pulumi preview` will show us all the changes a deployment will make. A preview always happens and is also available online to review, which is great for good CI practices.

![pulumi preview](/media/2019/03/pulumi-preview.png)

`pulumi up` will again create a preview for us and will then ask us if we want to perform the update, want to cancel or maybe see more details. Selecting `yes` will execute the deployment and update the online state. `pulumi up --yes` would have skipped the question post preview. You will want to use this in your release pipeline.<br>

![pulumi up](/media/2019/03/pulumi-up.png)

This has now created our Pulumi stack and created a Resource Group and a Storage Account. In my opinion the code used was more than easy and as we will see going forward is very easy to extend on.

`pulumi destroy` will obviously then delete the stack again. Please do so, as I don't want to be the person responsible for your incurred cost ;-)

## Summary

So, after my previous experiences with Terraform (see my earlier articles) and ARM I have to say I am really liking Pulumi.<br>
No, I am not your typical developer, I wouldn't even call myself a developer, but I'm very open to tools that will make my life **A LOT** easier when it comes to infrastructure as code. Leveraging actual established programming languages we are able to also use established practices and now finally apply them to our infracode, like linting, testing, creating modules, publishing these modules etc.<br>
Pulumi already has quite the following and there are already people working on enabling other programming languages based on dotnet for example.<br>
Would you like to read more about Pulumi on Azure? Let me know in the comments or on [Twitter @david_obrien](https://twitter.com/david_obrien).