<#
 UsefulScripts.psm1
 Aggregates all individual helper script modules in this repository into a single autoloadable meta module.
 Place the enclosing UsefulScripts folder into a path listed in $env:PSModulePath (e.g. ~\Documents\PowerShell\Modules) so that
 calling any exported function triggers automatic module loading.
#>

$moduleRoot = Split-Path -Parent $PSCommandPath

# Import all *.psm1 files under the repo except this meta module itself
Get-ChildItem -Path $moduleRoot -Recurse -Filter *.psm1 | Where-Object { $_.FullName -ne $PSCommandPath } | ForEach-Object {
    try {
        Import-Module $_.FullName -Scope Local -Force -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Verbose "[UsefulScripts] Failed to import $($_.FullName): $_"
    }
}

# Collect public functions from the just-imported child modules (skip those starting with underscore)
$publicFunctions = Get-Command -CommandType Function | Where-Object {
    $_.Module -and $_.Module.Path -like "$moduleRoot*" -and $_.Name -notmatch '^_' -and $_.Module.Name -ne 'UsefulScripts'
} | Select-Object -ExpandProperty Name -Unique

if ($publicFunctions) {
    Export-ModuleMember -Function $publicFunctions -Alias *
}

function Get-UsefulScriptInfo {
    <#
        .SYNOPSIS
            Lists the functions aggregated by the UsefulScripts meta module.
    #>
    $functions = $publicFunctions | Sort-Object
    [PSCustomObject]@{
        ModulePath    = $moduleRoot
        FunctionCount = $functions.Count
        Functions     = $functions
    }
}

Export-ModuleMember -Function Get-UsefulScriptInfo -Alias * -ErrorAction SilentlyContinue
