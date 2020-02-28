---
title: Right Tool For The Job
date: 2020-02-28T00:01:30
layout: single-github
permalink: /2020/02/powershell-python
categories:
  - tools
tags:
  - cloud
  - powershell
  - python
github_comments_issueid: 13
---

When I started off in IT in 2009 I was straight away introduced to Windows PowerShell, back then that was still PowerShell v1. Version 2 released later that year and now, 11 years later we're getting close to version 7. Time flies.<br>
PowerShell was a huge part of my career and arguably still is, so much so that my work with PowerShell was one of the reasons Microsoft awarded me with my first MVP Award back in [2013](/2013/10/first-time-awarded-microsoft-mvp/).<br>
I am most comfortable in day to day PowerShell scripting and light PowerShell development, so much so that even though I haven't used a Windows platform for my laptops in 3 years now, it is still my go-to language.

## Evolution Of Tools

A few years ago my focus shifted from on-premises to cloud (Azure and AWS) and this taught me that my toolset must evolve in order for me to keep up with the industry. I, the Citrix and ConfigMgr / SCCM guy, started learning about infrastructure as code, CI/CD, C#, Python, NodeJS, Go and modern ways of managing infrastructure in a cloud environment. I am far off from being fluent in any of those other programming languages, but know enough to think I can pick the right tool for the job.

## PowerShell vs Python

Recently I started working on a fun side-project with fellow MVP Alexandre Verkinderen where we made use of Azure Cognitive Services and needed to train a model with a big-ish number of images.<br>
These images needed to be categorised and moved into correct local directories based on tags in a CSV file. This does not sound too difficult. Small caveat, we are talking about around 130,000 images. Roughly 21GB of files. Small files.<br>
We naturally used PowerShell initially, because that is what we are used to, but Alex quickly started complaining to me that this process is taking ages.<br>
This here is the PowerShell script we used and everybody is absolutely invited to help us make this faster.

```powershell
$sourceloc = './dataset'
$targetloc = './target'
$records = Import-Csv train_labels.csv
$files = Get-ChildItem -Path $sourceloc
foreach ($file in $files){
  $data = $records| where-object FileName -eq $file.Name
  $destinationfolder = $targetloc +'\'+ $data.scientific_name
  $sourcefile = $sourceloc + '\' + $file.name
  Copy-Item -Path $sourcefile -Destination $destinationfolder -Force
}
```

This script took around 24hrs to sort about 8,000 images. Fair to say, that's slow.<br>
I went and wrote a small python script (runs on Windows and Linux) that does the same thing as the PowerShell script. Only it's also accepting parameters and does some more outputs.

```python
import csv
import os
from shutil import move
import argparse
from datetime import datetime

parser = argparse.ArgumentParser(description='Copy files into correct folders')
parser.add_argument("--i", default="input", help="Where to find all the images.")
parser.add_argument("--d", default="train_labels.csv", help="path to CSV file")
parser.add_argument("--t", default="target/", help="root of where to copy the files")
args = parser.parse_args()

now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
print("script start =", dt_string)

with open(args.d) as csv_file:
  csv_reader = list(csv.reader(csv_file, delimiter=','))
  line_count = 0
  files = os.scandir(args.i)
  for file in files:
    for row in csv_reader:
      if row[4] == file.name:
        target_location = args.t
        destination_path = target_location + row[3] + '/' + file.name
        os.makedirs(os.path.dirname(destination_path), exist_ok=True)
        move(file.path, destination_path)

now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
print("script end =", dt_string)
```

On my local laptop (16GB RAM, SSD, Ubuntu 19.10) it took 3hrs to sort all images. You think that's fast? This image here is Alex's result on a Windows Azure VM on the temp D:\ drive.

[![Python Move Files](/media/2020/02/python-move-images.jpg)](/media/2020/02/python-move-images.jpg)

39mins to move all 130,000 images.

## Why Python?

It's just another tool in your box. I do not just use what has worked for me for over a decade. I'm not a python magician and above script took me about 45mins to write (shockingly, most of that was the argument parsing). Yes, that's longer than what writing the PowerShell script would take, but look at the difference.<br>
I invite everybody to make the PowerShell script faster, but keep in mind, I believe that above PowerShell script is what at least 95% of all PowerShell scripters would have come up with as well.
