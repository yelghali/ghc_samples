# Azure DevOps Classic to YAML Pipelines

## What Is Available

This folder provides a reusable migration workflow for Azure DevOps Classic pipelines. It supports two paths:

- Classic build pipelines: export YAML from the pipeline definition view when the option is available.
- Classic release pipelines: inventory and migrate tasks manually because direct YAML export is not supported.

This folder is custom packaging created for this catalog. It is based on existing Microsoft Learn Azure DevOps migration and YAML editor procedures, plus public Microsoft repository examples that show generated Classic-to-YAML migration comments.

## Microsoft Tools and Procedures

- Azure DevOps Classic build pipeline export: pipeline definition view > more menu > Export to YAML.
- Azure DevOps YAML editor: IntelliSense, task assistant, Validate, and Download full YAML.
- Azure Pipelines YAML schema reference for `trigger`, `resources`, `stages`, `jobs`, `deployment`, `variables`, `schedules`, and templates.
- Internal Microsoft examples show generated migration comments from `https://aka.ms/1ESPTMigration`, including warnings for secrets, missing triggers, run names, and OAuth token access. Treat those comments as review inputs.

## Custom Assets Created Here

- `.github/skills/azure-devops-classic-to-yaml/SKILL.md`: custom Copilot skill for repeatable migration review.
- `.github/agents/azure-devops-migration.agent.md`: custom specialist agent instructions.
- `samples/azure-pipelines.converted.yml`: custom starter YAML draft.
- `samples/migration-inventory.template.json`: custom offline inventory template.
- `samples/classic-to-yaml-review-checklist.md`: custom review checklist.

## Copilot / Agent Assets

- Skill: `.github/skills/azure-devops-classic-to-yaml/SKILL.md`
- Agent: `.github/agents/azure-devops-migration.agent.md`

## Offline Workflow Without Azure DevOps Access

1. Ask the pipeline owner for exported YAML, task screenshots, variable groups, service connection names, schedules, retention settings, environments, approvals, and artifact definitions.
2. Fill out `samples/migration-inventory.template.json`.
3. Draft YAML using `samples/azure-pipelines.converted.yml` as a starting structure.
4. Review with `samples/classic-to-yaml-review-checklist.md`.
5. When an Azure DevOps environment is available, validate in the YAML editor before running.

## Migration Risks to Review

- Secret variables copied into YAML instead of variable groups or Key Vault.
- Classic UI schedules using local organization time while YAML schedules use UTC by default.
- Deployment approvals and gates not represented in YAML unless environments/checks are configured.
- Service connection permissions and pipeline authorization missing after migration.
- Build artifacts and release artifacts mapped incorrectly.
