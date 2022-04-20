param (
    [string] $ModulePath = '',
    [Switch] $WriteOutput = $false
)

foreach ($item in (Get-ChildItem -Path $ModulePath -Recurse -Include *.psm1).BaseName) {
    if (Remove-Module $item -errorAction SilentlyContinue) {
        if ($WriteOutput -eq $true) {
            Write-Host "Successfully removed $item module"
        }
    }
    else {
        if ($WriteOutput -eq $true) {
            Write-Host "$item module does not exist"
        }
    }
}