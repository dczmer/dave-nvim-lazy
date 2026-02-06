# AGENTS.md

Context for AI coding agents working in this Neovim configuration repository.
Also read `.opencode/rules/*.md` for detailed Neovim, Nix, Git, and documentation standards.

## Project Overview

Nix flake-based Neovim configuration using `wrapNeovim` for reproducible builds.
48 plugins total (12 startup, 36 lazy-loaded via lz.n). Leader key is `,`.

### Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Package definitions, plugins, runtime tools |
| `config/default.nix` | Nix derivation wrapping Neovim with config |
| `config/lua/init.lua` | Entry point, load order orchestrator |
| `config/lua/dave-vim/settings.lua` | `vim.opt` settings |
| `config/lua/dave-vim/maps.lua` | Core keymaps and LSP on-attach bindings |
| `config/lua/dave-vim/commands.lua` | Autocommands (filetype indentation, LSP root markers) |
| `config/lua/dave-vim/lz-n.lua` | Central lazy-loader registry (all plugin specs) |
| `config/lua/dave-vim/plugins/` | One file per plugin |
| `config/lua/dave-vim/plugins/lsp/` | One file per language server |

## Build / Lint / Test Commands

There is no test framework. All build operations use Nix.

```bash
# Build and run Neovim with this config
nix run .#

# Validate the flake definition
nix flake check

# Enter dev environment (provides LSPs, linters, formatters)
nix develop

# Update pinned dependencies
nix flake update

# Format Lua files
stylua config/lua/

# Format Nix files
nixfmt-rfc-style flake.nix
```

Tools available in the Nix environment: `nixd`, `lua-language-server`, `luacheck`,
`shellcheck`, `stylua`, `nixfmt-rfc-style`, `yamlfix`, `yamllint`, `universal-ctags`,
`pandoc`, `ripgrep`, `fd`, `fzf`, `gcc`.

## Code Style

### Lua

- **Indentation**: 4 spaces (enforced by stylua and `settings.lua`)
- **Strings**: Double quotes (`"..."`)
- **Trailing commas**: Use them on the last element of multi-line tables
- **Line length**: No hard limit; keep readable (~120 chars)
- **Comments**: Single-line `--` only. Explain "why", not "what"
- **Section headers**: Use `-- ===` or `-- ---` separators for major sections
- **Globals**: Avoid. Use `local` for everything

### Nix

- **Indentation**: 2 spaces
- **Formatter**: `nixfmt-rfc-style`
- **Flakes only**: No `<nixpkgs>`, no `NIX_PATH`, no impure operations

### Filetype-Specific Indentation (set in commands.lua)

- 2 spaces: `.nix`, `.css`, `.html`, `.js`, `.ts`, `.jsx`, `.tsx`
- 4 spaces: everything else

## Naming Conventions

- **File names**: `kebab-case.lua` (e.g., `neo-tree.lua`, `cmp-nvim.lua`)
- **Variables**: `snake_case` (e.g., `lsp_capabilities`, `file_set`)
- **Functions**: `snake_case` (e.g., `set_hl_for_float`, `format_selections_for_opencode`)
- **No camelCase** in user-authored code

## Import / Require Patterns

Requires use dot-path notation matching the directory structure:

```lua
require("dave-vim.settings")
require("dave-vim.plugins.telescope")
require("dave-vim.plugins.lsp.lua-ls")
```

Top-level library requires go at the top of the file:

```lua
local cmp = require("cmp")
local luasnip = require("luasnip")
```

Deferred requires go inside `setup` functions (for lazy-loaded plugins):

```lua
local setup = function()
    require("neo-tree").setup(opts)
end
```

## Plugin Module Pattern

Every lazy-loaded plugin gets its own file in `config/lua/dave-vim/plugins/`.
Each module exports a `lazy()` function returning an lz.n spec:

```lua
local setup = function()
    require("plugin-name").setup({ ... })
end

local keys = {
    { "<leader>xx", some_function, desc = "Description for which-key" },
}

local lazy = function()
    return {
        "plugin-name",
        after = setup,
        keys = keys,
    }
end

return { lazy = lazy }
```

Then registered in `lz-n.lua`:

```lua
require("dave-vim.plugins.plugin-name").lazy(),
```

### lz.n Spec Fields

- `after` — function to run after loading (equivalent to lazy.nvim's `config`)
- `before` — function to run before loading
- `keys` — keybinding triggers for lazy-loading
- `cmd` — command triggers
- `ft` — filetype triggers
- `event` — event triggers
- `lazy = false` — disable lazy-loading (use sparingly)

### Non-Lazy Modules

Files like `settings.lua`, `maps.lua`, `commands.lua`, and `nvim-treesitter.lua`
are side-effect-only (they execute immediately and return nothing).

## LSP Configuration

Uses the modern `vim.lsp.config()` + `vim.lsp.enable()` API (not the older lspconfig
setup pattern). Each LSP gets its own file in `plugins/lsp/`:

```lua
vim.lsp.config("server-name", {
    cmd = { "server-binary" },
    root_markers = { "marker-file" },
})
vim.lsp.enable("server-name")
```

LSPs are lazy-loaded by filetype through lz.n specs in `lz-n.lua`.

## Error Handling

- **pcall**: Use for optional dependency checks only
- **vim.notify()**: Preferred for user-facing messages (with proper severity levels)
- **vim.fn.executable()**: Use to detect tool availability before conditional loading
- **No `error()` or `assert()`**: Not used in this codebase

```lua
local ok, telescope = pcall(require, "telescope")
if not ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
end
```

## API Preferences

- Use `vim.keymap.set()` over `vim.api.nvim_set_keymap()`
- Use `vim.diagnostic.*` for diagnostics
- Use `vim.lsp.*` for LSP operations
- Use `vim.api.nvim_create_autocmd()` with descriptive `desc` fields
- Minimize `vim.cmd()` — only for vimscript with no clean Lua equivalent
- Alias `vim.opt` as `local o = vim.opt` for brevity in settings

## Type Annotations

Not currently used. No LuaLS/EmmyLua annotations in the codebase.

## Conditional Loading

`lz-n.lua` detects available tools at the top level and loads alternatives:
- `claude` CLI present → loads `claudecode-nvim`; `opencode` CLI → loads `opencode-nvim`
- `deno` available → loads `denols`; otherwise → loads `ts_ls`

Pattern: `vim.fn.executable("tool") == 1`

## Git Conventions

- Do NOT add "co-author" statements to commit messages
- Format Lua with `stylua` and Nix with `nixfmt-rfc-style` before committing
- Format-on-save is enabled via conform.nvim (500ms timeout, LSP fallback)

## Documentation

- Place docs in `docs/`, follow existing conventions
- Include keybindings, examples, and common use cases
- Snippets live in `config/lua/snippets/` (SnipMate format)
