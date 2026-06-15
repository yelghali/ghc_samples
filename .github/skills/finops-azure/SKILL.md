---
name: finops-azure
description: "Use when implementing Azure FinOps with Azure Advisor, Azure Well-Architected cost best practices, FinOps Toolkit, Cost Management exports, FinOps hubs, budgets, tags, and cost optimization."
argument-hint: "Billing scope, subscription, export, hub, workbook, or optimization scenario"
---

# FinOps on Azure

## When to Use

Use this skill for Azure FinOps implementation, Azure Advisor cost review, Azure Well-Architected cost best practices, FinOps Toolkit automation, Cost Management exports, hub deployment planning, Power BI reporting, workbooks, and optimization recommendations.

## Procedure

1. Read `../../../finops-azure/README.md`.
2. Identify target scope and permissions: billing account/profile/invoice section, subscription, management group, or resource group.
3. Query Azure Advisor Cost and Performance recommendations when Azure access exists; otherwise document that Advisor review is pending.
4. Read actual deployed resource inventory and configuration with Azure CLI, Azure PowerShell, SDK, or REST APIs; do not use MCP.
5. Use FinOps Toolkit tools where possible: FinOps hubs, Power BI reports, FinOps workbooks, Azure Optimization Engine, PowerShell module, Bicep Registry modules, and open data.
6. Generate scripts with placeholders for tenant, subscription, billing scope, storage, export name, recurrence, and format.
7. Emit detected enhancements, not only generic guidance. For each issue, include the observed item, why it matters, recommended enhancement, and a validation or action command. Distinguish observed Azure facts from recommendations requiring human validation: tags, budgets, anomalies, idle resources, orphaned disks/IPs, reservations, savings plans, rightsizing, and commitment coverage.

## Bundled Samples

- `../../../finops-azure/samples/finops-cost-export.ps1`
- `../../../finops-azure/samples/finops-hub.parameters.json`
- `../../../finops-azure/samples/kql-cost-anomaly.kql`
- `../../../finops-azure/samples/advisor-finops-review.ps1`
