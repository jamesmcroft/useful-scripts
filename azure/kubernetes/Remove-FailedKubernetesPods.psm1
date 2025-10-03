Function Remove-FailedKubernetesPods {
    if (Get-Command kubectl -errorAction SilentlyContinue) {
        Write-Host "Removing failed pods..."
        kubectl delete pods --field-selector="status.phase==Failed" --all-namespaces
    }
    else {
        Write-Host "The kubectl CLI is not installed. Please install the kubectl CLI (https://kubernetes.io/docs/tasks/tools/#kubectl) and try again."
    }    
}

Export-ModuleMember -Function *