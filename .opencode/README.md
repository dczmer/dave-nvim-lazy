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

## Build & Development Commands

- **Flake validation**: `nix flake check`
- **Enter dev environment**: `nix develop`
- **Run Neovim**: `nvim` (from within nix develop)
- **Update dependencies**: `nix flake update`
- **Format Nix files**: `nixfmt-rfc-style flake.nix`
- **Format Lua files**: `stylua config/lua/`

## Architecture Overview

This is a Nix flake-based Neovim configuration using the `wrapNeovim` pattern for reproducible builds.

### Three-Tier Plugin Loading
- **Startup plugins**: 12 plugins always loaded
- **Lazy-loaded plugins**: 36 plugins loaded on-demand
- **Total**: 48 plugins (75% lazy-loaded for performance)

### Plugin Module Pattern
Each plugin in `config/lua/dave-vim/plugins/` exports a `lazy()` function:

```lua
local setup = function() ... end
local keys = { ... }
local lazy = function()
    return {
        "plugin-name",
        after = setup,
        keys = keys,
        ft = "filetype",  -- or event, cmd, etc.
    }
end
return { lazy = lazy }
```

Then referenced in `lz-n.lua` as: `require("dave-vim.plugins.plugin-name").lazy()`

### Load Sequence (config/lua/init.lua)
1. **Core settings**: Load `dave-vim.settings`, `dave-vim.maps`, `dave-vim.commands`
2. **Non-lazy plugins**: Load startup plugins (always available)
3. **Lazy loader**: Initialize lz.n with plugin registry from `dave-vim.lz-n`
4. **Local overrides**: Source `~/.config/nvim/init.lua` if present

### LSP Loading
LSPs are filetype-triggered via lz.n spec. Example: Opening a Python file triggers pyright to load.

## Nix-Specific Patterns

### Package Split
- **`start` packages**: Always loaded at startup (in `extraPlugins`)
- **`opt` packages**: Lazy-loadable (in `extraOptionalPlugins`)

### Tool Management
- **Core tools**: Lua, Nix, Shell LSPs defined in flake.nix
- **Project-specific tools**: Installed in project dev shells
- **Runtime dependencies**: Tools in `runtimeInputs` available to Neovim via PATH

### Project Workflow
1. User runs `nix develop` in their project directory
2. Project-specific LSPs become available in PATH
3. Launch nvim
4. LSP configs detect and use project tools

## LSP Integration

### Core LSPs (Always Available)
- **Lua**: lua-language-server
- **Nix**: nixd
- **Shell**: shellcheck

### Project-Specific LSPs
Installed in project dev shells, Neovim finds them via PATH.

### LSP Configuration
Configs are minimal, just `vim.lsp.enable("lsp-name")`. Lazy-loaded by filetype via lz.n spec in files like `config/lua/dave-vim/plugins/lsp/pyright.lua`.

## Important File Locations

- **Configuration root**: `config/lua/`
- **Entry point**: `config/lua/init.lua`
- **Plugin configs**: `config/lua/dave-vim/plugins/`
- **LSP configs**: `config/lua/dave-vim/plugins/lsp/`
- **Lazy loader registry**: `config/lua/dave-vim/lz-n.lua`
- **Core settings**: `config/lua/dave-vim/{settings,maps,commands}.lua`
- **Nix derivation**: `config/default.nix`
- **Package definitions**: `flake.nix`

## Key Architectural Decisions

- **Reproducibility**: Nix flakes with pinned dependencies
- **Performance**: Lazy-loading 75% of plugins (36/48)
- **Modularity**: Plugin module pattern reduces nesting, improves readability
- **Project-scoped dependencies**: Not all languages in base config
- **Local override support**: Via `~/.config/nvim/init.lua`

## Documentation Standards

Based on `.opencode/rules/`:

- Use modern Lua APIs (`vim.*` over deprecated calls)
- Follow plugin module pattern consistently
- 4-space indentation for Lua, 2-space for Nix
- Format with stylua (Lua) and nixfmt-rfc-style (Nix)
- Keep plugin configs in separate module files

## Central Registry: lz-n.lua

The file `config/lua/dave-vim/lz-n.lua` coordinates all lazy-loaded plugins. It imports each plugin module and registers them with the lz.n lazy loader. This is the single source of truth for which plugins are lazy-loaded and their trigger conditions.

## Critical Files for Understanding

- `flake.nix` - Package definitions (plugins, tools, dependencies)
- `config/lua/init.lua` - Load sequence and initialization
- `config/lua/dave-vim/lz-n.lua` - Plugin registry for lazy loading
- `.opencode/rules/neovim.md` - Neovim coding standards
- `.opencode/rules/nix.md` - Nix coding standards
- `config/default.nix` - Nix derivation wrapping Neovim with config
