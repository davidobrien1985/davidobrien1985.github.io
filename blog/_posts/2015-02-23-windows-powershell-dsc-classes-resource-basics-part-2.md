---
id: 2979
title: 'Windows PowerShell DSC - classes - resource basics (part 2)'
date: 2015-02-23T08:42:16+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=2979
permalink: /2015/02/windows-powershell-dsc-classes-resource-basics-part-2/
categories:
  - automation
  - Desired State Configuration
  - DSC
  - Microsoft
  - PowerShell
tags:
  - classes
  - Desired State Configuration
  - Powershell
  - PSDSC
  - WMF5
---
<p class="">
  In part one of this miniseries I explained some principals around using the new class keyword in Windows PowerShell DSC resource modules. If you haven't read that article yet, go find it here:<br /> [http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/](http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/)<br /> This part 2 will concentrate on the <i style="font-weight: bold;">enum </i>keyword and the three main functions in each resource class.
</p>

# Enum -erate input {.}

<p class="">
  One of the most important things in every script (no matter what language) is error handling. PowerShell and DSC is no exception here. For me, part of error handling is also to validate input  users can provide your script or application with.<br /> <strong>Enum</strong> is used to implement constant values inside of a variable. A limitation that is currently still present is that you need to implement the enum in the script where you're using it. This is apparently different in the .Net Framework, where they are always available as soon as the class library is loaded.<br /> In a cmdlet based DSC resource we would do something like this:
</p>

<p class="">
  <div id="wpshdo_27" class="wp-synhighlighter-outer">
    <div id="wpshdt_27" class="wp-synhighlighter-expanded">
      <table border="0" width="100%">
        <tr>
          <td align="left" width="80%">
            <a name="#codesyntax_27"></a><a id="wpshat_27" class="wp-synhighlighter-title" href="#codesyntax_27"  onClick="javascript:wpsh_toggleBlock(27)" title="Click to show/hide code block">Source code</a>
          </td>
          
          <td align="right">
            <a href="#codesyntax_27" onClick="javascript:wpsh_code(27)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_27" onClick="javascript:wpsh_print(27)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
          </td>
        </tr>
      </table>
    </div>
    
    <div id="wpshdi_27" class="wp-synhighlighter-inner" style="display: block;">
      <pre class="powershell" style="font-family:monospace;"><span class="kw3">param</span> <span class="br0">&#40;</span>
