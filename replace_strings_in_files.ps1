[cmdletBinding()]
param (
  [string]$oldvalue,
  [string]$newvalue,
  [string]$path_to_files = 'C:\_posts\test'
)

$files = Get-ChildItem -Path $path_to_files -Recurse
<#
foreach ($file in $files) {
  (Get-Content -Path $file.FullName).Replace("$oldvalue","$newvalue") | Set-Content -Path $file.FullName
}
#>

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $content -replace 'author.+',$null | Set-Content -Path $file.FullName
    #$content -replace '{% include toc %}','' | Set-Content -Path $file.FullName
}