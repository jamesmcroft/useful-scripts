# Useful Scripts

A collection of various, useful scripts for developers (mainly PowerShell)

## Installing PowerShell Modules

Modules can be installed individually using the `Install-Module` command. Alternatively, to install all modules in the repository, run `Add-UsefulScriptModules.ps1` at the root of the repository.

You can also run `Remove-UsefulScriptModules.ps1` to remove all Useful Script modules.

## Azure

The Azure scripts are designed to be used with the Azure CLI to simplify the approach to interfacing with Azure.

### Kubernetes

#### [Remove-FailedKubernetesPods.ps1](/azure/kubernetes/Remove-FailedKubernetesPods.psm1)

Removes all failed pods, from all namespaces, within a Kubernetes cluster.

**Usage**

```powershell
Remove-FailedKubernetesPods
```

#### [Update-ExistingAksServicePrincipal](/azure/kubernetes/Update-ExistingAksServicePrincipal.psm1)

Resets the service principal for an existing Azure Kubernetes Service Principal, and updates the service principal's permissions to allow access to the cluster.

This follows the [Azure documentation for resetting an existing service principal](https://docs.microsoft.com/en-us/azure/aks/update-credentials#reset-the-existing-service-principal-credential).

**Usage**

```powershell
Update-ExistingAksServicePrincipal -ResourceGroupName $resourceGroupName -ClusterName $clusterName
```

## Build

A collection of scripts useful when building applications/projects in a continuous integration (CI) environment.

### [Get-BuildVersion](/build/Get-BuildVersion.psm1)

Gets a semantically versioned build number from a provided string value. This is useful when you want to version your applications based on a Git tag or branch name containing the expected version number. Supports pre-release versions with a `-` format after the version number.

**Usage**

```powershell
# Gets the build version from the current Git branch name
Get-BuildVersion -VersionString $Env:GITHUB_REF
```
