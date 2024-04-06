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
        
        if ($currentBranch -ne $MainBranch) {
            git checkout $MainBranch
        }

        git pull
        git checkout -b $branchName
        git push -u origin $branchName
    }
}