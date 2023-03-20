---
title: Automating Role Assignment Cleanup in Azure with PowerShell
date: 2023-03-19T00:01:30
layout: single-github
permalink: /2023/03/azure-role-assignment-cleanup
categories:
  - azure
tags:
  - azure
  - powershell
  - security
github_comments_issueid: 32
---

As an Azure administrator, maintaining a clean and secure environment is crucial. One aspect of keeping Azure organized is managing role assignments. Over time, you might end up with unused or "Unknown" role assignments, which can make management more challenging and potentially introduce security risks.<br>
In this blog post, we'll walk you through a handy PowerShell script to automate the cleanup of role assignments with an object type of "Unknown" in your Azure environment. This script works at both the resource group and subscription levels, ensuring a comprehensive cleanup.

## Script Overview

The PowerShell script provided in this blog post is designed to loop through all your Azure subscriptions and resource groups, identifying role assignments with an object type of "Unknown".<br>
Once these role assignments are detected, the script will remove them automatically. Additionally, the script checks if the necessary Az PowerShell module is installed and installs it if required. Finally, the script employs error handling to provide a more robust solution.

To run this script, simply open PowerShell, copy the script provided, and paste it into the console. The script will prompt you to log in to your Azure account if you haven't already done so.

## Script Breakdown

Let's go through the key components of the script:

1. Installing the Az module (if necessary): The script checks if the Az module is installed on your system. If it's not installed, the script will automatically install the module for the current user.

```powershell
if (-not (Get-Module -ListAvailable -Name Az)) {
    Write-Output "Installing Az module..."
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}
```

2. Logging into Azure: The Connect-AzAccount cmdlet is used to prompt the user to log in to their Azure account.

`Connect-AzAccount`

3. Looping through subscriptions: The script retrieves all subscriptions and iterates through each subscription to set the context.

```powershell
$subIds = Get-AzSubscription | Select-Object -ExpandProperty SubscriptionId
foreach ($subId in $subIds) {
    Set-AzContext -SubscriptionId $subId
    #...
}
```

4. Looping through resource groups: Within each subscription, the script retrieves all resource groups and iterates through them.

```powershell
$resourceGroups = Get-AzResourceGroup
foreach ($resourceGroup in $resourceGroups) {
    #...
}
```

5. Retrieving and processing role assignments: The script retrieves role assignments at both the resource group and subscription levels. It then checks if the object type is "Unknown" and removes the assignment if necessary.

```powershell
$assignments = Get-AzRoleAssignment -ResourceGroupName $resourceGroup.ResourceGroupName -ErrorAction SilentlyContinue
#...
if ($assignment.Properties.ObjectType -eq "Unknown") {
    # Remove the assignment
}
```

6. Error handling: The script implements try and catch blocks for handling errors at the resource group and subscription levels. This ensures that errors are caught and reported, allowing the script to continue processing other resources.

```powershell
try {
    # Process role assignments
}
catch {
    Write-Error "Error message: $_"
}
```

## Conclusion

This PowerShell script provides an efficient and automated way to clean up role assignments with an object type of "Unknown" in your Azure environment. By removing these unused role assignments, you can improve the organization and security of your Azure infrastructure. The script is designed to be user-friendly and robust, making it an essential tool for Azure administrators looking to streamline their environment management.<br>
Feel free to customize the script to suit your specific needs, and consider incorporating it into your regular maintenance tasks to keep your Azure environment clean and well-organized.
Find the complete script here on GitHub.<br>

{% gist 8b510deb60f39c18f7183caf5c4b9ac8 %}

To delete the role assignments, run the script with the parameter `-DeleteRoleAssignments $true`. If you don't provide the parameter or set it to $false, the script will only identify and display the "Unknown" role assignments without removing them.
