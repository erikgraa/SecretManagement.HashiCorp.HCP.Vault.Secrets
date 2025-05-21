function Test-SecretVault {
    [CmdletBinding()]
    param (
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        if ($null -eq $AdditionalParameters.OrganizationId -or $null -eq $AdditionalParameters.ProjectId -or $null -eq $AdditionalParameters.AppName) {
            Write-Error 'Register the vault with a HCP organization ID, HCP project ID and HCP Vault Secrets App name'
        }

        $script:authenticated = $false

        $accessToken = Get-Variable -Name ('SecretManagement_{0}_Vault_AccessToken' -f $VaultName) -Scope Script -ErrorAction SilentlyContinue

        if ($null -ne $accessToken) {
            $accessTokenDateTime = (Get-Variable -Name ('SecretManagement_{0}_Vault_AccessToken_DateTime' -f $VaultName) -Scope Script -ErrorAction SilentlyContinue).Value
            $accessTokenExpiryInSeconds = (Get-Variable -Name ('SecretManagement_{0}_Vault_AccessToken_ExpiryInSeconds' -f $VaultName) -Scope Script -ErrorAction SilentlyContinue).Value
        
            if ([DateTime]$accessTokenDateTime.AddSeconds($accessTokenExpiryInSeconds) -gt (Get-Date).AddMinutes(-1)) {
                $script:authenticated = $true
            }
        }

        if ($script:authenticated -eq $false) {
            $script:authenticated = Request-SecretVaultAccessToken -VaultName $VaultName -AdditionalParameters $AdditionalParameters
        }

        if ($script:authenticated -eq $false) {
            return $false
        }
        else {
            try {
                $uri = ('{0}/secrets/{1}/organizations/{2}/projects/{3}/apps/{4}' -f $script:HCPBaseUri, $script:HCPApiVersion, $AdditionalParameters.OrganizationId, $AdditionalParameters.ProjectId, $AdditionalParameters.AppName)

                $app = Invoke-RestMethod -Uri $uri -Method Get -Headers $script:authorizationHeader

                return $true
            }
            catch {
                Write-Error ('HashiCorp HCP Vault Secrets App {0} does not exist in the current project' -f $AdditionalParameters.AppName)

                return $false
            }
        }
    }
    catch {
        $false
    }
}