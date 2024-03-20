---
title: Continuous Access Evaluation in Entra ID
date: 2024-03-20T00:01:30
layout: single-github
permalink: /2024/03/continuous-access-evaluation-in-entra-id
categories:
  - entraid
tags:
  - entraid
  - continuous access evaluation
  - security
  - governance
github_comments_issueid: 35
---

## Unlocking the Potential of Continuous Access Evaluation

Traditional methods issue access tokens to APIs for a duration of typically 60 minutes (1 hour) and allow applications to use refresh tokens to ask for new tokens once the original token expired. Unlike traditional methods that rely on this periodic re-evaluation, Continuous Access Evaluation (CAE) offers automated real-time monitoring and decision-making capabilities based on signals from the evaluation of Conditional Access Policies. This means that access rights can be adjusted instantly in response to changing client conditions or emerging threats, ensuring that only the right entities have access at the right times.

## Safeguarding Workload Identities with Precision

With more and more cloud-based applications leveraging workload identities — which represent applications and services rather than individuals — stringent protection of these is important. CAE specifically addresses the unique challenges associated with securing these non-human entities, providing a mechanism to continuously assess and enforce access policies based on current threat levels and security requirements.

## Implementing CAE in Entra ID Applications

Integrating CAE into Entra ID Enterprise Applications is an important step to bolster their security measures. The process involves leveraging Microsoft Entra ID's advanced security protocols to monitor access patterns and respond to anomalies in real-time. This proactive stance on security not only mitigates risks but also aligns with regulatory compliance standards, offering peace of mind to businesses and their stakeholders.

> Developers can opt in to Continuous access evaluation for workload identities when their API requests `xms_cc` as an optional claim. The `xms_cc` claim with a value of `cp1` in the access token is the authoritative way to identify a client application is capable of handling a claims challenge.
<a href="https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation-workload#enable-your-application" target="_blank">Microsoft Documentation</a><br>
One thing to note, if you have the Azure PowerShell `Az.Accounts` installed with version 11.3.0 or later, then you can already leverage CAE with PowerShell. The release notes for Azure PowerShell mention `Enabled Continue Access Evaluation (CAE) for all Service Principals login methods.` <a href="https://learn.microsoft.com/en-us/powershell/azure/release-notes-azureps?view=azps-11.4.0#1130---february-2024" target="_blank">PowerShell release notes</a>

## Not just a Technical Solution

Adopting new technologies often comes with its set of challenges, and CAE is no exception. However, the key to successfully implementing CAE lies in understanding its operational nuances and being prepared to address potential issues. One commonly overlooked aspect of CAE is the need for a cultural shift within organisations. This shift involves fostering a security-first mindset and ensuring that all stakeholders are aligned with the principles of CAE. This also includes the need for continuous training and awareness programmes to keep everyone informed about the evolving security landscape and implications to their day-to-day operations.

## Embracing the Future of Cybersecurity

CAE marks a significant milestone in the evolution of access control mechanisms. By offering a more nuanced and responsive approach to security, it sets a new standard for protecting critical digital assets. As we all move forward, the integration of CAE into cybersecurity strategies will be pivotal for security teams in combating the threats that loom in the cloud.<br>
For more detailed information on Continuous Access Evaluation and its application to workload identities, I highly recommend visiting Microsoft's official documentation on the topic. Here are the links to get you started:

- Continuous Access Evaluation in Microsoft Entra: <a href="https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation" target="_blank">Microsoft Documentation</a>
- Continuous Access Evaluation for Workload Identities: <a href="https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-continuous-access-evaluation-workload" target="_blank">Microsoft Documentation</a>
