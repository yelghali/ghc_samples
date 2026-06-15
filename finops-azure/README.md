# FinOps on Azure

## What Is Available

This folder provides reusable starting points for Azure FinOps implementation using Microsoft FinOps Toolkit, Azure Cost Management, Azure Advisor, and Azure Well-Architected cost optimization guidance.

This folder is custom packaging created for this catalog. It is based on existing Microsoft FinOps Toolkit docs, the `microsoft/finops-toolkit` repository, Cost Management export workflows, FinOps hubs, Power BI reports, workbooks, Azure Optimization Engine, and FinOps Toolkit PowerShell commands.

## Microsoft Tools and Procedures

- FinOps Toolkit: open-source tools and resources for Microsoft Cloud FinOps.
- FinOps hubs: scalable cost reporting data ingestion and storage.
- Power BI reports: reporting starter kits.
- FinOps workbooks: cost optimization and governance views in Azure.
- Azure Optimization Engine: extensible optimization recommendations.
- FinOps Toolkit PowerShell module: commands such as `Deploy-FinOpsHub`, `Get-FinOpsCostExport`, and `New-FinOpsCostExport`.
- Bicep Registry modules: official FinOps Toolkit deployment modules.
- Open data: pricing units, regions, resource types, services, and sample exports.
- Azure Advisor: personalized recommendations across cost, reliability, security, performance, and operational excellence based on deployed resource configuration and telemetry.
- Azure Advisor cost recommendations: VM/VMSS shutdown, resize, and burstable recommendations based on utilization and cost criteria.
- Azure Well-Architected cost optimization: cost-management discipline, cost-efficiency mindset, usage optimization, rate optimization, and continuous monitoring.

## Custom Assets Created Here

- `.github/skills/finops-azure/SKILL.md`: custom Copilot skill for FinOps implementation workflows.
- `.github/agents/azure-finops.agent.md`: custom specialist agent instructions.
- `samples/finops-cost-export.ps1`: custom Cost Management export starter script using FinOps Toolkit commands.
- `samples/finops-hub.parameters.json`: custom FinOps hub parameter placeholder file.
- `samples/kql-cost-anomaly.kql`: custom KQL starter query for cost anomaly review.
- `samples/advisor-finops-review.ps1`: custom Azure CLI script that reads Azure Advisor and deployed resource configuration, then emits FinOps guidelines.

## Copilot / Agent Assets

- Skill: `.github/skills/finops-azure/SKILL.md`
- Agent: `.github/agents/azure-finops.agent.md`

## Offline Workflow Without Azure Access

1. Identify expected billing model, reporting scope, subscriptions, and owner teams.
2. Draft export and hub parameters using the sample files.
3. Ask Azure admins to confirm billing permissions and target storage locations.
4. Review tag policy, budgets, commitment usage, anomaly detection, and idle resource cleanup processes.
5. Run scripts only after installing the FinOps Toolkit PowerShell module and authenticating to Azure.

## Live Azure Review Workflow

Use `samples/advisor-finops-review.ps1` when Azure access is available and MCP is not allowed. The script uses Azure CLI to:

1. Read Azure Advisor recommendations for Cost and Performance. The Azure CLI currently supports Advisor categories `Cost`, `HighAvailability`, `Performance`, and `Security`; operational-excellence guidance remains documented in Microsoft Learn but is not exposed as an `az advisor recommendation list --category` value in this environment.
2. Read deployed resource inventory, resource tags, locations, and SKUs where available.
3. Summarize likely FinOps actions: rightsizing, shutdown/removal candidates, tag governance gaps, budget/alert follow-up, commitment review, and data export setup.
4. Emit a Markdown report that separates observed Azure configuration from recommendations that require human validation.

Advisor recommendations should be treated as evidence-backed starting points, not automatic actions. Validate workload criticality, reservations/savings plans, support contracts, business schedules, and performance requirements before making changes.
