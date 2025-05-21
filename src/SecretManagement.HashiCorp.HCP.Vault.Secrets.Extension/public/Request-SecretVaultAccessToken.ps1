function Request-SecretVaultAccessToken {
    [CmdletBinding()]
    param (
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    try {
        try {
            $clientId = $null
            $clientSecret = $null

            $clientId = (Get-Item ('env:HCP_{0}_CLIENT_ID' -f $VaultName) -ErrorAction Stop).Value
            $clientSecret = (Get-Item ('env:HCP_{0}_CLIENT_SECRET' -f $VaultName) -ErrorAction Stop).Value
        }
        catch {
            $clientId = $env:HCP_CLIENT_ID
            $clientSecret = $env:HCP_CLIENT_SECRET
        }

        if ($null -eq $clientId -or $null -eq $clientSecret) {
            Write-Error 'A HCP Client ID and HCP Client Secret must be available as environment variables to authenticate with HashiCorp Cloud Platform'
        }

        $body = @{
            'grant_type' = 'client_credentials'
            'client_id' = $clientId
            'client_secret' = $clientSecret
            'audience' = $script:HCPAuthenticationAudienceUri
        }

        $accessToken = Invoke-RestMethod -Uri $script:HCPAuthenticationUri -Method Post -Body $body -ContentType $script:HCPApiAccessTokenContentType

        if ($null -ne $accessToken.access_token) {
            Set-Variable -Name ('SecretManagement_{0}_Vault_AccessToken' -f $VaultName) -Value $accessToken.access_token -Scope Script        
            Set-Variable -Name ('SecretManagement_{0}_Vault_AccessToken_ExpiryInSeconds' -f $VaultName) -Value $accessToken.expires_in -Scope Script
            Set-Variable -Name ('SecretManagement_{0}_Vault_AccessToken_DateTime' -f $VaultName) -Value (Get-Date) -Scope Script

            $script:authorizationHeader = @{
                'Authorization' = ('Bearer {0}' -f $accessToken.access_token)
            }

            return $true
        }

        return $false
    }
    catch  {
        $false
    }
}