Function New-GitBranch {
    Param (
        [string]$Branch,
        [string]$MainBranch = "main"
    )

    if ([string]::IsNullOrWhitespace($Branch)) {
        throw "Branch name is required"
    }
    else {
        Get-AllGitRepos
        $currentBranch = git rev-parse --abbrev-ref HEAD
        if ($currentBranch -ne $MainBranch) {
            git checkout $MainBranch
        }
        git pull
        git checkout -b $Branch
        git push -u origin $Branch
    }
}

Export-ModuleMember -Function *