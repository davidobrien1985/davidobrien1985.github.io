---
title: Deploying Microsoft Domain Controllers on AWS
date: 2016-05-17T01:30:30
layout: single
permalink: /2016/05/microsoft-domain-controllers-on-aws/
categories:
  - AWS
tags:
  - AWS
  - Domain Controllers
  - Microsoft
  - PowerShell
  - CloudFormation
---

# Deploying Microsoft Domain Controllers on AWS

I am currently building an end to end automation framework for a secure Windows environment on Amazon Web Services (AWS). This is really interesting as Google will give you at least a dozen hits on this topic, including AWS Quickstart templates to deploy a VPC with Remote Desktop Services Gateways, Domain Controllers, Domain members, etc, using CloudFormation.
This one here is a very complete example of how to do it: <http://docs.aws.amazon.com/quickstart/latest/powershell-dsc/welcome.html>
<!--more-->

"What's the point of this article then?", you ask? Fair question.

## CloudFormation endpoints

CloudFormation is the deployment orchestration service from AWS. It takes a `json` formatted file with instructions describing the environment (if you're a Microsoft Azure person reading this, this is like Azure Resource Manager templates).
Most examples of CloudFormation templates you will find use CloudFormation Configuration Sets that describe certain tasks in a template and that are then applied to an instance via the [userdata](/2016/04/aws-ec2-user_data-on-windows/) script calling the `cfn-init.exe`.
This all works, with one caveat, the instance executing `cfn-init` to get the Configuration Sets needs to have internet access.
Whereas an EC2 instance is perfectly able to access S3 (Simple Storage Service) buckets to download files shared on this service without internet access, getting **to** the CloudFormation endpoint requires internet access.
Without having internet access on your EC2 instances you won't be able to use the CloudFormation Configuration Sets.
Here follows the beginning of such a Configuration Set definition for an EC2 instance.

```json
    "DomainController": {
      "Type": "AWS::EC2::Instance",
      "Metadata": {
        "AWS::CloudFormation::Init": {
          "configSets": {
            "config": [
              "setup"
            ]
          },
          "setup": {
            "files": {
              "c:\\cfn\\cfn-hup.conf": {
                "content": {
                  "Fn::Join": [
                    "",
                    [
                      "[main]\n",
                      "stack=",
                      {
                        "Ref": "AWS::StackName"
                      },
                      "\n",
                      "region=",
                      {
                        "Ref": "AWS::Region"
                      },
                      "\n"
                    ]
                  ]
                }
              },
              "c:\\cfn\\hooks.d\\cfn-auto-reloader.conf": {
                "content": {
                  "Fn::Join": [
                    "",
                    [
                      "[cfn-auto-reloader-hook]\n",
                      "triggers=post.update\n",
                      "path=Resources.DomainController.Metadata.AWS::CloudFormation::Init\n",
                      "action=cfn-init.exe -v -c config -s ",
                      {
                        "Ref": "AWS::StackId"
                      },
                      " -r DomainController",
                      " --region ",
                      {
                        "Ref": "AWS::Region"
                      },
                      "\n"
                    ]
                  ]
                }
              },
              "c:\\cfn\\scripts\\Set-StaticIP.ps1": {
                "content": {
                  "Fn::Join": [
                    "",
                    [
                      "$netip = Get-NetIPConfiguration;",
                      "$ipconfig = Get-NetIPAddress | ?{$_.IpAddress -eq $netip.IPv4Address.IpAddress};",
                      "Get-NetAdapter | Set-NetIPInterface -DHCP Disabled;",
                      "Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $netip.IPv4Address.IpAddress -PrefixLength $ipconfig.PrefixLength -DefaultGateway $netip.IPv4DefaultGateway.NextHop;",
                      "Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $netip.DNSServer.ServerAddresses;",
                      "\n"
                    ]
                  ]
                }
              }
            }
          }
```

>Again, this will only work if your EC2 instance has internet access.

Don't know about you, but I don't like having my Domain Controllers connected to the internet, even via a proxy, which most blog articles or templates are doing.

Well, what now?

## Deployment of non-internet EC2 instances

As I see it we have three "obvious" choices:

- execute the whole configuration from the userdata script
  - no infrastructure needed
  - userdata has a maximum size limit and might thus be too limited for some deployments
  - becomes hard to maintrain
    - this initially was a typo, but a good one. Code like that is long and hard to maintain and read and also hard to train others on
  - no easy way of doing cross-instance orchestration
- deploy a PowerShell Desired State Configuration (DSC) Pull Server
  - EC2 instances will download their configuration files and resources from this Pull Server
  - extra infrastructure is a downside
    - ideally highly available
  - Pull servers bring a bit of overhead to a DSC deployment (zip files, checksum)
- put DSC configuration scripts into an S3 bucket and use DSC push mode to install servers
  - no infrastructure needed
  - S3 can encrypt files at rest
  - DSC push mode a lot more maintainable than Pull mode

I prefer the last option, to put my scripts on S3 and then have a step in `userdata` that will download the files from S3, do some pre-deployment tasks and then execute the scripts.

```
  "UserData": { "Fn::Base64" : { "Fn::Join" : ["", [
    "<powershell>\n",
      "Read-S3Object -BucketName ",
        {
          "Ref": "S3BucketName"
        },
      " -Key \"windows_soe/install-adds.ps1\" -File c:\\install-adds.ps1 -Region ap-southeast-2 \n",
      "Read-S3Object -BucketName ",
        {
          "Ref": "S3BucketName"
        },
      " -Key \"windows_soe/dscmodules.zip\" -File c:\\dscmodules.zip -Region ap-southeast-2 \n",
      "Expand-Archive -Path c:\\dscmodules.zip -DestinationPath 'C:\\Program Files\\WindowsPowerShell\\Modules' -Force \n",
      "& c:\\adds.ps1 -safemodepassword ",
        {
          "Ref": "DomainAdminPassword"
        },
      " -DomainAdminPassword ",
      {
        "Ref": "DomainAdminPassword"
      },
      " -ADServer1PrivateIp ",
      {
        "Ref": "DC1PrivateIP"
      },
      "\n",
    "</powershell>\n"
  ]]}},
```

This example is from my actual CloudFormation template that deploys multiple Domain Controllers into the AWS VPC. Those Domain Controllers do not have any connectivity to the internet, they are in a private subnet, no proxy, and are in different Availability Zones (AZs) in AWS.

## Separation of code

By doing it this way I also separate my deployment code from my configuration code. This makes managing your code a lot easier because you maintain the code that configures your instances (and is potentially also written by a different team like your application team) in a different place than your deployment code (potentially written by your infrastructure team).

## PowerShell DSC to configure AWS Windows instances

With DSC I can tell the EC2 instance to be the way I want it to be without depending on internet connection (unless of cource I'm telling it to do something that needs internet connectivity). Push mode will make it easy to execute the code locally on your DCs without standing up a Pull-Server environment and managing the deployment of your configuration scripts to those Pull-Servers.
A great way to deploy multiple Domain Controllers is using the `xActiveDirectory` DSC module from the PowerShell Gallery with its `xWaitForADDomain` resource. Even though this is not exactly "cross-node orchestration", it means that you can ask CloudFormation to deploy all your instances in parallel and have all your domain members and "following" Domain Controllers wait for the Active Directory Domain to exist (be installed on the first DC) and then continue installing.

```
  xWaitForADDomain waitfordomain
  {
    DomainName = $Node.domain_name
    DomainUserCredential = $domainCred
    RetryIntervalSec = 30
    RetryCount = 20
  }
```

## Summary

I hope that this gives you a few insights as to why I am using PowerShell DSC to deploy the Microsoft foundation infrastructure for AWS environments.
Would love to hear your feedback on this approach or if you have any questions, leave me a comment or contact me on Twitter.