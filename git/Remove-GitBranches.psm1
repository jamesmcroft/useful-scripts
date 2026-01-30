Function Remove-GitBranches {
    Param (
        [string]$BaseBranch = "main",
        [string[]]$ProtectedBranches = @("main", "master", "develop"),
        [switch]$DryRun
    )

    git fetch --prune

    $targetBranch = $BaseBranch
    $baseExists = git show-ref --verify "refs/heads/$targetBranch" 2>$null

    if (-not $baseExists -and $BaseBranch -ne "master") {
        $targetBranch = "master"
        $baseExists = git show-ref --verify "refs/heads/$targetBranch" 2>$null
    }

    if (-not $baseExists) {
        Write-Host "No base branch found. Nothing to prune."
        return
    }

    $currentBranch = git rev-parse --abbrev-ref HEAD
    $mergedBranches = git branch --format "%(refname:short)" --merged $targetBranch 2>$null

    foreach ($branch in $mergedBranches) {
        if ($branch -in $ProtectedBranches) {
            continue
        }

        if ($branch -eq $currentBranch) {
            continue
        }

        if ($DryRun) {
            Write-Host "Would remove branch $branch"
            continue
        }

        git branch -d $branch
    }
}

New-Alias -Name gitprune -Value Remove-GitBranches -Force

Export-ModuleMember -Function * -Alias *
