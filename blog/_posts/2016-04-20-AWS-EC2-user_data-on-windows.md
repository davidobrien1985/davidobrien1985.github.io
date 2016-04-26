---
title: AWS EC2 userdata on Windows
date: 2016-04-20T12:30:30

layout: single
permalink: /2016/04/aws-ec2-user_data-on-windows/
categories:
  - AWS
tags:
  - AWS
  - DevOps
  - EC2
  - Powershell
  - user_data
  - automation
---
# AWS EC2 user data

As I have been previously doing more work on the other cloud, namely Amazon Web Services (AWS), I have found a few things that are worth mentioning and in this article here I will start with EC2 instances and their deployment / provisioning on AWS.

Often you will find yourself in the situation where you will need to run code post deployment of your AWS marketplace or pre-baked custom Amazon machine image (AMI) that you weren't able to run while creating the AMI or wasn't included into the marketplace AMI.
Examples for this could be:

* joining a Microsoft Active Directory Domain
* installing (or registering) agents, like Anti Virus or monitoring agents
* preparing the instance for other Configuration Management tools like Ansible, Puppet or Chef

Depending on what sort of image (AMI) you are deploying you actually have two options:

* you own the image:
  * create a Scheduled Task while baking the image
  * user_data
* you don't own the image:
  * bake a new image from the marketplace image
  * user_data

## AWS userdata

AWS gives you, as the provisioner of instances, the capability of injecting code into the launch process of an EC2 instance, no matter if you go straight to EC2 or use for example CloudFormation to deploy your infrastructure.

UserData is code that is executed on instances upon instance launch. On Windows that code can come in two flavours, `script` and `powershell`.

![AWS EC2 userdata](/media/2016/04/aws_launch_ec2_userdata.png)

Your userdata code is configured / set before you launch your instances and if you are using the AWS Console to launch them then above picture will show you where to input the code.
UserData is a block of code with a maximum size of 16kb, **after** it has been encoded to Base64. This means don't put a 1000 lines of PowerShell code in here.

> A very basic test showed me that around 200 lines of PowerShell encoded into Base64 equal around 16kb.

For example setting your machines up for [Ansible](https://www.ansible.com/) with this PowerShell script would still work via userdata: <https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1>

However, you don't normally use the AWS Console to spin up machines, right? Just as you wouldn't use the Azure portal to deploy instances, you would use a CLI, a tool like Ansible or in AWS's case CloudFormation to help you with this task.

UserData on Windows can call two different shells, well, the two that exist on Windows (except for Bash, for now?).

`script` will convert your code into a `.bat` file and call `cmd.exe`.
`powershell` will convert your conde into a `.ps1` file and call `powershell.exe`.



```json
"UserData": {
  "Fn::Base64": {
    "Fn::Join": [
      "",
      [
        "<script>\n",
        "powershell.exe -Command \"",
        "set-itemproperty ",
        "\\\"hkcu:Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Internet Settings\\\"",
        " -name ProxyEnable",
        " -value 1",
        ";",
        "\n",
        "\n",
        "powershell.exe -Command \"",
        "set-itemproperty ",
        "\\\"hkcu:Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Internet Settings\\\"",
        " -name ProxyServer",
        " -value \\\"",
        "http=",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        ";",
        "https=",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        ";",
        "ftp=",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        ";",
        "socks=",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        ";",
        "\\\"",
        ";",
        "\n",
        "\n",
        "powershell.exe -Command \"",
        "set-itemproperty ",
        "\\\"hkcu:Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Internet Settings\\\"",
        " -name ProxyOverride",
        " -value '",
        {
          "Ref": "ProxyExcludeList"
        },
        "<local>",
        "'\"",
        ";",
        "\n",
        "\n",
        "netsh winhttp import proxy source=ie;",
        "\n",
        "\n",
        "cfn-init.exe -v",
        " --http-proxy=\"http://",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        "\"",
        " --https-proxy=\"http://",
        {
          "Ref": "ProxyServerEndpoint"
        },
        ":",
        {
          "Ref": "ProxyPort"
        },
        "\"",
        " -c config -s ",
        {
          "Ref": "AWS::StackId"
        },
        " -r DomainController",
        " --region ",
        {
          "Ref": "AWS::Region"
        },
        "\n",
        "</script>\n"
      ]
    ]
  }
},
```