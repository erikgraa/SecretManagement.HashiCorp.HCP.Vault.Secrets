# SecretManagement.HashiCorp.HCP.Vault.Secrets

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/erikgraa/SecretManagement.HashiCorp.HCP.Vault.Secrets/refs/heads/main/LICENSE)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/SecretManagement.HashiCorp.HCP.Vault.Secrets)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/SecretManagement.HashiCorp.HCP.Vault.Secrets?color=green)

> This PowerShell module is a Microsoft.PowerShell.SecretManagement extension for HashiCorp HCP Vault Secrets available in [the PowerShell Gallery](https://www.powershellgallery.com/packages/SecretManagement.HashiCorp.HCP.Vault.Secrets).

> [!TIP]  
> Read the related blog post at https://blog.graa.dev/Vault-LAPS

## 📄 Prerequisites

### PowerShell version

> [!IMPORTANT]  
> At present only PowerShell 7 is supported, and testing has been done on PowerShell `7.5.1`

### Microsoft.PowerShell.SecretManagement

Make sure that the requisite `Microsoft.PowerShell.SecretManagement` module is installed.

```powershell
Install-Module -Name Microsoft.PowerShell.SecretManagement
```

## 📦 Installation

Install the HashiCorp HCP Vault Secrets extension that is published to the PowerShell Gallery:

```powershell
Install-Module -Name SecretManagement.HashiCorp.HCP.Vault.Secrets -AllowClobber
```

## 🔧 Usage

### Register vault

The following are required:
* A vault name (typically one would choose the same as the HCP Vault Secrets App Name)
* HCP Organization ID
* HCP Project ID
* HCP Vault Secrets App Name

To access secrets in the vault after registering one needs an IAM service principal's client ID and client secret.

```powershell
$vaultName = 'HCP-Secrets-App'
$module = 'SecretManagement.HashiCorp.HCP.Vault.Secrets'

$vaultParameters = @{ 
    'OrganizationId' = '<organizationID>'
    'ProjectId' = '<projectID>'
    'AppName' = 'HCP-Secrets-App'
}

Register-SecretVault -Name $vaultName -Module $module -VaultParameters $vaultParameters
```

Optionally set this vault as the default one.

```powershell
Set-SecretVaultDefault -Name 'HCP-Secrets-App'
```

### Authenticating

When using the cmdlets exposed by the module, authentication attempts happen in this order until one succeeds or they are all exhausted:

1. If `$script:SecretManagement_<VaultName>_AccessToken` exists - check if it is valid and not expired
2. Checking whether the environment variables `$ENV:HCP_<VaultName>_CLIENT_ID` and `$env:HCP_<VaultName>_CLIENT_SECRET` are set
3. Checking whether the environment variables `$ENV:HCP_CLIENT_ID` and `$env:HCP_CLIENT_SECRET` are set
4. Interactively asking for a client ID and client secret

### Retrieve secret info

Retrieve information about every secret:

```powershell
Get-SecretInfo -Vault 'HCP-Secrets-App'
```

Filter by secret name:

```powershell
Get-SecretInfo -Vault 'HCP-Secrets-App' -Name 'secret'
```

### Retrieve secret

Retrieve a secret by specifying the secret name:

```powershell
Get-Secret -Vault 'HCP-Secrets-App' -Name 'secret'
```

### Set secret

Set a secret by specifying the secret name and its value - as a SecureString (preferred) or plaintext:

```powershell
$secret = Read-Host -Prompt 'Secret value' -AsSecureString

Set-Secret -Vault 'HCP-Secrets-App' -Name 'secret' -Secret $secret
```

Or plaintext:

```powershell
Set-Secret -Vault 'HCP-Secrets-App' -Name 'secret' -Secret 'secret value'
```

### Remove secret

Remove a secret by specifying the secret name:

```powershell
Remove-Secret -Vault 'HCP-Secrets-App' -Name 'secret'
```

## 🙌 Contributing

Any contributions are welcome and appreciated!

Please do so by forking the project and opening a pull request!

## ✨ Credits

> [!NOTE]
> This module is not supported by HashiCorp in any way.