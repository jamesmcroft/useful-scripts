Function Add-DbMigration {
    Param (
        [string]$MigrationName,
        [string]$ContextName,
        [string]$OutputDir
    )

    if ([string]::IsNullOrWhitespace($MigrationName)) {
        throw "Migration name is required"
    }
    else {
        if ([string]::IsNullOrWhitespace($OutputDir)) {
            if ([string]::IsNullOrWhitespace($ContextName)) {
                dotnet ef migrations add $MigrationName
            }
            else {
                dotnet ef migrations add $MigrationName --context $ContextName
            }
        }
        else {
            if ([string]::IsNullOrWhitespace($ContextName)) {
                dotnet ef migrations add $MigrationName --output-dir $OutputDir
            }
            else {
                dotnet ef migrations add $MigrationName --context $ContextName --output-dir $OutputDir
            }
        }
    }
}