# Practical Examples Without MCP

These examples show how to run or showcase the catalog using tools that are allowed in this environment. MCP servers are intentionally not required.

## Examples

- `azure-cli-showcase.ps1`: Azure CLI validation and non-destructive what-if flow for the Bicep samples.
- `azure-sdk-resource-inventory.py`: Azure SDK read-only subscription inventory example.
- `azure-devops-offline-inventory.md`: Practical offline Azure DevOps Classic migration collection guide when no Azure DevOps environment is available.
- `test-detected-guidelines.ps1`: Practical live test that regenerates FinOps and security reports, then verifies they contain finding-specific detected enhancements with validation/action guidance.
- `finops-guidelines-2026-06-11.md`: Generated FinOps report with actual Azure Advisor Cost findings and detected enhancement rows.
- `security-guidelines-2026-06-11.md`: Generated security report with live storage configuration findings, Azure Advisor Security findings, and detected enhancement rows.

## Tooling Notes

- Azure CLI may be installed but not on `PATH`. On Windows, a common path is `C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd`.
- Terraform may be installed but not on `PATH`. Use `where.exe terraform` or search common install folders before assuming it is unavailable.
- Keep all examples non-destructive by default. Prefer `az bicep build`, `az deployment group what-if`, and read-only `az resource list` before any deployment.
- If PowerShell script execution is blocked locally, use a process-scoped bypass for the current terminal only: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force`.

## Latest Local Showcase

See `showcase-run-2026-06-11.md` for the latest run against subscription `ME-MngEnvMCAP861042-yaelghal-2`.
