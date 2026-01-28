---
name: yo
description: Search and recall project memories from Yolog. Use "/yo recall <query>" to search for memories about a topic, or "/yo context" to get project overview with decisions, patterns, and architecture.
---

# Yolog Memory Recall

Search project memories stored by the Yolog desktop app.

## Configuration

Set your MCP CLI path below (copy from Yolog Settings > Memory & Skills):

```
MCP_CLI_PATH=/path/to/yolog-mcp-server
```

## Commands

| Command | Description |
|---------|-------------|
| `/yo recall <query>` | Search memories by keyword or topic. See [RECALL.md](RECALL.md) |
| `/yo context` | Get project overview at session start. See [CONTEXT.md](CONTEXT.md) |

## Instructions

Parse `$ARGUMENTS` to determine the command:

- **If arguments start with `recall`**: Follow instructions in [RECALL.md](RECALL.md)
- **If arguments equal `context`**: Follow instructions in [CONTEXT.md](CONTEXT.md)
- **If arguments empty or invalid**: Show usage help

## Usage Help

```
Yolog Memory Commands:
  /yo recall <query>  - Search memories by keyword or topic
  /yo context         - Get project overview
```
