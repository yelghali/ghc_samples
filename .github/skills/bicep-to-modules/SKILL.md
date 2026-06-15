---
name: bicep-to-modules
description: "Use when transforming flat Bicep files or deployment scripts into reusable Bicep modules with parameters, outputs, scopes, bicepparam files, and Azure Verified Module references."
argument-hint: "Bicep file, resource group, or module extraction goal"
---

# Bicep to Modules

## When to Use

Use this skill to split Bicep into modules, design module contracts, add `.bicepparam` files, publish to a private registry, or replace custom code with Azure Verified Modules.

## Procedure

1. Read `../../../bicep-to-modules/README.md`.
2. Identify resource groups by lifecycle, owner, deployment scope, and reuse boundary.
3. Extract module parameters for environment-specific values only.
4. Keep security defaults inside the module unless callers must intentionally choose.
5. Return outputs only for non-secret integration values.
6. Validate root and module files with `az bicep build` and deployment `what-if`.

## Bundled Samples

- `../../../bicep-to-modules/samples/main.bicep`
- `../../../bicep-to-modules/samples/modules/storage-account/main.bicep`
- `../../../bicep-to-modules/samples/modules/storage-account/main.bicepparam`
