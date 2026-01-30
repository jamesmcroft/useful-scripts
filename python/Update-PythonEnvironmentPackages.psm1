Function Update-PythonEnvironmentPackages {
    Param (
        [switch]$RemoveExtras
    )

    if (-not (Test-Path requirements.txt)) {
        Write-Host "No requirements.txt file found in the current directory."
        return
    }

    if (Test-Path .venv) {
        .\.venv\Scripts\Activate
    }

    Write-Host "Installing required packages"
    python -m pip install -r requirements.txt

    if (-not $RemoveExtras) {
        return
    }

    $requiredPackages = Get-Content requirements.txt |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not $_.StartsWith("#") } |
    ForEach-Object { ($_ -split "[=<>~!;]")[0].Trim() } |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    $installedPackages = python -m pip freeze | ForEach-Object { ($_ -split "==")[0] }
    $protectedPackages = @("pip", "setuptools", "wheel")

    $extras = $installedPackages | Where-Object { $requiredPackages -notcontains $_ -and $protectedPackages -notcontains $_ }

    foreach ($package in $extras) {
        Write-Host "Removing extra package $package"
        python -m pip uninstall -y $package
    }
}

New-Alias -Name pyreconcile -Value Update-PythonEnvironmentPackages -Force

Export-ModuleMember -Function * -Alias *
