foreach ($item in (Get-ChildItem -Recurse -Include *.psm1).BaseName) {
    if (Remove-Module $item -errorAction SilentlyContinue) {
        Write-Host "Successfully removed $item module"
    }
    else {
        Write-Host "$item module does not exist"
    }
}