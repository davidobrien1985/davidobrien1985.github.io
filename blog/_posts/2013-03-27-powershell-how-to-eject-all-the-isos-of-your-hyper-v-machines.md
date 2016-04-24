---
id: 875
title: 'Powershell&ndash;How to eject all the ISOs of your Hyper-V machines?'
date: 2013-03-27T00:02:38+00:00
author: "David O'Brien"
layout: single

permalink: /2013/03/powershell-how-to-eject-all-the-isos-of-your-hyper-v-machines/
categories:
  - Hyper-V
  - PowerShell
  - scripting
tags:
  - Hyper-V
  - Powershell
  - Win8
---
Quick post before going to bed ;-)

## Ejecting ISOs of Hyper-V machines with Powershell

I’m using my Windows’ 8 client Hyper-V since switching over to Win8 and I love it. I had so much problems with VMware Workstation’s network configuration and now it’s so much simpler (forgetting the Internet Connection Sharing problems I got…).

Well, I usually have all my ISOs I need on a daily basis on my external USB hard drive and mount those ISOs as DVD drives into my machines. Not too special, I know ;-)

But I tend to forget where I mounted what and when I try to disconnect my USB drive it nearly always moans about some file still being in use, which in 99% of all cases is an ISO mounted to a VM.

That’s why I wrote this little script.

What does it do?

* enumerate all VMs on your local machine
* looks if any has something in their DVD drives
  * if so, “ejects” the ISO

That’s it!

After that, all is good again.

```
$VMs = Get-VM
foreach ($VM in $VMs)
{
  if (-not $((Get-VMDvdDrive -VMName $VM.VMName).Path -eq $null))
  {
    Write-Verbose "$($VM.VMName)´'s DVD drive is not empty. Going to eject the ISO now"
    Get-VMDvdDrive -VMName $VM.Name | Set-VMDvdDrive -Path $null
    if ($?)
    {
      "All good!"
    }
  }
}
```


