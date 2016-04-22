[cmdletBinding()]
param (
  [string]$oldvalue,
  [string]$newvalue,
  [string]$path_to_files = 'C:\githubpages\_posts'
)

$files = Get-ChildItem -Path $path_to_files -Recurse

foreach ($file in $files) {
  (Get-Content -Path $file.FullName).Replace("$oldvalue","$newvalue") | Set-Content -Path $file.FullName
}

<#
$content = Get-Content -Path C:\githubpages\blog\_posts\2012-06-08-install-distribution-point-for-configuration-manager-2012.md -Raw
$Matches = $null
$regex = "<pre style=`"text-align: left; line-height: 12pt; background-color: \w+; margin: 0em; width: 100%; font-family: 'Courier New', courier, monospace; direction: ltr; color: black; font-size: 8pt; overflow: visible; border-style: none; padding: 0px;`"><span id=`"lnum\d`" style=`"color: #606060;`">"

$content -match $regex
#>