param (
    [Parameter]
    [Switch]$WriteOutput
)

foreach ($item in (Get-ChildItem -Recurse -Include *.psm1).BaseName) {
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