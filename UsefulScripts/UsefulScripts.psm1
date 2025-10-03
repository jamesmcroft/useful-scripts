<#
 Simplified UsefulScripts meta module
 Responsibility: import sibling directory script modules; each sub-module owns its own exports (default behaviour exports all functions & aliases unless it calls Export-ModuleMember itself).
 Place the UsefulScripts folder (containing this file + manifest) alongside the subfolders (azure, git, etc.) or include them inside the module folder before publishing.
#>

if (-not $script:UsefulScripts_Initialized) {
    $script:UsefulScripts_Initialized = $true

    # The module directory (UsefulScripts) and its parent (repo root)
    $moduleDir = Split-Path -Parent $PSCommandPath
    $repoRoot = Split-Path -Parent $moduleDir

    # Sibling folders treated as sub-module roots (exclude this module folder)
    $subRoots = Get-ChildItem -Path $repoRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne (Split-Path $moduleDir -Leaf) }

    $script:UsefulScripts_ImportedModules = @()
    $script:UsefulScripts_FunctionsToExport = @()
    $script:UsefulScripts_AliasesToExport = @()

    foreach ($r in $subRoots) {
        # Find any *.psm1 files under each root (one level or recursive if you like)
        Get-ChildItem -Path $r.FullName -Recurse -Filter *.psm1 -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $module = Import-Module $_.FullName -Scope Local -Force -PassThru -ErrorAction Stop
                $script:UsefulScripts_ImportedModules += $_.FullName

                if ($module) {
                    if ($module.ExportedFunctions) {
                        $script:UsefulScripts_FunctionsToExport += $module.ExportedFunctions.Keys
                    }

                    if ($module.ExportedAliases) {
                        $script:UsefulScripts_AliasesToExport += $module.ExportedAliases.Keys
                    }
                }
            }
            catch {
                Write-Verbose "[UsefulScripts] Failed to import $($_.FullName): $_"
            }
        }
    }

    $script:UsefulScripts_Root = $repoRoot
    $script:UsefulScripts_ModuleRoot = $moduleDir
}

function Get-UsefulScriptInfo {
    <# .SYNOPSIS Returns summary of imported UsefulScripts child modules, functions, and aliases. #>
    $repoRoot = $script:UsefulScripts_Root

    $functions = Get-Command -CommandType Function | Where-Object {
        $_.Module -and $_.Module.Path -like (Join-Path $repoRoot '*') -and $_.Module.Name -ne 'UsefulScripts'
    } | Sort-Object -Property Name -Unique | Select-Object -ExpandProperty Name

    $aliases = Get-Command -CommandType Alias | Where-Object {
        $_.Module -and $_.Module.Path -like (Join-Path $repoRoot '*') -and $_.Module.Name -ne 'UsefulScripts'
    } | Sort-Object -Property Name -Unique | Select-Object -ExpandProperty Name

    [PSCustomObject]@{
        RepoRoot       = $repoRoot
        ModuleRoot     = $script:UsefulScripts_ModuleRoot
        LoadedSubFiles = $script:UsefulScripts_ImportedModules
        FunctionCount  = $functions.Count
        AliasCount     = $aliases.Count
        Functions      = $functions
        Aliases        = $aliases
    }
}

$functionsToExport = @('Get-UsefulScriptInfo')
if ($script:UsefulScripts_FunctionsToExport) {
    $functionsToExport += $script:UsefulScripts_FunctionsToExport
}
$functionsToExport = $functionsToExport | Sort-Object -Unique

$aliasesToExport = @()
if ($script:UsefulScripts_AliasesToExport) {
    $aliasesToExport += $script:UsefulScripts_AliasesToExport | Sort-Object -Unique
}

Export-ModuleMember -Function $functionsToExport -Alias $aliasesToExport
