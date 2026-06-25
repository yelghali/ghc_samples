# Classic to YAML Review Checklist

## Source and Export
- [ ] Source type identified: Classic **build** (exportable) vs Classic **release** (not exportable).
- [ ] Exported YAML came from the pipeline definition view, not a specific run.
- [ ] Classic release pipeline tasks were inventoried manually; release JSON snapshot captured as the reference oracle.

## Structure and Tasks
- [ ] Stages, agent phases, agentless phases (`pool: server`), and deployment phases mapped to the correct YAML constructs.
- [ ] Deployment phases use `jobs.deployment` with an `environment` and a `strategy` (`runOnce`/`rolling`/`canary`).
- [ ] Task names and major versions match the inventory exactly (no Task Assistant version drift).
- [ ] `matrix` used only on `jobs.job`, never on a deployment job.

## Variables, Secrets, and Connections
- [ ] Variables reviewed and secrets moved to variable groups, Key Vault, or secret variables.
- [ ] Variable-group secrets passed into steps via explicit `env:` blocks.
- [ ] Service connections are named but credentials are not embedded.
- [ ] Variable groups and service connections re-authorized for the new pipeline.

## Triggers, Schedules, Artifacts
- [ ] CI, PR, and schedule triggers match the Classic behavior.
- [ ] Cron schedules account for YAML UTC behavior.
- [ ] Agent pools and demands are represented.
- [ ] Artifacts are published and downloaded with pipeline artifact tasks or resources.

## Approvals, Environments, Cutover
- [ ] Approvals, gates, and checks are configured through environments/checks (not YAML).
- [ ] Deployment groups modeled as `environment` resources of type `virtualMachine` where applicable.
- [ ] OAuth token access is intentionally enabled only for steps that require it.
- [ ] Side-by-side parity tested before cutover; classic release abandoned as draft (not deleted) after cutover.

## Validation
- [ ] YAML editor Validate succeeds.
- [ ] Download full YAML was reviewed when templates are used.