<span class="br0">[</span>ValidateSet<span class="br0">&#40;</span><span class="st0">'Present'</span><span class="sy0">,</span> <span class="st0">'Absent'</span><span class="br0">&#41;</span><span class="br0">]</span>
<span class="br0">[</span><span class="re3">string</span><span class="br0">]</span><span class="re0">$Ensure</span> <span class="sy0">=</span> <span class="st0">'Present'</span>
<span class="br0">&#41;</span></pre>
    </div>
  </div>
</p>

<p class="">
  Now with the enum keyword that's much easier:<br /> 
  
  <div id="wpshdo_28" class="wp-synhighlighter-outer">
    <div id="wpshdt_28" class="wp-synhighlighter-expanded">
      <table border="0" width="100%">
        <tr>
          <td align="left" width="80%">
            <a name="#codesyntax_28"></a><a id="wpshat_28" class="wp-synhighlighter-title" href="#codesyntax_28"  onClick="javascript:wpsh_toggleBlock(28)" title="Click to show/hide code block">Source code</a>
          </td>
          
          <td align="right">
            <a href="#codesyntax_28" onClick="javascript:wpsh_code(28)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_28" onClick="javascript:wpsh_print(28)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
          </td>
        </tr>
      </table>
    </div>
    
    <div id="wpshdi_28" class="wp-synhighlighter-inner" style="display: block;">
      <pre class="powershell" style="font-family:monospace;">enum Ensure <span class="br0">&#123;</span>
Present
Absent
<span class="br0">&#125;</span></pre>
    </div>
  </div>
  
  <br /> You can have multiple enum in one resource module.
</p>

<div id="wpshdo_29" class="wp-synhighlighter-outer">
  <div id="wpshdt_29" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_29"></a><a id="wpshat_29" class="wp-synhighlighter-title" href="#codesyntax_29"  onClick="javascript:wpsh_toggleBlock(29)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_29" onClick="javascript:wpsh_code(29)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_29" onClick="javascript:wpsh_print(29)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_29" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">enum HouseType <span class="br0">&#123;</span>
Tent
House
<span class="br0">&#125;</span>
&nbsp;
enum HouseSize <span class="br0">&#123;</span>
large
small
medium
<span class="br0">&#125;</span></pre>
  </div>
</div>

<p class="">
  The delimiter between values is 'newline', so no comma, semicolon or other fancy stuff.
</p>

<p class="">
  You can now go and check with PowerShell if a user's input is valid by executing the following:
</p>

<div id="wpshdo_30" class="wp-synhighlighter-outer">
  <div id="wpshdt_30" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_30"></a><a id="wpshat_30" class="wp-synhighlighter-title" href="#codesyntax_30"  onClick="javascript:wpsh_toggleBlock(30)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_30" onClick="javascript:wpsh_code(30)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_30" onClick="javascript:wpsh_print(30)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_30" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">enum HouseSize <span class="br0">&#123;</span>
large
small
medium
<span class="br0">&#125;</span>
<span class="br0">[</span>enum<span class="br0">]</span>::IsDefined<span class="br0">&#40;</span><span class="br0">&#40;</span><span class="br0">[</span>HouseSize<span class="br0">]</span><span class="br0">&#41;</span><span class="sy0">,</span><span class="st0">'tiny'</span><span class="br0">&#41;</span></pre>
  </div>
</div>

In a class based DSC resource this would look something like this:
  


<div id="wpshdo_31" class="wp-synhighlighter-outer">
  <div id="wpshdt_31" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_31"></a><a id="wpshat_31" class="wp-synhighlighter-title" href="#codesyntax_31"  onClick="javascript:wpsh_toggleBlock(31)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_31" onClick="javascript:wpsh_code(31)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_31" onClick="javascript:wpsh_print(31)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_31" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">enum Ensure
<span class="br0">&#123;</span>
   Absent
   Present
<span class="br0">&#125;</span>
&nbsp;
<span class="br0">[</span>DscResource<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
class Test
<span class="br0">&#123;</span>
   <span class="br0">[</span>DscResourceKey<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
   <span class="br0">[</span><span class="re3">string</span><span class="br0">]</span> <span class="re0">$Test</span>
   <span class="br0">[</span>DscResourceMandatory<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">]</span>
   <span class="br0">[</span>Ensure<span class="br0">]</span> <span class="re0">$Ensure</span> 
&nbsp;
   <span class="br0">[</span>void<span class="br0">]</span> <span class="kw2">Set</span><span class="br0">&#40;</span><span class="br0">&#41;</span>
&nbsp;
   <span class="br0">&#123;</span>
      <span class="kw3">if</span><span class="br0">&#40;</span><span class="re0">$this</span>.Ensure <span class="kw4">-eq</span> <span class="br0">[</span>Ensure<span class="br0">]</span>::Present<span class="br0">&#41;</span>
      <span class="br0">&#123;</span>
        Try
        <span class="br0">&#123;</span> 
<span class="co1">#### and so on...</span></pre>
  </div>
</div>

Since the November update of WMF 5 there is a change in how you use variables in the scope of a class. In order to use a variable in one of the class's methods, you need to reference it with the $this scope variable. The $this scope doesn't only apply to the enum keyword, but to all variables used inside a class based DSC resource as well, and, for that matter, all classes used in PowerShell.
  
For more information on $this, execute _**get-help about\_Automatic\_Variables**_ in your PowerShell.

**As a side note**, make sure you read all the release notes that come with the WMF 5 previews. This is a big change in how to handle variables and a lot of people (including myself) missed that and wondered why their classes didn't work anymore.

# Get, Set, Test your DSC resource {.}

<p class="">
  We are talking about DSC and even though we're now talking about class based resources, we do have to remember the three minimum functions our DSC resources must implement as well. We used to call them <b>Get-TargetResource</b>, <b>Set-TargetResource</b> and <b>Test-TargetResource. </b>Not anymore, they are now just <strong>Get()</strong>, <strong>Set()</strong> and <strong>Test()</strong>. Looks a lot like a method, right?<br /> These three methods still do exactly the same as they used to and they also still need to have the following output:
</p>

  * Get() 
      * returns an instance of this class with the updated key properties
  * Set() 
      * void
  * Test() 
      * boolean ($true or $false)

<p class="">
  The base principle still applies here. All three methods need to be implemented. There are a couple of changes now though. Well, of course there are.
</p>

## Parameter implementation {.}

<p class="">
  In a cmdlet based resource the three functions needed to accept all parameters that were implemented through the schema.mof file. This sometimes led to very long param () statements in the beginning of each function.<br /> There is no schema.mof file anymore, so how are we going to do it now?
</p>

<a href="/media/2015/02/1424380983_full.png" onclick="_gaq.push(['_trackEvent', 'outbound-article', '/media/2015/02/1424380983_full.png', '']);" target="_blank"><img class="img-responsive full aligncenter" src="/media/2015/02/1424380983_thumb.png" alt="Windows PowerShell DSC resource class" width="246" height="368" align="middle" /></a>

We can see that now, instead of defining all the variables inside of each function's scope, we define the variables in the class' scope. This looks a lot tidier and, at least to me, makes much more sense.
  
You'll see that I used a couple of properties in this param block that might be unfamiliar at first.

  * <!-- [if gte mso 9]><xml>
<o:OfficeDocumentSettings>
<o:RelyOnVML></o:RelyOnVML>
<o:AllowPNG></o:AllowPNG>
</o:OfficeDocumentSettings>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:TrackMoves></w:TrackMoves>
<w:TrackFormatting></w:TrackFormatting>
<w:PunctuationKerning></w:PunctuationKerning>
<w:ValidateAgainstSchemas></w:ValidateAgainstSchemas>
<w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
<w:IgnoreMixedContent>false</w:IgnoreMixedContent>
<w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
<w:DoNotPromoteQF></w:DoNotPromoteQF>
<w:LidThemeOther>EN-US</w:LidThemeOther>
<w:LidThemeAsian>ZH-CN</w:LidThemeAsian>
<w:LidThemeComplexScript>TA</w:LidThemeComplexScript>
<w:Compatibility>
<w:BreakWrappedTables></w:BreakWrappedTables>
<w:SnapToGridInCell></w:SnapToGridInCell>
<w:WrapTextWithPunct></w:WrapTextWithPunct>
<w:UseAsianBreakRules></w:UseAsianBreakRules>
<w:DontGrowAutofit></w:DontGrowAutofit>
<w:SplitPgBreakAndParaMark></w:SplitPgBreakAndParaMark>
<w:EnableOpenTypeKerning></w:EnableOpenTypeKerning>
<w:DontFlipMirrorIndents></w:DontFlipMirrorIndents>
<w:OverrideTableStyleHps></w:OverrideTableStyleHps>
<w:UseFELayout></w:UseFELayout>
</w:Compatibility>
<m:mathPr>
<m:mathFont m:val="Cambria Math"></m:mathFont>
<m:brkBin m:val="before"></m:brkBin>
<m:brkBinSub m:val="&#45;-"></m:brkBinSub>
<m:smallFrac m:val="off"></m:smallFrac>
<m:dispDef></m:dispDef>
<m:lMargin m:val="0"></m:lMargin>
<m:rMargin m:val="0"></m:rMargin>
<m:defJc m:val="centerGroup"></m:defJc>
<m:wrapIndent m:val="1440"></m:wrapIndent>
<m:intLim m:val="subSup"></m:intLim>
<m:naryLim m:val="undOvr"></m:naryLim>
</m:mathPr></w:WordDocument>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true"
DefSemiHidden="true" DefQFormat="false" DefPriority="99"
LatentStyleCount="276">
<w:LsdException Locked="false" Priority="0" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Normal"></w:LsdException>
<w:LsdException Locked="false" Priority="9" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="heading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 1"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 2"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 3"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 4"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 5"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 6"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 7"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 8"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 9"></w:LsdException>
<w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"></w:LsdException>
<w:LsdException Locked="false" Priority="10" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Title"></w:LsdException>
<w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"></w:LsdException>
<w:LsdException Locked="false" Priority="11" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtitle"></w:LsdException>
<w:LsdException Locked="false" Priority="22" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Strong"></w:LsdException>
<w:LsdException Locked="false" Priority="20" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="59" SemiHidden="false"
UnhideWhenUsed="false" Name="Table Grid"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"></w:LsdException>
<w:LsdException Locked="false" Priority="1" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="No Spacing"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"></w:LsdException>
<w:LsdException Locked="false" Priority="34" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"></w:LsdException>
<w:LsdException Locked="false" Priority="29" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="30" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="19" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="21" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="31" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="32" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="33" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Book Title"></w:LsdException>
<w:LsdException Locked="false" Priority="37" Name="Bibliography"></w:LsdException>
<w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"></w:LsdException>
</w:LatentStyles>
</xml><![endif]-->
    
    <!-- [if gte mso 10]>




<![endif]-->
    
    <!--StartFragment-->
    
    <span lang="EN-US">[</span><span lang="EN-US">DscResource</span><span lang="EN-US">()</span><span lang="EN-US">], tells PowerShell that the following class is a DSC resource</span>
  * <span lang="EN-US">[</span><span lang="EN-US">DscProperty</span><span lang="EN-US">(Key)]</span> , a DSC resource requires at least one Key value. This uniquely identifies the resource instance. It also means that this parameter is required. If it's not set, DSC will not execute.
  * <!-- [if gte mso 9]><xml>
<o:OfficeDocumentSettings>
<o:RelyOnVML></o:RelyOnVML>
<o:AllowPNG></o:AllowPNG>
</o:OfficeDocumentSettings>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:TrackMoves></w:TrackMoves>
<w:TrackFormatting></w:TrackFormatting>
<w:PunctuationKerning></w:PunctuationKerning>
<w:ValidateAgainstSchemas></w:ValidateAgainstSchemas>
<w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
<w:IgnoreMixedContent>false</w:IgnoreMixedContent>
<w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
<w:DoNotPromoteQF></w:DoNotPromoteQF>
<w:LidThemeOther>EN-US</w:LidThemeOther>
<w:LidThemeAsian>ZH-CN</w:LidThemeAsian>
<w:LidThemeComplexScript>TA</w:LidThemeComplexScript>
<w:Compatibility>
<w:BreakWrappedTables></w:BreakWrappedTables>
<w:SnapToGridInCell></w:SnapToGridInCell>
<w:WrapTextWithPunct></w:WrapTextWithPunct>
<w:UseAsianBreakRules></w:UseAsianBreakRules>
<w:DontGrowAutofit></w:DontGrowAutofit>
<w:SplitPgBreakAndParaMark></w:SplitPgBreakAndParaMark>
<w:EnableOpenTypeKerning></w:EnableOpenTypeKerning>
<w:DontFlipMirrorIndents></w:DontFlipMirrorIndents>
<w:OverrideTableStyleHps></w:OverrideTableStyleHps>
<w:UseFELayout></w:UseFELayout>
</w:Compatibility>
<m:mathPr>
<m:mathFont m:val="Cambria Math"></m:mathFont>
<m:brkBin m:val="before"></m:brkBin>
<m:brkBinSub m:val="&#45;-"></m:brkBinSub>
<m:smallFrac m:val="off"></m:smallFrac>
<m:dispDef></m:dispDef>
<m:lMargin m:val="0"></m:lMargin>
<m:rMargin m:val="0"></m:rMargin>
<m:defJc m:val="centerGroup"></m:defJc>
<m:wrapIndent m:val="1440"></m:wrapIndent>
<m:intLim m:val="subSup"></m:intLim>
<m:naryLim m:val="undOvr"></m:naryLim>
</m:mathPr></w:WordDocument>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true"
DefSemiHidden="true" DefQFormat="false" DefPriority="99"
LatentStyleCount="276">
<w:LsdException Locked="false" Priority="0" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Normal"></w:LsdException>
<w:LsdException Locked="false" Priority="9" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="heading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 1"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 2"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 3"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 4"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 5"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 6"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 7"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 8"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 9"></w:LsdException>
<w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"></w:LsdException>
<w:LsdException Locked="false" Priority="10" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Title"></w:LsdException>
<w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"></w:LsdException>
<w:LsdException Locked="false" Priority="11" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtitle"></w:LsdException>
<w:LsdException Locked="false" Priority="22" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Strong"></w:LsdException>
<w:LsdException Locked="false" Priority="20" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="59" SemiHidden="false"
UnhideWhenUsed="false" Name="Table Grid"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"></w:LsdException>
<w:LsdException Locked="false" Priority="1" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="No Spacing"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"></w:LsdException>
<w:LsdException Locked="false" Priority="34" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"></w:LsdException>
<w:LsdException Locked="false" Priority="29" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="30" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="19" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="21" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="31" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="32" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="33" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Book Title"></w:LsdException>
<w:LsdException Locked="false" Priority="37" Name="Bibliography"></w:LsdException>
<w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"></w:LsdException>
</w:LatentStyles>
</xml><![endif]-->
    
    <!-- [if gte mso 10]>




<![endif]-->
    
    <!--StartFragment-->
    
    <span lang="EN-US">[</span><span lang="EN-US">DscProperty</span><span lang="EN-US">(NotConfigurable)], this is a "read only" parameter which will be set by the Get() method.</span>
  * <!-- [if gte mso 9]><xml>
<o:OfficeDocumentSettings>
<o:RelyOnVML></o:RelyOnVML>
<o:AllowPNG></o:AllowPNG>
</o:OfficeDocumentSettings>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:TrackMoves></w:TrackMoves>
<w:TrackFormatting></w:TrackFormatting>
<w:PunctuationKerning></w:PunctuationKerning>
<w:ValidateAgainstSchemas></w:ValidateAgainstSchemas>
<w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
<w:IgnoreMixedContent>false</w:IgnoreMixedContent>
<w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
<w:DoNotPromoteQF></w:DoNotPromoteQF>
<w:LidThemeOther>EN-US</w:LidThemeOther>
<w:LidThemeAsian>ZH-CN</w:LidThemeAsian>
<w:LidThemeComplexScript>TA</w:LidThemeComplexScript>
<w:Compatibility>
<w:BreakWrappedTables></w:BreakWrappedTables>
<w:SnapToGridInCell></w:SnapToGridInCell>
<w:WrapTextWithPunct></w:WrapTextWithPunct>
<w:UseAsianBreakRules></w:UseAsianBreakRules>
<w:DontGrowAutofit></w:DontGrowAutofit>
<w:SplitPgBreakAndParaMark></w:SplitPgBreakAndParaMark>
<w:EnableOpenTypeKerning></w:EnableOpenTypeKerning>
<w:DontFlipMirrorIndents></w:DontFlipMirrorIndents>
<w:OverrideTableStyleHps></w:OverrideTableStyleHps>
<w:UseFELayout></w:UseFELayout>
</w:Compatibility>
<m:mathPr>
<m:mathFont m:val="Cambria Math"></m:mathFont>
<m:brkBin m:val="before"></m:brkBin>
<m:brkBinSub m:val="&#45;-"></m:brkBinSub>
<m:smallFrac m:val="off"></m:smallFrac>
<m:dispDef></m:dispDef>
<m:lMargin m:val="0"></m:lMargin>
<m:rMargin m:val="0"></m:rMargin>
<m:defJc m:val="centerGroup"></m:defJc>
<m:wrapIndent m:val="1440"></m:wrapIndent>
<m:intLim m:val="subSup"></m:intLim>
<m:naryLim m:val="undOvr"></m:naryLim>
</m:mathPr></w:WordDocument>
</xml><![endif]-->
    
    <!-- [if gte mso 9]><xml>
<w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true"
DefSemiHidden="true" DefQFormat="false" DefPriority="99"
LatentStyleCount="276">
<w:LsdException Locked="false" Priority="0" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Normal"></w:LsdException>
<w:LsdException Locked="false" Priority="9" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="heading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"></w:LsdException>
<w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 1"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 2"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 3"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 4"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 5"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 6"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 7"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 8"></w:LsdException>
<w:LsdException Locked="false" Priority="39" Name="toc 9"></w:LsdException>
<w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"></w:LsdException>
<w:LsdException Locked="false" Priority="10" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Title"></w:LsdException>
<w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"></w:LsdException>
<w:LsdException Locked="false" Priority="11" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtitle"></w:LsdException>
<w:LsdException Locked="false" Priority="22" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Strong"></w:LsdException>
<w:LsdException Locked="false" Priority="20" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="59" SemiHidden="false"
UnhideWhenUsed="false" Name="Table Grid"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"></w:LsdException>
<w:LsdException Locked="false" Priority="1" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="No Spacing"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"></w:LsdException>
<w:LsdException Locked="false" Priority="34" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"></w:LsdException>
<w:LsdException Locked="false" Priority="29" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="30" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 1"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 2"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 3"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 4"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 5"></w:LsdException>
<w:LsdException Locked="false" Priority="60" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="61" SemiHidden="false"
UnhideWhenUsed="false" Name="Light List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="62" SemiHidden="false"
UnhideWhenUsed="false" Name="Light Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="63" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="64" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="65" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="66" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium List 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="67" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="68" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="69" SemiHidden="false"
UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="70" SemiHidden="false"
UnhideWhenUsed="false" Name="Dark List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="71" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Shading Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="72" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful List Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="73" SemiHidden="false"
UnhideWhenUsed="false" Name="Colorful Grid Accent 6"></w:LsdException>
<w:LsdException Locked="false" Priority="19" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="21" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"></w:LsdException>
<w:LsdException Locked="false" Priority="31" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="32" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"></w:LsdException>
<w:LsdException Locked="false" Priority="33" SemiHidden="false"
UnhideWhenUsed="false" QFormat="true" Name="Book Title"></w:LsdException>
<w:LsdException Locked="false" Priority="37" Name="Bibliography"></w:LsdException>
<w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"></w:LsdException>
</w:LatentStyles>
</xml><![endif]-->
    
    <!-- [if gte mso 10]>




<![endif]-->
    
    <!--StartFragment-->
    
    <span lang="EN-US">[</span><span lang="EN-US">DscProperty</span><span lang="EN-US">(Mandatory)]</span><!--EndFragment--> , means this parameter is required. Without this the DSC resource will not be executed.

As an example for a class based resource I have migrated my cmdlet based resource to install a ConfigMgr primary site to a class based one. As you can see, inside of the class I can write regular PowerShell. In this case this is the Get() method of that resource.

<div id="wpshdo_32" class="wp-synhighlighter-outer">
  <div id="wpshdt_32" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_32"></a><a id="wpshat_32" class="wp-synhighlighter-title" href="#codesyntax_32"  onClick="javascript:wpsh_toggleBlock(32)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_32" onClick="javascript:wpsh_code(32)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_32" onClick="javascript:wpsh_print(32)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_32" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">        <span class="br0">[</span>ConfigMgrClass<span class="br0">]</span> Get<span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
            <span class="re0">$Configuration</span> <span class="sy0">=</span> <span class="br0">[</span><span class="re3">hashtable</span><span class="br0">]</span>::new<span class="br0">&#40;</span><span class="br0">&#41;</span>
            <span class="re0">$Configuration</span>.Add<span class="br0">&#40;</span><span class="st0">'SiteCode'</span><span class="sy0">,</span> <span class="re0">$this</span>.SiteCode<span class="br0">&#41;</span>
            try <span class="br0">&#123;</span>
                <span class="re0">$CMSite</span> <span class="sy0">=</span> Get<span class="sy0">-</span>CimInstance <span class="sy0">-</span>ClassName SMS_Site <span class="kw5">-Namespace</span> root\SMS\Site_$<span class="br0">&#40;</span><span class="re0">$this</span>.SiteCode<span class="br0">&#41;</span> <span class="kw5">-ErrorAction</span> Stop
                <span class="kw3">if</span> <span class="br0">&#40;</span><span class="re0">$CMSite</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
                    <span class="re0">$Configuration</span>.Add<span class="br0">&#40;</span><span class="st0">'Ensure'</span><span class="sy0">,</span><span class="st0">'Present'</span><span class="br0">&#41;</span>
                <span class="br0">&#125;</span>
                <span class="kw3">else</span> <span class="br0">&#123;</span>
                    <span class="re0">$Configuration</span>.Add<span class="br0">&#40;</span><span class="st0">'Ensure'</span><span class="sy0">,</span><span class="st0">'Absent'</span><span class="br0">&#41;</span>
                <span class="br0">&#125;</span>
            <span class="br0">&#125;</span>
            catch <span class="br0">&#123;</span>
                <span class="re0">$exception</span> <span class="sy0">=</span> <a href="about:blank"><span class="kw6">$_</span></a>
                 <span class="kw1">Write-Verbose</span> <span class="st0">'Error occurred'</span>
                 <span class="kw3">while</span> <span class="br0">&#40;</span><span class="re0">$exception</span>.InnerException <span class="kw4">-ne</span> <span class="re0">$null</span><span class="br0">&#41;</span>
                 <span class="br0">&#123;</span>
                     <span class="re0">$exception</span> <span class="sy0">=</span> <span class="re0">$exception</span>.InnerException
                     <span class="kw1">Write-Verbose</span> <span class="re0">$exception</span>.message
                 <span class="br0">&#125;</span>
                <span class="br0">&#125;</span>    
            <span class="kw3">return</span> <span class="re0">$Configuration</span>
        <span class="br0">&#125;</span></pre>
  </div>
</div>

As already mentioned above, you can see that I have to use _**$this.SiteCode**_ in order to use its value.
  
Save the file as **_[classname].psm1_** in a folder in the **$PSModulePath** which is called [classname].

# New-ModuleManifest {.}

From here on there's not a really big difference between working with a cmdlet or class based resource.
  
Use the New-ModuleManifest cmdlet to create the psd1 file.

<div id="wpshdo_33" class="wp-synhighlighter-outer">
  <div id="wpshdt_33" class="wp-synhighlighter-expanded">
    <table border="0" width="100%">
      <tr>
        <td align="left" width="80%">
          <a name="#codesyntax_33"></a><a id="wpshat_33" class="wp-synhighlighter-title" href="#codesyntax_33"  onClick="javascript:wpsh_toggleBlock(33)" title="Click to show/hide code block">Source code</a>
        </td>
        
        <td align="right">
          <a href="#codesyntax_33" onClick="javascript:wpsh_code(33)" title="Show code only"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/code.png" /></a>&nbsp;<a href="#codesyntax_33" onClick="javascript:wpsh_print(33)" title="Print code"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/printer.png" /></a>&nbsp;<a href="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/About.html', '']);" target="_blank" title="Show plugin information"><img border="0" style="border: 0 none" src="http://www.david-obrien.net/David/wp-content/plugins/wp-synhighlight/themes/default/images/info.gif" /></a>&nbsp;
        </td>
      </tr>
    </table>
  </div>
  
  <div id="wpshdi_33" class="wp-synhighlighter-inner" style="display: block;">
    <pre class="powershell" style="font-family:monospace;">New<span class="sy0">-</span>ModuleManifest <span class="kw5">-Path</span> <span class="st0">'C:\Program Files\WindowsPowerShell\Modules\ConfigMgrClass\ConfigMgrclass.psd1'</span> <span class="sy0">-</span>DscResourcesToExport <span class="st0">'ConfigMgrClass'</span> <span class="sy0">-</span>PowerShellVersion 5.0 <span class="kw5">-Description</span> <span class="st0">'Class based DSC resource to install roles and features of ConfigMgr'</span> <span class="sy0">-</span>ModuleVersion <span class="st0">'1.0.0.0'</span> <span class="sy0">-</span>Guid $<span class="br0">&#40;</span><span class="br0">[</span>guid<span class="br0">]</span>::NewGuid<span class="br0">&#40;</span><span class="br0">&#41;</span><span class="br0">&#41;</span> <span class="sy0">-</span>Author <span class="st0">'David OBrien'</span> <span class="sy0">-</span>RootModule <span class="st0">'.\ConfigMgrClass.psm1'</span> <span class="sy0">-</span>CompanyName <span class="st0">'DOCorp'</span></pre>
  </div>
</div>

In my previous article ([http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/](http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-introduction-part-1/) ) I mentioned that Get-DscResource is unable to find class based resource modules. Guess what?! Microsoft changed that with the current February release of WMF5.
  
In order to find your resource module, though, you need to add a new parameter to your Module Manifest, which is called <span lang="EN-US"><strong>DscResourcesToExport</strong>. This will make the class based resource discoverable to Get-DscResource.</span>

In the next part I will walk through my converted ConfigMgr resource and show you a couple of more classes I've implemented into this resource.

Until then, enjoy automating!
  
- <a href="http://www.twitter.com/david_obrien" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.twitter.com/david_obrien', 'David']);" target="_blank">David</a> 

<div style="float: right; margin-left: 10px;">
  <a href="https://twitter.com/share" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'https://twitter.com/share', 'Tweet']);" class="twitter-share-button" data-hashtags="classes,Desired+State+Configuration,Powershell,PSDSC,WMF5" data-count="vertical" data-url="http://www.david-obrien.net/2015/02/windows-powershell-dsc-classes-resource-basics-part-2/">Tweet</a>
</div>


