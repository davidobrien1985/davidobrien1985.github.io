---
id: 3128
title: Ansible test lab in under 30 minutes
date: 2016-01-25T02:12:51+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3128
permalink: /2016/01/ansible-test-lab-30-minutes/
categories:
  - Ansible
  - DevOps
tags:
  - Ansible
  - Configuration Management
  - DevOps
  - vagrant
---
I speak to a lot of people at a lot of user groups, Meetups (like the [Melbourne PowerShell Meetup](http://www.meetup.com/Melbourne-PowerShell-Meetup/)) or conferences and a lot of them seem to not have heard of Ansible yet. To be fair, Ansible is still very new to the Microsoft ecosystem and Microsoft is still quite new to the whole Configuration Management thing.
  
These people are instantly interested in what Ansible can do and usually ask me "so, how do I start?"
  
This obviously always depends on what type of person you are and how you learn. I for example need to actually use technology, otherwise I won't understand it properly. Just reading about it doesn't cut it for me.
  
This article will show you how to stand up an Ansible test lab in under 30 minutes.<!--more-->

I have already written about what Ansible is, so if you haven't seen that article, find it here: [Ansible - Windows Configuration Management from Linux<br /> ](http://www.david-obrien.net/2015/08/windows-configuration-management-from-nix-with-ansible/)

You will also find a link to Trond Hindenes's website where he explains how to get started with Ansible.

# Vagrant

Trond's article is great to get you started, but it also takes quite a while to get everything setup and installed. This blog is all about automation, so it just makes sense to even automate the deployment of your next Ansible test lab, right?

The main idea about test labs that are mainly used for testing/validating code that you have just written is to spin them up easily and quickly and after having run all your tests you destroy it again.

Vagrant ([https://www.vagrantup.com](https://www.vagrantup.com))  is perfect for this scenario. Vagrant lets you, with only one line of code on the command line (PowerShell or Mac Terminal) deploy a whole test environment. Vagrant is available for download on Windows and Mac OS and supports all sorts of Hypervisors like Hyper-V, Virtualbox and Docker. There are also plugins available that add support to provision environments on AWS or Azure.

If you're not sure why to use Vagrant, read this article: [https://www.vagrantup.com/docs/why-vagrant/](https://www.vagrantup.com/docs/why-vagrant/)

# Vagrant up

The great thing about Vagrant is that you describe your environment in just one file. Granted, it's a ruby script, so you do need to make sure that syntax is right and maybe read a bit of the (by the way excellent) Vagrant documentation.

Because I am a nice guy I have already prepared a Vagrantfile that includes a Shell script that will install Ansible into the newly provisioned "box".<figure id="attachment_3178" class="wp-caption aligncenter" style="max-width: 623px">

<img class="img-responsive wp-image-3178 size-full" src="/media/2016/01/ansible_vagrant_up.png" alt="Ansible Vagrant" width="623" height="371" srcset="/media/2016/01/ansible_vagrant_up-300x179.png 300w, /media/2016/01/ansible_vagrant_up.png 623w" sizes="(max-width: 623px) 100vw, 623px" /><figcaption class="wp-caption-text">Ansible Vagrant</figcaption></figure> 

&nbsp;

## Prerequisites

  1. Internet connection
  2. Virtualbox installed
  3. Vagrant installed
  4. optional: git client installed

## Make it so

The following code will clone my Github repository hosting the two needed files to do the installation and then execute the provisioning.

If you don't have a git client installed on your machine (why wouldn't you???) then download the sources manually.

&nbsp;

<div id="wpshdo_42" class="wp-synhighlighter-outer">
  <div id="wpshdt_42" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_42"></a><a id="wpshat_42" class="wp-synhighlighter-title" href="#codesyntax_42"  onClick="javascript:wpsh_toggleBlock(42)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_42" onClick="javascript:wpsh_code(42)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_42" onClick="javascript:wpsh_print(42)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_42" class="wp-synhighlighter-inner" style="display: block;">
    git clone https:<span class="sy0">//github.com<span class="sy0">/davidobrien1985<span class="sy0">/vagrant_ansible.git<br /> <span class="kw3">cd vagrant_ansible<br /> Vagrant up
  </div>
</div>

&nbsp;

These four lines will create a new Linux server and will get Ansible and its prereqs installed onto the new server. The whole process will take approx. 10mins, depending on your internet connection.

vagrant ssh ansible will connect you to the new server via SSH (if you have SSH available on your machine or have configured Vagrant to use Putty (Windows)).
  
We are installing Ansible from source, so we need to run one more command to get Ansible working.

<div id="wpshdo_43" class="wp-synhighlighter-outer">
  <div id="wpshdt_43" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_43"></a><a id="wpshat_43" class="wp-synhighlighter-title" href="#codesyntax_43"  onClick="javascript:wpsh_toggleBlock(43)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_43" onClick="javascript:wpsh_code(43)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_43" onClick="javascript:wpsh_print(43)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_43" class="wp-synhighlighter-inner" style="display: block;">
    <span class="kw3">source ansible<span class="sy0">/hacking<span class="sy0">/env-setup
  </div>
</div>

Now you can start using Ansible. You will probably want to start adding more machines into your Vagrantfile to make sure that you will actually have an environment to test in. This is really easy. My test environment consists of the Ansible master server, an Ubuntu Ansible node and a Windows Server 2012 R2 Ansible node.

When I'm done I just call the following code and my environment is gone. No worries, because all my config and code is in source control anyways and gets automatically pulled in into each new environment I provision with Vagrant.

<div id="wpshdo_44" class="wp-synhighlighter-outer">
  <div id="wpshdt_44" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_44"></a><a id="wpshat_44" class="wp-synhighlighter-title" href="#codesyntax_44"  onClick="javascript:wpsh_toggleBlock(44)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_44" onClick="javascript:wpsh_code(44)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_44" onClick="javascript:wpsh_print(44)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_44" class="wp-synhighlighter-inner" style="display: block;">
    vagrant destroy
  </div>
</div>

Enjoy your new toy! 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="Ansible,Configuration+Management,DevOps,vagrant" data-count="vertical" data-url="http://www.david-obrien.net/2016/01/ansible-test-lab-30-minutes/">Tweet</a>
</div>


