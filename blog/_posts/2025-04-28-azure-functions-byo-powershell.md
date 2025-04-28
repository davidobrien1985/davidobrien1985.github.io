---
title: Azure Functions - Learnings from executing PowerShell from C#
date: 2025-04-27T00:01:30
layout: single-github
permalink: /2025/04/azure-fucntions-byo-powershell/
categories:
  - azure
  - azure-functions
  - powershell
  - csharp
tags:
  - azure
github_comments_issueid: 39
---

Our SaaS (<a href="https://argos-security.io" target="_blank">ARGOS Cloud Security</a>) is developed in C# and 95% of our application runs on Azure Functions. As ARGOS is about to get its latest new feature, the capability to assess more M365 components, we now have a requirement to execute PowerShell scripts from this c# code as certain M365 APIs are only exposed via Microsoft's own PowerShell modules. (looking at you, Exchange Online).<br>
This sounded like a straightforward task, but it turned out to be a bit more complex than expected. Here are some of the challenges we faced and how we solved them.

- We use Azure Functions Flex Consumption plan, which means we do not have access to Kudu. Most of the examples on the internet assume access to Kudu in order to install the PowerShell modules. This is not possible in our case, so we had to find a different way to install the modules.
- Azure Functions says "`pwsh` what?"
- We mostly develop on Windows, but our Azure Functions run on Linux. This means that we have to be careful about the modules we install and make sure they are compatible with Linux. While we live in a cross-platform world, down to the OS and file system level, there are subtle differences that can cause issues.

## Installing PowerShell modules in Azure Functions

The first step was to decide how to install the required PowerShell modules. As we couldn't copy the modules to the Kudu site (and really, that's a pretty clunky way to do it), we decided to bundle the modules with our code.

[![Folder Structure](/media/2025/04/root-folder.png)](/media/2025/04/root-folder.png)
[![PowerShell modules](/media/2025/04/modules.png)](/media/2025/04/modules.png)

The folder structure above shows how we bundled the modules with our code. The `modules` folder contains the PowerShell modules we need, and the `PowerShell` folder contains the PowerShell scripts we want to execute. The way we did this is by using the `Save-Module` cmdlet to save the modules to a folder locally. We then committed this folder to our repository. This way, we can be sure that the modules are always available when we deploy our code. This was probably the easiest part of the whole process.

## Executing PowerShell from C#

Executing PowerShell from c# is not an uncommon task, but with Azure Functions, if you're not on Windows and using the PowerShell language worker, it can be a bit tricky. `powershell` is not available on Linux, and `pwsh` is not installed on Flex Consumption. There is, as of now, no way to install third party dependencies in Azure Functions Flex Consumption. Who knows, maybe this will change in the future, but for now, we have to work with what we have.<br>
So, similar to the way we bundled the modules, we also had to bundle the PowerShell executable with our code. (Shoutout to the ever-so-helpful <a href="https://www.linkedin.com/in/thiagoalmeidaprofile/" target="_blank">Thiago Almeida<b> for the tip!).<br>
This is how we did it:<br>

- go to the <a href="https://github.com/PowerShell/PowerShell/releases" target="_blank">PowerShell GitHub repository</a> and download the latest release for Linux. The `tar.gz` file is a compressed file that contains the PowerShell executable and all the required files to run PowerShell on Linux.
- extract the `tar.gz` file and copy the `pwsh` executable and all its dependencies to the `powershell` folder in our code. This way, we can execute PowerShell from c# without having to install it on the Azure Functions host. (Important: Linux is case-sensitive, so make sure to reference the files and folders with the correct casing.)
- we call the `pwsh` executable from c# and pass the path to the PowerShell script we want to execute as an argument. We also pass the path to the modules folder as an argument, so PowerShell can find the modules when it executes the script.

