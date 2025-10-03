<#
 .Synopsis
  Updates the Git index cache for all repositories in the current directory.

 .Description
  This function iterates through all repositories in the current directory and
  updates the Git index cache for each repository.

 .Example
   Update-GitIndex
#>
Function Update-GitIndex {
    Get-ChildItem -Recurse -Depth 2 -Force |
    Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" } |
    ForEach-Object {
        $dir = Get-Item (Join-Path $_.FullName "../")
        Push-Location $dir
 
        Write-Host Updating $dir repo Git index cache
        git rm -r --cached .
        git add .
    }
}

Export-ModuleMember -Function *