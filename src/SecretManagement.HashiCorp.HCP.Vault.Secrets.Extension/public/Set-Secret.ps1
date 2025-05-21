function Set-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [object] $Secret,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        if (Test-SecretVault -VaultName $VaultName -AdditionalParameters $AdditionalParameters) {        
            if ($Secret -isnot [string] -and $Secret -is [System.Security.SecureString]) {
                $Secret = ConvertFrom-SecureString -SecureString $Secret -AsPlainText
            }

            $body = @{
                'name' = $Name
                'value' = $Secret
            } | ConvertTo-Json

            $uri = ('{0}/secrets/{1}/organizations/{2}/projects/{3}/apps/{4}/secret/kv' -f $script:HCPBaseUri, $script:HCPApiVersion, $AdditionalParameters.OrganizationId, $AdditionalParameters.ProjectId, $AdditionalParameters.AppName)

            $secret = Invoke-RestMethod -Uri $uri -Method Post -Body $body -Headers $script:authorizationHeader
        }
    }
    catch {
        Write-Error $_
    }    
}