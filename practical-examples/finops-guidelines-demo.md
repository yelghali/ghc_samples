# Azure FinOps Advisor Review

## Azure Context

- Subscription: `ME-MngEnvMCAP861042-yaelghal-2`
- Subscription ID: `292e62e6-54a8-4c6a-b996-0c83f8cc29d0`
- Tenant ID: `5dc82be3-90ab-4f72-a0f2-b2557ba694e3`
- Resource group scope: `rg-ghc-samples-showcase`

## Observed Configuration

- Resource count: 2
- Untagged resource count: 1
- Storage account count: 1
- Public IP count: 0
- Managed disk count: 0

## Azure Advisor Findings

- Cost recommendations: 14
- Performance recommendations: 0
- Cost: Consider Cosmos DB reserved instance to save over the pay-as-you-go costs -> Consider Cosmos DB reserved instance to save over the pay-as-you-go costs
- Cost: Consider purchasing a savings plan to unlock lower prices -> Consider purchasing a savings plan to unlock lower prices
- Cost: Consider virtual machine reserved instance to save over the on-demand costs -> Consider virtual machine reserved instance to save over the on-demand costs
- Cost: Right-size or shutdown underutilized virtual machines -> Right-size or shutdown underutilized virtual machines

## Detected Enhancements

| Area | Detected item | Why it matters | Recommended enhancement | Validation/action |
| --- | --- | --- | --- | --- |
| Tagging | Resource `stghcdevmg7x6qml5ohay-5802e66e-a59f-4b5b-97bb-f45fd4df1994` has no tags. | Missing ownership and cost-center tags make showback, chargeback, anomaly routing, and cleanup decisions harder. | Apply required tags such as workload, environment, owner, and costCenter through IaC and Azure Policy. | `az resource show --ids "/subscriptions/292e62e6-54a8-4c6a-b996-0c83f8cc29d0/resourceGroups/rg-ghc-samples-showcase/providers/Microsoft.EventGrid/systemTopics/stghcdevmg7x6qml5ohay-5802e66e-a59f-4b5b-97bb-f45fd4df1994" --query tags` |
| Azure Advisor Cost | Consider purchasing a savings plan to unlock lower prices | Azure Advisor identified a potential cost optimization opportunity based on platform telemetry. | Consider purchasing a savings plan to unlock lower prices | `az advisor recommendation list --category Cost --output table` |
| Azure Advisor Cost | Consider Cosmos DB reserved instance to save over the pay-as-you-go costs | Azure Advisor identified a potential cost optimization opportunity based on platform telemetry. | Consider Cosmos DB reserved instance to save over the pay-as-you-go costs | `az advisor recommendation list --category Cost --output table` |
| Azure Advisor Cost | Right-size or shutdown underutilized virtual machines | Azure Advisor identified a potential cost optimization opportunity based on platform telemetry. | Right-size or shutdown underutilized virtual machines | `az advisor recommendation list --category Cost --output table` |
| Azure Advisor Cost | Consider virtual machine reserved instance to save over the on-demand costs | Azure Advisor identified a potential cost optimization opportunity based on platform telemetry. | Consider virtual machine reserved instance to save over the on-demand costs | `az advisor recommendation list --category Cost --output table` |

## Baseline Guidelines

- Use Azure Advisor Cost recommendations as the first prioritization input for rightsizing, shutdown, and burstable SKU opportunities.
- Validate Advisor savings against reservations, savings plans, negotiated discounts, workload criticality, performance requirements, and business calendars before actioning.
- Require workload, environment, owner, and cost-center tags for showback/chargeback and ownership routing.
- Configure budgets and alerts at the subscription/resource-group scope before deploying recurring workloads.
- Use Cost Management exports or FinOps hubs for durable reporting instead of relying only on portal views.
- Review public IPs, orphaned disks, unattached resources, and nonproduction always-on resources on a regular cadence.
- Treat this report as evidence plus guidance; it does not deploy, resize, delete, or purchase commitments.
