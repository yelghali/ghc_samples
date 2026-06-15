---
name: azure-devops-classic-to-yaml
description: "Use when migrating Azure DevOps Classic build or release pipelines to YAML, reviewing exported YAML, mapping tasks, variables, schedules, service connections, approvals, and templates."
argument-hint: "Classic pipeline export, task list, or pipeline migration goal"
---

# Azure DevOps Classic to YAML

## When to Use

Use this skill for Azure DevOps Classic build pipeline migration, Classic release migration planning, exported YAML cleanup, generated `1ESPTMigration` output review, Azure Pipelines schema validation, and YAML template extraction.

## Procedure

1. Read the use-case guide in `../../../azure-devops-classic-to-yaml/README.md`.
2. If the source is a Classic build pipeline, export YAML from the pipeline definition view when available.
3. If the source is a Classic release pipeline, inventory each stage/task manually; direct release export to YAML is not supported.
4. Review exported warnings for secrets, missing triggers, run numbers, OAuth token access, and variables.
5. Convert the output into maintainable `stages`, `jobs`, `deployment` jobs, `resources`, and `templates`.
6. Validate with Azure DevOps YAML editor Validate and Download full YAML.

## Bundled Samples

- `../../../azure-devops-classic-to-yaml/samples/azure-pipelines.converted.yml`
- `../../../azure-devops-classic-to-yaml/samples/migration-inventory.template.json`
- `../../../azure-devops-classic-to-yaml/samples/classic-to-yaml-review-checklist.md`
