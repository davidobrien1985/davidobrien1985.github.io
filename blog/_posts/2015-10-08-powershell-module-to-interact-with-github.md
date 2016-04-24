---
id: 3116
title: PowerShell module to interact with Github
date: 2015-10-08T22:00:25+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3116
permalink: /2015/10/powershell-module-to-interact-with-github/
categories:
  - automation
  - DevOps
  - Git
  - PowerShell
  - PowerShellGallery
tags:
  - automation
  - DevOps
  - git
  - github
  - gitlab
  - Powershell
  - powershell gallery
  - Windows PowerShell
---
I sometimes find myself in a situation where I need to do something on Github, but, because I still once in a while use Windows machines which don't have any git installed, I have to go and use the Web UI, pretty clunky.

# Github API

Fortunately github offers a great Rest API with an awesome documentation. [https://developer.github.com/v3/](https://developer.github.com/v3/)

All calls to the Github API are over _**https**_ and accept and respond with _**json**_.

From PowerShell it is very easy to interact with this web API via _Invoke-WebRequest _or _curl_.

The latter however is not the actual curl, but just an alias for Invoke-WebRequest.

`Get-Alias curl`

# Github authentication

Most Github API calls need authentication to happen before interacting with the API.

In order to connect to Github there are two scenarios:

* Username and Password
* Username and Password and One Time Password

The One Time Password is only needed if the user you are using to authenticate has 2 Factor Authentication / Multi-Factor-Authentication enabled for Github.

# PowerShell module for Github

The PowerShell module **GithubConnect** that I developed is currently (07/10/2015) available in version 0.5 and installable from the <http://www.powershellgallery.com>

![image](/media/2015/10/2015-10-07_23-50-06.png)

Find it and install it through the PSGet module: <https://www.powershellgallery.com/packages/GithubConnect>

```
Find-Module -Name GithubConnect
Install-Module -Name GithubConnect
```

The following cmdlets are currently implemented in version 0.5:

```
Connect-Github
Get-GithubBranch
Get-GithubOrgRepository
Get-GithubOwnRepositories
Get-GithubPublicRepositories
Get-GithubWebhook
List-GithubBranches
New-GithubRepository
New-GithubWebhook
Remove-GithubRepository
```

# Contributions welcome!

Of course, as always, if you want to add something to the module or would like to "properly" report and issue with the module, head over to Gitlab and check out the repository directly: <https://gitlab.com/dobrien/GithubConnect>

Is this helpful?