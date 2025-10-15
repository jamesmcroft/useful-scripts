# James' Really Useful Azure Scripts

The Azure scripts are designed to be used with the Azure CLI to simplify the approach to interfacing with Azure.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [General](#general)
  - [Set-AzureSubscription](#set-azuresubscription)
  - [Show-AzureQuotas](#show-azurequotas)
  - [Resize-AzureQuotas](#resize-azurequotas)
- [Kubernetes](#kubernetes)
  - [Remove-FailedKubernetesPods](#remove-failedkubernetespods)
  - [Update-ExistingAksServicePrincipal](#update-existingaksserviceprincipal)

---

## General

### [Set-AzureSubscription](./Set-AzureSubscription.psm1)

Sets the current Azure subscription context.

```powershell
Set-AzureSubscription -AzureConfig @{ subscription = '00000000-0000-0000-0000-000000000000' }
```

### [Show-AzureQuotas](./Show-AzureQuotas.psm1)

Shows the current Azure quotas for a given subscription, location, and resource type. The output will be a table showing the current usage and limits for each quota family.

```powershell
Show-AzureQuotas -SubscriptionId '00000000-0000-0000-0000-000000000000' -Locations 'eastus2' -Type 'Compute'
```

### [Resize-AzureQuotas](./Resize-AzureQuotas.psm1)

Resizes the Azure quotas for a given subscription, location, and resource type. This will submit a request to increase the quota limits for each family to the specified new limit.

```powershell
Resize-AzureQuotas -SubscriptionId '00000000-0000-0000-0000-000000000000' -Locations 'eastus2' -Type 'Compute' -Family 'Standard_DSv3_Family' -Quota 20
```

## Kubernetes

### [Remove-FailedKubernetesPods](./kubernetes/Remove-FailedKubernetesPods.psm1)

Removes all failed pods, from all namespaces, within a Kubernetes cluster.

```powershell
Remove-FailedKubernetesPods
```

### [Update-ExistingAksServicePrincipal](./kubernetes/Update-ExistingAksServicePrincipal.psm1)

Resets the service principal for an existing Azure Kubernetes Service Principal, and updates the service principal's permissions to allow access to the cluster.

This follows the [Azure documentation for resetting an existing service principal](https://docs.microsoft.com/en-us/azure/aks/update-credentials#reset-the-existing-service-principal-credential).

```powershell
Update-ExistingAksServicePrincipal -ResourceGroupName $resourceGroupName -ClusterName $clusterName
```
