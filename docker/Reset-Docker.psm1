Function Reset-Docker {
    # Stop everything
    Write-Host "Stopping Docker..."
    wsl --shutdown
    Get-Process *docker* -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Stop-Service com.docker.service -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5

    # Nuke the stale state
    Write-Host "Removing Docker state..."
    Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Docker\wsl\data" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Docker\wsl\main" -ErrorAction SilentlyContinue

    # Clear Docker Desktop caches
    Write-Host "Clearing Docker Desktop caches..."
    Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Docker Desktop" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "$env:PROGRAMDATA\DockerDesktop" -ErrorAction SilentlyContinue

    # Make sure WSL is healthy & current
    Write-Host "Ensuring WSL is healthy..."
    wsl --update
    wsl --set-default-version 2

    # Restart Docker
    Write-Host "Starting Docker..."
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

New-Alias -Name resetdocker -Value Reset-Docker -Force

Export-ModuleMember -Function * -Alias *
