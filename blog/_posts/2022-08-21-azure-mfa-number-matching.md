---
title: Azure MFA - Enhanced Context with Number Matching
date: 2022-08-21T00:01:30
layout: single-github
permalink: /2022/08/azure-mfa-enhanced-context
categories:
  - azure
tags:
  - azure
  - multi-factor-authentication
  - mfa
  - security
github_comments_issueid: 28
---

Multi-factor authentication (MFA) is one of the best ways to protect your identity in an online world. Microsoft even claims that using MFA <a href="https://www.zdnet.com/article/microsoft-using-multi-factor-authentication-blocks-99-9-of-account-hacks/" target="_blank">blocks 99.9% of all automated attacks</a> to your identity.<br>
Lately however the <a href="https://portswigger.net/daily-swig/mfa-fatigue-attacks-users-tricked-into-allowing-device-access-due-to-overload-of-push-notifications" target="_blank">industry has seen attacks on MFA</a> protected accounts where attackers repeatedly send MFA prompts to end users in the hope that someone will eventually just approve the request, without looking at it too hard. These attacks are called "MFA fatigue attacks" and are regularly seen on Microsoft Office 365 accounts.<br>
How are these attacks successful? Often MFA requests do not have enough context. You might not necessarily be told which application sent the request, or where (geographically) the request originated.

## Azure MFA Number Matching

One issue with MFA has often been that I, an attacker, could open a browser, send a request, and the attacked person, without seeing the browser, could allow/grant my request. Azure MFA now has a new (currently in preview) feature that is called "Number Matching". To enable this new feature (which seems to be for free), browse to <a href="https://portal.azure.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/AdminAuthMethods" target="_blank">the Azure AD portal</a> and ensure the _Microsoft Authenticator_ method is enabled. Either target this at "All Users" or a select group of users. To the right you can see three `...` to open a context menu.<br>

[![Azure MFA Authenticator Configuration](/media/2022/08/authenticator_configure.png)](/media/2022/08/authenticator_configure.png)

In this context menu you can configure a few things, mainly though to require `number matching` and to `show additional context in notifications`.

[![Azure MFA Number Matching](/media/2022/08/azure_mfa_number_matching.png)](/media/2022/08/azure_mfa_number_matching.png)

Once you have enabled both these settings, the next time a user logs in to their Azure AD / Office 365 account they will be prompted to type in a number in their Microsoft Authenticator app. They will only know that number, if they can also see the browser the request originated from. This means the "MFA fatigue attack" vector is almost eliminated, unless one can socially engineer a person to type in the number (which is certainly possible).<br>
The additional context is another great security feature. The MFA prompt on the Microsoft Authenticator app will also show where in the world, based on the client IP, the request is coming from, in addition to which application initiated it.<br>
In the end, it will look something like this.

[![Azure MFA Number Matching Client](/media/2022/08/number_match.png)](/media/2022/08/number_match.png)
[![Azure MFA Number Matching Client](/media/2022/08/additional_info.png)](/media/2022/08/additional_info.png)
