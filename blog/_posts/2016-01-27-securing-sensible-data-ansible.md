---
id: 3127
title: Securing sensible data with Ansible
date: 2016-01-27T11:19:08+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3127
permalink: /2016/01/securing-sensible-data-ansible/
categories:
  - Ansible
  - Configuration Management
  - DevOps
  - Uncategorized
tags:
  - Ansible
  - Ansible-Vault
  - Configuration Management
  - deployment
  - passwords
  - Redhat
  - security
---
One very important aspect of deployments and the tools used for deployments is the security of sensible data like passwords, user names, server names, connection strings and such.

It is important to make sure that these information do not get into the hands of someone who isn't supposed to have them. That's why you should not store these in your scripts - in clear text. (seen this a lot of times unfortunately)

This article will explain how the Configuration Management tool Ansible can help make your deployments more secure.

# Store your data in a vault

Ansible ships with a command line executable called \`ansible-vault\` that helps you securing your data. How?

Ansible-Vault uses a shared secret to encrypt and decrypt an ansible-vault file with a default AES cipher. There are plugins on the internet that support other cipher algorithms, but I've not done a proper research on these nor have I used any.

Using the vault is really easy. Assume you've got a user's password that you need during your deployment to connect to a remote database. You obviously want to have the password stored away encrypted somewhere. This is how you would do it. These steps are done **BEFORE** you save your files in source control.

Again, **DO NOT** commit any sensible data to source control. Even though there are ways to completely (really?) remove files again from systems like git, as soon as they are pushed you should consider your data compromised.

## Creating the encrypted ansible-vault file

Ansible-Vault is a Linux only application and thus using the vault (encrypting, decrypting, viewing, editing, what ever) must be executed on Linux. It might work using something like cygwin on Windows, but again, not tested and probably also not supported. If you don't have access to a Linux machine just have a look at [this article showing you how to create a working Ansible server in under 30 minutes](/2016/01/ansible-test-lab-30-minutes/), from scratch.

Before we start, let's check the help file for ansible-vault.

![image](/media/2016/01/2016-01-26_20-55-13.png)

Please be aware that in some cases when viewing or editing an already encrypted file, the content might remain in memory or on disk even - in clear text.

First step is to create an empty file, this will be the file with all the secrets. It doesn't really matter what is in the file, it could be a yaml (*.yml) file, txt, whatever.

![image](/media/2016/01/2016-01-26_20-29-34.png)

In this case I created the "secretfile.yml" with one key-value pair.

Ansible-Vault can now be used to encrypt the file.

![Ansible vault](/media/2016/01/2016-01-26_20-30-40.png)

`Ansible-Vault encrypt secretfile.yml` will prompt you to enter the password to decrypt twice. Make sure you remember it, otherwise you will have to destroy the file and create it with a new password.

After encryption the file is not readable anymore. It is now safe to commit the file to source control. :-)

Reading / editing or decrypting the file should be self-explanatory.

# Ansible-Vault in Ansible-Playbook

Great, we have secured the data that we don't want anybody to read, now how do we use it in our Ansible deployments?

Assume we have the following folder structure in our Ansible playbook. To make it easier for a human to recognize encrypted files I have a habit of calling my encrypted files "something_**secret.yml**".

![image](/media/2016/01/2016-01-26_21-14-49.png)

An encrypted file's content follows a very specific pattern so that Ansible can also identify it.

![image](/media/2016/01/2016-01-26_21-12-59.png)

During run time of Ansible it parses specific locations on the filesystem to gather inventory information, group\_vars, host\_vars etc and whenever it comes along a file that has content looking like this, it will use the ansible-vault executable to decrypt the file in memory.

There are now a few options to tell Ansible what password to use to decrypt encrypted files.

## Interactive ansible-vault decryption

During development of an Ansible playbook it is okay to have some interaction on the command line. So let's check out the first and easiest way to pass in the decryption keyword to Ansible.

`ansible-playbook tagstest.yml -i inventory/dev --ask-vault-pass`

![image](/media/2016/01/2016-01-26_21-39-00.png)

If you type in the wrong password, Ansible will warn you and fail its execution. Type in the correct password and Ansible will continue its execution as usual.

This process obviously has its downsides, like, you either need to tell everybody which password you are using to encrypt the files or you need to remember to rekey the files before pushing into source control. Both not the best of processes.

## Automated ansible-vault decryption

It wouldn't make sense to in an automated deployment process (from a CD server for example) to have a human type in the password with every deployment. That's why Ansible supports having a file passed in as a parameter that can sort out passing the password to ansible-vault.

`ansible-playbook tagstest.yml -i inventory/dev --vault-password-file vault-pass.txt`

This file must only consist of one line echoing the vault's password in clear text. Again, not the best solution, as we are passing the password around in clear text.

Now comes the best bit. Ansible supports script execution with this parameter. Here is one way to do it, one I like very much.

Continuous Integration / Continuous Deployment tools like Jenkins, TeamCity, Octopus Deploy or Bamboo can set environment variables during run time. This means that instead of typing in the password every time Ansible gets called, we can use this feature of our deployment tools and write a script that accesses the environment variable and echoes it out to Ansible.

![teamcity](/media/2016/01/2016-01-27_10-36-43.png)

`ansible-playbook tagstest.yml -i inventory/dev --vault-password-file vault-pass.py`

Check above picture of the folder structure to find the "_vault-pass.py_" file. Make sure however that the script is actually executable:

![ansible vault](/media/2016/01/2016-01-27_10-45-29.png)

This script here will require python to be available, imports the os module and then prints out the value of that variable to stdout.

```python
#!/usr/bin/python
import os
print os.environ['ansible_vault_pass']
```

Great experience!

Enjoy using Ansible in a more secure fashion.