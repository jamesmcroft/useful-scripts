Function Undo-GitCommit {
    git reset --hard HEAD~1
}

New-Alias -Name gitundo -Value Undo-GitCommit -Force

Export-ModuleMember -Function * -Alias *
