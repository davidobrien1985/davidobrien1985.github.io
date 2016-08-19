---
title: PowerShell on Linux - Get started with Ansible
date: 2016-08-20T01:30:30
layout: single
permalink: /2016/08/powershell-linux-ansible/
categories:
  - PowerShell
tags:
  - Ansible
  - Open Source
  - Microsoft
  - PowerShell
  - RedHat
---

# PowerShell on Linux

If you haven't heard already, Microsoft has open-sourced Windows PowerShell and made it also available on other Operating Systems: <https://blogs.msdn.microsoft.com/powershell/2016/08/18/powershell-on-linux-and-open-source-2/>
It is great that I can finally share this stuff with you guys.

Here are some links to catch up on the announcement:

- [PowerShell repository](https://github.com/PowerShell/PowerShell)
- [Powerscripting Podcast](https://www.youtube.com/watch?v=UVz_1ACRnpU)

<!--more-->

## Getting started

It is really easy to get started with PowerShell on Linux. Make sure that you read the [known issues](https://github.com/PowerShell/PowerShell/blob/master/docs/KNOWNISSUES.md) before you do.
Check out the [getting started](https://github.com/PowerShell/PowerShell/#get-powershell) instructions if you've already got an environment to run PowerShell in.

You don't have a Linux VM handy? [Docker](https://docs.docker.com/engine/getstarted/step_one/#docker-for-windows) to the rescue.

## Docker with PowerShell and Ansible

Follow the instructions on the Docker website on how to get it running on your system or provision containers on either Azure or AWS, whichever you choose, here is a handy `Dockerfile` for you:

```Dockerfile
From centos:latest

RUN yum install -y epel-release
RUN yum update -y
RUN yum -y install python-pip
RUN yum group install -y "Development Tools"
RUN yum install -y git openssl-devel readline-devel zlib-devel python-devel libffi-devel
RUN pip install --upgrade pip
RUN yum -y install python-crypto
RUN rpm -ivh https://github.com/Versent/unicreds/releases/download/v1.1.0/unicreds-1.1.0_1.rpm
RUN pip install xmltodict
RUN pip install pywinrm
RUN pip install ansible
RUN ansible --version
RUN pip install awscli
RUN pip install boto

# Change this URL to the exact version you want to install
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/powershell-6.0.0_alpha.9-1.el7.centos.x86_64.rpm --output powershell_linux.rpm
RUN yum -y install powershell_linux.rpm
RUN powershell
```

In `cmd.exe` or `powershell.exe` verify that your docker VM is running by executing `docker --version`. You get output? Great.
Save above code as `Dockerfile` in a new directory and change your shell to that directory.
Our next execution will ask Docker to download the latest version of a container file system called `centos` and install a couple of things into this file system, most notably `Ansible` and `PowerShell`.
Regularly check the PowerShell repository and adjust the URL to the rpm file over time.

`docker build -t ansible/powershell .`

Follow the host output and understand what is happening.

`docker run -i ansible/powershell powershell`
We are here asking Docker to now run the container that we have just built and "log us in" after executing `powershell`.

```
C:\dev\git\docker\centos-powershell-ansible> docker run -i ansible/powershell powershell
PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS /> $PSversiontable
$PSversiontable

Name                           Value
----                           -----
PSVersion                      6.0.0-alpha
PSEdition                      Core
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   3.0.0.0
GitCommitId                    v6.0.0-alpha.9
CLRVersion
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1


PS />
```

Now, run the following on that line: `ansible all -i "localhost," -c local -m raw -a 'powershell' -vvvv`
Wow! We just executed PowerShell, from Ansible, on Linux!
I realise that we didn't do much, but where on from here? So many possibilities.

Type `exit` and you'll leave the container again.

Enjoy your familiar language on more Operating Systems!