---
id: 3127
title: Securing sensible data with Ansible
date: 2016-01-27T11:19:08+00:00
author: "David O'Brien"
layout: post
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

<!--more-->

# Store your data in a vault

Ansible ships with a command line executable called \`ansible-vault\` that helps you securing your data. How?

Ansible-Vault uses a shared secret to encrypt and decrypt an ansible-vault file with a default AES cipher. There are plugins on the internet that support other cipher algorithms, but I've not done a proper research on these nor have I used any.

Using the vault is really easy. Assume you've got a user's password that you need during your deployment to connect to a remote database. You obviously want to have the password stored away encrypted somewhere. This is how you would do it. These steps are done **BEFORE** you save your files in source control.
  
Again, **DO NOT** commit any sensible data to source control. Even though there are ways to completely (really?) remove files again from systems like git, as soon as they are pushed you should consider your data compromised.

## Creating the encrypted ansible-vault file

Ansible-Vault is a Linux only application and thus using the vault (encrypting, decrypting, viewing, editing, what ever) must be executed on Linux. It might work using something like cygwin on Windows, but again, not tested and probably also not supported. If you don't have access to a Linux machine just have a look at <a href="http://www.david-obrien.net/2016/01/ansible-test-lab-30-minutes/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/2016/01/ansible-test-lab-30-minutes/', 'this article showing you how to create a working Ansible server in under 30 minutes']);" target="_blank">this article showing you how to create a working Ansible server in under 30 minutes</a>, from scratch.

Before we start, let's check the help file for ansible-vault.

<img class="img-responsive alignnone size-full wp-image-3215" src="/media/2016/01/2016-01-26_20-55-13.png" alt="2016-01-26_20-55-13" width="655" height="161" srcset="/media/2016/01/2016-01-26_20-55-13-300x74.png 300w, /media/2016/01/2016-01-26_20-55-13.png 655w" sizes="(max-width: 655px) 100vw, 655px" />

Please be aware that in some cases when viewing or editing an already encrypted file, the content might remain in memory or on disk even - in clear text.

First step is to create an empty file, this will be the file with all the secrets. It doesn't really matter what is in the file, it could be a yaml (*.yml) file, txt, whatever.

<img class="img-responsive alignnone size-full wp-image-3209" src="/media/2016/01/2016-01-26_20-29-34.png" alt="2016-01-26_20-29-34" width="932" height="224" srcset="/media/2016/01/2016-01-26_20-29-34-300x72.png 300w, /media/2016/01/2016-01-26_20-29-34-768x185.png 768w, /media/2016/01/2016-01-26_20-29-34.png 932w" sizes="(max-width: 932px) 100vw, 932px" />

In this case I created the "secretfile.yml" with one key-value pair.
  
Ansible-Vault can now be used to encrypt the file.

<img class="img-responsive alignnone size-full wp-image-3220" src="/media/2016/01/2016-01-26_20-30-40.png" alt="2016-01-26_20-30-40" width="1190" height="598" srcset="/media/2016/01/2016-01-26_20-30-40-300x151.png 300w, /media/2016/01/2016-01-26_20-30-40-768x386.png 768w, /media/2016/01/2016-01-26_20-30-40-1024x515.png 1024w, /media/2016/01/2016-01-26_20-30-40.png 1190w" sizes="(max-width: 1190px) 100vw, 1190px" />

"Ansible-Vault encrypt secretfile.yml" will prompt you to enter the password to decrypt twice. Make sure you remember it, otherwise you will have to destroy the file and create it with a new password.

After encryption the file is not readable anymore. It is now safe to commit the file to source control. <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

Reading / editing or decrypting the file should be self-explanatory.

# Ansible-Vault in Ansible-Playbook

Great, we have secured the data that we don't want anybody to read, now how do we use it in our Ansible deployments?

Assume we have the following folder structure in our Ansible playbook. To make it easier for a human to recognize encrypted files I have a habit of calling my encrypted files "something_**secret.yml**".

<img class="img-responsive size-full wp-image-3237 aligncenter" src="/media/2016/01/2016-01-26_21-14-49.png" alt="2016-01-26_21-14-49" width="263" height="421" />

An encrypted file's content follows a very specific pattern so that Ansible can also identify it.

<img class="img-responsive alignnone size-full wp-image-3235" src="/media/2016/01/2016-01-26_21-12-59.png" alt="2016-01-26_21-12-59" width="573" height="366" srcset="/media/2016/01/2016-01-26_21-12-59-300x192.png 300w, /media/2016/01/2016-01-26_21-12-59.png 573w" sizes="(max-width: 573px) 100vw, 573px" />

During run time of Ansible it parses specific locations on the filesystem to gather inventory information, group\_vars, host\_vars etc and whenever it comes along a file that has content looking like this, it will use the ansible-vault executable to decrypt the file in memory.

There are now a few options to tell Ansible what password to use to decrypt encrypted files.

## Interactive ansible-vault decryption

During development of an Ansible playbook it is okay to have some interaction on the command line. So let's check out the first and easiest way to pass in the decryption keyword to Ansible.

<div id="wpshdo_45" class="wp-synhighlighter-outer">
  <div id="wpshdt_45" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_45"></a><a id="wpshat_45" class="wp-synhighlighter-title" href="#codesyntax_45"  onClick="javascript:wpsh_toggleBlock(45)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_45" onClick="javascript:wpsh_code(45)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_45" onClick="javascript:wpsh_print(45)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_45" class="wp-synhighlighter-inner" style="display: block;">
    ansible-playbook tagstest.yml <span class="re5">-i</span> inventory<span class="sy0">/</span>dev <span class="re5">--ask-vault-pass</span>
  </div>
</div>

<img class="img-responsive alignnone size-full wp-image-3236" src="/media/2016/01/2016-01-26_21-39-00.png" alt="2016-01-26_21-39-00" width="719" height="76" srcset="/media/2016/01/2016-01-26_21-39-00-300x32.png 300w, /media/2016/01/2016-01-26_21-39-00.png 719w" sizes="(max-width: 719px) 100vw, 719px" />

If you type in the wrong password, Ansible will warn you and fail its execution. Type in the correct password and Ansible will continue its execution as usual.

This process obviously has its downsides, like, you either need to tell everybody which password you are using to encrypt the files or you need to remember to rekey the files before pushing into source control. Both not the best of processes.

## Automated ansible-vault decryption

It wouldn't make sense to in an automated deployment process (from a CD server for example) to have a human type in the password with every deployment. That's why Ansible supports having a file passed in as a parameter that can sort out passing the password to ansible-vault.

<div id="wpshdo_46" class="wp-synhighlighter-outer">
  <div id="wpshdt_46" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_46"></a><a id="wpshat_46" class="wp-synhighlighter-title" href="#codesyntax_46"  onClick="javascript:wpsh_toggleBlock(46)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_46" onClick="javascript:wpsh_code(46)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_46" onClick="javascript:wpsh_print(46)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_46" class="wp-synhighlighter-inner" style="display: block;">
    ansible-playbook tagstest.yml <span class="re5">-i</span> inventory<span class="sy0">/</span>dev <span class="re5">--vault-password-file</span> vault-pass.txt
  </div>
</div>

This file must only consist of one line echoing the vault's password in clear text. Again, not the best solution, as we are passing the password around in clear text.

Now comes the best bit. Ansible supports script execution with this parameter. Here is one way to do it, one I like very much.

Continuous Integration / Continuous Deployment tools like Jenkins, TeamCity, Octopus Deploy or Bamboo can set environment variables during run time. This means that instead of typing in the password every time Ansible gets called, we can use this feature of our deployment tools and write a script that accesses the environment variable and echoes it out to Ansible.

<img class="img-responsive alignnone size-full wp-image-3258" src="/media/2016/01/2016-01-27_10-36-43.png" alt="2016-01-27_10-36-43" width="1269" height="768" srcset="/media/2016/01/2016-01-27_10-36-43-300x182.png 300w, /media/2016/01/2016-01-27_10-36-43-768x465.png 768w, /media/2016/01/2016-01-27_10-36-43-1024x620.png 1024w, /media/2016/01/2016-01-27_10-36-43.png 1269w" sizes="(max-width: 1269px) 100vw, 1269px" />

<div id="wpshdo_47" class="wp-synhighlighter-outer">
  <div id="wpshdt_47" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_47"></a><a id="wpshat_47" class="wp-synhighlighter-title" href="#codesyntax_47"  onClick="javascript:wpsh_toggleBlock(47)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_47" onClick="javascript:wpsh_code(47)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_47" onClick="javascript:wpsh_print(47)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_47" class="wp-synhighlighter-inner" style="display: block;">
    ansible-playbook tagstest.yml <span class="re5">-i</span> inventory<span class="sy0">/</span>dev <span class="re5">--vault-password-file</span> vault-pass.py
  </div>
</div>

Check above picture of the folder structure to find the "_vault-pass.py_" file. Make sure however that the script is actually executable:

<img class="img-responsive alignnone size-full wp-image-3264" src="/media/2016/01/2016-01-27_10-45-29.png" alt="2016-01-27_10-45-29" width="445" height="142" srcset="/media/2016/01/2016-01-27_10-45-29-300x96.png 300w, /media/2016/01/2016-01-27_10-45-29.png 445w" sizes="(max-width: 445px) 100vw, 445px" />

This script here will require python to be available, imports the os module and then prints out the value of that variable to stdout.

<div id="wpshdo_48" class="wp-synhighlighter-outer">
  <div id="wpshdt_48" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_48"></a><a id="wpshat_48" class="wp-synhighlighter-title" href="#codesyntax_48"  onClick="javascript:wpsh_toggleBlock(48)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_48" onClick="javascript:wpsh_code(48)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_48" onClick="javascript:wpsh_print(48)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_48" class="wp-synhighlighter-inner" style="display: block;">
    <span class="co0">#!/usr/bin/python</span><br /> import os<br /> print os.environ<span class="br0">[</span><span class="st_h">'ansible_vault_pass'</span><span class="br0">]</span>
  </div>
</div>

Great experience! <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

Enjoy using Ansible in a more secure fashion. 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Ansible,Ansible-Vault,Configuration+Management,deployment,passwords,Redhat,security" data-count="vertical" data-url="http://www.david-obrien.net/2016/01/securing-sensible-data-ansible/">Tweet</a>
</div>

