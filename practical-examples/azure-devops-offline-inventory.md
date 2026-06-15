# Azure DevOps Offline Migration Inventory Example

Use this when MCP and live Azure DevOps access are not available.

Ask the Azure DevOps owner to export or capture:

- Classic build YAML export if available.
- Classic release stage/task screenshots if direct YAML export is unavailable.
- Variable groups, secret variable names, secure files, and service connection names.
- Trigger settings, branch filters, path filters, and schedules with the original time zone.
- Agent pool names and demands.
- Artifact publish/download settings.
- Environment approvals, gates, checks, and deployment conditions.

Then fill `azure-devops-classic-to-yaml/samples/migration-inventory.template.json` and use the Azure DevOps migration skill to draft YAML for review.
