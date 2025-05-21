function Remove-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        if (Test-SecretVault -VaultName $VaultName -AdditionalParameters $AdditionalParameters) {        
            $uri = ('{0}/secrets/{1}/organizations/{2}/projects/{3}/apps/{4}/secrets/{5}' -f $script:HCPBaseUri, $script:HCPApiVersion, $AdditionalParameters.OrganizationId, $AdditionalParameters.ProjectId, $AdditionalParameters.AppName, $Name)

            $null = Invoke-RestMethod -Uri $uri -Method Delete -Headers $script:authorizationHeader
        }
    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException] {    
        Write-Debug ("The Secret {0} does not exist: {1}" -f $Name, $_) 
    }    
    catch {
        Write-Error $_
    }
}