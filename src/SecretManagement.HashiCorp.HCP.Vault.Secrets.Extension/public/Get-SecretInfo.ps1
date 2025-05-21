function Get-SecretInfo {
    [CmdletBinding()]
    param (
        [string] $Filter,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        if (Test-SecretVault -VaultName $VaultName -AdditionalParameters $AdditionalParameters) {
            $uri = ('{0}/secrets/{1}/organizations/{2}/projects/{3}/apps/{4}/secrets?pagination.page_size={5}' -f $script:HCPBaseUri, $script:HCPApiVersion, $AdditionalParameters.OrganizationId, $AdditionalParameters.ProjectId, $AdditionalParameters.AppName, $script:HCPApiPageSize)

            $secret = (Invoke-RestMethod -Uri $uri -Method Get -Headers $script:authorizationHeader).secrets

            if (-not([string]::IsNullOrEmpty($Filter))) {
                $secret = $secret | Where-Object { $_.Name -match $Filter }
            }

            $secret | ForEach-Object {
                $metadata = [Ordered]@{
                    'type' = $PSItem.type
                    'latest_version' = $PSItem.latest_version
                    'created_at' = $PSItem.created_at
                    'created_by' = $PSItem.created_by
                    'sync_status' = $PSItem.sync_status
                    'static_version' = $PSItem.static_version
                    'version_count' = $PSItem.version_count
                }

                return @(,[Microsoft.PowerShell.SecretManagement.SecretInformation]::new(
                    $PSItem.name,
                    [Microsoft.PowerShell.SecretManagement.SecretType]::SecureString,
                    $VaultName,
                    $metadata))
            }
        }
    }
    catch {
        Write-Error $_
    }
}