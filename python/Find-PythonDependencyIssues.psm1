Function Find-PythonDependencyIssues {
    if (Test-Path .venv) {
        .\.venv\Scripts\Activate
    }

    Write-Host "Checking for dependency issues"
    python -m pip check

    Write-Host "Listing outdated packages"
    python -m pip list --outdated --format=columns
}

New-Alias -Name pydeps -Value Find-PythonDependencyIssues -Force

Export-ModuleMember -Function * -Alias *
