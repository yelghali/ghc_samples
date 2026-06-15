# Azure Security Configuration Guidelines

## Azure Context

- Subscription: `ME-MngEnvMCAP861042-yaelghal-2`
- Subscription ID: `292e62e6-54a8-4c6a-b996-0c83f8cc29d0`
- Tenant ID: `5dc82be3-90ab-4f72-a0f2-b2557ba694e3`
- Resource group: `rg-ghc-samples-showcase`

## Observed Configuration

- Resource count: 1
- Storage accounts inspected: 1
- Storage `stghcdevmg7x6qml5ohay`: publicNetworkAccess=`Disabled`, allowBlobPublicAccess=`False`, allowSharedKeyAccess=`False`, httpsOnly=`True`, minTls=`TLS1_2`, networkDefaultAction=`Allow`, identity=``

## Azure Advisor / Defender Findings

- Advisor security recommendations: 49
- Security: Access to storage accounts with firewall and virtual network configurations should be restricted -> Access to storage accounts with firewall and virtual network configurations should be restricted
- Security: API Management calls to API backends should be authenticated -> API Management calls to API backends should be authenticated
- Security: API Management calls to API backends should not bypass certificate thumbprint or name validation -> API Management calls to API backends should not bypass certificate thumbprint or name validation
- Security: API Management should disable public network access to the service configuration endpoints -> API Management should disable public network access to the service configuration endpoints
- Security: App Configuration should use private link -> App Configuration should use private link
- Security: Azure Backup should be enabled for virtual machines -> Azure Backup should be enabled for virtual machines
- Security: Azure registry container images should have vulnerabilities resolved -> Azure registry container images should have vulnerabilities resolved
- Security: Container registries should not allow unrestricted network access -> Container registries should not allow unrestricted network access
- Security: Container registries should use private link -> Container registries should use private link
- Security: CosmosDB accounts should use private link -> CosmosDB accounts should use private link

## Detected Enhancements

| Area | Detected item | Why it matters | Recommended enhancement | Validation/action |
| --- | --- | --- | --- | --- |
| Identity | Storage account `stghcdevmg7x6qml5ohay` does not have a managed identity configured. | Managed identity enables secretless integration with Azure services and supports least-privilege access patterns. | Enable system-assigned or user-assigned managed identity when the storage account participates in automation, diagnostics, encryption, or service integrations. | `az storage account show --name stghcdevmg7x6qml5ohay --resource-group rg-ghc-samples-showcase --query identity` |
| Network access | Storage account `stghcdevmg7x6qml5ohay` network default action is `Allow`. | Deny-by-default network rules reduce exposure if public network access is re-enabled or exceptions are added later. | Set network default action to Deny and add explicit private endpoint, trusted service, or subnet rules required by the workload. | `az storage account show --name stghcdevmg7x6qml5ohay --resource-group rg-ghc-samples-showcase --query networkRuleSet.defaultAction` |
| Azure Advisor Security | EDR configuration issues should be resolved on virtual machines | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | EDR configuration issues should be resolved on virtual machines | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Linux virtual machines should enable Azure Disk Encryption or EncryptionAtHost. | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Linux virtual machines should enable Azure Disk Encryption or EncryptionAtHost. | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Microsoft Defender for APIs should be enabled | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Microsoft Defender for APIs should be enabled | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Machines should be configured to periodically check for missing system updates | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Machines should be configured to periodically check for missing system updates | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Azure registry container images should have vulnerabilities resolved | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Azure registry container images should have vulnerabilities resolved | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Foundry Agent's MCP tool should be configured with allowed tools list | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Foundry Agent's MCP tool should be configured with allowed tools list | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | App Configuration should use private link | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | App Configuration should use private link | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | API Management should disable public network access to the service configuration endpoints | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | API Management should disable public network access to the service configuration endpoints | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Microsoft Foundry resources should restrict network access | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Microsoft Foundry resources should restrict network access | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Email notification to subscription owner for high severity alerts should be enabled | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Email notification to subscription owner for high severity alerts should be enabled | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | CosmosDB accounts should use private link | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | CosmosDB accounts should use private link | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | API Management calls to API backends should not bypass certificate thumbprint or name validation | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | API Management calls to API backends should not bypass certificate thumbprint or name validation | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Storage accounts should restrict network access using virtual network rules | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Storage accounts should restrict network access using virtual network rules | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | API Management calls to API backends should be authenticated | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | API Management calls to API backends should be authenticated | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Storage account should use a private link connection | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Storage account should use a private link connection | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Container registries should not allow unrestricted network access | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Container registries should not allow unrestricted network access | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Guest Configuration extension should be installed on machines | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Guest Configuration extension should be installed on machines | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Container registries should use private link | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Container registries should use private link | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Virtual machines and virtual machine scale sets should have encryption at host enabled | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Virtual machines and virtual machine scale sets should have encryption at host enabled | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Microsoft Foundry Agent should be configured with operational instructions | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Microsoft Foundry Agent should be configured with operational instructions | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Microsoft Foundry resources should have key access disabled (disable local authentication) | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Microsoft Foundry resources should have key access disabled (disable local authentication) | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Microsoft Foundry resources should use Azure Private Link | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Microsoft Foundry resources should use Azure Private Link | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Subnets should be associated with a network security group | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Subnets should be associated with a network security group | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Subscriptions should have a contact email address for security issues | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Subscriptions should have a contact email address for security issues | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Access to storage accounts with firewall and virtual network configurations should be restricted | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Access to storage accounts with firewall and virtual network configurations should be restricted | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Diagnostic logs in Microsoft Foundry resources should be enabled | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Diagnostic logs in Microsoft Foundry resources should be enabled | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Azure Backup should be enabled for virtual machines | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Azure Backup should be enabled for virtual machines | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Email notification for high severity alerts should be enabled | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Email notification for high severity alerts should be enabled | `az advisor recommendation list --category Security --output table` |
| Azure Advisor Security | Virtual networks should be protected by Azure Firewall | Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience. | Virtual networks should be protected by Azure Firewall | `az advisor recommendation list --category Security --output table` |

## Baseline Guidelines

- Verify explicitly: require managed identity or Entra ID auth where supported; avoid shared keys and long-lived secrets.
- Use least privilege: scope RBAC narrowly and review role assignments for workload identities and operators.
- Assume breach: disable public network access where private access is available, deny by default on network ACLs, and enable diagnostics.
- Protect confidentiality: enforce HTTPS-only, TLS 1.2 or later, encryption at rest, private endpoints for sensitive data stores, and secret-free outputs.
- Protect integrity: use immutable or soft-delete capabilities where supported, keep API versions current, and validate IaC with build, what-if, policy, and PSRule.
- Protect availability: ensure security controls do not block recovery paths, and apply equivalent security controls to backup/DR resources.
- Sustain posture: review Azure Advisor/Defender recommendations regularly and compare deployed config against intended Bicep after every release.
- Treat this report as guidance. Confirm business exceptions, data classification, network topology, and operational ownership before remediation.
