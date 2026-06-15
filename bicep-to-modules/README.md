# Transform Bicep Code into Modules

## What Is Available

This folder shows how to move from a flat Bicep deployment to a module-oriented layout with a root deployment file, module folder, and `.bicepparam` sample.

This folder is custom packaging created for this catalog. It is based on existing Microsoft Learn Bicep module guidance and Azure Verified Modules patterns.

## Microsoft Tools and Procedures

- Bicep modules use `module <symbolicName> '<path>' = { params: {} }`.
- Module paths use `/` separators, including on Windows.
- Modules can target local files, public registry modules, private registry modules, or template specs.
- Azure Verified Modules are the Microsoft standard for public Bicep Registry modules.
- Modules deploy in parallel unless dependencies are implied or declared.

## Custom Assets Created Here

- `.github/skills/bicep-to-modules/SKILL.md`: custom Copilot skill for module extraction and module contract design.
- `.github/agents/bicep-modernization.agent.md`: shared custom specialist agent for Bicep modernization.
- `samples/main.bicep`: custom root deployment sample.
- `samples/modules/storage-account/main.bicep`: custom reusable module sample.
- `samples/modules/storage-account/main.bicepparam`: custom parameter file sample.

## Copilot / Agent Assets

- Skill: `.github/skills/bicep-to-modules/SKILL.md`
- Agent: `.github/agents/bicep-modernization.agent.md`

## Refactor Heuristics

- Split by ownership and lifecycle: network, identity, data, app, observability.
- Keep reusable security posture inside modules.
- Parameterize environment-specific values, not every resource property.
- Return only non-secret outputs needed by callers.
- Use Azure Verified Modules before writing a custom module for common resources.
