# Variables

$script:HCPAuthenticationUri = 'https://auth.idp.hashicorp.com/oauth/token'
$script:HCPAuthenticationAudienceUri = 'https://api.hashicorp.cloud'
$script:HCPBaseUri = 'https://api.cloud.hashicorp.com'
$script:HCPApiAccessTokenContentType = 'application/x-www-form-urlencoded'
$script:HCPApiPageSize = '10000'
$script:HCPApiVersion = '2023-11-28'

# Dot sourcing functions/classes/enums

$public = Get-ChildItem -Path ('{0}/public' -f $PSScriptRoot) -File -Recurse -ErrorAction Stop | Where-Object { $_.Extension -eq '.ps1' } 
$private = Get-ChildItem -Path ('{0}/private' -f $PSScriptRoot) -File -Recurse -ErrorAction Stop | Where-Object { $_.Extension -eq '.ps1' } 

foreach ($_cmdlet in @($public + $private)) {
    try {
        . $_cmdlet.FullName
    }
    catch {
        throw ("Failed to dot-source '{0}': {1}" -f $_cmdlet.Name, $_)
    }
}

Export-ModuleMember -Function $public.BaseName