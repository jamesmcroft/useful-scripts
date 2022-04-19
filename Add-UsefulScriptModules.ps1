param (
    [Parameter]
    [Switch]$WriteOutput
)

foreach ($item in (Get-ChildItem -Recurse -Include *.psm1)) {
    $moduleName = $item.BaseName;
    if (Get-Command $moduleName -errorAction SilentlyContinue) {
        if ($WriteOutput -eq $true) {
            Write-Host "Updating $moduleName module..."
        }

        Remove-Module $moduleName
    } else {
        if ($WriteOutput -eq $true) {
            Write-Host "Importing $moduleName module..."
        }
    }

    Import-Module $item.FullName
}