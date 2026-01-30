Function Register-AzureCoreProviders {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter]
        [string[]]$CoreProviders
    )

    if (-not $CoreProviders) {
        $CoreProviders = @(
            # Management Resource Providers
            "Microsoft.Advisor",
            "Microsoft.CustomProviders",
            "Microsoft.GuestConfiguration",
            "Microsoft.ManagedServices",
            "Microsoft.Management",
            "Microsoft.PolicyInsights",
            "Microsoft.Quota",
            "Microsoft.RecoveryServices",
            "Microsoft.ResourceHealth",
            "Microsoft.ResourceNotifications",
            "Microsoft.SaaS",
            "Microsoft.SaaSHub",
            "Microsoft.ServiceLinker",
            # Identity Resource Providers
            "Microsoft.ManagedIdentity",
            # Monitoring Resource Providers
            "Microsoft.AlertsManagement",
            "Microsoft.ChangeAnalysis",
            "Microsoft.Insights",
            "Microsoft.Monitor",
            "Microsoft.OperationalInsights",
            "Microsoft.OperationsManagement",
            # Security Resource Providers
            "Microsoft.DataProtection",
            "Microsoft.KeyVault",
            "Microsoft.Security",
            "Microsoft.SecurityCopilot",
            "Microsoft.SecurityInsights",
            # Networking Resource Providers
            "Microsoft.Cdn",
            "Microsoft.Network",
            # Integration Resource Providers
            "Microsoft.ApiManagement",
            "Microsoft.EventGrid",
            "Microsoft.EventHub",
            "Microsoft.ServiceBus",
            # Compute/Container Resource Providers
            "Microsoft.App",
            "Microsoft.Compute",
            "Microsoft.ContainerRegistry",
            "Microsoft.ContainerService",
            "Microsoft.DesktopVirtualization",
            "Microsoft.Maintenance",
            "Microsoft.Web",
            # AI/ML Resource Providers
            "Microsoft.CognitiveServices",
            "Microsoft.MachineLearningServices",
            "Microsoft.Search",
            # Data Resource Providers
            "Microsoft.DocumentDB",
            "Microsoft.Sql",
            "Microsoft.Storage",
            # Developer Tools Resource Providers
            "Microsoft.AppConfiguration",
            "Microsoft.CloudShell"
        )
    }

    # Ensure commands target the requested subscription
    az account set --subscription $SubscriptionId

    # Loop through each namespace and register
    $CoreProviders | ForEach-Object -Parallel {
        # Check if the provider is already registered
        $registered = az provider show --namespace $_ --query registrationState -o tsv
        if ($registered -eq "Registered") {
            Write-Host "$_ is already registered" -ForegroundColor Yellow
        }
        else {
            Write-Host "Registering $_..."
            az provider register --namespace $_
        }
    } -ThrottleLimit 10

    Write-Host "All core providers have been processed." -ForegroundColor Green
}