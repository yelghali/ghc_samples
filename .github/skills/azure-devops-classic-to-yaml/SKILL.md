---
name: azure-devops-classic-to-yaml
description: "Use when migrating Azure DevOps Classic build or release pipelines to YAML, reviewing exported YAML, mapping tasks, variables, schedules, service connections, approvals, environments, and templates."
argument-hint: "Classic pipeline export, task list, or pipeline migration goal"
---

# Azure DevOps Classic to YAML

## When to Use

Use this skill for Azure DevOps Classic build pipeline migration, Classic release pipeline migration planning, exported YAML cleanup, generated `1ESPTMigration` output review, Azure Pipelines schema validation, environment/approval mapping, and YAML template extraction.

## What Can and Cannot Be Exported

State this constraint before doing any work; it is the key correctness rule.

- **Classic build pipelines** built with the classic build designer **can be exported to YAML**: open the pipeline *definition* view (not a specific run) > three-dot menu > **Export to YAML**. A `.yml` file is downloaded. If no Export to YAML/JSON option appears, that pipeline does not support exporting.
- **Classic release pipelines do not support YAML export.** There is no `Export to YAML` button on a release definition. Each release is migrated by hand, task by task, into a multi-stage YAML `deployment` job model. Microsoft Learn is explicit: "Classic release pipelines don't support YAML export, you'll need to export each task individually."
- The closest machine-readable starting point for a release is the **REST API definition JSON** (`GET https://vsrm.dev.azure.com/{org}/{project}/_apis/release/definitions/{id}?api-version=7.1`). Save it as `classic-release.snapshot.json` and use it as the reference oracle during parity testing. Do not delete the classic release after cutover; the JSON snapshot is the only record of historical approvals and gates.

## Procedure (Offline-First)

1. Read the use-case guide in `../../../azure-devops-classic-to-yaml/README.md`.
2. Identify the source type: Classic **build** or Classic **release**. The path differs.
3. **Classic build:** export YAML from the definition view, then clean the generated output (step 5).
4. **Classic release:** inventory each stage manually using `../../../azure-devops-classic-to-yaml/samples/migration-inventory.template.json`. Capture per stage: trigger condition, agent pool, ordered task list **with exact versions**, pre-deployment approvers, gates, variable scope, and artifact source.
5. Review exported/inventoried content for secrets, missing triggers, run numbers, OAuth token access, schedules, and variables.
6. Translate into maintainable structure using these mapping rules:
   - Classic stage -> `stages.stage`.
   - Classic agent phase -> `jobs.job`.
   - Classic agentless (server) phase -> `jobs.job` with `pool: server`.
   - Classic deployment phase -> `jobs.deployment` with an `environment` and a `strategy` (`runOnce`, `rolling`, or `canary`). `matrix` is only valid on `jobs.job.strategy`, never on `jobs.deployment`.
   - Classic task -> `steps.task` with the **identical task name and major version** (version drift is the most common silent regression).
   - Classic pre-deployment approvals/gates -> Azure DevOps **environment checks** (Approval, Branch control, Business hours, Invoke Azure Function, Invoke REST API, Required template, Exclusive lock). These live on the environment, not in the YAML file.
   - Classic deployment groups -> `environment` resources of type `virtualMachine`.
7. Reuse, do not migrate, shared objects: variable groups (`variables: - group: <name>`), service connections, and secure files are referenced as-is. Secrets from a variable group are **not** auto-mapped into `$env:`/`${{ }}`; pass them explicitly through a step `env:` block.
8. Add review notes for anything that cannot be verified offline (service connection names, approver identities, pool names).
9. Recommend side-by-side parity testing: keep the classic release shipping while the YAML version shadows it through non-production stages; cut over per environment; archive the classic release with **Save as draft > Abandon** (do not delete).

## Validation

- Azure DevOps YAML editor: IntelliSense, Task Assistant, **Validate**, and **Download full YAML** (especially when templates are used).
- Confirm cron schedules: YAML `schedules.cron` runs in **UTC** by default; Classic used the organization's local time zone.
- Re-authorize each variable group and service connection on the first YAML run (the "needs permission to access a resource" banner).

## Optional: Azure CLI Inventory (Requires Explicit User Approval)

This path needs **live Azure DevOps access and credentials**, so treat it as opt-in. Before running anything, confirm the user approves connecting to their organization. If they decline, stay on the offline template workflow above.

- Prerequisite: `az extension add --name azure-devops`, then `az devops login` (PAT) or `az login`.
- Sample script: `../../../azure-devops-classic-to-yaml/samples/classic-release-inventory.ps1` (optional, approval-gated).
- **Safety (inspected):** the script is **read-only** (only `list`/`GET` calls), prompts for an explicit `yes` before connecting, and writes JSON to a local folder. Secret variable values and service-connection credentials are **never returned** by these APIs, so the snapshots do not contain secrets. The script does not create, update, or delete any pipeline, variable group, or service connection.
- Commands used (all GA in the `azure-devops` extension): `az pipelines variable-group list`, `az devops service-endpoint list`, and `az rest` against the release-definitions REST endpoint.
- MCP is not allowed in this workspace. Use Azure CLI, REST APIs, and exported files only.

## Bundled Samples

- `../../../azure-devops-classic-to-yaml/samples/azure-pipelines.converted.yml`
- `../../../azure-devops-classic-to-yaml/samples/migration-inventory.template.json`
- `../../../azure-devops-classic-to-yaml/samples/classic-to-yaml-review-checklist.md`
- `../../../azure-devops-classic-to-yaml/samples/classic-release-inventory.ps1` (optional, requires approval)

## Sources

Every "can / cannot do" claim above is backed by official Microsoft Learn documentation:

- Export reality (build exportable, release not exportable; definition view; UTC schedules): https://learn.microsoft.com/en-us/azure/devops/pipelines/release/from-classic-pipelines?view=azure-devops
- Deployment jobs and `runOnce`/`rolling`/`canary` strategies (rolling supports VM resources): https://learn.microsoft.com/en-us/azure/devops/pipelines/process/deployment-jobs?view=azure-devops
- Jobs, server/agentless jobs (`pool: server`), `matrix` as a job strategy, OAuth token mapped via `env`: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops
- Approvals and checks live on the resource/environment, not in YAML (Approval, Branch control, Business hours, Invoke Azure Function, Invoke REST API, Required template, Exclusive lock): https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops
- Environments and `virtualMachine` resources: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments-virtual-machines?view=azure-devops
- Variable groups (referenced via `variables: - group:`; secrets not auto-mapped): https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops
- Release definitions REST API (release JSON snapshot): https://learn.microsoft.com/en-us/rest/api/azure/devops/release/definitions?view=azure-devops-rest-7.1
- Azure CLI azure-devops extension (`az pipelines variable-group`, `az devops service-endpoint`): https://learn.microsoft.com/en-us/cli/azure/pipelines/variable-group?view=azure-cli-latest

Non-Microsoft community walkthrough (illustrative example only; do not treat as authoritative): Gabriel Okom, "Migrating Azure DevOps classic release pipelines to multi-stage YAML" - https://ougabriel.medium.com/migrating-azure-devops-classic-release-pipelines-to-multi-stage-yaml-f990b62b6aae
