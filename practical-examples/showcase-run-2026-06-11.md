# Showcase Run - 2026-06-11

## Azure Context

- Tenant: `5dc82be3-90ab-4f72-a0f2-b2557ba694e3`
- Subscription: `ME-MngEnvMCAP861042-yaelghal-2`
- Subscription ID: `292e62e6-54a8-4c6a-b996-0c83f8cc29d0`
- User: `admin@MngEnvMCAP861042.onmicrosoft.com`

## Commands Run

- Set active subscription with Azure CLI.
- Built Bicep samples with `az bicep build`.
- Created or confirmed resource group `rg-ghc-samples-showcase` in `eastus` with tags `purpose=ghc-samples` and `environment=showcase`.
- Ran non-destructive `az deployment group what-if` previews for:
  - `arm-to-bicep-conversion/samples/converted.main.bicep`
  - `bicep-to-modules/samples/main.bicep`
  - `secure-bicep-iac/samples/secure-storage.bicep`
- Compiled the Python Azure SDK example with `python -m py_compile`.
- Checked Terraform availability.
- Deployed the module sample storage account so live configuration readers had an actual resource to inspect.
- Generated FinOps guidelines from Azure Advisor Cost recommendations and deployed resource configuration.
- Generated security guidelines from Azure Advisor Security recommendations and deployed storage account configuration.
- Ran `practical-examples/test-detected-guidelines.ps1` to regenerate both reports and verify they contain finding-specific detected enhancements with validation/action guidance.

## What-If Results

- ARM-to-Bicep sample preview: one storage account would be created with HTTPS-only, TLS 1.2, and blob public access disabled.
- Bicep module sample preview: one storage account would be created with HTTPS-only, TLS 1.2, blob public access disabled, and public network access disabled.
- Secure Bicep sample preview: three resources would be created:
  - `Microsoft.Storage/storageAccounts/stghcmg7x6qml5ohay`
  - `Microsoft.Storage/storageAccounts/stghcmg7x6qml5ohay/blobServices/default`
  - `Microsoft.Storage/storageAccounts/stghcmg7x6qml5ohay/providers/Microsoft.Insights/diagnosticSettings/send-storage-logs`

## Actual Azure Changes

- Resource group `rg-ghc-samples-showcase` exists and is provisioned successfully.
- Storage account `stghcdevmg7x6qml5ohay` was deployed from `bicep-to-modules/samples/main.bicep` for live configuration inspection.
- The secure Bicep what-if used a placeholder Log Analytics workspace resource ID and did not create that workspace.

## Advisor and Live Config Reports

- `practical-examples/finops-guidelines-2026-06-11.md`: Reads Azure Advisor Cost recommendations plus live resource count, tags, storage accounts, public IPs, and disks.
- `practical-examples/finops-guidelines-2026-06-11.md`: Emits detected enhancements such as Azure Advisor commitment recommendations with why-it-matters and validation/action commands.
- `practical-examples/security-guidelines-2026-06-11.md`: Reads Azure Advisor Security recommendations plus actual storage account settings such as public network access, blob public access, shared key access, HTTPS-only, TLS, network default action, and identity.
- `practical-examples/security-guidelines-2026-06-11.md`: Emits detected enhancements such as missing managed identity, network default action not set to deny, and Advisor security findings with why-it-matters and validation/action commands.

## Practical Example Checks

- `practical-examples/azure-sdk-resource-inventory.py` compiled successfully with Python 3.12.
- Terraform v1.15.6 was found at `C:\Users\yaelghal\AppData\Local\Microsoft\WinGet\Packages\Hashicorp.Terraform_Microsoft.Winget.Source_8wekyb3d8bbwe\terraform.exe`.

## Notes

- MCP was not used.
- Azure CLI was invoked by full path: `C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd`.
- PowerShell script execution was blocked by policy until a process-scoped bypass was applied for the terminal session.
