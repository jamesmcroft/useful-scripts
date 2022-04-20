param (
    [string] $ModulePath = '',
    [Switch] $WriteOutput = $false
)

Write-Host "Installing Useful Script Modules from $ModulePath..."

foreach ($item in (Get-ChildItem -Path $ModulePath -Recurse -Include *.psm1)) {
    $moduleName = $item.BaseName;
    if (Get-Command $moduleName -errorAction SilentlyContinue) {
        if ($WriteOutput -eq $true) {
            Write-Host "Updating $moduleName module..."
        }

        Remove-Module $moduleName
    }
    else {
        if ($WriteOutput -eq $true) {
            Write-Host "Importing $moduleName module..."
        }
    }

    Import-Module $item.FullName
}