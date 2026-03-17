<#
.SYNOPSIS
    Inspects a NuGet package for architecture-specific and platform-specific contents.

.DESCRIPTION
    Downloads a NuGet package (optionally from a custom feed) and lists its contents,
    highlighting architecture folders (arm64, x64, x86, AnyCPU) and runtime identifiers.

.PARAMETER PackageName
    The NuGet package ID to inspect (e.g. "Microsoft.Internal.Dia").

.PARAMETER Version
    Optional package version. If omitted, the latest version is fetched.

.PARAMETER Source
    Optional NuGet feed URL(s). Can specify multiple. Defaults to nuget.org.

.PARAMETER ExtractTo
    Optional directory to extract the package into for browsing. If omitted, uses a temp directory that is cleaned up.

.PARAMETER Filter
    Optional regex filter to apply to file paths (e.g. "arm64|x64" to show only those).

.EXAMPLE
    .\Inspect-NuGetPackage.ps1 -PackageName Microsoft.Internal.Dia

.EXAMPLE
    .\Inspect-NuGetPackage.ps1 -PackageName Microsoft.Internal.Dia -Version 18.6.0-preview-1-11615-033 `
        -Source "https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json"

.EXAMPLE
    .\Inspect-NuGetPackage.ps1 -PackageName System.Text.Json -ExtractTo ./extracted-pkg

.EXAMPLE
    .\Inspect-NuGetPackage.ps1 -PackageName Microsoft.Internal.Dia -Filter "arm64|aarch64"
#>
Function Inspect-NuGetPackage {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$PackageName,

        [string]$Version,

        [string[]]$Source,

        [string]$ExtractTo,

        [string]$Filter
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    # --- Resolve dotnet CLI ---
    $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
    if (-not $dotnet) {
        Write-Error "dotnet CLI not found on PATH. Install the .NET SDK first."
        return
    }

    # --- Set up temp workspace ---
    $workDir = Join-Path ([System.IO.Path]::GetTempPath()) "nuget-inspect-$([guid]::NewGuid().ToString('N').Substring(0,8))"
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null

    try {
        # --- Create a minimal project to restore the package ---
        $versionAttr = if ($Version) { " Version=\"$Version\"" } else { " Version=\" * \"" }
        $csproj = @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <GeneratePackageOnBuild>false</GeneratePackageOnBuild>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="$PackageName"$versionAttr GeneratePathProperty="true" />
  </ItemGroup>
</Project>
"@
        $csprojPath = Join-Path $workDir 'inspect.csproj'
        Set-Content -Path $csprojPath -Value $csproj -Encoding UTF8

        # --- Build restore arguments ---
        $pkgsDir = Join-Path $workDir 'pkgs'
        $restoreArgs = @('restore', $csprojPath, '--packages', $pkgsDir)
        if ($Source) {
            foreach ($s in $Source) {
                $restoreArgs += '--source'
                $restoreArgs += $s
            }
            # Always include nuget.org as a fallback for transitive dependencies
            $restoreArgs += '--source'
            $restoreArgs += 'https://api.nuget.org/v3/index.json'
        }

        Write-Host "Restoring package..." -ForegroundColor Cyan
        & $dotnet @restoreArgs 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            # Retry with verbose output so the user can see what went wrong
            Write-Host "Restore failed. Retrying with diagnostics..." -ForegroundColor Yellow
            & $dotnet @restoreArgs
            return
        }

        # --- Locate the downloaded package ---
        $pkgId = $PackageName.ToLowerInvariant()
        $pkgRoot = Join-Path $pkgsDir $pkgId
        if (-not (Test-Path $pkgRoot)) {
            Write-Error "Package '$PackageName' was not found after restore. Check the package name and source."
            return
        }

        $versionDirs = @(Get-ChildItem -Path $pkgRoot -Directory | Sort-Object Name)
        if ($versionDirs.Count -eq 0) {
            Write-Error "No version directories found under $pkgRoot"
            return
        }

        $resolvedVersionDir = $versionDirs[-1]  # Latest if wildcard
        $resolvedVersion = $resolvedVersionDir.Name
        Write-Host "`nPackage : $PackageName" -ForegroundColor Green
        Write-Host "Version : $resolvedVersion" -ForegroundColor Green

        # --- Find the .nupkg ---
        $nupkg = Get-ChildItem -Path $resolvedVersionDir.FullName -Filter '*.nupkg' | Select-Object -First 1
        if (-not $nupkg) {
            Write-Error "No .nupkg file found in $($resolvedVersionDir.FullName)"
            return
        }

        # --- List contents from the zip ---
        $zip = [System.IO.Compression.ZipFile]::OpenRead($nupkg.FullName)
        try {
            $entries = @($zip.Entries | ForEach-Object {
                    [PSCustomObject]@{
                        Path = $_.FullName
                        Size = $_.Length
                    }
                })
        }
        finally {
            $zip.Dispose()
        }

        # --- Architecture detection ---
        $archPatterns = @{
            'arm64'  = 'arm64|aarch64'
            'arm'    = '\barm\b'
            'x64'    = '\bx64\b|amd64|win-x64|linux-x64|osx-x64'
            'x86'    = '\bx86\b|win-x86|linux-x86|i[3-6]86'
            'AnyCPU' = 'AnyCPU|anycpu'
        }

        $runtimeIdPattern = 'runtimes/(?<rid>[^/]+)/'

        # Detect architectures present
        $foundArchs = [ordered]@{}
        foreach ($arch in $archPatterns.Keys) {
            $archMatches = @($entries | Where-Object { $_.Path -match $archPatterns[$arch] })
            if ($archMatches.Count -gt 0) {
                $foundArchs[$arch] = $archMatches.Count
            }
        }

        # Detect runtime identifiers
        $foundRids = @{}
        foreach ($e in $entries) {
            if ($e.Path -match $runtimeIdPattern) {
                $rid = $Matches['rid']
                if (-not $foundRids.ContainsKey($rid)) { $foundRids[$rid] = 0 }
                $foundRids[$rid]++
            }
        }

        # --- Print summary ---
        Write-Host "`n--- Architecture Summary ---" -ForegroundColor Yellow
        if ($foundArchs.Count -eq 0) {
            Write-Host "  No architecture-specific folders detected." -ForegroundColor DarkGray
        }
        else {
            foreach ($kv in $foundArchs.GetEnumerator()) {
                Write-Host "  $($kv.Key): $($kv.Value) file(s)" -ForegroundColor White
            }
        }

        if ($foundRids.Count -gt 0) {
            Write-Host "`n--- Runtime Identifiers (RIDs) ---" -ForegroundColor Yellow
            $foundRids.GetEnumerator() | Sort-Object Key | ForEach-Object {
                Write-Host "  $($_.Key): $($_.Value) file(s)" -ForegroundColor White
            }
        }

        # --- Print file listing ---
        Write-Host "`n--- Package Contents ($($entries.Count) entries) ---" -ForegroundColor Yellow

        $displayEntries = $entries
        if ($Filter) {
            $displayEntries = @($entries | Where-Object { $_.Path -match $Filter })
            Write-Host "  (filtered by: $Filter)" -ForegroundColor DarkGray
        }

        foreach ($e in $displayEntries) {
            $sizeStr = if ($e.Size -gt 0) { " ({0:N0} bytes)" -f $e.Size } else { '' }

            # Highlight architecture-specific paths
            $color = 'Gray'
            foreach ($arch in $archPatterns.Keys) {
                if ($e.Path -match $archPatterns[$arch]) {
                    $color = 'Cyan'
                    break
                }
            }
            if ($e.Path -match $runtimeIdPattern) { $color = 'Cyan' }

            Write-Host "  $($e.Path)$sizeStr" -ForegroundColor $color
        }

        # --- Optional: Extract for browsing ---
        if ($ExtractTo) {
            $extractDir = Join-Path (Resolve-Path .).Path $ExtractTo
            if (Test-Path $extractDir) {
                Write-Host "`nExtract directory already exists: $extractDir" -ForegroundColor Yellow
                Write-Host "Skipping extraction. Delete it first to re-extract." -ForegroundColor Yellow
            }
            else {
                Write-Host "`nExtracting to: $extractDir" -ForegroundColor Green
                [System.IO.Compression.ZipFile]::ExtractToDirectory($nupkg.FullName, $extractDir)
                Write-Host "Done. Browse the extracted package at: $extractDir" -ForegroundColor Green
            }
        }
    }
    finally {
        # --- Clean up temp workspace ---
        Remove-Item -Path $workDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Export-ModuleMember -Function *
