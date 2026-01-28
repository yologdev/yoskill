# Contributing to Yolog Skills

Thanks for your interest in contributing to Yolog Skills!

## Adding a New Skill

1. Create a folder under `skills/` with your skill name
2. Add a `SKILL.md` file following the [Claude Code Skills format](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/skills)
3. Update `.claude-plugin/marketplace.json` to include your skill
4. Submit a pull request

### SKILL.md Requirements

```yaml
---
name: your-skill-name
description: Brief description of what the skill does and when to use it.
---

# Skill Title

Instructions for Claude...
```

## Guidelines

- Keep skills focused and single-purpose
- Test your skill before submitting
- Document any prerequisites or configuration needed
- Follow existing code style

## Reporting Issues

Open an issue on GitHub with:
- What you expected to happen
- What actually happened
- Steps to reproduce
- Your Yolog Desktop version

## Questions?

Open a discussion on GitHub or reach out at [yolog.dev](https://yolog.dev).
