# Classic to YAML Review Checklist

- [ ] Exported YAML came from the pipeline definition view, not a specific run.
- [ ] Classic release pipeline tasks were inventoried manually if direct export was unavailable.
- [ ] Variables were reviewed and secrets moved to variable groups, Key Vault, or secret variables.
- [ ] Service connections are named but credentials are not embedded.
- [ ] CI, PR, and schedule triggers match the Classic behavior.
- [ ] Cron schedules account for YAML UTC behavior.
- [ ] Agent pools and demands are represented.
- [ ] Artifacts are published and downloaded with pipeline artifact tasks or resources.
- [ ] Approvals, gates, and checks are configured through environments/checks.
- [ ] OAuth token access is intentionally enabled only for steps that require it.
- [ ] YAML editor Validate succeeds.
- [ ] Download full YAML was reviewed when templates are used.
