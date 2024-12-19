---
title: Azure - Save Money by Changing Disk Type
date: 2024-12-19T00:01:30
layout: single-github
permalink: /2024/12/azure-change-disk-type/
categories:
  - azure
  - finops
  - cost-optimization
  - virtual-machines
tags:
  - azure
github_comments_issueid: 38
---

Here's a quick tip to save money on your Azure VMs by changing the disk type. Especially over the holidays, when you might be running VMs for development or testing purposes, you can save a lot of money by changing the disk type, especially if you are using premium disks.<br>
Yes, turning off VMs when not in use is a good practice, but changing the disk type can save you even more money.

```powershell
# Define the resource group name
$resourceGroupName = "<resource-group-name>"

# Get all virtual machines in the specified resource group
$vms = Get-AzVM -ResourceGroupName $resourceGroupName

$newSku = "Standard_LRS"

# Loop through each VM and change the disk type to $newSku
foreach ($vm in $vms) {
    # Get the OS disk ID from the VM's storage profile
    $osDiskId = $vm.StorageProfile.OsDisk.ManagedDisk.Id
    
    # Retrieve the disk resource using its ID
    $osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName (Split-Path -Leaf $osDiskId)

    # Update the disk's Sku to $newSku if it is different
    if ($osDisk.Sku.Name -ne $newSku) {
        $osDisk.Tags["DesiredSku"] = $osDisk.Sku.Name
        $osDisk.Sku.Name = $newSku
        # Update the disk
        $osDisk | Update-AzDisk
        
        Write-Host "Updated disk type for VM $($vm.Name) from $($osDisk.Tags["DesiredSku"]) to $newSku"
    }
    # Check if the disk type needs to be reverted back
    elseif ($osDisk.Tags["DesiredSku"] -and $osDisk.Sku.Name -ne $osDisk.Tags["DesiredSku"]){
        $osDisk.Sku.Name = $osDisk.Tags["DesiredSku"]
        $osDisk.Tags.Remove("DesiredSku")
        # Update the disk
        $osDisk | Update-AzDisk
        
        Write-Host "Updated disk type for VM $($vm.Name) back to $($osDisk.Sku.Name)"
    }
}
```

(Updated on 20/12/2024 with a great addition by "AzureToujours" on [Reddit](https://www.reddit.com/r/AZURE/comments/1hhpvkd/comment/m2t6xb0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button))

This script will change the disk type of all VMs in the specified resource group to HDD (Standard HDD). You can modify the script to change the disk type to SSD (Standard SSD) or any other type supported by Azure. Make sure to test the script in a non-production environment before running it in production. While it is safe to change the disk type, it is always a good practice to test any automation scripts before applying them to production resources.