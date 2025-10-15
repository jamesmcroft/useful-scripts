Function Show-AzureQuotas {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter(Mandatory = $true)]
        [string[]]$Locations,
        [Parameter(Mandatory = $true)]
        [ValidateSet('AzureContainerApps', 'AutomationAccounts', 'AzureVMwareSolution', 'Compute', 'AzureContainerInstances', 'AzureKubernetesService', 'AzurePostgreSQL', 'DevBox', 'ManagedDevOpsPools', 'MicrosoftFabric', 'AzureHDInsight', 'AzureLabServices', 'MachineLearning', 'Networking', 'Search', 'Storage', 'Web')]
        [string]$Type
    )

    $scopes = @{
        'AzureContainerApps'      = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.App/locations/$location" }
        'AutomationAccounts'      = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Automation/locations/$location" }
        'AzureVMwareSolution'     = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.AVS/locations/$location" }
        'Compute'                 = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Compute/locations/$location" }
        'AzureContainerInstances' = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.ContainerInstance/locations/$location" }
        'AzureKubernetesService'  = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.ContainerService/locations/$location" }
        'AzurePostgreSQL'         = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.DBforPostgreSQL/locations/$location" }
        'DevBox'                  = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.DevCenter/locations/$location" }
        'ManagedDevOpsPools'      = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.DevOpsInfrastructure/locations/$location" }
        'MicrosoftFabric'         = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Fabric/locations/$location" }
        'AzureHDInsight'          = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.HDInsight/locations/$location" }
        'AzureLabServices'        = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.LabServices/locations/$location" }
        'MachineLearning'         = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.MachineLearningServices/locations/$location" }
        'Networking'              = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Network/locations/$location" }
        'Search'                  = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Search/locations/$location" }
        'Storage'                 = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Storage/locations/$location" }
        'Web'                     = { param($subscriptionId, $location) "/subscriptions/$subscriptionId/providers/Microsoft.Web/locations/$location" }
    }

    $quotaExtension = az extension list --query "[?name=='quota']" -o json | ConvertFrom-Json

    if (-not $quotaExtension) {
        Write-Host "Azure CLI Quota extension not found. Installing..."
        az extension add --upgrade -n quota
    }

    $allQuotas = @()

    Write-Host "Fetching $Type quotas for subscription $SubscriptionId..."

    # Loop through each location to request the quota increase
    $Locations | ForEach-Object {
        $location = $_

        # Set the provider based on the workload
        $scope = &($scopes[$Type]) $SubscriptionId $location
        if (-not $scope) {
            Write-Host "The workload type $Type is not supported. Skipping." -ForegroundColor Red
            return
        }

        $quotas = az quota list --scope $scope -o json | ConvertFrom-Json

        $quotas | ForEach-Object {
            $quota = $_
            $allQuotas += $quota
        }
    }

    # Display all quotas as a table in the console
    $allQuotas | Sort-Object -Property name | Format-Table -Property @{Label = "Family"; Expression = { $_.name } },
    @{Label = "Display Name"; Expression = { $_.properties.name.localizedValue } }, 
    @{Label = "Location"; Expression = { 
            $idParts = $_.id -split '/'; 
            $locationIndex = [Array]::IndexOf($idParts, 'locations') + 1; 
            $idParts[$locationIndex] 
        } 
    }, 
    @{Label = "Quota"; Expression = { $_.properties.limit.value } }
}