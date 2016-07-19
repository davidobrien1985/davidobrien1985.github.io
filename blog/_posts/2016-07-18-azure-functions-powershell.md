---
title: Azure Functions - PowerShell
date: 2016-07-18T01:30:30
layout: single
permalink: /2016/07/azure-functions-PowerShell/
categories:
  - Azure
tags:
  - Azure
  - ARM
  - Microsoft
  - PowerShell
  - serverless
---

# PowerShell runtime in Azure Functions

This is part 2 in this series of articles on the Azure Functions platform. If you're after part 1, check here: [the what and why](/2016/07/azure-functions-what-and-why/)
The following article will provide a more closer look at how Azure Functions can be used by you, the PowerShell guy.

<!--more-->

Now that I have done a quick intro to Azure Functions in general, I also need to make a quick statement:

>Azure Functions is still in active development and is undergoing a lot of changes. I will try to keep these articles as up to date as possible, but please keep an eye on the "last updated" date on the articles and compare it to the actual Azure Functions version out there.

With that out of the way, let's get into it.

## Getting started

I am going to assume here that you have already created your Function App, if not, please do that here: <https://azure.microsoft.com/en-us/services/functions/>

## Environment

Azure Functions is a shared environment. This means that you will unlikely get a dedicated runner for yourself to run your functions. This shouldn't cause too many issues, permitted that Microsoft can scale the number of runners quickly enough if need be. I don't want my customers to wait just because my job is queued up to be executed.
As of writing this article the PowerShell environment comes with PowerShell version 4 and the following configuration:

```
Name                           Value                                            
----                           -----                                            
$                                                                               
?                              True                                             
^                                                                               
args                           {}                                               
ConfirmPreference              High                                             
ConsoleFileName                                                                 
DebugPreference                SilentlyContinue                                 
Error                          {}                                               
ErrorActionPreference          Continue                                         
ErrorView                      NormalView                                       
ExecutionContext               System.Management.Automation.EngineIntrinsics    
false                          False                                            
FormatEnumerationLimit         4                                                
HOME                                                                            
Host                           System.Management.Automation.Internal.Host.Int...
input                          System.Collections.ArrayList+ArrayListEnumerat...
InvocationId                   430821e4-8e11-49c4-b25c-f3447b5d809e             
MaximumAliasCount              4096                                             
MaximumDriveCount              4096                                             
MaximumErrorCount              256                                              
MaximumFunctionCount           4096                                             
MaximumHistoryCount            4096                                             
MaximumVariableCount           4096                                             
MyInvocation                   System.Management.Automation.InvocationInfo      
NestedPromptLevel              0                                                
null                                                                            
OutputEncoding                 System.Text.ASCIIEncoding                        
PID                            26508                                            
ProgressPreference             Continue                                         
PSBoundParameters              {}                                               
PSCommandPath                                                                   
PSCulture                      en-US                                            
PSDefaultParameterValues       {}                                               
PSEmailServer                                                                   
PSHOME                         D:\Windows\SysWOW64\WindowsPowerShell\v1.0       
PSScriptRoot                                                                    
PSSessionApplicationName       wsman                                            
PSSessionConfigurationName     http://schemas.microsoft.com/powershell/Micros...
PSSessionOption                System.Management.Automation.Remoting.PSSessio...
PSUICulture                    en-US                                            
PSVersionTable                 {PSVersion, WSManStackVersion, SerializationVe...
PWD                            D:\Windows\system32                              
req                            D:\local\Temp\Functions\Binding\430821e4-8e11-...
REQ_HEADERS_ACCEPT             application/json                                 
REQ_HEADERS_ACCEPT-ENCODING    gzip                                             
REQ_HEADERS_ACCEPT-LANGUAGE    en-US                                            
REQ_HEADERS_CONNECTION         Keep-Alive                                       
REQ_HEADERS_DISGUISED-HOST     dotest.azurewebsites.net                         
REQ_HEADERS_HOST               dotest.azurewebsites.net                         
REQ_HEADERS_MAX-FORWARDS       10                                               
REQ_HEADERS_ORIGIN             https://functions.azure.com                      
REQ_HEADERS_REFERER            https://functions.azure.com/?trustedAuthority=...
REQ_HEADERS_USER-AGENT         Mozilla/5.0                                      
REQ_HEADERS_X-ARR-LOG-ID       b0502400-7351-46c6-900c-a9d07070fe07             
REQ_HEADERS_X-ARR-SSL          2048|256|C=US, S=Washington, L=Redmond, O=Micr...
REQ_HEADERS_X-FORWARDED-FOR    123.254.126.130:21429                            
REQ_HEADERS_X-FUNCTIONS-KEY    1zR863sFjMesKNgJh1Rq7TFjcSdBls7ai3QMswBXhqUJtg...
REQ_HEADERS_X-LIVEUPGRADE      1                                                
REQ_HEADERS_X-MS-DEFAULT-HO... dotest.azurewebsites.net                         
REQ_HEADERS_X-ORIGINAL-URL     /api/httptriggerpowershell1                      
REQ_HEADERS_X-SITE-DEPLOYME... dotest                                           
REQ_METHOD                     POST                                             
res                            D:\local\Temp\Functions\Binding\430821e4-8e11-...
ShellId                        Microsoft.PowerShell                             
StackTrace                                                                      
true                           True                                             
VerbosePreference              SilentlyContinue                                 
WarningPreference              Continue                                         
WhatIfPreference               False
```

The following modules are available by default:

