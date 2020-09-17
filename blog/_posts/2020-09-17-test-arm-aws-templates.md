---
title: Testing ARM and AWS Templates
date: 2020-09-17T00:01:30
layout: single-github
permalink: /2020/09/testing-arm-aws-templates
categories:
  - azure
  - aws
tags:
  - azure
  - azure resource manager
  - aws
  - cloudformation
  - argos
  - testing
  - devops
  - cloud
github_comments_issueid: 21
---

Are you already using infrastructure as code (IaC) templates like Azure Resource Manager (ARM) templates or AWS CloudFormation to describe your cloud infrastructure?<br>
Yes? Awesome.<br>
How are you testing them? How are you making sure that whatever templates are developed are secure?

## Static Code Analysis of Templates

Because something is better than nothing I went and looked at options for tools that can help the community with testing their templates, whether it's for Azure or AWS. After looking for a bit I decided it's either build your own or use something that already exists.<br>
A lot of people like using PowerShell Pester which is great to write tests, but the thing is, you have to write and maintain them yourself, and I believe that is not necessarily what organisations are interested in paying their employees.<br>
So, as I wasn't able to find any Pester examples with a set of rules extensive enough to cover more than just the most basic of scenarios and at the same time also cover both AWS **and** Azure, I followed the rule I always tell our customers about.

> buy before build

On my search I found a great open source tool called <a href="https://github.com/bridgecrewio/checkov" target="_blank">checkov</a> which does exactly what I believe most companies need. It analyses cloud infracode templates for security issues and flags them.

## Testing ARM / CloudFormation Templates

Now, checkov is developed in python, which means you need to have a local python runtime configured and you need to install checkov on your local machine. Not everybody knows how to do that or has the permissions to do so.<br>
What can (almost) every computer do though? Send data to an API.
In the context of <a href="https://argos-security.io" target="_blank">ARGOS</a> we built an open source, free for everybody, API that you can send your Azure ARM or AWS CloudFormation template to. The API will take the template, execute checkov, and return any issues found.<br>
At the moment of writing checkov checks:

- 86 controls on AWS CloudFormation templates
- 45 controls on Azure ARM templates

These are tests / checks an individual now not has to write and maintain, and those numbers are only growing, which is awesome to see.

## Using the ARGOS Test API

The API is accessible at https://test-iac.argos-security.io/api/iac-test <br>
The parameters that need to be sent to the API are the following:

- framework: `arm` (in the case of Azure) or `cloudformation` (in the case of AWS)
- file_type: json / yaml
- body: the template

[![Testing AWS CloudFormation](/media/2020/09/test-aws-cloudformation.png)](/media/2020/09/test-aws-cloudformation.png)

Here's an example of testing an Azure ARM template using PowerShell:

{% gist 00fbd4eb5587be5e663ea0d3166daf15 %}

More information can be found on our GitHub repo: https://github.com/argos-au/argos-iac-testing <br>
I'd love to know more about your use case and if this helps you at all.