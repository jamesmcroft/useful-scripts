Function Update-ExistingAksServicePrincipal {
    Param (
        [Parameter(Mandatory)][string]$ResourceGroup,
        [Parameter(Mandatory)][string]$ClusterName
    )

    if (Get-Command az -errorAction SilentlyContinue) {
        Write-Host "Retrieving current AKS service principal ID..."
        $SP_ID = (az aks show --resource-group $ResourceGroup --name $ClusterName --query servicePrincipalProfile.clientId -o tsv)
            
        Write-Host "Resetting current AKS service principal secret..."
        $SP_SECRET = (az ad sp credential reset --name "$SP_ID" --query password -o tsv)
            
        Write-Host "Updating AKS service principal credentials..."
        az aks update-credentials --resource-group $ResourceGroup --name $ClusterName --reset-service-principal --service-principal "$SP_ID" --client-secret "$SP_SECRET"   
    }
    else {
        Write-Host "The Azure CLI is not installed. Please install the Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and try again."
    }    
}

Export-ModuleMember -Function *