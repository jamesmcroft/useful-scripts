# Useful Scripts

A collection of various, useful scripts for developers (mainly PowerShell)

## Azure

The Azure scripts are designed to be used with the Azure CLI to simplify the approach to interfacing with Azure.

### Kubernetes

#### [Update-ExistingAksServicePrincipal](/azure/kubernetes/Update-ExistingAksServicePrincipal.ps1)

Resets the service principal for an existing Azure Kubernetes Service Principal, and updates the service principal's permissions to allow access to the cluster.

This follows the [Azure documentation for resetting an existing service principal](https://docs.microsoft.com/en-us/azure/aks/update-credentials#reset-the-existing-service-principal-credential).
