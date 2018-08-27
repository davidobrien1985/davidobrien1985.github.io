---
title: Super small Azure toolset
date: 2018-08-26T12:01:30
layout: single
permalink: /2018/08/super-small-azure-toolset
categories:
  - Azure
  - Microsoft
  - cloud
  - Linux
tags:
  - azure
  - cloud
  - devops
  - linux
  - docker
  - containers
---

# Swiss knife Azure toolset with Linux

## Run all the containers

I do not like installing tools on my laptop, mainly because I do not want to get attached to my laptop. <br>
Around 3 years ago I read [Jess Frazelle's](https://twitter.com/jessfraz) blog article on how and why she runs all her desktop apps in docker containers, find it here <https://blog.jessfraz.com/post/docker-containers-on-the-desktop/>. As I am running Windows on my laptop I never really got any further than running Chrome in a container, without audio. <br>
What I did take away though was that I am only going to install the bare minimum of stuff onto my laptop, everything that can be run in a container, will be run in a container.

## CLIs in a container

So I decided that especially CLIs I do not want to install on my laptop, instead I install [Docker for Windows](https://www.docker.com/) on my machine and run docker images on demand. <br>
Another great use case for this is whenever I get to a customer and they ask me "What do we need on our machines?", my response nowadays is "Docker, I'll bring the rest.".
Last week someone complained to me about one of those container images being way too big (800MB download). So over the weekend I sat down and built a new container image based on [alpine Linux](https://hub.docker.com/_/alpine/). <br>
Alpine doesn't come with anything, except for a fully functioning Linux OS and a package manager. If all you need is an OS to run a binary file on, Alpine is the perfect fit, as long as your binary does not care what OS it runs on. Alpine Linux is only 5MB (Yes, MEGABYTES!) in size.<br>
Go head over to <a href="https://hub.docker.com/r/davidobrien/alpine_azure_tools" target="_blank">docker hub</a> and find the probably smallest docker image that has all the important tools on it to work on Azure.

* Azure CLI
* bash
* python
* terraform
* helm
* kubernetes CLI (kubectl)

Bash and python are the two runtimes that bloat this image up to a compressed size of 92MB unfortunately, but both are required for the python based Azure CLI.<br>

## Run Azure CLI in docker

My workflow on a new laptop is now as follows:

* launch `cmd` or `powershell` / `pwsh`
* execute `docker pull davidobrien/alpine_azure_tools`

This downloads the image to my local machine and I can then execute commands like this:
`docker run davidobrien/alpine_azure_tools az group list` or <br>
`docker run davidobrien/alpine_azure_tools terraform plan` <br>
without actually having any of those CLIs installed on my machine.

![alpine linux docker terraform](/media/2018/08/alpine_terraform.jpg)

This is just one example of many what docker containers are already super useful for, even if not a single one of your company's applications can be containerised today. <br>
Want to know more? Hit me up on [my Twitter](https://twitter.com/david_obrien) or on my [company website](https://davidobrienconsulting.com).