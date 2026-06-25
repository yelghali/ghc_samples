# Azure DevOps Classic to YAML Pipelines

## What Is Available

This folder provides a reusable migration workflow for Azure DevOps Classic pipelines. It supports two paths, and the path you take depends on the pipeline type:

- **Classic build pipelines** (created with the classic build designer): export YAML directly from the pipeline definition view. If the export option is missing, the pipeline does not support it.
- **Classic release pipelines**: there is **no YAML export**. Inventory and migrate each task manually into a multi-stage YAML `deployment` job model. The closest machine-readable starting point is the release definition JSON from the REST API.

This folder is custom packaging created for this catalog. It is based on existing Microsoft Learn Azure DevOps migration and YAML editor procedures, plus public Microsoft repository examples that show generated Classic-to-YAML migration comments.

## Build vs Release: What Exports and What Does Not

| Source | YAML export? | Path |
| --- | --- | --- |
| Classic build pipeline (build designer) | Yes | Definition view > three-dot menu > **Export to YAML** |
| Classic build pipeline (no export option shown) | No | Pipeline does not support export; rebuild in YAML |
| Classic release pipeline | **No** | Manual, task-by-task migration; snapshot the definition JSON via REST |

Microsoft Learn states: "Classic release pipelines don't support YAML export, you'll need to export each task individually." Always be in the pipeline **definition** view (not a specific run) to see Export to YAML.

## Microsoft Tools and Procedures

- Azure DevOps Classic build pipeline export: pipeline definition view > more menu > Export to YAML.
- Azure DevOps YAML editor: IntelliSense, Task Assistant, Validate, and Download full YAML.
- Azure Pipelines YAML schema reference for `trigger`, `resources`, `stages`, `jobs`, `deployment`, `environment`, `variables`, `schedules`, and templates.
- Classic release definition REST endpoint: `GET https://vsrm.dev.azure.com/{org}/{project}/_apis/release/definitions/{id}?api-version=7.1`.
- Internal Microsoft examples show generated migration comments from `https://aka.ms/1ESPTMigration`, including warnings for secrets, missing triggers, run names, and OAuth token access. Treat those comments as review inputs.

## Mapping Rules (Release -> Multi-Stage YAML)

- Classic stage -> `stages.stage`.
- Classic agent phase -> `jobs.job`; agentless (server) phase -> `jobs.job` with `pool: server`.
- Classic deployment phase -> `jobs.deployment` with an `environment` and a `strategy` (`runOnce`, `rolling`, `canary`). `matrix` is valid only on `jobs.job.strategy`.
- Classic task -> `steps.task` with the identical task name and major version.
- Classic approvals/gates -> environment checks (Approval, Branch control, Business hours, Invoke Azure Function, Invoke REST API, Required template, Exclusive lock).
- Classic deployment groups -> `environment` resources of type `virtualMachine`.
- Variable groups, service connections, and secure files are reused as-is (referenced, not migrated). Variable-group secrets must be passed into steps via an explicit `env:` block.

## Custom Assets Created Here

- `.github/skills/azure-devops-classic-to-yaml/SKILL.md`: custom Copilot skill for repeatable migration review.
- `.github/agents/azure-devops-migration.agent.md`: custom specialist agent instructions.
- `samples/azure-pipelines.converted.yml`: custom starter YAML draft.
- `samples/migration-inventory.template.json`: custom offline inventory template.
- `samples/classic-to-yaml-review-checklist.md`: custom review checklist.
- `samples/classic-release-inventory.ps1`: optional, approval-gated Azure CLI/REST inventory script (live access).

## Copilot / Agent Assets

- Skill: `.github/skills/azure-devops-classic-to-yaml/SKILL.md`
- Agent: `.github/agents/azure-devops-migration.agent.md`

## Offline Workflow Without Azure DevOps Access

1. Ask the pipeline owner for exported YAML, task screenshots, variable groups, service connection names, schedules, retention settings, environments, approvals, and artifact definitions.
2. Fill out `samples/migration-inventory.template.json`.
3. Draft YAML using `samples/azure-pipelines.converted.yml` as a starting structure.
4. Review with `samples/classic-to-yaml-review-checklist.md`.
5. When an Azure DevOps environment is available, validate in the YAML editor before running.

## Optional Live Inventory (Requires User Approval)

If the user has a live organization and explicitly approves connecting to it, `samples/classic-release-inventory.ps1` snapshots release definitions, variable groups, and service connections to JSON using the Azure CLI `azure-devops` extension and the release REST API. It was inspected for safety: it is **read-only** (`list`/`GET` only), prompts for explicit `yes` confirmation before connecting, and the list APIs never return secret variable values or service-connection credentials, so the snapshots contain no secrets. Default to the offline workflow when no live environment exists or the user declines. MCP is not allowed; use Azure CLI, REST APIs, and exported files only.

## Migration Risks to Review

- Secret variables copied into YAML instead of variable groups or Key Vault.
- Classic UI schedules using local organization time while YAML schedules use UTC by default.
- Deployment approvals and gates not represented in YAML unless environments/checks are configured.
- Service connection permissions and pipeline authorization missing after migration.
- Task version drift (e.g., `AzureWebApp@1` replaced by a different task/version by the Task Assistant).
- Build artifacts and release artifacts mapped incorrectly.
- Classic release deleted before parity is proven; abandon as draft and keep the JSON snapshot for audit.

## References

All capability claims in this folder are backed by official Microsoft Learn documentation:

- Migrate your Classic pipeline to YAML (build export, no release export, UTC schedules): https://learn.microsoft.com/en-us/azure/devops/pipelines/release/from-classic-pipelines?view=azure-devops
- Deployment jobs and `runOnce`/`rolling`/`canary` strategies: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/deployment-jobs?view=azure-devops
- Jobs, server/agentless jobs (`pool: server`), `matrix` job strategy, OAuth token via `env`: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops
- Approvals and checks (configured on resources/environments, not in YAML): https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops
- Environments and `virtualMachine` resources: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments-virtual-machines?view=azure-devops
- Variable groups: https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops
- Release definitions REST API: https://learn.microsoft.com/en-us/rest/api/azure/devops/release/definitions?view=azure-devops-rest-7.1
- Azure CLI azure-devops extension: https://learn.microsoft.com/en-us/cli/azure/pipelines/variable-group?view=azure-cli-latest

Community walkthrough (non-Microsoft, illustrative example only - not used as the basis for any can/cannot claim): Gabriel Okom, "Migrating Azure DevOps classic release pipelines to multi-stage YAML" - https://ougabriel.medium.com/migrating-azure-devops-classic-release-pipelines-to-multi-stage-yaml-f990b62b6aae
