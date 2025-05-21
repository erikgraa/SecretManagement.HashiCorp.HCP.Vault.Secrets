function Get-Secret {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        if (Test-SecretVault -VaultName $VaultName -AdditionalParameters $AdditionalParameters) {        
            $uri = ('{0}/secrets/{1}/organizations/{2}/projects/{3}/apps/{4}/secrets/{5}:open' -f $script:HCPBaseUri, $script:HCPApiVersion, $AdditionalParameters.OrganizationId, $AdditionalParameters.ProjectId, $AdditionalParameters.AppName, $Name)

            $secret = Invoke-RestMethod -Uri $uri -Method Get -Headers $script:authorizationHeader

            ConvertTo-SecureString -AsPlainText -Force -String $secret.secret.static_version.value
        }
    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException] {    
        Write-Debug ("The Secret {0} does not exist: {1}" -f $Name, $_) 
    }
    catch {
        Write-Error $_
    }    
}