---
name: secure-bicep-iac
description: "Use when authoring or reviewing secure Azure Bicep infrastructure as code with Azure best practices, Azure Advisor or Defender recommendations, live config reads, private access, identity, diagnostics, TLS, PSRule, Policy, and what-if."
argument-hint: "Bicep file, Azure resource type, or security review goal"
---

# Secure Bicep Infrastructure as Code

## When to Use

Use this skill for secure Bicep authoring, Azure best-practice security review, live deployed configuration inspection, Azure Advisor or Defender for Cloud recommendations, PSRule for Azure configuration, Azure Policy alignment, and secure defaults for Azure resources.

## Procedure

1. Read `../../../secure-bicep-iac/README.md`.
2. Apply Microsoft Bicep best practices: clear names, safe defaults, descriptions, recent API versions, implicit dependencies, and secure outputs.
3. Prefer private endpoints, disabled public network access, minimum TLS 1.2 or higher, managed identities, customer-managed keys where required, and diagnostics.
4. Use Azure Verified Modules when a module exists and fits the scenario.
5. When Azure access exists, read actual deployed resource configuration with Azure CLI, Azure PowerShell, SDK, or REST APIs and compare actual settings to intended Bicep.
6. Query Azure Advisor security recommendations or Defender for Cloud recommendations where available.
7. Validate with `az bicep build`, `az deployment what-if`, PSRule for Azure, and policy checks.
8. Emit detected enhancements, not only generic guidance. For each issue, include the observed item, why it matters, recommended enhancement, and a validation or action command. Distinguish observed Azure facts, platform recommendations, and manual follow-up.

## Bundled Samples

- `../../../secure-bicep-iac/samples/secure-storage.bicep`
- `../../../secure-bicep-iac/samples/bicepconfig.json`
- `../../../secure-bicep-iac/samples/ps-rule.yaml`
- `../../../secure-bicep-iac/samples/read-config-and-security-guidelines.ps1`
