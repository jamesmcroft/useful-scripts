<#
 .Synopsis
  Sets the Azure subscription to use for the current session using the Azure CLI.

 .Description
  This function sets the Azure subscription to use for the current session using
  the Azure CLI. The Azure CLI must be installed and available in the PATH.

 .Parameter AzureConfig
  An object containing the subscription to set. The object must have a property
  named 'subscription' that contains the subscription ID.

 .Example
   $AzureConfig = @{
       subscription = '00000000-0000-0000-0000-000000000000'
   }
   Set-AzureSubscription $AzureConfig
#>
Function Set-AzureSubscription {
    Param (
        [PSCustomObject]$AzureConfig
    )

    Write-Host Setting subscription to $AzureConfig.subscription
    az account set --subscription $AzureConfig.subscription
}

Export-ModuleMember -Function *