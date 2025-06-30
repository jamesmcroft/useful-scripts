Function Merge-WithGitBranch {
    Param (
        [string]$Branch
    )

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

Function Merge-WithGitMain {
    Merge-WithGitBranch "main"
}

New-Alias -Name gitupdate -Value Merge-WithGitMain -Force -Option AllScope
