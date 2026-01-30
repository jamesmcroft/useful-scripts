Function Resize-AzureQuotas {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter(Mandatory = $true)]
        [string[]]$Locations,
        [Parameter(Mandatory = $true)]
        [ValidateSet('AzureContainerApps', 'AutomationAccounts', 'AzureVMwareSolution', 'Compute', 'AzureContainerInstances', 'AzureKubernetesService', 'AzurePostgreSQL', 'DevBox', 'ManagedDevOpsPools', 'MicrosoftFabric', 'AzureHDInsight', 'AzureLabServices', 'MachineLearning', 'Networking', 'Search', 'Storage', 'Web')]
        [string]$Type,
        [Parameter(Mandatory = $true)]
        [string]$Family,
        [Parameter(Mandatory = $true)]
        [int]$Quota
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

    # Ensure commands target the requested subscription
    az account set --subscription $SubscriptionId

    Write-Host "Requesting $Type quota increases for subscription $SubscriptionId..."

    # Loop through each location to request the quota increase
    $Locations | ForEach-Object -Parallel {
        $location = $_
        $scopes = $using:scopes
        $subscriptionId = $using:SubscriptionId
        $family = $using:Family
        $quota = $using:Quota
        $type = $using:Type

        # Set the provider based on the workload
        $scope = &($scopes[$type]) $subscriptionId $location
        if (-not $scope) {
            Write-Host "The workload type $type is not supported. Skipping." -ForegroundColor Red
            return
        }

        Write-Host "Resizing the $type quota limit for $family in scope $scope to $quota..."

        # Check the current size of the quotas in the subscription
        $existingQuota = (az quota show --resource-name $family --scope $scope -o json | ConvertFrom-Json)
        $existingQuotaLimit = $existingQuota.properties.limit.value

        if ($null -eq $existingQuota) {
            Write-Host "The quota for $family in scope $scope does not exist. Skipping." -ForegroundColor Red
        }
        elseif ($existingQuotaLimit -lt $Quota) {
            Write-Host "The current quota limit is $existingQuotaLimit for $family in scope $scope. Requesting an increase to $quota..." -ForegroundColor Yellow
            az quota update --resource-name $family --scope $scope --limit-object value=$quota --no-wait
        }
        else {
            Write-Host "The current quota limit is $existingQuotaLimit for $family in scope $scope. Skipping." -ForegroundColor Yellow
        }
    } -ThrottleLimit 10

    Write-Host "Quota increase requests submitted. It may take some time for the changes to take effect."
}