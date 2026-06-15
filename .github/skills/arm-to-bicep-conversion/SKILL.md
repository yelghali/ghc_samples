---
name: arm-to-bicep-conversion
description: "Use when converting ARM JSON templates to Bicep with az bicep decompile, cleaning generated Bicep, building, what-if validation, and migration review."
argument-hint: "Path to ARM JSON template or conversion goal"
---

# ARM to Bicep Conversion

## When to Use

Use this skill for ARM template decompile, JSON-to-Bicep cleanup, symbolic-name review, Bicep build fixes, side-by-side behavior checks, and migration notes.

## Procedure

1. Read `../../../arm-to-bicep-conversion/README.md`.
2. Run or recommend `az bicep decompile --file main.json`.
3. Rename generated symbols, variables, and parameters for readability.
4. Replace manual `resourceId()` and `reference()` patterns with symbolic references where possible.
5. Build with `az bicep build --file main.bicep`.
6. Preview with `az deployment group what-if` or the correct deployment scope.

## Bundled Samples

- `../../../arm-to-bicep-conversion/samples/main.json`
- `../../../arm-to-bicep-conversion/samples/converted.main.bicep`
- `../../../arm-to-bicep-conversion/samples/decompile-and-validate.ps1`