```
Name                                     Version                                
----                                     -------                                
AppLocker                                1.0.0.0                                
Appx                                     1.0.0.0                                
BitsTransfer                             1.0.0.0                                
BranchCache                              1.0.0.0                                
CimCmdlets                               1.0.0.0                                
DirectAccessClientComponents             1.0.0.0                                
Dism                                     1.0                                    
DnsClient                                1.0.0.0                                
FileServerResourceManager                1.1.1.1                                
iSCSI                                    1.0.0.0                                
IscsiTarget                              1.0.0.0                                
ISE                                      1.0.0.0                                
Kds                                      1.0.0.0                                
Microsoft.PowerShell.Diagnostics         3.0.0.0                                
Microsoft.PowerShell.Host                3.0.0.0                                
Microsoft.PowerShell.Management          3.1.0.0                                
Microsoft.PowerShell.Security            3.0.0.0                                
Microsoft.PowerShell.Utility             3.1.0.0                                
Microsoft.WSMan.Management               3.0.0.0                                
MsDtc                                    1.0.0.0                                
NetAdapter                               1.0.0.0                                
NetConnection                            1.0.0.0                                
NetLbfo                                  1.0.0.0                                
NetQos                                   1.0                                    
NetSecurity                              1.0.0.0                                
NetSwitchTeam                            1.0.0.0                                
NetTCPIP                                 1.0.0.0                                
NetworkConnectivityStatus                1.0.0.0                                
NetworkTransition                        1.0.0.0                                
PKI                                      1.0.0.0                                
PrintManagement                          1.0                                    
PSDiagnostics                            1.0.0.0                                
PSScheduledJob                           1.1.0.0                                
ScheduledTasks                           1.0.0.0                                
SecureBoot                               1.0.0.0                                
SmbShare                                 1.0.0.0                                
Storage                                  1.0.0.0                                
TroubleshootingPack                      1.0.0.0                                
TrustedPlatformModule                    1.0.0.0                                
VpnClient                                1.0.0.0                                
Wdac                                     1.0.0.0                                
WebAdministration                        1.0.0.0                                
Whea                                     1.0.0.0                                
WindowsDeveloperLicense                  1.0.0.0                                
WindowsErrorReporting                    1.0                                    
PEF                                      1.1.0.0                                
AzureRM.ApiManagement                    1.1.0                                  
AzureRM.Automation                       1.0.8                                  
AzureRM.AzureStackAdmin                  0.9.5                                  
AzureRM.AzureStackStorage                0.9.6                                  
AzureRM.Backup                           1.0.8                                  
AzureRM.Batch                            1.1.0                                  
AzureRM.Cdn                              1.0.2                                  
AzureRM.Compute                          1.3.0                                  
AzureRM.DataFactories                    1.0.8                                  
AzureRM.DataLakeAnalytics                1.1.0                                  
AzureRM.DataLakeStore                    1.0.8                                  
AzureRM.Dns                              1.0.8                                  
AzureRM.HDInsight                        1.1.0                                  
AzureRM.Insights                         1.0.8                                  
AzureRM.KeyVault                         1.1.7                                  
AzureRM.LogicApp                         1.0.4                                  
AzureRM.Network                          1.0.9                                  
AzureRM.NotificationHubs                 1.0.8                                  
AzureRM.OperationalInsights              1.0.8                                  
AzureRM.Profile                          1.0.8                                  
AzureRM.RecoveryServices                 1.1.0                                  
AzureRM.RecoveryServices.Backup          1.0.0                                  
AzureRM.RedisCache                       1.1.6                                  
AzureRM.Resources                        1.1.0                                  
AzureRM.SiteRecovery                     1.1.7                                  
AzureRM.Sql                              1.0.8                                  
AzureRM.Storage                          1.1.0                                  
AzureRM.StreamAnalytics                  1.0.8                                  
AzureRM.Tags                             1.0.8                                  
AzureRM.TrafficManager                   1.0.8                                  
AzureRM.UsageAggregates                  1.0.8                                  
AzureRM.Websites                         1.1.0                                  
Azure                                    1.4.0                                  
Azure.Storage                            1.1.2
```

I wasn't able to figure out which OS this is running as you don't have access to WMI, which is totally fine, you shouldn't need to anyways.

## Example Function with http trigger

I used the following PowerShell "Function" at a meetup the other day to demonstrate the service.

<script src="http://gist-it.appspot.com/https://github.com/davidobrien1985/azure_functions/blob/master/icao_weather.ps1"></script>

The code can be copied into the `HttpTrigger` template code window without change and then executed by calling the function's URL with a query_string provided on the URL.

![Azure Function URL](/media/2016/07/azure_functions_url.png)

In my example I would execute it like this:
`https://dotest.azurewebsites.net/api/metar?icao=ymml`

I have enabled `anonymous` authorization for this test function, which means that I don't have to provide any auth keys in order to execute this function.

The purpose of this function is to query an external API, prettify the output and present the user with the weather at a given airport, in this example this is YMML (Melbourne Tullamarine in Australia)

## Internal variables (query string)

The function needs input in form of a string, the 4 letter code for the airport to get the weather for. We can provide the input on the URL as a query string as you might have already seen in above example.
Azure Functions will know what to do with it and then create environment variables for each of the parameters provided in the header in the form of `$req_query_<param>`.
Check above code for the use of this parameter.

Again, this is not documented right now and might change in future versions.

## Clean up after yourself in your dev environment

Make sure (like I will after publishing this article) that you disable the function when you're done with it and have no authorization configured on it.

In the next article I will cover custom modules and the config of your Function.