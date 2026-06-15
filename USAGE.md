# Agent and Skill Demo Prompts

This catalog contains reusable GitHub Copilot and Claude-compatible agents and skills for Azure DevOps migration, Bicep modernization, secure IaC, and Azure FinOps. Use this file as a central demo script for showing how the customizations work.

## Before You Demo

- Open this repository in VS Code with GitHub Copilot Chat enabled.
- Use the matching specialist agent when the chat UI offers custom agents.
- If the chat UI does not expose custom agents, paste the prompt and mention the relevant skill path directly.
- MCP is not allowed in this catalog. Use Azure CLI, Azure PowerShell, Azure SDKs, REST APIs, exported files, and static Microsoft documentation links.
- Do not assume a live Azure DevOps organization. The migration demo works from exported YAML, screenshots, task lists, and inventory files.
- Live Azure demos require Azure CLI login and access to the target subscription.

## Available Agents

| Agent | File | Use it for |
| --- | --- | --- |
| Azure DevOps Migration Agent | `.github/agents/azure-devops-migration.agent.md` | Classic build/release pipeline migration to YAML. |
| Bicep Modernization Agent | `.github/agents/bicep-modernization.agent.md` | ARM-to-Bicep conversion, Bicep modules, secure Bicep, what-if, PSRule, Policy, and live config review. |
| Azure FinOps Agent | `.github/agents/azure-finops.agent.md` | Azure Advisor cost review, FinOps Toolkit, Cost Management exports, hubs, workbooks, tagging, and optimization. |

## Available Skills

| Skill | File | Use it for |
| --- | --- | --- |
| Azure DevOps Classic to YAML | `.github/skills/azure-devops-classic-to-yaml/SKILL.md` | Pipeline inventory, YAML conversion review, variables, service connections, approvals, triggers, and schedules. |
| ARM to Bicep Conversion | `.github/skills/arm-to-bicep-conversion/SKILL.md` | `az bicep decompile`, cleanup, `az bicep build`, and what-if review. |
| Bicep to Modules | `.github/skills/bicep-to-modules/SKILL.md` | Refactoring flat Bicep into reusable modules, parameters, outputs, and `.bicepparam` files. |
| Secure Bicep IaC | `.github/skills/secure-bicep-iac/SKILL.md` | Secure defaults, Advisor/Defender recommendations, live config reads, private access, identity, diagnostics, TLS, PSRule, Policy, and what-if. |
| Azure FinOps | `.github/skills/finops-azure/SKILL.md` | Advisor cost findings, actual resource inventory, tags, budgets, exports, FinOps hubs, and optimization guidance. |

## Demo 1: Azure DevOps Classic to YAML Migration

Use the Azure DevOps Migration Agent.

Prompt:

```text
Use the Azure DevOps Migration Agent to review azure-devops-classic-to-yaml/samples/migration-inventory.template.json and azure-devops-classic-to-yaml/samples/azure-pipelines.converted.yml. Explain what is ready, what is a migration draft, and what a human must review before production use.
```

Expected result:

- Identifies the sample YAML as a draft migration output.
- Calls out manual review for secrets, service connections, variables, approvals, environments, schedules, triggers, agent pools, and task mapping.
- Points to `azure-devops-classic-to-yaml/samples/classic-to-yaml-review-checklist.md`.

Follow-up prompt:

```text
Create a migration readiness checklist for this sample pipeline and group items by blocking, recommended, and optional follow-up.
```

## Demo 2: ARM Template to Bicep

Use the Bicep Modernization Agent or the ARM-to-Bicep skill.

Prompt:

```text
Use the arm-to-bicep-conversion skill to review arm-to-bicep-conversion/samples/main.json and arm-to-bicep-conversion/samples/converted.main.bicep. Explain the decompile cleanup that was done and list validation commands I should run without deploying anything.
```

Expected result:

- Describes `az bicep decompile` as a starting point, not final output.
- Recommends `az bicep build` and `az deployment group what-if`.
- Calls out secure defaults such as HTTPS-only, TLS 1.2, and disabled blob public access.

Optional validation command:

