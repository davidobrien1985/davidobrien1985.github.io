---
title: Deploying Microsoft Domain Controllers on AWS
date: 2016-05-14T01:30:30
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
This one here is a very complete example of how to do it:

"What's the point of this article?", you ask? Fair question.

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

