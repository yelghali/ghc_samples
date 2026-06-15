# Secure Bicep Infrastructure as Code

## What Is Available

This folder provides a secure-by-default Bicep sample and validation configuration for authoring Azure infrastructure as code, plus a live Azure configuration review workflow that emits security guidelines from actual deployed settings.

This folder is custom packaging created for this catalog. It is based on existing Microsoft Learn Bicep best practices, Azure Verified Modules guidance, PSRule for Azure practices, and Azure deployment what-if validation.

## Microsoft Tools and Procedures

- Microsoft Bicep best practices: clear names, safe defaults, helpful descriptions, recent API versions, implicit dependencies, `existing` resources, and `@secure()` outputs for sensitive data.
- Azure Verified Modules: prefer Microsoft-maintained modules for common resources.
- PSRule for Azure: static analysis for Azure Well-Architected and security rules.
- Azure Policy and deployment what-if: environment-aware validation before deployment.
- Azure Advisor and Defender for Cloud recommendations: prioritized security recommendations based on resource configuration, policy assessments, and security posture.
- Azure Well-Architected security principles: plan security readiness, protect confidentiality, protect integrity, protect availability, and sustain security posture.

## Custom Assets Created Here

- `.github/skills/secure-bicep-iac/SKILL.md`: custom Copilot skill for secure Bicep authoring and review.
- `.github/agents/bicep-modernization.agent.md`: shared custom specialist agent for Bicep modernization.
- `samples/secure-storage.bicep`: custom secure storage sample.
- `samples/bicepconfig.json`: custom sample Bicep analyzer configuration.
- `samples/ps-rule.yaml`: custom PSRule for Azure sample configuration.
- `samples/read-config-and-security-guidelines.ps1`: custom Azure CLI script that reads deployed configuration and emits security guidelines.

## Copilot / Agent Assets

- Skill: `.github/skills/secure-bicep-iac/SKILL.md`
- Agent: `.github/agents/bicep-modernization.agent.md`

## Baseline Security Defaults

- Disable public access unless there is a documented exception.
- Enforce HTTPS and TLS 1.2 or later.
- Use managed identity instead of secrets where possible.
- Send diagnostic logs to a workspace or approved sink.
- Mark sensitive outputs with `@secure()` and avoid passing secrets through outputs.
- Use private endpoints for data plane access when the target architecture supports it.

## Live Azure Security Review Workflow

Use `samples/read-config-and-security-guidelines.ps1` when Azure access is available and MCP is not allowed. The script uses Azure CLI to:

1. Read actual deployed resources in a target resource group.
2. Query Azure Advisor security recommendations when available.
3. Inspect common resource configuration, especially storage accounts, for settings such as public network access, blob public access, shared key access, HTTPS-only, minimum TLS, managed identity, and network default action.
4. Emit Markdown guidelines mapped to Azure Well-Architected security principles: verify explicitly, least privilege, assume breach, segmentation, encryption, logging, and continuous posture review.

Do not rely only on generated Bicep. Always compare intended IaC settings with the actual deployed resource configuration and Azure platform recommendations.
