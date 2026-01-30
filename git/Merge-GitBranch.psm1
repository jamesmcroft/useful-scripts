Function Merge-GitBranch {
    Param (
        [string]$Branch
    )

    if ([string]::IsNullOrWhiteSpace($Branch)) {
        throw "Branch name is required"
    }

    Get-AllGitRepos
    $currentBranch = git rev-parse --abbrev-ref HEAD

    if ($currentBranch -ne $Branch) {
        git checkout $Branch
    }

    git pull

    if ($currentBranch -ne $Branch) {
        git checkout $currentBranch
        git merge $Branch
    }
}

Function Merge-GitMain {
    Merge-GitBranch -Branch "main"
}

New-Alias -Name gitupdate -Value Merge-GitMain -Force
Export-ModuleMember -Function * -Alias *
