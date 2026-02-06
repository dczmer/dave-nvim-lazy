# Plugin Keymaps Reference

All keybindings defined under `config/lua/dave-vim/plugins/` using `<leader>` (`,`) or `<localleader>` (`\`).

---

## `<leader>` Keybindings (leader = `,`)

### Telescope -- File Navigation

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ff` | n | Find files | `telescope.lua` |
| `,fF` | n | Find ALL files (hidden + ignored) | `telescope.lua` |
| `,fr` | n | Recent files | `telescope.lua` |
| `,fw` | n | Grep word under cursor | `telescope.lua` |
| `,fb` | n | Buffers | `telescope.lua` |

### Telescope -- Text Search

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,fg` | n | Live grep | `telescope.lua` |
| `,fG` | n | Live grep (all files, no ignore) | `telescope.lua` |
| `,fs` | n | Fuzzy search current buffer | `telescope.lua` |

### Telescope -- LSP

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,fl` | n | Find references (no declaration) | `telescope.lua` |
| `,fd` | n | Definitions | `telescope.lua` |
| `,fD` | n | Type definitions | `telescope.lua` |
| `,fi` | n | Implementations | `telescope.lua` |
| `,fx` | n | Diagnostics (all buffers) | `telescope.lua` |
| `,fX` | n | Diagnostics (current buffer only) | `telescope.lua` |
| `,fo` | n | Document symbols | `telescope.lua` |
| `,fO` | n | Workspace symbols | `telescope.lua` |

### Telescope -- Git

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,fc` | n | Git commits | `telescope.lua` |
| `,fC` | n | Git buffer commits | `telescope.lua` |
| `,ft` | n | Git status | `telescope.lua` |
| `,fB` | n | Git branches | `telescope.lua` |
| `,fT` | n | Git tracked files | `telescope.lua` |

### Telescope -- Vim Internals

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,fh` | n | Help tags | `telescope.lua` |
| `,fk` | n | Keymaps | `telescope.lua` |
| `,fm` | n | Marks | `telescope.lua` |
| `,fj` | n | Jump list | `telescope.lua` |
| `,fq` | n | Quickfix list | `telescope.lua` |
| `,fL` | n | Location list | `telescope.lua` |
| `,fv` | n | Vim options | `telescope.lua` |
| `,f:` | n | Command history | `telescope.lua` |
| `,f/` | n | Search history | `telescope.lua` |
| `,fR` | n | Registers | `telescope.lua` |
| `,fA` | n | Autocommands | `telescope.lua` |
| `,fH` | n | Highlight groups | `telescope.lua` |
| `,fz` | n | Spelling suggestions | `telescope.lua` |
| `,f?` | n | All Telescope pickers | `telescope.lua` |
| `,fp` | n | Resume previous picker | `telescope.lua` |

### Git

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,gb` | n | Toggle inline git blame | `gitsigns.lua` |

### NeoTree

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,tt` | n | Toggle NeoTree file browser | `neo-tree.lua` |

### Tags

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ta` | n | Toggle Tagbar | `tagbar.lua` |

### Which-Key

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,?` | n | Show which-key popup | `which-key.lua` |

### Undo

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,u` | n | Toggle Undotree | `undotree.lua` |

### Snacks / Zen

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,zz` | n | Toggle Zen Mode | `snacks.lua` |

### AI: Claude Code (loaded only if `claude` CLI is available)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ac` | n | Toggle Claude terminal | `claudecode.lua` |
| `,af` | n | Focus Claude | `claudecode.lua` |
| `,ar` | n | Resume Claude | `claudecode.lua` |
| `,aC` | n | Continue Claude | `claudecode.lua` |
| `,am` | n | Select model (interactive) | `claudecode.lua` |
| `,a1` | n | Switch to Sonnet 4.5 | `claudecode.lua` |
| `,a2` | n | Switch to Opus 4.5 | `claudecode.lua` |
| `,a3` | n | Switch to Haiku 4.5 | `claudecode.lua` |
| `,ab` | n | Add current buffer to context | `claudecode.lua` |
| `,as` | v | Send selection to Claude | `claudecode.lua` |
| `,as` | n | Add file from tree (NeoTree/oil only) | `claudecode.lua` |
| `,aa` | n | Accept diff | `claudecode.lua` |
| `,ad` | n | Deny diff | `claudecode.lua` |

### AI: OpenCode (loaded only if `opencode` CLI is available)

#### Ask / Analyze

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,as` | n | Ask with @this context | `opencode.lua` |
| `,ax` | n | Select operation | `opencode.lua` |
| `,ae` | n | Explain code | `opencode.lua` |
| `,ae` | v | Explain selection | `opencode.lua` |
| `,af` | n | Find bugs | `opencode.lua` |
| `,af` | v | Find bugs in selection | `opencode.lua` |
| `,ar` | n | Refactor code | `opencode.lua` |
| `,ar` | v | Refactor selection | `opencode.lua` |
| `,at` | n | Write tests | `opencode.lua` |
| `,at` | v | Write tests for selection | `opencode.lua` |
| `,ad` | n | Add documentation | `opencode.lua` |
| `,ad` | v | Document selection | `opencode.lua` |
| `,ai` | n | Improve/optimize code | `opencode.lua` |

#### Operator

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ao` | n | Operator-pending: add range to OpenCode | `opencode.lua` |
| `,aoo` | n | Add current line to OpenCode | `opencode.lua` |

#### Sessions

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,an` | n | New session | `opencode.lua` |
| `,al` | n | List sessions | `opencode.lua` |
| `,ac` | n | Clear session | `opencode.lua` |

#### Modes

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ab` | n | Switch to Build mode | `opencode.lua` |
| `,ap` | n | Switch to Plan mode | `opencode.lua` |

#### Navigation

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ak` | n | Scroll OpenCode up | `opencode.lua` |
| `,aj` | n | Scroll OpenCode down | `opencode.lua` |

#### Telescope Integration

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,aF` | n | Telescope files -> send to OpenCode | `opencode.lua` |
| `,aG` | n | Telescope grep -> send to OpenCode | `opencode.lua` |
| `,aB` | n | Telescope buffers -> send to OpenCode | `opencode.lua` |

#### Misc

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,ag` | n | Review git diff | `opencode.lua` |
| `,au` | n | Undo last change | `opencode.lua` |
| `,ah` | n | Show help | `opencode.lua` |

#### NeoTree Window

| Key | Mode | Action | File |
|-----|------|--------|------|
| `,aa` | n | Add selected node to OpenCode (NeoTree window only) | `neo-tree.lua` |

---

## `<localleader>` Keybindings (localleader = `\`)

### DAP Debugger -- Execution (`\d`)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `\dc` | n | Continue | `nvim-dap.lua` |
| `\dn` | n | Step over | `nvim-dap.lua` |
| `\di` | n | Step into | `nvim-dap.lua` |
| `\drc` | n | Run to cursor | `nvim-dap.lua` |
| `\d.` | n | Focus current frame | `nvim-dap.lua` |
| `\dk` | n | Go up in call stack | `nvim-dap.lua` |
| `\dj` | n | Go down in call stack | `nvim-dap.lua` |
| `\dq` | n | Terminate session | `nvim-dap.lua` |

### DAP Debugger -- Breakpoints (`\db`)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `\dbt` | n | Toggle breakpoint | `nvim-dap.lua` |
| `\dbl` | n | List breakpoints | `nvim-dap.lua` |
| `\dbc` | n | Clear all breakpoints | `nvim-dap.lua` |

### DAP Debugger -- Sidebar (`\ds`)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `\dst` | n | Toggle sidebar (frames widget) | `nvim-dap.lua` |
| `\dss` | n | Sidebar: sessions view | `nvim-dap.lua` |
| `\dsc` | n | Sidebar: scopes view | `nvim-dap.lua` |
| `\dsf` | n | Sidebar: frames view | `nvim-dap.lua` |
| `\dsr` | n | Sidebar: threads view | `nvim-dap.lua` |
| `\dse` | n | Sidebar: expression view | `nvim-dap.lua` |

### DAP Debugger -- REPL (`\dr`)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `\drt` | n | Toggle REPL (below split) | `nvim-dap.lua` |



### Formatting (`\f`)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `\fw` | n | Format buffer | `conform-nvim.lua` |




