# GitHub Copilot Azure Modernization Samples

This workspace contains reusable GitHub Copilot / Claude-style customizations for Azure DevOps and Azure infrastructure modernization work. Each use case has its own folder with a README, recommended Microsoft tools, and sample code or configuration.

The catalog combines two things:

- Existing Microsoft resources I found in Microsoft Learn, GitHub Docs, VS Code docs, and Microsoft/Azure GitHub repositories.
- Custom reusable skills, agents, READMEs, checklists, and sample code/configuration created in this workspace to package those resources for repeatable Copilot-assisted workflows.

## Use Cases

| Use case | Folder | Customization |
| --- | --- | --- |
| Azure DevOps Classic to YAML pipelines | `azure-devops-classic-to-yaml/` | `.github/skills/azure-devops-classic-to-yaml/`, `.github/agents/azure-devops-migration.agent.md` |
| ARM template to Bicep conversion | `arm-to-bicep-conversion/` | `.github/skills/arm-to-bicep-conversion/`, `.github/agents/bicep-modernization.agent.md` |
| Transform Bicep scripts into modules | `bicep-to-modules/` | `.github/skills/bicep-to-modules/`, `.github/agents/bicep-modernization.agent.md` |
| Secure Bicep infrastructure as code | `secure-bicep-iac/` | `.github/skills/secure-bicep-iac/`, `.github/agents/bicep-modernization.agent.md` |
| FinOps on Azure | `finops-azure/` | `.github/skills/finops-azure/`, `.github/agents/azure-finops.agent.md` |

## Source Anchors

- GitHub Copilot repository custom instructions, path-specific instructions, prompt files, skills, custom agents, `AGENTS.md`, and `CLAUDE.md`.
- VS Code agent customization docs for instructions, prompt files, agent skills, custom agents, MCP servers, and hooks.
- Microsoft Learn for Azure DevOps Classic to YAML migration, YAML schema, YAML editor validation, task assistant, and downloaded full YAML.
- Microsoft Learn for Bicep decompile, modules, and best practices.
- Azure Verified Modules in `Azure/bicep-registry-modules` for standard reusable Bicep modules.
- `Azure/AZVerify` for Azure Copilot skill patterns around diagram, Azure, Bicep, what-if, and policy workflows.
- `microsoft/finops-toolkit` for FinOps Toolkit, PowerShell automation, Bicep modules, agent skills, and Claude plugin patterns.
- Microsoft repository examples referencing `https://aka.ms/1ESPTMigration` output comments for internal Classic build-to-YAML migration output.

## Existing Resources vs Custom Assets

Existing resources found:

- GitHub Docs and VS Code docs for Copilot custom instructions, prompt files, skills, custom agents, `AGENTS.md`, and `CLAUDE.md` support.
- Microsoft Learn guidance for Azure DevOps Classic-to-YAML migration, Azure Pipelines YAML schema, YAML editor validation, and Download full YAML.
- Microsoft Learn guidance for `az bicep decompile`, Bicep modules, Bicep best practices, and deployment what-if validation.
- Azure Verified Modules and the `Azure/bicep-registry-modules` repository for Microsoft-standard Bicep modules.
- `Azure/AZVerify` as an example of Azure-focused Copilot skills for Azure-to-Bicep, diagram, what-if, and policy workflows.
- `microsoft/finops-toolkit` for FinOps Toolkit tools, PowerShell commands, Bicep modules, agent skills, and Claude plugin patterns.
- Microsoft public repository examples of Classic pipeline conversion comments generated with `https://aka.ms/1ESPTMigration`.

Custom assets created here:

- Workspace instructions: `.github/copilot-instructions.md`, `AGENTS.md`, and `CLAUDE.md`.
- Custom agents: `.github/agents/azure-devops-migration.agent.md`, `.github/agents/bicep-modernization.agent.md`, and `.github/agents/azure-finops.agent.md`.
- Custom skills: `.github/skills/azure-devops-classic-to-yaml/`, `.github/skills/arm-to-bicep-conversion/`, `.github/skills/bicep-to-modules/`, `.github/skills/secure-bicep-iac/`, and `.github/skills/finops-azure/`.
- Use-case READMEs and samples under each top-level use-case folder.

## How to Reuse

Copy the relevant `.github/skills/<name>/SKILL.md` and `.github/agents/*.agent.md` files into a target repo. Keep the matching use-case folder if you want the sample templates and READMEs available as local context.

If you use Claude Code or another agent that reads `AGENTS.md` / `CLAUDE.md`, copy the relevant sections from this workspace into that file. GitHub Copilot can also use `AGENTS.md` and root `CLAUDE.md` files where supported.

See `USAGE.md` for central demo prompts, sample commands, and suggested flows for showing the agents and skills.

## MCP Status

MCP is not allowed for this catalog. Do not depend on Azure MCP, Microsoft Docs MCP, Draw.io MCP, or other MCP servers when running these samples.

Use these workarounds instead:

- Azure CLI for Azure account context, resource discovery, Bicep build, deployment what-if, and read-only inventory.
- Azure PowerShell or Azure SDKs for scripted discovery when CLI output is not enough.
- Microsoft Learn and GitHub docs opened directly in a browser or cited as static links in documentation.
- Exported Azure DevOps YAML, screenshots, task lists, and inventory JSON when there is no live Azure DevOps environment.
- Terraform CLI for Terraform-only validation if a target repo uses Terraform, but this catalog's IaC samples are Bicep-first.

See `practical-examples/` for CLI and SDK examples that do not require MCP.
