Function Sync-AllGitRepos {
    Get-AllGitRepos

    Get-ChildItem -Recurse -Depth 2 -Force |
    Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" } |
    ForEach-Object {
        $dir = Get-Item (Join-Path $_.FullName "../")
        Push-Location $dir

        "Pulling $($dir.Name)..."

        git pull
        Pop-Location
    }
}

New-Alias -Name gitsync -Value Sync-AllGitRepos -Force

Export-ModuleMember -Function * -Alias *
