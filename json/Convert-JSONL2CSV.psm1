Function Convert-JSONL2CSV {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$Path,
        [Parameter(Position = 1)]
        [string]$OutputPath
    )
    
    if (!(Test-Path $Path)) {
        throw "Input file '$Path' does not exist."
    }

    $jsonObjects = @()
    Get-Content -Path $Path | ForEach-Object {
        if ($_ -match '\S') {
            try {
                $jsonObjects += ($_ | ConvertFrom-Json)
            }
            catch {
                Write-Warning "Skipping invalid JSON line: $_"
            }
        }
    }

    if ($jsonObjects.Count -eq 0) {
        throw "No valid JSON objects found in '$Path'."
    }

    if ($OutputPath) {
        $jsonObjects | Export-Csv -Path $OutputPath -NoTypeInformation
        Write-Host "CSV exported to $OutputPath"
    }
    else {
        $jsonObjects | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1
    }
}