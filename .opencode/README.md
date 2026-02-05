# OpenCode Project Configuration

This directory contains project-specific OpenCode configuration and guidelines.

## Directory Structure

```
.opencode/
├── rules/          # Coding standards and guidelines (auto-loaded by OpenCode)
├── agents/         # Custom project-specific agents (optional)
├── commands/       # Custom slash commands (optional)
└── README.md       # This file
```

## Rules Directory

Files in `rules/` are automatically loaded into OpenCode's context via the `instructions` configuration in `config/lua/dave-vim/plugins/opencode.lua`.

**Current rules**:
- `neovim.md` - Neovim and Lua coding standards
- `nix.md` - Nix and NixOS configuration best practices

When you ask OpenCode for help, it will automatically follow these guidelines without you needing to repeat them.

## Usage

### Adding New Rules

Create a new markdown file in `rules/`:

```bash
nvim .opencode/rules/my-standards.md
```

OpenCode will automatically load it (pattern: `.opencode/rules/*.md`).

### Custom Agents (Optional)

You can create project-specific agents in `agents/`. See OpenCode documentation for agent file format.

### Custom Commands (Optional)

You can create custom slash commands in `commands/`. See OpenCode documentation for command file format.

## Global vs Project Configuration

- **Global config**: `~/.config/opencode/opencode.json` - User preferences
- **Project config**: `opencode.json` in project root - Project settings
- **This directory**: `.opencode/` - Rules, agents, commands specific to this project

This project uses Lua configuration in `config/lua/dave-vim/plugins/opencode.lua` for Neovim integration, but also supports standard OpenCode project configuration patterns.
