---
title: Azure Functions - handling secrets
date: 2016-09-14T12:30:30
layout: single
permalink: /2016/09/azure-functions-secrets/
categories:
  - Azure
tags:
  - serverless computing
  - NodeJS
  - PowerShell
  - Azure Functions
---

# How to handle secrets with Azure Functions

By the time you have finished working through "how-tos" or "101s" on any topic like this you will get to a point where you actually want to develop a real-life scenario, in our case here an Azure Function.
This usually involves passing around secrets like API keys to even trigger the Azure Function or API keys to authenticate on 3rd party APIs, database connection string or user passwords. These are all secrets you absolutely (!!!) do not want to hardcode into your scripts and have them potentially even committed to Source Control.

So how does on handle secrets on Azure Functions?
There are two different types of secrets we should look at.

# Where's my Azure Function API key?

Azure Functions can be triggered in several ways, for example HTTP calls. Check the screenshot for ways to configure authorization on that HTTP trigger in the Azure portal or read here more about it: https://azure.microsoft.com/en-us/documentation/articles/functions-bindings-http-webhook/#api-keys

![Azure Function authorization](/media/2016/09/azure_function_auth.PNG)

Connect to your KUDU console on `https://<azure_function_app_name>.scm.azurewebsites.net` and open up the debug console to get the API keys you need to trigger your function.

![Azure Function API keys](/media/2016/09/azure_function_api_keys.PNG)

Imagine a function configured like this:

```
{
  "bindings": [
    {
      "name": "req",
      "type": "httpTrigger",
      "direction": "in",
      "authLevel": "function"
    },
    {
      "name": "response",
      "type": "http",
      "direction": "out"
    }
  ],
  "disabled": false
}
```

This means we need the "function" API key from the `host.json` file or the API key from a `<function_name>.json` file and then we can invoke this function providing the call the http request parameter `code` or add the API key in the http header.
I would call these secrets "internal secrets" to Azure Functions. What about other secrets you don't want to hardcode into your function or just environment specific data for that matter?

# How to handle secrets

I will use my Slackbot here as an example. I am currently developing a fairly extensive Slackbot that can currently get aviation weather and a flight's status from [FlightAware](http://flightaware.com/) and present that back to the Slack user.

![metar Slackbot](/media/2016/09/slackbot.PNG)

I will soon also write an article explaining the Slackbot, for now the screenshot has to be enough though ;)

In order to use the FlightAware API I have to provide my personal API key to it to authenticate myself. FlightAware charges me for every invocation of an API call so I am hesitant to commit my API key to Source Control for everybody to reuse and max out my credit card.

Functions hosted on a Function app all share the same runtime environment so just be aware of this if you share an App with other teams.
On the Azure portal you will need to edit your Function App settings and there go into the "Application Settings" to view your environment information, including variables.

![Azure Functions environment variables](/media/2016/09/azure_function_env_vars.PNG)

You can see my two custom environment variables called `flightaware_api` and `flightaware_user` that I have created and now want to use in my function. 
Be aware that you currently cannot flag a variable as a "secret", this means that in the portal they will be in clear text. If you have access to the portal, you can see all environment variables.

Here is an example of how to use those "secrets" or variables in your code.

PowerShell:

```
$pair = "$($env:flightaware_user):$($env:flightaware_api)"
$encodedCreds = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$Headers = @{
  Authorization = $basicAuthValue
}
Invoke-RestMethod -Method Get -Uri "https://flightxml.flightaware.com/json/FlightXML2/MetarEx?airport=YMML&howMany=1" -Headers $Headers
```

The variables you create in the portal are later on going to be actual environment variables that you can access in your code like any other environment variable.

# The future

I hope that the Azure Functions team will soon start supporting Azure Key Vault to store secrets or support encrypting secrets in the app's environment and enable the app to read those secrets easily.
Whatever solution the team will go with it is imperative that it's blazingly fast. Just as an example, a Slack Bot by default times out after 3000ms.

What do you think? Do you like the way it is now? What would you like to see happening on Azure Functions? 