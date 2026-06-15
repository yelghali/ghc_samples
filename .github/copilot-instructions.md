# Repository Instructions

This repository is a reusable sample catalog for Azure DevOps, Bicep, and FinOps agent customizations.

When generating or editing samples:

- Prefer Microsoft-supported tools and documented procedures over ad hoc scripts.
- Treat generated migration output as a draft that must be reviewed for secrets, triggers, schedules, approvals, environments, service connections, and RBAC.
- For Bicep, prefer Azure Verified Modules when they fit the target resource and keep hand-written modules small, parameterized, and secure by default.
- Always include validation steps such as Azure Pipelines Validate, `az bicep build`, `az deployment * what-if`, PSRule for Azure, or FinOps Toolkit commands where applicable.
- Do not assume the user has a live Azure DevOps or Azure subscription. Provide offline review steps and placeholders when a live environment is required.
- MCP is not allowed in this workspace. Use Azure CLI, Azure PowerShell, Azure SDKs, REST APIs, exported files, and static documentation links instead of MCP tools.