[![Call pwsh from c#](/media/2025/04/call-pwsh.png)](/media/2025/04/call-pwsh.png)

```csharp
string scriptPath = Path.Combine(AppContext.BaseDirectory, "HelperScripts", "GetTransportRule.ps1");
string powerShellPath = Path.Combine(AppContext.BaseDirectory, "powershell", "pwsh");

// Build arguments for the PowerShell script to be executed
var arguments = $"-NoProfile -NonInteractive -File \"{scriptPath}\" -organization \"{organization}\"";
if (!string.IsNullOrWhiteSpace(accessToken))
{
    arguments += $" -accessToken \"{accessToken}\"";
}
else if (!string.IsNullOrWhiteSpace(appRegistrationClientId) && !string.IsNullOrWhiteSpace(certificateThumbprint))
{
    arguments += $" -entraAppId \"{appRegistrationClientId}\" -thumbprint \"{certificateThumbprint}\"";
}

var startInfo = new ProcessStartInfo
{
    FileName = powerShellPath,
    Arguments = arguments,
    RedirectStandardOutput = true,
    RedirectStandardError = true,
    CreateNoWindow = true,
    UseShellExecute = false,
};

using var process = new Process { StartInfo = startInfo };
process.Start();

// Capture outputs
var outputJson = await process.StandardOutput.ReadToEndAsync();
var errorOutput = await process.StandardError.ReadToEndAsync();

await process.WaitForExitAsync();
```

The code above shows how we call the `pwsh` executable from c#. We use the `ProcessStartInfo` class to configure the process and redirect the output. We also wait for the process to exit and capture the output and error messages. It's not important for this blog post to explain what the script itself does.<br>
The important part is that running this code locally works perfectly, but when we deploy it to Azure Functions, we get a strange error message. Remember, we mostly develop on Windows, but our Azure Functions run on Linux. File permissions are a common issue when running code on Linux, and this is where we ran into trouble. The error message we got post deployment was:

```
An error occurred trying to start process '/home/site/wwwroot/powershell/pwsh' with working directory '/home/site/wwwroot'. Permission denied
```

Huh? Weird. Why? The `pwsh` executable is not executable? We checked the permissions on the file in WSL even and it was set to `-rwxrwxrwx`, which means that the file is executable. So why is it not working?

`-rwxrwxrwx 1 adobrien adobrien    75144 Jan 17 10:18 pwsh*`

Is Windows or WSL doing something magic to make it work locally? Is our code somehow using a different version of `pwsh` that is installed on our machine?<br>
This led us down a rabbit hole of trying to figure out how to make the `pwsh` executable executable on Azure Functions. We tried everything we could think of:

- changing the permissions on the file using `chmod` (which didn't work because the file was already executable)
- changing the file permissions in `Program.cs` which is executed when the function worker starts. For some reason, this didn't work either.
- decided to take Windows out of the equation and download the `pwsh` executable during the GitHub Actions build process, instead of bundling it with our code. We then checked the permissions on the file before bundling it into the release package and deploying it to Azure Functions. This also didn't work, as the file was still not executable after deployment.

This gave us a clue that the problem was not with how we called the `pwsh` executable, but how it was deployed.

## The Solution

Here is the final GitHub Actions workflow that we use to build and deploy our code. It includes the steps to download the `pwsh` executable, set the permissions, and deploy the code to Azure Functions.<br>
One will note the `tar` command in the workflow. This is used to preserve the permissions on the files when we bundle them into a tarball. This is because of this little gem of information I found on the internet: <a href="https://github.com/actions/upload-artifact/tree/v4/?tab=readme-ov-file#permission-loss" target="_blank">GitHub Actions - Upload Artifact</a><br>

| File permissions are not maintained during artifact upload. All directories will have 755 and all files will have 644. For example, if you make a file executable using chmod and then upload that file, post-download the file is no longer guaranteed to be set as an executable.

This explains why even though the `actions/upload-artifact@v4` action packages the artifact, the permissions are lost when we download it again in the `publish-scanflex` job using the `actions/download-artifact@v4` action. The `tar` command preserves the permissions on the files, so when we extract the tarball, the permissions are set correctly.

```yaml
name: Deploy ARGOS Scan Azure Functions

on:
  repository_dispatch:
    types: deploy-functions
  push:
    branches:
      - main
    paths:
      - <paths>

env:
  AZURE_FUNCTIONAPP_FLEX_NAME: <functionapp-name>
  AZURE_FUNCTIONAPP_PACKAGE_PATH: <path-to-package>
  DOTNET_VERSION: '8.x.x'
  POWERSHELL_VERSION: '7.5.0'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: 'Checkout GitHub Action'
      uses: actions/checkout@v4

    - name: Setup DotNet ${{ env.DOTNET_VERSION }} Environment
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: ${{ env.DOTNET_VERSION }}

    - name: 'Build Package'
      run: |
        cd "${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}"
        dotnet publish --configuration ReleaseScan --output ./output

    - name: 'Download and Extract PowerShell'
      run: |
        cd "${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}/output"
        curl -L -o ./powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v${{env.POWERSHELL_VERSION}}/powershell-${{env.POWERSHELL_VERSION}}-linux-x64.tar.gz
        mkdir -p powershell
        tar zxf ./powershell.tar.gz -C ./powershell
        rm -rf powershell.tar.gz
  
    - name: 'Make pwsh Executable'
      run: |
        cd "${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}/output/powershell"
        chmod +x pwsh

    - name: 'Tar output directory to preserve permissions'
      run: |
        cd "${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}"
        tar -cvf output.tar output

    - name: 'Upload Build Artifacts'
      uses: actions/upload-artifact@v4
      with:
        name: argos-scan-build
        path: Argos/Argos.Scan/output.tar
        include-hidden-files: true
  
  publish-scanflex:
    runs-on: ubuntu-latest
    needs: build
    steps:
    - name: 'Download Build Artifacts'
      uses: actions/download-artifact@v4
      with:
        name: argos-scan-build
        path: .

    - name: 'Extract output tarball'
      run: |
        tar -xvf output.tar

    - name: 'Publish Azure Flex Functions'
      uses: Azure/functions-action@v1.5.2
      with:
        app-name: ${{ env.AZURE_FUNCTIONAPP_FLEX_NAME }}
        package: output
        publish-profile: ${{ secrets.PUBLISH_PROFILE }}
        sku: flexconsumption
        remote-build: false
```

Once we deployed the code with the correct permissions, everything worked as expected. We were able to execute PowerShell scripts from c# in Azure Functions without any issues.