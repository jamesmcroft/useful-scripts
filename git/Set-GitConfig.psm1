<#
 .Synopsis
  Sets the Git configuration for all repositories in the current directory.

 .Description
  This function iterates through all repositories in the current directory and
  sets the git configuration user.name and user.email for each repository.

 .Parameter GitConfig
  An object containing the user name and email to set. The object must have
  properties named 'user' and 'email'.

 .Example
   $GitConfig = @{
       user = 'John Doe'
       email = 'john.doe@example.com'
   }
   Set-GitConfig $GitConfig
#>
Function Set-GitConfig {
    Param (
        [PSCustomObject]$GitConfig
    )

    Get-ChildItem -Recurse -Depth 2 -Force |
    Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" } |
    ForEach-Object {
        $dir = Get-Item (Join-Path $_.FullName "../")
        Push-Location $dir
 
        Write-Host Setting $dir repo Git config to name $GitConfig.user and email $GitConfig.email
        git config user.name $GitConfig.user
        git config user.email $GitConfig.email
    }
}

Export-ModuleMember -Function *