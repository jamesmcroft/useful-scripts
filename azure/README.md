# James' Really Useful Azure Scripts

The Azure scripts are designed to be used with the Azure CLI to simplify the approach to interfacing with Azure.

## Table of Contents

- [James' Really Useful Azure Scripts](#james-really-useful-azure-scripts)
  - [Table of Contents](#table-of-contents)
  - [Kubernetes](#kubernetes)
    - [Remove-FailedKubernetesPods](#remove-failedkubernetespods)
    - [Update-ExistingAksServicePrincipal](#update-existingaksserviceprincipal)

---

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
