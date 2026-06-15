# ARM to Bicep Conversion

## What Is Available

This folder provides a repeatable ARM JSON to Bicep migration workflow with sample input, converted output, and a PowerShell validation script.

This folder is custom packaging created for this catalog. It is based on existing Microsoft Learn guidance for `az bicep decompile`, VS Code Bicep decompile support, Bicep build, and deployment what-if.

## Microsoft Tools and Procedures

- `az bicep decompile --file main.json` converts ARM JSON to Bicep.
- VS Code Bicep extension supports Decompile into Bicep and Paste JSON as Bicep.
- Decompilation is not guaranteed to produce production-ready Bicep. Microsoft Learn recommends fixing warnings/errors and improving generated names.
- `az bicep build --file main.bicep` validates that Bicep compiles back to ARM JSON.
- `az deployment group what-if` or the correct deployment scope previews behavior.

## Custom Assets Created Here

- `.github/skills/arm-to-bicep-conversion/SKILL.md`: custom Copilot skill for ARM-to-Bicep conversion cleanup and validation.
- `.github/agents/bicep-modernization.agent.md`: shared custom specialist agent for Bicep modernization.
- `samples/main.json`: custom ARM template sample.
- `samples/converted.main.bicep`: custom cleaned Bicep example.
- `samples/decompile-and-validate.ps1`: custom helper script for decompile, build, and optional what-if.

## Copilot / Agent Assets

- Skill: `.github/skills/arm-to-bicep-conversion/SKILL.md`
- Agent: `.github/agents/bicep-modernization.agent.md`

## Procedure

1. Save the ARM template as `main.json`.
2. Run `az bicep decompile --file main.json`.
3. Rename generated symbols and variables.
4. Replace ARM-style string functions with Bicep interpolation and symbolic references.
5. Build the result with `az bicep build`.
6. Run a what-if deployment before any real deployment.
