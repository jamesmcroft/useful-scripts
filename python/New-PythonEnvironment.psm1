Function New-PythonEnvironment {
    if (-not (Test-Path .venv)) {
        Write-Host Creating Python Virtual Environment
        python -m venv .venv
    }
    .\.venv\Scripts\Activate

    if (-not (Test-Path requirements.txt)) {
        Write-Host No requirements.txt file found in the current directory. Skipping installation.
    }
    else {
        Write-Host Installing Python Requirements
        pip install -r requirements.txt
    }
}

New-Alias -Name pyenv -Value New-PythonEnvironment -Force -Option AllScope
