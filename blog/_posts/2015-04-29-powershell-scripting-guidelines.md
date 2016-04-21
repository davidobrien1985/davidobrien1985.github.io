---
id: 3032
title: PowerShell scripting guidelines
date: 2015-04-29T20:05:13+00:00
author: "David O'Brien"
layout: single
guid: http://www.david-obrien.net/?p=3032
permalink: /2015/04/powershell-scripting-guidelines/
categories:
  - PowerShell
  - scripting
tags:
  - automation
  - DevOps
  - ITPro
  - Microsoft
  - PoSh
  - Powershell
  - scripting
---
Like always, if people are talking languages they will have dialects or accents (I don't  <img src="http://www.david-obrien.net/David/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />). PowerShell is not an exception here.
  
There are so many people nowadays writing PowerShell all over the world or even in just one company, that there have to be some ground rules.

Obviously PowerShell already has its own rules, otherwise it wouldn't work, but just knowing the words doesn't make it easier for everybody to understand.

Especially in environments where a lot of people are working on the same scripts / code, there have to be rules so that anybody can go and understand and edit anybody's script

# PowerShell scripting guidelines

This here is just a short list that I like to send out to customers or colleagues or anybody on social media (hence this article) if I get asked about some scripting guidelines. This is not a complete list and obviously this is how I like to write my scripts. If you don't agree, tell me why, I'm happy to consider new ways of doing it.

I'd be happy to add more tips / guidelines to this list. Just add yours to the comment section and I'll add them in here.

  * Readability 
      * Camel case: 
          * Get-CMDeviceCollectionDirectMembershipRule
  
            **NOT**
  
            get-cmdevicecollectiondirectmembershiprule
      * Make your code easy to read for humans!
      * Avoid 'Hungarian notation': [http://windowsitpro.com/blog/what-do-not-do-powershell-part-5](http://windowsitpro.com/blog/what-do-not-do-powershell-part-5)
      * Use comments to describe what you are doing 
          * Create comment based help (Header)
          * If you had to google / bing something, copy the URL to the solution into a comment
      * Output 
          * Give clear output as to what is happening
          * Write-Verbose, Write-Debug, Write-Error
      * NO aliases in a script
  * Verb-Noun 
      * Cmdlets always use verb-Noun
      * Approved verbs : [https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx)
      * Also applies to custom functions
  * Write reusable code 
      * Use as many functions as possible
      * Functions only do one thing
      * Functions can be added to a custom module which can be reused then in other scripts (across all developer machines)
      * Always write advanced functions 
          * [cmdletBinding()]
  * Error-Handling 
      * <div id="wpshdo_35" class="wp-synhighlighter-outer">
          <div id="wpshdt_35" class="wp-synhighlighter-expanded">
            <table border="0" width="100%">
              <tr>
                <td align="left" width="80%">
                  <a name="#codesyntax_35"></a><a id="wpshat_35" class="wp-synhighlighter-title" href="#codesyntax_35"  onClick="javascript:wpsh_toggleBlock(35)" title="Click to show/hide code block">Source code</a>
                </td>
                
                <td align="right">
                  <a href="#codesyntax_35" onClick="javascript:wpsh_code(35)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_35" onClick="javascript:wpsh_print(35)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
                </td>
              </tr>
            </table>
          </div>
          
          <div id="wpshdi_35" class="wp-synhighlighter-inner" style="display: block;">
            <pre class="powershell" style="font-family:monospace;">Try
<span class="br0">&#123;
Get<span class="sy0">-WindowsFeature 
<span class="br0">&#125;
catch 
<span class="br0">&#123;
<span class="kw1">Write-Error <span class="kw5">-Message <a href="about:blank"><span class="kw6">$_</a> 
<span class="br0">&#125;
finally 
<span class="br0">&#123;
Do<span class="sy0">-Stuff 
<span class="br0">&#125;
          </div>
        </div>
    
      * Fail fast, fail early 
          * Do early parameter validation 
              * Maybe even already in the param() block
  * Strings and variable expansion 
      * If a string does not need to expand a variable, use single quotes ('), otherwise double quotes (")
  * Never use the backtick (\`) to continue a command on the next line, it makes code impossible to read 
      * If the command is too long to easily understand it, use Splatting 
          * Get-Help about_Splatting
  * Use [OutputType] with functions 
      * Makes using results of a function later on easier
  * If possible, use .Where() and .ForEach() methods instead of pipelines 
      * <a href="http://www.powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/', 'http://www.powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/']);" >http://www.powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/</a>
  * If a script can only run with
  
    a certain PS Version ($PSVersionTable), use Set-StrictMode -Version X
  * If there is a cmdlet and an executable to do the same thing (Get-Service vs sc.exe), prefer the cmdlet.
  * Perfect is the enemy of good!

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="automation,DevOps,ITPro,Microsoft,PoSh,Powershell,scripting" data-count="vertical" data-url="http://www.david-obrien.net/2015/04/powershell-scripting-guidelines/">Tweet</a>
</div>


