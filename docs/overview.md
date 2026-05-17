# dave-nvim-lazy: Project Overview

Comprehensive technical overview of a reproducible, lazy-loaded, AI-enhanced Neovim configuration built with Nix flakes.

## Table of Contents

- [Project Summary](#project-summary)
- [Architecture Overview](#architecture-overview)
  - [Nix Flake Architecture](#nix-flake-architecture)
  - [Plugin Management System](#plugin-management-system)
  - [Configuration Structure](#configuration-structure)
- [Core Features](#core-features)
  - [Language Server Protocol (LSP)](#language-server-protocol-lsp)
  - [Code Completion & Snippets](#code-completion--snippets)
  - [Fuzzy Finding (Telescope)](#fuzzy-finding-telescope)
  - [Debug Adapter (nvim-dap)](#debug-adapter-nvim-dap)
  - [Git Integration](#git-integration)
  - [Additional Features](#additional-features)
- [Keybinding Organization](#keybinding-organization)
  - [Hierarchy by Prefix](#hierarchy-by-prefix)
  - [Contextual Bindings](#contextual-bindings)
  - [Which-key Integration](#which-key-integration)
- [Performance & Optimization](#performance--optimization)
- [Development Workflow](#development-workflow)
  - [Nix Flake Workflow](#nix-flake-workflow)
  - [LSP Discovery Process](#lsp-discovery-process)
  - [Plugin Configuration Workflow](#plugin-configuration-workflow)
- [Extensibility](#extensibility)
  - [Adding Plugins](#adding-plugins)
  - [Adding LSPs](#adding-lsps)
  - [Custom Keybindings](#custom-keybindings)
- [Key Design Decisions](#key-design-decisions)
  - [Why Nix Flakes?](#why-nix-flakes)
  - [Why lz.n?](#why-lzn)
  - [Why Modular Plugin Pattern?](#why-modular-plugin-pattern)
- [Related Documentation](#related-documentation)
- [Summary](#summary)

## Project Summary

**dave-nvim-lazy** is a general-purpose Neovim configuration implementing modern development workflows through:

- **Reproducible deployment** via Nix flakes with pinned dependencies
- **Performance optimization** through strategic lazy-loading (75% of plugins)
- **Multi-language support** with 11 LSP servers loaded on-demand
- **AI agent integration** via tmux-agent.lua for lightweight tmux pane messaging
- **Comprehensive documentation** with 2,500+ lines across 8 reference guides

### Design Philosophy

1. **Reproducibility First**: All dependencies declared in `flake.nix`, no global state pollution
2. **Performance Conscious**: Lazy-load everything possible, minimize startup time
3. **Modular Architecture**: One file per plugin, consistent patterns across 36 configurations
4. **AI Agent Workflow**: Lightweight tmux-based agent messaging without plugin dependencies
5. **Documentation-Driven**: Comprehensive guides for every major feature

### Target Use Cases

- **System administration**: Core LSPs (Lua, Nix, Shell) always available
- **Multi-language development**: Project-specific LSPs via dev shells
- **AI-assisted coding**: Send prompts and file references to tmux agent panes
- **Reproducible environments**: Works identically across systems with Nix

---

## Architecture Overview

### Nix Flake Architecture

The project is built as a Nix flake, providing complete reproducibility and declarative configuration.

#### Flake Structure

```nix
{
  description = "Neovim with LSP and lazy-loading";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        customRC = import ./config { inherit pkgs; };
        neovimWrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            inherit customRC;
            packages.myVimPackage = with pkgs.vimPlugins; {
              start = [ /* 12 essential plugins */ ];
              opt = [ /* 36 lazy-loaded plugins */ ];
            };
          };
        };
      in {
        packages.default = writeShellApplication { /* ... */ };
        apps.default = { /* ... */ };
      }
    );
}
```

#### Flake Components Diagram

```
flake.nix
├── Inputs
│   ├── nixpkgs (package repository)
│   └── flake-utils (cross-platform support)
│
├── Outputs
│   ├── packages.default (wrapped nvim binary)
│   └── apps.default (executable entry point)
│
└── Configuration
    ├── customRC (from ./config)
    │   └── init.lua (loads dave-vim modules)
    │
    ├── Vim Packages
    │   ├── start (12 plugins - loaded at startup)
    │   │   ├── lz-n (lazy-loader)
    │   │   ├── nvim-treesitter
    │   │   ├── nvim-cmp
    │   │   ├── nvim-lspconfig
    │   │   └── ... (8 more)
    │   │
    │   └── opt (34 plugins - lazy-loaded)
    │       ├── telescope-nvim
    │       ├── neo-tree-nvim
    │       ├── nvim-dap
    │       └── ... (31 more)
    │
    └── Runtime Inputs (30+ tools)
        ├── Language Tools
        │   ├── nixd, lua-language-server
        │   ├── stylua, nixfmt
        │   └── shellcheck, yamlfix
        │
        └── Support Tools
            ├── ripgrep, fd, fzf
            ├── gcc, pandoc
            └── python3 (with pynvim)
```

#### Package Wrapping Strategy

The configuration uses `wrapNeovim` to bundle Neovim with custom configuration and plugins:

1. **Start packages**: Essential plugins loaded immediately (treesitter, cmp, lspconfig)
2. **Opt packages**: Lazy-loaded plugins triggered by events/keys/filetypes
3. **Runtime inputs**: External tools available in PATH (LSPs, formatters, linters)
4. **Custom RC**: Lua configuration from `./config` directory

#### Startup vs Lazy-Loaded Plugins

| Category | Count | Purpose | Examples |
|----------|-------|---------|----------|
| **Start** | 12 | Essential functionality, provide APIs | lz.n, treesitter, cmp, lspconfig, plenary |
| **Opt** | 34 | Feature plugins, load on demand | telescope, neo-tree, dap, gitsigns, which-key |

**Rationale**: Only load what's needed for startup. Everything else triggers on-demand via lz.n.

#### Runtime Dependencies

```nix
runtimeInputs = with pkgs; [
  # Telescope and Treesitter
  ripgrep fd fzf gcc
  
  # Core LSPs (always available)
  nixd lua-language-server shellcheck
  
  # Formatters and Linters
  stylua nixfmt-rfc-style yamlfix yamllint
  
  # Additional Tools
  universal-ctags pandoc vimwiki-markdown
  
  # Python Support
  (python3.withPackages (p: with p; [
    tasklib pynvim
  ]))
];
```

**Reproducibility Guarantees**:
- All plugin versions pinned in `flake.lock`
- All tools explicitly declared in flake
- No reliance on global packages
- Identical behavior across systems

---

### Plugin Management System

#### Why lz.n?

The project uses [lz.n](https://github.com/nvim-neorocks/lz.n) as the lazy-loader for four key reasons:

1. **Nix-friendly**: No built-in package manager (conflicts with Nix)
2. **Simple**: Minimal API surface, easy to understand
3. **Flexible**: Multiple loading triggers (filetype, keys, events, after)
4. **Performant**: Fast lazy-loading with minimal overhead

#### Plugin Module Pattern

All plugins follow a consistent modular pattern for maintainability:

```lua
-- Example: config/lua/dave-vim/plugins/telescope.lua
local builtin = require("telescope.builtin")

-- Local variables for configuration
local keys = {
    { "<leader>ff", builtin.find_files },
    { "<leader>fg", builtin.live_grep },
    { "<leader>fb", builtin.buffers },
    { "<leader>fh", builtin.help_tags },
}

-- Setup function (runs after plugin loads)
local setup = function()
    require("telescope").setup({
        -- configuration here
    })
end

-- Export lazy-loader specification
return {
    lazy = function()
        return {
            "telescope.nvim",
            after = setup,      -- Run setup after load
            keys = keys,        -- Load on these keybindings
        }
    end,
}
```

**Benefits of this pattern**:
1. **Decomposition**: Local variables reduce nesting
2. **Clarity**: Setup logic separate from loader spec
3. **Maintainability**: One file per plugin, easy to find
4. **Consistency**: Same pattern across all 38 plugins

#### Loading Triggers

| Trigger Type | Syntax | Use Case | Example Plugins |
|--------------|--------|----------|-----------------|
| **filetype** | `ft = "lua"` | Language-specific tools | LSP configs (11) |
| **keys** | `keys = { "<leader>ff" }` | Feature activation | Telescope, Neo-tree, DAP |
| **event** | `event = "BufEnter"` | Vim event hooks | Gitsigns, Lualine |
| **after** | `after = setup` | Post-load setup | Nearly all plugins |
| **cmd** | `cmd = "Tagbar"` | Ex command trigger | Tagbar, Undotree |

#### Plugin Loading Flow

```
Neovim Startup
     ↓
Load Start Plugins (12)
├── lz-n (lazy-loader core)
├── nvim-treesitter (syntax highlighting)
├── nvim-cmp (completion engine)
├── nvim-lspconfig (LSP framework)
├── plenary-nvim (Lua utilities)
├── nvim-web-devicons (icons)
├── lspkind-nvim (completion icons)
├── luasnip (snippet engine)
└── ... (4 more supporting libraries)
     ↓
Execute: config/init.lua
     ↓
Load: dave-vim modules
├── settings.lua (vim options)
├── maps.lua (core keybindings)
└── lz-n.lua (lazy-loader spec)
     ↓
Register Lazy Plugins (36)
     ↓
     ┌─────────────────┬──────────────────┬─────────────────┐
     │   Filetype      │   Keybinding     │     Event       │
     │   Trigger       │   Trigger        │    Trigger      │
     └────────┬────────┴─────────┬────────┴────────┬────────┘
              ↓                   ↓                 ↓
        Load LSPs           Load Telescope      Load Others
     (when opening        (when pressing      (on vim events)
      .lua, .nix, .py)     ,ff ,fg ,fb)       (BufEnter, etc.)
```

---

### Configuration Structure

#### Directory Layout

```
dave-nvim-lazy/
├── flake.nix (139 lines)          # Nix flake definition
├── flake.lock                      # Locked dependency versions
├── README.md                       # Project overview
│
├── config/
│   └── lua/
│       ├── snippets/               # Code snippets (SnipMate format)
│       └── dave-vim/
│           ├── lz-n.lua (175 lines)         # Lazy-loader spec
│           ├── maps.lua (37 lines)          # Core keybindings
│           ├── settings.lua                 # Vim settings
│           ├── commands.lua                 # Autocmds & commands
│           ├── toggle-transparent-bg.lua    # Background toggle
│           │
│           └── plugins/ (36 files)
│               ├── telescope.lua            # Fuzzy finding
│               ├── nvim-dap.lua             # Debug adapter
│               ├── neo-tree.lua             # File explorer
│               ├── cmp-nvim.lua             # Completion
│               ├── conform-nvim.lua         # Formatting
│               ├── nvim-lint.lua            # Linting
│               ├── gitsigns.lua             # Git integration
│               ├── which-key.lua            # Keybinding help
│               ├── ... (29 more plugins)
│               │
│               └── lsp/ (11 files)          # LSP configurations
│                   ├── lua-ls.lua           # Lua
│                   ├── nixd.lua             # Nix
│                   ├── pyright.lua          # Python
│                   ├── gopls.lua            # Go
│                   ├── ts_ls.lua            # TypeScript
│                   ├── ccls.lua             # C/C++
│                   ├── omnisharp.lua        # C#
│                   ├── cssls.lua            # CSS
│                   ├── elixir-ls.lua        # Elixir
│                   ├── metals.lua           # Scala
│                   └── denols.lua           # Deno (disabled)
│
├── docs/ (5 files, ~1800 lines)
│   ├── overview.md (this file)
│   ├── keybindings-master.md (775 lines)
│   ├── nvim-dap-reference.md (377 lines)
│   ├── telescope-reference.md (409 lines)
│   ├── nvim-cmp-reference.md (175 lines)
│   └── keybindings-core.md (193 lines)
```

#### Key Configuration Files

| File | Lines | Purpose |
|------|-------|---------|
| `flake.nix` | 139 | Nix flake definition, plugin lists, dependencies |
| `lz-n.lua` | 175 | Lazy-loader specification, plugin loading triggers |
| `maps.lua` | 37 | Core keybindings (leader keys, LSP, terminal) |
| `tmux-agent.lua` | ~80 | Tmux agent pane messaging and keybindings |
| `cmp-nvim.lua` | 102 | Completion configuration, sources, keybindings |
| `nvim-dap.lua` | 129 | Debug adapter protocol, Python debugging |
| `telescope.lua` | 20 | Fuzzy finder keybindings |
| `lsp/*.lua` | ~30 each | Individual LSP server configurations |

---

## Core Features

### Language Server Protocol (LSP)

#### Supported Languages

| Language | LSP Server | Filetypes | Module | Load Trigger |
|----------|-----------|-----------|--------|--------------|
| **Lua** | lua-language-server | lua | lua-ls.lua | `ft = "lua"` |
| **Nix** | nixd | nix | nixd.lua | `ft = "nix"` |
| **Python** | pyright | python | pyright.lua | `ft = "python"` |
| **Go** | gopls | go, gomod | gopls.lua | `ft = {"go", "gomod"}` |
| **C/C++** | ccls | c, cpp, objc, cuda | ccls.lua | `ft = {"c", "cpp", ...}` |
| **C#** | omnisharp | cs | omnisharp.lua | `ft = "cs"` |
| **TypeScript** | ts_ls | js, jsx, ts, tsx | ts_ls.lua | `ft = {"javascript", ...}` |
| **CSS** | cssls | css, scss, less | cssls.lua | `ft = {"css", "scss"}` |
| **Elixir** | elixir-ls | elixir, heex | elixir-ls.lua | `ft = {"elixir", ...}` |
| **Scala** | metals | scala | metals.lua | `ft = "scala"` |
| **Shell** | shellcheck | sh, bash | (linting only) | - |

**Core LSPs** (always available): Lua, Nix, Shell (shellcheck)
**Project LSPs** (via dev shells): All others - installed per-project

#### LSP Module Pattern

```lua
-- Example: config/lua/dave-vim/plugins/lsp/pyright.lua
vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { 
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        ".git" 
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
}

vim.lsp.enable("pyright")
```

**Filetype-based Loading** (from `lz-n.lua`):
```lua
{
    "dave-vim.plugins.lsp.pyright",
    load = function()
        require("dave-vim.plugins.lsp.pyright")
    end,
    ft = "python",  -- Only loads when opening .py files
}
```

#### LSP Keybindings

Automatically enabled when LSP attaches to a buffer:

| Key | Action | Description |
|-----|--------|-------------|
| `K` | Hover documentation | Show docs for symbol under cursor |
| `gd` | Go to definition | Jump to symbol definition |
| `gD` | Go to declaration | Jump to symbol declaration |
| `gi` | Go to implementation | Jump to implementation |
| `go` | Go to type definition | Jump to type definition |
| `gr` | Show references | List all references to symbol |
| `gs` | Signature help | Show function signature |
| `<F2>` | Rename symbol | Rename symbol across project |
| `<F3>` | Format code | Format buffer or selection |
| `<F5>` | Code actions | Show available code actions |
| `gl` | Open diagnostic | Show diagnostic details |
| `[d` | Previous diagnostic | Jump to previous diagnostic |
| `]d` | Next diagnostic | Jump to next diagnostic |

**Buffer-local Activation**: Keybindings only active when LSP server successfully attaches to buffer.

#### Dev Shell Integration

LSPs are discovered from the current environment, enabling project-specific tooling:

```nix
# Example: Python project dev shell
pkgs.mkShell {
  packages = with pkgs; [
    pyright                    # LSP server
    (python3.withPackages (p: with p; [
      debugpy                  # Debug adapter
      black isort              # Formatters
      flake8                   # Linter
    ]))
  ];
}
```

**Workflow**:
1. Enter dev shell: `nix develop`
2. Launch Neovim: `nvim` (from flake)
3. Open file: Neovim detects LSP in PATH
4. LSP auto-attaches: Full language support available

**Benefits**:
- Project-specific tooling versions
- No global LSP installations
- Reproducible across team members
- Isolated per-project dependencies

---

### Code Completion & Snippets

#### nvim-cmp Architecture

The completion system uses **nvim-cmp** with multiple sources, prioritized in order:

```lua
-- From config/lua/dave-vim/plugins/cmp-nvim.lua
local sources = {
    { name = "path" },                             -- File system paths
    { name = "nvim_lsp", keyword_length = 1 },     -- LSP completions
    { name = "buffer", keyword_length = 3 },       -- Current buffer text
    { name = "luasnip", keyword_length = 2 },      -- Code snippets
    { name = "nvim_lsp_signature_help" },          -- Function signatures
}
```

**Source Priority & Triggering**:

| Source | Priority | Min Chars | Purpose |
|--------|----------|-----------|---------|
| **path** | 1 | 0 | File/directory completion |
| **nvim_lsp** | 2 | 1 | Language-aware completions from LSP |
| **buffer** | 3 | 3 | Words from current buffer |
| **luasnip** | 4 | 2 | Expandable code snippets |
| **signature_help** | 5 | 1 | Function parameter hints |

#### Completion Keybindings

```lua
-- Insert mode navigation
["<Tab>"]     -- Next item or jump to next snippet placeholder
["<S-Tab>"]   -- Previous item or jump to previous snippet placeholder
["<C-n>"]     -- Next item
["<C-p>"]     -- Previous item
["<Up>"]      -- Previous item
["<Down>"]    -- Next item

-- Documentation scrolling
["<C-u>"]     -- Scroll docs up
["<C-d>"]     -- Scroll docs down

-- Actions
["<C-Space>"] -- Manually trigger completion
["<C-e>"]     -- Abort completion
["<CR>"]      -- Confirm (only if explicitly selected)
```

**Smart Tab Behavior**:
- If completion menu visible → select next item
- If in snippet → jump to next placeholder
- Otherwise → insert tab character

#### Snippet System

Uses **LuaSnip** with SnipMate-style snippet loading:

```lua
local luasnip = require("luasnip")
require("luasnip.loaders.from_snipmate").lazy_load()

local snippet = {
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end,
}
```

**Snippet locations**: `config/lua/snippets/` (SnipMate format)

#### Visual Formatting

```lua
local formatting = {
    format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "...",
    }),
}
```

Uses **lspkind** for VS Code-like pictograms:
- 🔧 Function
- 📦 Module
- 📝 Variable
- 🎨 Color
- ... (context-aware icons)

---

### Fuzzy Finding (Telescope)

#### Core Operations

| Keybinding | Command | Description |
|------------|---------|-------------|
| `,ff` | `builtin.find_files` | Search files by name in project |
| `,fg` | `builtin.live_grep` | Search text content across files |
| `,fb` | `builtin.buffers` | List and switch between open buffers |
| `,fh` | `builtin.help_tags` | Search Neovim help documentation |
| `,tt` | `Neotree toggle` | Toggle Neo-tree file explorer |

#### Telescope Picker Navigation

When inside a Telescope picker:

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
| `<CR>` | Open in current window |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<Tab>` | Toggle selection (multi-select) |
| `<S-Tab>` | Toggle selection (reverse) |
| `<C-q>` | Send to quickfix list |
| `<C-u>` | Scroll preview up |
| `<C-d>` | Scroll preview down |
| `<C-/>` | Show help/mappings |
| `<Esc>` | Close picker |

#### Integration with External Tools

- **ripgrep** (rg): Fast text searching for live_grep
- **fd**: Fast file finding (respects .gitignore)
- **fzf**: Fuzzy matching algorithm

**Dependencies declared in flake.nix**:
```nix
runtimeInputs = [ ripgrep fd fzf /* ... */ ];
```

---

### Debug Adapter (nvim-dap)

#### Configuration Overview

Pre-configured for Python debugging with **dap-python**:

```lua
local setup = function()
    require("dap")
    require("dap-python").setup("python3")
end
```

**Python Requirements**: Install `debugpy` in project environment.

#### Keybindings (18 total)

All debug commands use the `<localleader>d` (`\d`) prefix:

**Sidebar Views**:
| Key | Action | Description |
|-----|--------|-------------|
| `\dst` | Toggle sidebar | Toggle current debug sidebar |
| `\dss` | Sessions view | Show debug sessions |
| `\dsc` | Scopes view | Show variable scopes (local/global) |
| `\dsf` | Frames view | Show call stack frames |
| `\dsr` | Threads view | Show running threads |
| `\dse` | Expression view | Show watched expressions |

**Debug Control**:
| Key | Action | Description |
|-----|--------|-------------|
| `\dc` | Continue | Start or continue execution |
| `\dn` | Step over | Execute current line, don't enter functions |
| `\di` | Step into | Enter function calls |
| `\dq` | Terminate | Stop debug session |
| `\drc` | Run to cursor | Execute until cursor position |

**Stack Navigation**:
| Key | Action | Description |
|-----|--------|-------------|
| `\d.` | Focus frame | Focus current stack frame |
| `\dk` | Up frame | Move up call stack |
| `\dj` | Down frame | Move down call stack |

**Breakpoints**:
| Key | Action | Description |
|-----|--------|-------------|
| `\dbt` | Toggle breakpoint | Set/remove breakpoint at cursor |
| `\dbl` | List breakpoints | Show all breakpoints |
| `\dbc` | Clear breakpoints | Remove all breakpoints |

**REPL**:
| Key | Action | Description |
|-----|--------|-------------|
| `\drt` | Toggle REPL | Open/close debug REPL (interactive console) |

**Detailed Reference**: See `docs/nvim-dap-reference.md`

---

### Git Integration

#### fugitive

Full Git workflow integration (no custom keybindings - use standard fugitive commands):

- `:Git` / `:G` - Git command interface
- `:Git blame` - Annotate file with commit info
- `:Git diff` - View changes
- `:Gwrite` - Stage current file
- `:Gread` - Checkout current file

#### gitsigns

Inline git indicators and blame:

```lua
-- Keybinding
{ ",gb", "<cmd>Gitsigns toggle_current_line_blame<cr>" }
```

**Features**:
- Inline diff indicators in sign column
- Current line blame (toggle with `\gb`)
- Hunks navigation (via gitsigns commands)

### Additional Features

**File Navigation**:
- **Neo-tree**: File explorer (`,tt` to toggle)
- **Tagbar**: Code outline/tags (`,ta` to toggle)
- **Undo tree**: Visual undo history (`,u` to toggle)

**Syntax & Highlighting**:
- **Treesitter**: Advanced syntax highlighting for all languages
- **Rainbow delimiters**: Colorize matching brackets/parentheses
- **nvim-colorizer**: Highlight color codes (#ff0000, rgb(), etc.)

**Code Quality**:
- **conform.nvim**: Auto-formatting on save (multiple formatters)
- **nvim-lint**: Linting for various languages

**Terminal Integration**:
- **tmux-navigator**: Seamless navigation between Neovim and tmux (`<C-h/j/k/l>`)
- **Terminal mode**: Enhanced with window navigation (`<ESC>` to exit)

**Markdown Support**:
- **wiki.vim**: Personal wiki/notes (markdown-based)
- **vim-markdown**: Enhanced markdown syntax
- **markdown-preview**: Live preview in browser
- **vim-table-mode**: Easy table editing
- **bullets.vim**: Smart bullet list handling

**Utilities**:
- **which-key**: Keybinding help popup (`,?` or wait after prefix)
- **vim-suda**: Save files with sudo (`:SudaWrite`)
- **vim-surround**: Surround text objects with quotes/brackets
- **camelcasemotion**: Enhanced word motions for camelCase

---

## Keybinding Organization

### Hierarchy by Prefix

```
Keybindings (80+)
├── Leader (,) Commands (40+)
│   ├── ,f* - Find (Telescope) - 36 bindings
│   │   ├── ,ff - Find files
│   │   ├── ,fg - Live grep
│   │   ├── ,fb - Buffers
│   │   └── ,fh - Help tags
│   │
│   ├── ,a* - AI (tmux-agent) - 4 bindings
│   │   ├── ,af - Find agent pane
│   │   ├── ,ab - Send buffer ref
│   │   ├── ,av - Send visual range
│   │   └── ,ap - Prompt agent
│   │
│   ├── ,t* - Toggle/Tags
│   │   ├── ,tt - Neo-tree toggle
│   │   └── ,ta - Toggle tagbar
│   │
│   ├── Other Leader Commands
│   │   ├── ,? - Which-key help
│   │   ├── ,bg - Toggle background
│   │   ├── ,gb - Toggle git blame
│   │   └── ,u - Toggle undo tree
│   │
├── Local Leader (\) Commands (25+)
│   ├── \d* - Debug (DAP) - 18 bindings
│   │   ├── Sidebar Views (6)
│   │   │   ├── \dst - Toggle
│   │   │   ├── \dss - Sessions
│   │   │   ├── \dsc - Scopes
│   │   │   ├── \dsf - Frames
│   │   │   ├── \dsr - Threads
│   │   │   └── \dse - Expressions
│   │   ├── Debug Control (5)
│   │   │   ├── \dc - Continue
│   │   │   ├── \dn - Step over
│   │   │   ├── \di - Step into
│   │   │   ├── \dq - Terminate
│   │   │   └── \drc - Run to cursor
│   │   ├── Stack Navigation (3)
│   │   │   ├── \d. - Focus frame
│   │   │   ├── \dk - Up frame
│   │   │   └── \dj - Down frame
│   │   ├── Breakpoints (3)
│   │   │   ├── \dbt - Toggle
│   │   │   ├── \dbl - List
│   │   │   └── \dbc - Clear
│   │   └── REPL (1)
│   │       └── \drt - Toggle REPL
│   │
│   └── Other Local Commands
│       ├── \rnu - Toggle relative numbers
│       └── \fw - Format with conform
│
├── Function Keys (6)
│   ├── <F2> - Rename symbol (LSP)
│   ├── <F3> - Format code (LSP)
│   ├── <F4> - Toggle paste mode
│   ├── <F5> - Code actions (LSP)
│   ├── <F11> - Previous buffer
│   └── <F12> - Next buffer
│
├── Control Keys (4)
│   ├── <C-h> - Navigate left (tmux)
│   ├── <C-j> - Navigate down (tmux)
│   ├── <C-k> - Navigate up (tmux)
│   └── <C-l> - Navigate right (tmux)
│
├── LSP Keys (13) - contextual
│   ├── Navigation (7)
│   │   ├── K - Hover docs
│   │   ├── gd - Definition
│   │   ├── gD - Declaration
│   │   ├── gi - Implementation
│   │   ├── go - Type definition
│   │   ├── gr - References
│   │   └── gs - Signature
│   └── Diagnostics (3)
│       ├── gl - Open float
│       ├── [d - Previous
│       └── ]d - Next
│
└── Terminal Mode (5)
    ├── <ESC> - Exit to normal
    ├── <C-h> - Window left
    ├── <C-j> - Window down
    ├── <C-k> - Window up
    └── <C-l> - Window right
```

### Contextual Bindings

Some keybindings only work in specific contexts:

1. **LSP Keys** (13 bindings): Only active when LSP server attached to buffer
2. **Neo-tree `,aa`**: Only works inside Neo-tree buffer
3. **Telescope Picker** (10+ bindings): Only in Telescope picker interface
4. **Terminal `<C-h/j/k/l>`**: Different behavior in terminal vs normal mode
5. **DAP Debug Control**: Some only work during active debug session

### Which-key Integration

```lua
-- Press ,? to show which-key popup
{ "<leader>?", function() require("which-key").show() end }
```

**Auto-popup**: Wait after pressing a prefix (`,` or `\`) to see available commands.

**Complete Reference**: See `docs/keybindings-master.md` for all 80+ keybindings.

---

## Performance & Optimization

### Lazy-Loading Statistics

```
Plugin Loading Strategy
┌────────────────────────────────────────┐
│  Start Plugins:  12 (25%)              │
│  Lazy Plugins:   36 (75%)              │
│  Total:          48 plugins            │
└────────────────────────────────────────┘

Startup Overhead
├── Start plugins loaded: ~100ms
├── LSP overhead: 0ms (filetype-triggered)
└── Lazy plugins registered: ~10ms
    Total startup time: ~110ms (fast)
```

### Startup Optimization Strategy

**What loads at startup** (12 plugins):
- **lz.n**: Lazy-loader core (required)
- **treesitter**: Syntax highlighting (pervasive need)
- **nvim-cmp**: Completion engine (frequent use)
- **nvim-lspconfig**: LSP framework (provides API)
- **plenary-nvim**: Lua utilities (library only)
- **nvim-web-devicons**: Icons (visual only)
- **lspkind-nvim**: Completion icons (visual only)
- **luasnip**: Snippet engine (cmp dependency)
- **cmp_luasnip**: Snippet integration (cmp source)
- **vim-snippets**: Snippet definitions (data only)
- **vim-nix**: Nix syntax (lightweight)
- **camelcasemotion**: Enhanced motions (always useful)
- **vim-sleuth**: Auto-detect indentation (automatic)
- **cyberdream-nvim**: Colorscheme (theme)

**What loads on-demand** (34 plugins):
- **Filetype triggers**: LSP configs (11), markdown plugins (5)
- **Keybinding triggers**: Telescope, Neo-tree, DAP, which-key
- **Event triggers**: Gitsigns, Lualine, Bufferline

### Filetype-based LSP Loading

**Zero LSP overhead at startup**:
```lua
-- LSPs only load when opening relevant files
{
    "dave-vim.plugins.lsp.pyright",
    ft = "python",  -- Only triggers on .py files
}
```

**Before**: All LSPs load at startup → slow
**After**: LSPs load per-filetype → instant startup

### Memory Efficiency

**Benefits of lazy-loading**:
- Reduced initial memory footprint
- Plugins loaded only when needed
- LSPs don't consume memory for unused languages
- Faster buffer switching (fewer active plugins)

**Trade-off**: First use of lazy plugin has ~50ms delay (negligible in practice)

---

## Development Workflow

### Nix Flake Workflow

```
Project Setup
     ↓
Create flake.nix + flake.lock
(pins nixpkgs + all dependencies)
     ↓
     ┌──────────────────────────────────────┐
     │  nix flake update                    │
     │  (update all inputs)                 │
     └──────────────────────────────────────┘
     ↓
Run Neovim
     ↓
     ┌──────────────────────────────────────┐
     │  nix run .#                          │
     │  (builds + runs from flake)          │
     └──────────────────────────────────────┘
     ↓
Reproducible Environment
(same plugins, same versions, everywhere)
```

### LSP Discovery Process

```
Enter Project Directory
     ↓
Create shell.nix or flake.nix
(declare project-specific LSPs)
     ↓
     ┌──────────────────────────────────────┐
     │  nix develop                         │
     │  (activates project shell)           │
     └──────────────────────────────────────┘
     ↓
Tools available in PATH
(pyright, typescript-language-server, etc.)
     ↓
     ┌──────────────────────────────────────┐
     │  nvim                                │
     │  (from dave-nvim-lazy flake)         │
     └──────────────────────────────────────┘
     ↓
Open file (*.py, *.ts, etc.)
     ↓
LSP module triggers (filetype)
     ↓
     ┌──────────────────────────────────────┐
     │  vim.lsp.enable("pyright")           │
     │  (looks for pyright in PATH)         │
     └──────────────────────────────────────┘
     ↓
LSP server found and started
     ↓
Full language support available
(completions, diagnostics, etc.)
```

**Key insight**: Neovim picks up tools from environment, Nix controls environment.

### Plugin Configuration Workflow

**Adding a new plugin**:

1. **Add to flake.nix**:
   ```nix
   packages.myVimPackage = with pkgs.vimPlugins; {
     opt = [
       # ... existing plugins
       my-new-plugin
     ];
   };
   ```

2. **Create plugin module** (`config/lua/dave-vim/plugins/my-plugin.lua`):
   ```lua
   local setup = function()
       require("my-plugin").setup({
           -- configuration
       })
   end
   
   local keys = {
       { "<leader>mp", "<cmd>MyPlugin<cr>", desc = "My Plugin" },
   }
   
   local lazy = function()
       return {
           "my-new-plugin",
           after = setup,
           keys = keys,
       }
   end
   
   return { lazy = lazy }
   ```

3. **Add to lz-n spec** (`config/lua/dave-vim/lz-n.lua`):
   ```lua
   local spec = {
       -- ... existing plugins
       require("dave-vim.plugins.my-plugin").lazy(),
   }
   ```

4. **Update flake**:
   ```bash
   nix flake update
   nix run .#
   ```

**Adding an LSP**:

1. Add LSP to flake `runtimeInputs` or project dev shell
2. Create LSP module in `plugins/lsp/my-lsp.lua`
3. Add filetype trigger to `lz-n.lua`
4. LSP auto-loads when opening relevant files

## Extensibility

### Adding Plugins

**Step-by-step**:

1. Find plugin on [NixOS Search](https://search.nixos.org/packages) (search "vimPlugins")
2. Add to `flake.nix` (opt or start section)
3. Create config module in `plugins/`
4. Add to `lz-n.lua` spec
5. Update and run flake

**Example** - Adding `vim-fugitive`:
```nix
# flake.nix
opt = [
  fugitive
  # ...
];
```

```lua
-- config/lua/dave-vim/plugins/fugitive.lua
local lazy = function()
    return {
        "vim-fugitive",
        cmd = { "Git", "G" },  -- Load on :Git command
    }
end

return { lazy = lazy }
```

```lua
-- config/lua/dave-vim/lz-n.lua
local spec = {
    require("dave-vim.plugins.fugitive").lazy(),
    -- ...
}
```

### Adding LSPs

**Step-by-step**:

1. **Identify LSP server** (check [nvim-lspconfig server list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md))

2. **Create LSP module** (`plugins/lsp/my-lsp.lua`):
   ```lua
   vim.lsp.config.mylsp = {
       cmd = { "mylsp-server", "--stdio" },
       filetypes = { "mylang" },
       root_markers = { ".git", "project.toml" },
       settings = {
           mylsp = {
               -- LSP-specific settings
           },
       },
   }
   
   vim.lsp.enable("mylsp")
   ```

3. **Add to lz-n spec**:
   ```lua
   {
       "dave-vim.plugins.lsp.my-lsp",
       load = function()
           require("dave-vim.plugins.lsp.my-lsp")
       end,
       ft = "mylang",
   }
   ```

4. **Install LSP server** (in flake or project dev shell):
   ```nix
   runtimeInputs = [
     mylsp-server
     # ...
   ];
   ```

### Custom Keybindings

**In plugin modules**:
```lua
local keys = {
    { "<leader>mp", my_function, desc = "My action" },
}

return {
    lazy = function()
        return {
            "my-plugin",
            keys = keys,
        }
    end
}
```

**In maps.lua** (for non-plugin keybindings):
```lua
vim.keymap.set("n", "<leader>x", function()
    -- custom action
end, { desc = "Custom action" })
```

## Key Design Decisions

### Why Nix Flakes?

**1. Reproducibility**
- Every dependency pinned in `flake.lock`
- Exact same versions on every machine
- No "works on my machine" problems
- Time-travel to any previous state

**2. Declarative Configuration**
- All dependencies explicit in `flake.nix`
- No hidden global state
- Clear dependency tree
- Easy to understand system

**3. Isolation**
- No pollution of global packages
- Project-specific tools via dev shells
- Multiple Neovim configs can coexist
- Clean uninstall (just delete directory)

**4. Cross-platform**
- Works on any system with Nix
- Linux, macOS, NixOS
- Consistent behavior everywhere
- Share config across machines

**Alternative rejected**: Manual plugin management (brittle, not reproducible)

### Why lz.n?

**1. Nix-friendly**
- No built-in package manager
- Doesn't conflict with Nix
- Uses Neovim's native package system
- Clean separation of concerns

**2. Simple API**
- Minimal learning curve
- Small codebase (easy to debug)
- Clear loading triggers
- No magic behavior

**3. Flexible Triggers**
- Filetype-based loading
- Keybinding-based loading
- Event-based loading
- Command-based loading

**4. Performant**
- Fast lazy-loading (~10ms overhead)
- Minimal startup time
- Efficient plugin registration
- No unnecessary processing

**Alternative rejected**: Lazy.nvim (includes package manager, conflicts with Nix)

### Why Modular Plugin Pattern?

**1. Maintainability**
- One file per plugin
- Easy to find configuration
- Clear responsibility boundaries
- Simple to remove plugins

**2. Decomposition**
- Local variables reduce nesting
- Setup logic separate from spec
- Functions grouped logically
- Less cognitive overhead

**3. Clarity**
- No deeply nested tables
- Self-documenting structure
- Consistent pattern everywhere
- Easy to review changes

**4. Consistency**
- Same pattern for all 38 plugins
- Predictable file structure
- Easy onboarding for contributors
- Reduced decision fatigue

**Before** (inline configuration):
```lua
-- Hard to read, deeply nested
require("lz.n").load({
    {
        "telescope.nvim",
        after = function()
            require("telescope").setup({
                -- 50 lines of config here
            })
        end,
        keys = {
            -- 10 lines of keybindings here
        },
    },
    -- Repeat for 38 plugins...
})
```

**After** (modular pattern):
```lua
-- Clean, maintainable
require("lz.n").load({
    require("dave-vim.plugins.telescope").lazy(),
    require("dave-vim.plugins.neo-tree").lazy(),
    -- ... 36 more one-liners
})
```

## Related Documentation

### Documentation Hierarchy

```
Documentation (5 files, ~1800 lines)
├── overview.md (this file)           # Project architecture & features
│
├── Keybindings (2 files)
│   ├── keybindings-master.md         # Complete reference (all 50+ bindings)
│   └── keybindings-core.md           # Core bindings detailed guide
│
└── Plugin References (3 files)
    ├── telescope-reference.md        # Fuzzy finder guide
    ├── nvim-dap-reference.md         # Debug adapter guide
    └── nvim-cmp-reference.md         # Completion reference
```

### Quick Reference Guide

| Need to... | See document |
|------------|--------------|
| **Understand architecture** | `docs/overview.md` (this file) |
| **Find a keybinding** | `docs/keybindings-master.md` |
| **Learn core keybindings** | `docs/keybindings-core.md` |
| **Use Telescope** | `docs/telescope-reference.md` |
| **Debug with DAP** | `docs/nvim-dap-reference.md` |
| **Configure completion** | `docs/nvim-cmp-reference.md` |
| **Understand Neovim standards** | `AGENTS.md` |
| **Understand Nix patterns** | `AGENTS.md` |

---

## Summary

**dave-nvim-lazy** is a production-ready Neovim configuration that balances:

- **Reproducibility** (Nix flakes) with **flexibility** (project dev shells)
- **Performance** (lazy-loading) with **features** (46 plugins)
- **Simplicity** (lz.n) with **power** (11 LSPs, tmux-agent)
- **Conventions** (modular pattern) with **customization** (extensible)

**Key strengths**:
1. **Nix-based reproducibility**: Works identically everywhere
2. **Lazy-loading efficiency**: 75% of plugins load on-demand
3. **Comprehensive LSP support**: 11 languages with filetype-based loading
4. **Lightweight AI integration**: tmux-agent for pane messaging
5. **Extensive documentation**: 1,800+ lines across 5 guides

**Ideal for**:
- Developers seeking reproducible environments
- Multi-language projects requiring LSP support
- Teams wanting reproducible editor environments
- Anyone valuing documentation and conventions

**Project statistics**:
- 2,100 lines of Lua configuration
- 46 plugins (12 startup, 34 lazy)
- 11 LSP servers
- 50+ custom keybindings
- 1,800 lines of documentation

**Start exploring**: Check out `docs/keybindings-master.md` for complete keybinding reference.
