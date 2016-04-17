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