```powershell
az bicep build --file arm-to-bicep-conversion/samples/converted.main.bicep
```

## Demo 3: Transform Bicep into Modules

Use the Bicep Modernization Agent or the Bicep-to-modules skill.

Prompt:

```text
Use the bicep-to-modules skill to explain how bicep-to-modules/samples/main.bicep calls bicep-to-modules/samples/modules/storage-account/main.bicep. Identify the module boundary, parameters, outputs, and what would change if this became an Azure Verified Module reference.
```

Expected result:

- Explains the root deployment and storage module boundary.
- Identifies parameter and output contracts.
- Mentions when Azure Verified Modules are preferred.

Optional validation command:

```powershell
az bicep build --file bicep-to-modules/samples/main.bicep
```

## Demo 4: Secure Bicep and Live Security Config Review

Use the Bicep Modernization Agent or the secure-bicep-iac skill.

Prompt:

```text
Use the secure-bicep-iac skill to review secure-bicep-iac/samples/secure-storage.bicep and practical-examples/security-guidelines-2026-06-11.md. Explain which findings came from intended Bicep configuration, which came from actual deployed Azure configuration, and which came from Azure Advisor Security recommendations.
```

Expected result:

- Separates intended IaC from live Azure state and Advisor/Defender-style recommendations.
- Calls out detected enhancements such as missing managed identity or network default action not set to deny when present.
- Recommends validation with `az bicep build`, `az deployment group what-if`, PSRule for Azure, and Azure Policy checks.

Live report command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\secure-bicep-iac\samples\read-config-and-security-guidelines.ps1 `
  -AzPath "C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" `
  -SubscriptionId "<subscription-id>" `
  -ResourceGroupName "<resource-group-name>" `
  -OutputPath "practical-examples\security-guidelines-demo.md"
```

## Demo 5: Azure FinOps Advisor and Live Inventory Review

Use the Azure FinOps Agent or the finops-azure skill.

Prompt:

```text
Use the finops-azure skill to review practical-examples/finops-guidelines-2026-06-11.md. Explain the actual Azure facts, Azure Advisor Cost recommendations, and detected enhancements with validation or action commands.
```

Expected result:

- Separates live resource inventory from Advisor cost recommendations.
- Identifies detected enhancements such as commitment recommendations, untagged resources, public IPs, or managed disks when present.
- Keeps recommendations review-first and non-destructive.

Live report command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\finops-azure\samples\advisor-finops-review.ps1 `
  -AzPath "C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" `
  -SubscriptionId "<subscription-id>" `
  -ResourceGroupName "<resource-group-name>" `
  -OutputPath "practical-examples\finops-guidelines-demo.md"
```

## Demo 6: End-to-End Practical Test

Use this when you want to prove that the FinOps and security reports are finding-driven instead of generic.

Prompt:

```text
Run practical-examples/test-detected-guidelines.ps1 and summarize whether the generated FinOps and security reports contain detected enhancements with validation/action guidance.
```

Command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\practical-examples\test-detected-guidelines.ps1 `
  -AzPath "C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" `
  -SubscriptionId "<subscription-id>" `
  -ResourceGroupName "<resource-group-name>"
```

Expected result:

- Regenerates the FinOps and security reports.
- Verifies both reports contain `## Detected Enhancements`.
- Verifies both reports contain an actionable table with detected item, why it matters, recommended enhancement, and validation/action.

## Suggested Live Demo Order

1. Start with `README.md` to explain the catalog and MCP restriction.
2. Use the Azure DevOps Migration Agent with the offline pipeline samples.
3. Use the Bicep Modernization Agent to explain ARM-to-Bicep and module extraction.
4. Run the FinOps live report to show Azure Advisor and resource inventory.
5. Run the security live report to show actual deployed config and Advisor Security findings.
6. Run `practical-examples/test-detected-guidelines.ps1` as the proof that reports are finding-driven.

## Cleanup Reminder

If you deployed the showcase resources and no longer need them, review and then remove the resource group explicitly:

```powershell
az group delete --name rg-ghc-samples-showcase --yes
```

Only run cleanup when you are done with the live demo resources.