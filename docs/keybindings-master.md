# Master Keybindings Reference

Complete reference for all custom keybindings in dave-nvim-lazy.

## Table of Contents

- [Leader Keys](#leader-keys)
- [Quick Help](#quick-help)
- [Quick Reference by Prefix](#quick-reference-by-prefix)
- [Mnemonic Guide](#mnemonic-guide)
- [Detailed Reference by Category](#detailed-reference-by-category)
  - [Core Navigation & Editing](#1-core-navigation--editing)
  - [LSP Operations](#2-lsp-operations)
  - [OpenCode AI Integration](#3-opencode-ai-integration)
  - [Telescope Fuzzy Finding](#4-telescope-fuzzy-finding)
  - [Telescope Picker Navigation](#5-telescope-picker-navigation)
  - [Debug Adapter (nvim-dap)](#6-debug-adapter-nvim-dap)
  - [File & Project Navigation](#7-file--project-navigation)
  - [Tmux & Window Navigation](#8-tmux--window-navigation)
  - [Terminal Mode](#9-terminal-mode)
  - [Git Integration](#10-git-integration)
  - [Code Formatting](#11-code-formatting)
  - [Utilities & Toggles](#12-utilities--toggles)
- [Contextual Bindings](#contextual-bindings)
- [Mode-Specific Summary](#mode-specific-summary)
  - [Normal Mode](#normal-mode)
  - [Visual Mode](#visual-mode)
  - [Insert Mode](#insert-mode)
  - [Command Mode](#command-mode)
  - [Terminal Mode](#terminal-mode-1)
- [Related Documentation](#related-documentation)
- [Customization](#customization)
  - [Modifying Keybindings](#modifying-keybindings)
  - [Discovering Keybindings](#discovering-keybindings)
  - [Avoiding Conflicts](#avoiding-conflicts)

## Leader Keys

- **Leader**: `,` (comma)
- **Local Leader**: `\` (backslash)

## Quick Help

Press `,?` to show which-key popup with available commands.

---

## Quick Reference by Prefix

### Function Keys

| Key | Mode | Action |
|-----|------|--------|
| `<F2>` | Normal | Rename symbol (LSP) |
| `<F3>` | Normal, Visual | Format code (LSP) |
| `<F4>` | Normal | Toggle paste mode |
| `<F5>` | Normal | Code actions (LSP) |
| `<F11>` | Normal | Previous buffer |
| `<F12>` | Normal | Next buffer |

---

## Mnemonic Guide

Memory aids for remembering key combinations:

### Prefixes
- `,f` = **f**ind (Telescope fuzzy finder)
- `,a` = **a**I/assistant (OpenCode)
- `\d` = **d**ebug (DAP debugger)
- `,t` = **t**oggle/tags
- `,u` = **u**ndo (tree)
- `g*` = **g**o to (LSP navigation)

### OpenCode Prompts
- `,ae` = **e**xplain
- `,af` = **f**ind bugs
- `,ar` = **r**efactor
- `,at` = **t**ests
- `,ad` = **d**ocumentation
- `,ai` = **i**mprove

### OpenCode Management
- `,an` = **n**ew session
- `,al` = **l**ist sessions
- `,ac` = **c**lear session
- `,aa` = **a**dd to context
- `,ab` = **b**uild mode
- `,ap` = **p**lan mode

### OpenCode Context
- `,aF` = **F**iles (uppercase F)
- `,aG` = **G**rep (uppercase G)
- `,aB` = **B**uffers (uppercase B)

### Git
- `,gb` = **g**it **b**lame
- `,ag` = **a**I **g**it diff

### Formatting
- `\fw` = **f**ormat (on **w**rite)

### Debug (DAP)
- `\ds*` = **d**ebug **s**idebar (views)
- `\db*` = **d**ebug **b**reakpoints
- `\dr*` = **d**ebug **r**EPL/run
- `\dc` = **c**ontinue
- `\dn` = **n**ext (step over)
- `\di` = step **i**nto
- `\dq` = **q**uit (terminate)

### LSP Navigation
- `gd` = **g**o to **d**efinition
- `gD` = **g**o to **D**eclaration
- `gi` = **g**o to **i**mplementation
- `go` = **g**o to type (type definiti**o**n)
- `gr` = **g**o to **r**eferences
- `gs` = **g**et **s**ignature

---


### Leader Commands (`,`)

#### Files & Search (`,f`)

| Key | Action |
|-----|--------|
| `,ff` | Find files (Telescope) |
| `,fg` | Live grep (Telescope) |
| `,fb` | Buffers (Telescope) |
| `,fh` | Help tags (Telescope) |
| `,ft` | Git status (Telescope) |

#### AI/OpenCode (`,a`)

| Key | Action |
|-----|--------|
| `,as` | Ask OpenCode with context |
| `,ae` | Explain code |
| `,af` | Find bugs |
| `,ar` | Refactor code |
| `,at` | Write tests |
| `,ad` | Add documentation |
| `,ai` | Improve/optimize code |
| `,an` | New session |
| `,al` | List sessions |
| `,ac` | Clear session |
| `,ao` | Add range operator |
| `,aoo` | Add current line |
| `,aF` | Search files for OpenCode |
| `,aG` | Grep for OpenCode |
| `,aB` | Select buffers for OpenCode |
| `,aa` | Add Neo-tree node (in Neo-tree only) |
| `,ab` | Build mode |
| `,ap` | Plan mode |
| `,ak` | Scroll up |
| `,aj` | Scroll down |
| `,au` | Undo last change |
| `,ah` | Show help |
| `,ag` | Review git diff |
| `,ax` | Select operation |

#### Other Leader Commands

| Key | Action |
|-----|--------|
| `,?` | Toggle which-key |
| `,bg` | Toggle transparent background |
| `,gb` | Toggle git blame |
| `,ta` | Toggle tagbar |
| `,u` | Toggle undo tree |

### Local Leader Commands (`\`)

#### Debug (`,d`)

| Key | Action |
|-----|--------|
| `\dst` | Toggle debug sidebar |
| `\dss` | Sessions view |
| `\dsc` | Scopes view |
| `\dsf` | Frames view |
| `\dsr` | Threads view |
| `\dse` | Expression view |
| `\dc` | Continue |
| `\dn` | Step over |
| `\di` | Step into |
| `\dq` | Terminate |
| `\drc` | Run to cursor |
| `\d.` | Focus frame |
| `\dk` | Up stack frame |
| `\dj` | Down stack frame |
| `\dbt` | Toggle breakpoint |
| `\dbl` | List breakpoints |
| `\dbc` | Clear breakpoints |
| `\drt` | Toggle REPL |

#### Other Local Leader Commands

| Key | Action |
|-----|--------|
| `\rnu` | Toggle relative line numbers |
| `\fw` | Format with conform |

### Control Keys

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | Normal | Navigate left (tmux) |
| `<C-j>` | Normal | Navigate down (tmux) |
| `<C-k>` | Normal | Navigate up (tmux) |
| `<C-l>` | Normal | Navigate right (tmux) |

### Terminal Mode Keys

| Key | Action |
|-----|--------|
| `<ESC>` | Exit to normal mode |
| `<C-h>` | Navigate to left window |
| `<C-j>` | Navigate to down window |
| `<C-k>` | Navigate to up window |
| `<C-l>` | Navigate to right window |

### LSP Keys (Active when LSP attached)

| Key | Mode | Action |
|-----|------|--------|
| `K` | Normal | Show hover documentation |
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `go` | Normal | Go to type definition |
| `gr` | Normal | Show references |
| `gs` | Normal | Show signature help |
| `gl` | Normal, Visual | Open diagnostic float |
| `[d` | Normal, Visual | Previous diagnostic |
| `]d` | Normal, Visual | Next diagnostic |

### Command Mode Keys

| Key | Action |
|-----|--------|
| `<Tab>` | Native Vim completion (C-z) |

---

## Detailed Reference by Category

### 1. Core Navigation & Editing

Configuration: `config/lua/dave-vim/maps.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<F11>` | Normal | Previous buffer | Navigate to previous buffer |
| `<F12>` | Normal | Next buffer | Navigate to next buffer |
| `<F4>` | Normal | Toggle paste mode | Enable/disable paste mode for clean pasting |
| `\rnu` | Normal | Toggle relative line numbers | Show/hide relative line numbers |
| `,bg` | Normal | Toggle transparent background | Switch between transparent/opaque background |

**See also**: `docs/keybindings-core.md`

### 2. LSP Operations

Configuration: `config/lua/dave-vim/maps.lua`

**Context**: These keybindings are automatically enabled when an LSP server attaches to a buffer.

#### Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `K` | Normal | Hover documentation | Show documentation for symbol under cursor |
| `gd` | Normal | Go to definition | Jump to symbol definition |
| `gD` | Normal | Go to declaration | Jump to symbol declaration |
| `gi` | Normal | Go to implementation | Jump to implementation |
| `go` | Normal | Go to type definition | Jump to type definition |
| `gr` | Normal | Show references | List all references to symbol |
| `gs` | Normal | Signature help | Show function signature |

#### Actions

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<F2>` | Normal | Rename symbol | Rename symbol across project |
| `<F3>` | Normal, Visual | Format code | Format code (LSP) |
| `<F5>` | Normal | Code actions | Show available code actions |

#### Diagnostics

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gl` | Normal, Visual | Open diagnostic float | Show diagnostic details |
| `[d` | Normal, Visual | Previous diagnostic | Jump to previous diagnostic |
| `]d` | Normal, Visual | Next diagnostic | Jump to next diagnostic |

**See also**: `docs/keybindings-core.md`

### 3. OpenCode AI Integration

Configuration: `config/lua/dave-vim/plugins/opencode.lua`

All OpenCode commands use the `<leader>a` (`,a`) prefix.

#### Core Operations

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,as` | Normal | Ask OpenCode | Ask OpenCode with @this context |
| `,ax` | Normal | Select operation | Show operation menu |

#### Context-Aware Prompts

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ae` | Normal | Explain code | Explain this code: @this |
| `,af` | Normal | Find bugs | Review code for bugs: @this |
| `,ar` | Normal | Refactor code | Refactor and improve: @this |
| `,at` | Normal | Write tests | Write comprehensive tests: @this |
| `,ad` | Normal | Add documentation | Add comprehensive documentation: @this |
| `,ai` | Normal | Improve/optimize | Improve and optimize: @this |

#### Session Management

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,an` | Normal | New session | Create new OpenCode session |
| `,al` | Normal | List sessions | List all OpenCode sessions |
| `,ac` | Normal | Clear session | Clear current session history |

#### Text Operators

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ao` | Normal | Add range operator | Use as operator (e.g., `,ao3j`) |
| `,aoo` | Normal | Add current line | Add current line to OpenCode |

#### Telescope Integration

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,aF` | Normal | Search files | Search files to add to context |
| `,aG` | Normal | Grep code | Grep code to add to context |
| `,aB` | Normal | Select buffers | Select buffers to add to context |

#### Neo-tree Integration

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,aa` | Normal | Add node | Add Neo-tree node to OpenCode (context-specific) |

**Context**: Only works when cursor is in Neo-tree buffer.

#### Mode Switching

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ab` | Normal | Build mode | Switch to Build mode (can edit) |
| `,ap` | Normal | Plan mode | Switch to Plan mode (read-only) |

#### Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ak` | Normal | Scroll up | Scroll OpenCode output up |
| `,aj` | Normal | Scroll down | Scroll OpenCode output down |

#### Utilities

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,au` | Normal | Undo | Undo last OpenCode change |
| `,ah` | Normal | Help | Show OpenCode help |
| `,ag` | Normal | Review git diff | Review git changes with OpenCode |

#### Visual Mode Variants

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ae` | Visual | Explain selection | Explain this code: @selection |
| `,af` | Visual | Find bugs | Review for bugs: @selection |
| `,ar` | Visual | Refactor selection | Refactor: @selection |
| `,at` | Visual | Write tests | Write tests for: @selection |
| `,ad` | Visual | Document selection | Add documentation: @selection |

**See also**: 
- `docs/opencode-keybindings.md` - Detailed OpenCode keybindings
- `docs/opencode-usage.md` - OpenCode workflows and examples

### 4. Telescope Fuzzy Finding

Configuration: `config/lua/dave-vim/plugins/telescope.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ff` | Normal | Find files | Search files by name |
| `,fg` | Normal | Live grep | Search text content across files |
| `,fb` | Normal | Buffers | List and switch between buffers |
| `,fh` | Normal | Help tags | Search Neovim help documentation |

**See also**: 
- `docs/telescope-reference.md` - Detailed Telescope reference
- Telescope Picker Navigation section below

### 5. Telescope Picker Navigation

**Context**: These keys are active when inside a Telescope picker interface.

#### Navigation

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
| `<C-u>` | Scroll preview up |
| `<C-d>` | Scroll preview down |

#### Selection & Opening

| Key | Action |
|-----|--------|
| `<CR>` | Open in current window |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |

#### Multi-Selection

| Key | Action |
|-----|--------|
| `<Tab>` | Toggle selection |
| `<S-Tab>` | Toggle selection (reverse) |
| `<C-q>` | Send selections to quickfix list |

#### Other

| Key | Action |
|-----|--------|
| `<C-c>` / `<Esc>` | Close picker |
| `<C-/>` | Show help/mappings |

**See also**: `docs/telescope-reference.md`

### 6. Debug Adapter (nvim-dap)

Configuration: `config/lua/dave-vim/plugins/nvim-dap.lua`

All debug commands use the `<localleader>d` (`\d`) prefix.

#### Sidebar Views

| Key | Action | Description |
|-----|--------|-------------|
| `\dst` | Toggle sidebar | Toggle current debug sidebar |
| `\dss` | Sessions view | Show debug sessions |
| `\dsc` | Scopes view | Show variable scopes |
| `\dsf` | Frames view | Show stack frames |
| `\dsr` | Threads view | Show running threads |
| `\dse` | Expression view | Show expressions |

#### Debug Control

| Key | Action | Description |
|-----|--------|-------------|
| `\dc` | Continue | Start/continue execution |
| `\dn` | Step over | Step over (next line) |
| `\di` | Step into | Step into function |
| `\dq` | Terminate | Terminate debug session |
| `\drc` | Run to cursor | Run to cursor position |

#### Stack Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `\d.` | Focus frame | Focus current frame |
| `\dk` | Up frame | Move up stack frame |
| `\dj` | Down frame | Move down stack frame |

#### Breakpoints

| Key | Action | Description |
|-----|--------|-------------|
| `\dbt` | Toggle breakpoint | Toggle breakpoint at cursor |
| `\dbl` | List breakpoints | List all breakpoints |
| `\dbc` | Clear breakpoints | Clear all breakpoints |

#### REPL

| Key | Action | Description |
|-----|--------|-------------|
| `\drt` | Toggle REPL | Toggle debug REPL (below split) |

**See also**: `docs/nvim-dap-reference.md`

### 7. File & Project Navigation

#### Neo-tree

Configuration: `config/lua/dave-vim/plugins/neo-tree.lua`
Full Reference: `docs/neo-tree-reference.md`

**Global Keybindings**:
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,tt` | Normal | Toggle Neo-tree | Toggle file tree explorer |

**Internal Mappings** (when focused in neo-tree):
- **Navigation**: `j`/`k`, `<space>` (toggle node), `<cr>` (open), `P` (preview)
- **File ops**: `a` (add), `A` (add dir), `d` (delete), `r` (rename), `c` (copy), `m` (move)
- **Splits**: `s` (horizontal), `v` (vertical), `t` (tab)
- **Display**: `H` (toggle hidden), `I` (toggle gitignored), `R` (refresh), `.` (set root)
- **Git**: `A` (add all), `ga` (add file), `gu` (unstage), `gc` (commit), `gp` (push)
- **Other**: `?` (help), `q` (close), `i` (details), `,aa` (add to OpenCode)

See `docs/neo-tree-reference.md` for complete documentation.

#### Tagbar

Configuration: `config/lua/dave-vim/plugins/tagbar.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ta` | Normal | Toggle tagbar | Toggle tagbar (code outline) |

#### Undo Tree

Configuration: `config/lua/dave-vim/plugins/undotree.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,u` | Normal | Toggle undo tree | Toggle undo history tree |

### 8. Tmux & Window Navigation

Configuration: `config/lua/dave-vim/plugins/tmux-navigator.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-h>` | Normal | Navigate left | Move to left window/pane |
| `<C-j>` | Normal | Navigate down | Move to down window/pane |
| `<C-k>` | Normal | Navigate up | Move to up window/pane |
| `<C-l>` | Normal | Navigate right | Move to right window/pane |

**Note**: Seamlessly navigates between Neovim windows and tmux panes.

### 9. Terminal Mode

Configuration: `config/lua/dave-vim/maps.lua`

| Key | Action | Description |
|-----|--------|-------------|
| `<ESC>` | Exit to normal mode | Exit terminal insert mode |
| `<C-h>` | Navigate left | Move to left window |
| `<C-j>` | Navigate down | Move to down window |
| `<C-k>` | Navigate up | Move to up window |
| `<C-l>` | Navigate right | Move to right window |

**See also**: `docs/keybindings-core.md`

### 10. Git Integration

#### Gitsigns

Configuration: `config/lua/dave-vim/plugins/gitsigns.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,gb` | Normal | Toggle git blame | Show/hide git blame for current line |

#### OpenCode Git Review

Configuration: `config/lua/dave-vim/plugins/opencode.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ag` | Normal | Review git diff | Review git changes with OpenCode |

### 11. Code Formatting

#### Conform

Configuration: `config/lua/dave-vim/plugins/conform-nvim.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `\fw` | Normal | Format buffer | Format current buffer with conform |

**Note**: Format-on-save is enabled by default for configured languages.

#### LSP Format

Configuration: `config/lua/dave-vim/maps.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<F3>` | Normal, Visual | Format code | Format code with LSP (when LSP attached) |

### 12. Utilities & Toggles

#### Which-key

Configuration: `config/lua/dave-vim/plugins/which-key.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,?` | Normal | Show which-key | Display available keybindings |

#### Background Transparency

Configuration: `config/lua/dave-vim/toggle-transparent-bg.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,bg` | Normal | Toggle background | Toggle transparent background |

#### Command-Line Completion

Configuration: `config/lua/dave-vim/plugins/cmp-nvim.lua`

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<Tab>` | Command | Native completion | Use Vim's native completion (C-z) |

**Note**: This prevents nvim-cmp from breaking tab completion in command mode.

**See also**: `docs/nvim-cmp-reference.md` for insert mode completion keybindings

---

## Contextual Bindings

Some keybindings only work in specific contexts or change behavior based on the current buffer/mode:

### LSP Keybindings
**Context**: Only active when an LSP server is attached to the current buffer.

**Keys affected**: `K`, `gd`, `gD`, `gi`, `go`, `gr`, `gs`, `<F2>`, `<F3>`, `<F5>`, `gl`, `[d`, `]d`

**How to check**: Run `:LspInfo` to see if LSP is attached.

### Neo-tree Context
**Context**: The `,aa` keybinding only works when the cursor is inside a Neo-tree buffer.

**Key affected**: `,aa` (Add to OpenCode)

**How to check**: Open Neo-tree with `,tt` and navigate to a file/directory.

### Tmux Navigation & Terminal Mode
**Context**: The `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` keys work differently based on mode:

- **Normal mode**: Navigates between Neovim windows and tmux panes seamlessly
- **Terminal mode**: Navigates between windows from terminal

**Keys affected**: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`

### Telescope Picker Navigation
**Context**: Special navigation keys are only active when inside a Telescope picker interface.

**Keys affected**: See "Telescope Picker Navigation" section above

**How to trigger**: Open any Telescope command (`,ff`, `,fg`, `,fb`, `,fh`)

### Debug Adapter (DAP)
**Context**: Some debug keys only work when a debug session is active.

**Keys affected**: Debug control, stack navigation, and REPL commands work best during active debugging.

**How to start**: Set breakpoints with `\dbt` and start debugging with `\dc`.

---

## Mode-Specific Summary

### Normal Mode
**Total**: 70+ keybindings

**Categories**:
- Core navigation & editing (5)
- LSP operations (13 when attached)
- OpenCode AI integration (23)
- Telescope fuzzy finding (4)
- Debug adapter (18)
- File & project navigation (3)
- Tmux & window navigation (4)
- Git integration (2)
- Code formatting (2)
- Utilities & toggles (3)

### Visual Mode
**Total**: 7 keybindings

**All OpenCode prompts**:
- `,ae` - Explain selection
- `,af` - Find bugs in selection
- `,ar` - Refactor selection
- `,at` - Write tests for selection
- `,ad` - Document selection
- `<F3>` - Format selection (LSP)
- `gl`, `[d`, `]d` - Diagnostic navigation

### Insert Mode
**Total**: 0 custom keybindings

**Note**: Insert mode keybindings are handled by nvim-cmp completion.

**See**: `docs/nvim-cmp-reference.md` for completion keybindings.

### Command Mode
**Total**: 1 keybinding

- `<Tab>` - Native Vim completion (mapped to `<C-z>`)

### Terminal Mode
**Total**: 5 keybindings

- `<ESC>` - Exit to normal mode
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` - Window navigation

---

## Related Documentation

### Plugin-Specific References
- `docs/opencode-keybindings.md` - OpenCode detailed keybindings guide
- `docs/opencode-usage.md` - OpenCode workflows and examples
- `docs/opencode-troubleshooting.md` - OpenCode troubleshooting
- `docs/keybindings-core.md` - Core keybindings detailed guide
- `docs/telescope-reference.md` - Telescope fuzzy finder reference
- `docs/nvim-dap-reference.md` - Debug adapter detailed reference
- `docs/nvim-cmp-reference.md` - Completion keybindings (insert mode)

### Configuration Files
- `config/lua/dave-vim/maps.lua` - Core keybindings
- `config/lua/dave-vim/plugins/opencode.lua` - OpenCode configuration
- `config/lua/dave-vim/plugins/telescope.lua` - Telescope configuration
- `config/lua/dave-vim/plugins/nvim-dap.lua` - DAP configuration
- `config/lua/dave-vim/plugins/` - All plugin configurations

---

## Customization

### Modifying Keybindings

To customize keybindings, edit the relevant configuration files:

```lua
-- Example: Change buffer navigation in maps.lua
vim.keymap.set("n", "<F11>", "<cmd>bprev<cr>")
vim.keymap.set("n", "<F12>", "<cmd>bnext<cr>")

-- Example: Add custom OpenCode prompt in opencode.lua
{
    "<leader>ax",
    function()
        require("opencode").ask("Custom prompt: @this", { submit = true })
    end,
    desc = "Custom action",
}

### Discovering Keybindings

Use these tools to discover available keybindings:

1. **Which-key popup**: Press `,?` or wait after pressing a prefix key
2. **Verbose map**: `:verbose map <key>` to see binding source
3. **List all mappings**: `:map` for all modes, `:nmap` for normal mode
4. **Plugin help**: `:help {plugin-name}` for plugin documentation

### Avoiding Conflicts

When adding custom keybindings:

1. Check existing mappings: `:verbose map <key>`
2. Use unused prefixes or local leader
3. Follow the established patterns (`,f*` for find, `,a*` for AI, etc.)
4. Test in a fresh buffer to ensure no conflicts
