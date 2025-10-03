Function Restart-PythonEnvironment {
    if (Test-Path .venv) {
        Write-Host Restarting Python Virtual Environment
        .\.venv\Scripts\Deactivate
        .\.venv\Scripts\Activate
    }
    else {
        Write-Host No Python Virtual Environment Found. Run `pyenv` to create one.
    }
}

New-Alias -Name pyrestart -Value Restart-PythonEnvironment -Force

Export-ModuleMember -Function * -Alias *
