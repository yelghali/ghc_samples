# Agent Guidance

This repository is a sample catalog for GitHub Copilot and Claude-compatible agent customizations focused on Azure DevOps migration, Bicep modernization, secure IaC, and Azure FinOps.

## Available Specialist Agents

- `.github/agents/azure-devops-migration.agent.md`: Use for Azure DevOps Classic build/release migration to YAML.
- `.github/agents/bicep-modernization.agent.md`: Use for ARM-to-Bicep conversion, Bicep module refactoring, and secure Bicep review.
- `.github/agents/azure-finops.agent.md`: Use for FinOps Toolkit, Cost Management exports, FinOps hubs, workbooks, and optimization workflows.

## Available Skills

- `.github/skills/azure-devops-classic-to-yaml/SKILL.md`
- `.github/skills/arm-to-bicep-conversion/SKILL.md`
- `.github/skills/bicep-to-modules/SKILL.md`
- `.github/skills/secure-bicep-iac/SKILL.md`
- `.github/skills/finops-azure/SKILL.md`

## Working Rules

- Prefer Microsoft Learn procedures and Microsoft-supported tools.
- Do not assume live Azure DevOps or Azure access. Use placeholders and offline review steps when required.
- Treat migration output as a draft that requires human review for secrets, service connections, approvals, schedules, triggers, RBAC, and costs.
- Validate Bicep with `az bicep build`; use deployment `what-if`, PSRule for Azure, and Azure Policy checks when a target environment exists.
- Prefer Azure Verified Modules for common Azure resources when they fit the scenario.
- MCP is not allowed. Use Azure CLI, Azure PowerShell, Azure SDKs, REST APIs, exported files, and static documentation links instead.
