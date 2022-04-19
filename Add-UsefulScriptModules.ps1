foreach ($item in (Get-ChildItem -Recurse -Include *.psm1)) {
    $moduleName = $item.BaseName;
    if (Get-Command $moduleName -errorAction SilentlyContinue){
        Write-Host "Updating $moduleName module..."
        Remove-Module $moduleName
    } else {
        Write-Host "Importing $moduleName module..."
    }

    Import-Module $item.FullName
}