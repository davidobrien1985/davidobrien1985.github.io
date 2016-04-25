---
id: 208
title: Am I compatible to my future plans? How App-DNA’s AppTitude helps along the way (part 3) – Reports
date: 2011-10-23T17:59:00+00:00

layout: single

permalink: /2011/10/am-i-compatible-to-my-future-plans-how-app-dnas-apptitude-helps-along-the-way-part-3-reports/
if_slider_image:
  -
categories:
  - APP-DNA
  - App-V
  - Applications
  - Citrix
  - migration
  - Operating System
tags:
  - APPDNA
  - Applications
  - AppTitude
  - Desktop Transformation Model
  - Migration
---
The last [article](/2011/10/am-i-compatible-to-my-future-plans-how-app-dnas-apptitude-helps-along-the-way-part-2/) about AppTitude covered the import of an application.

This one will be a bit less technical but more about report generation, remediation and what AppTitude tells you about your applications.

# Where am I going?

In order to generate reports and have a look at any issues your application has to be analysed against a set of rules. These rules already come in a defined default state but can, or better, must be configured depending on your environment.

As I warned you at the beginning, this article will now be all about ‘how does my environment look like?’, ‘where do I want to go?’, ‘how do I want my environment to look like when I’m done?’, and not so much about the technical stuff.

So at this point we now have to define our project.

![module settings](/media/2012/01/module_settings.jpg "module_settings")

Under “settings”, select “module settings” and another window opens in which you define your project/environment and thus configure the modules and sets of rules for applications.

Lets imagine our IT’s company is still somewhere in the ‘90s and we only use fat clients, locally installed applications, no Terminal Servers, no virtualization, but hey, at least Windows XP.

Now a new CTO arrived and he wants to migrate to Windows 7 x64, bring applications onto Terminal Servers running [Citrix](http://www.citrix.com) XenApp6, maybe even use application streaming (Microsoft App-V or Citrix Streaming). He would now know the product versions he’d like to know and tell AppTitude to use only the rules applying to exactly these versions.

It wouldn’t make any sense to analyse your application and use rules applying to Presentation Server 4 when knowing that you want to use XenApp6. You’d only get false results which would mess up your reports!

![configure apptitude](/media/2012/01/configure_apptitude.jpg "configure_apptitude")

**Beware**: After changing these settings, applications already in your portfolio which already have been analysed, have to be analysed again! Keep that in mind! Every change you perform on your rules requires a new analysation of your applications.

## Analysation

Now that you’ve imported an application and configured your project, you can go and analyse your application. Select your application and click “Analyse”. Choose against which modules you’d like AppTitude to check your application and hit “Analyse” again. That’s it!

![analysation](/media/2012/01/analysation.jpg "analysation")

You will now see AppTitude checking your application. Overall AppTitude comes with close to 700 rules for 6 modules.

![analysation running](/media/2012/01/analysation_running.jpg "analysation_running")

Analysing 20 applications took my server around 25min. Analysing a whole bunch of applications will therefore take a lot longer, so keep that in mind when planning your analysation.

## Generating reports

When completed the analyzation Apptitude is ready to tell you all you want to know about your applications. Now it’s your turn to go create the appropriate reports.

In order to do this you have to assign a license to any application you want to see the details of. The “appliy licenses” menu is the place where you want to do this.

By selecting your application and clicking “manual unlock” at the top, you unlock your application and can see the RAG (Red, Amber, Green) results right away.

![applied licenses](/media/2012/01/applied_licenses.jpg "applied_licenses")

I’m going to stick to one example application, which today is Apple iTunes. I select the application from my applications list and click “View report”. By default, the overview summary opens.

In this overview you should mostly see the same results like you did when applying the license, but what’s more, AppTitude already tells you for which application it can remedy some issues it found and maybe that way turn a red into amber or even green state.

![overview report itunes](/media/2012/01/overview_report_itunes.jpg "overview_report_itunes")

As one of my plans was to install iTunes on Windows 7 x64 I will have a look at the x64 module first. This claims to be red. A click on the red icon brings us to iTunes’ remediation report. This will show you all the rules which got triggered by iTunes during its analysation including a short explanation to each rule, if known, a hint towards remediation and most interesting, who triggered the rule. Was it a driver? A 32-bit shell extension or maybe even 16-bit drivers?

![remediation report x64](/media/2012/01/remediation_report_x64.jpg "remediation_report_x64")

Keep in mind that some issues might be no real issues in your environment after all. For example, some applications need elevation to run, this would fire off the UAC in Wndows7. If your company’s security switched off the UAC, then this rule would not apply to you and you could go and configure the Windows 7 SP1 and Windows Server 2008R2 modules to treat this rule as “green”.

You can now switch over to the “Action View”, the details will now slightly change. AppTitude calculated if it can remedy any issues by itself by for example using Microsoft’s Shims database.

In the upper left box you see the “After RAG”. This tells you what AppTitude makes of your application.

Furthermore AppTitude gives you more details on what has to be done to get iTunes running on x64.

Because I downloaded the 32-bit version of iTunes, I knew that there would be some problems with the x64 module.

Here is what AppTitude says about Windows 7.

![itunes](/media/2012/01/itunes_win7sp1.jpg "itunes_win7sp1")

![itunes remediation](/media/2012/01/itunes_remediation_win7.jpg "itunes_remediation_win7")

For this module AppTiude knows a fix which you can easily download and use the downloaded MSI during insallation of iTunes.

![itunes remediation](/media/2012/01/itunes_remediation_win71.jpg "itunes_remediation_win7")

You can now go and select other modules at the top of this page and merge the results per applicaion with the results of the different modules. This way you can already build your own case scenarios and have a detailed look at all rhe issues and problems which might come up during deployment.

My next AppTiude article will cover Forward Paths and how to  configure them. according to your needs..




