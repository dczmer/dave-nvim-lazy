# Telescope Reference

Configuration: `config/lua/dave-vim/plugins/telescope.lua`

## Overview

Telescope is a highly extendable fuzzy finder for Neovim. It provides quick navigation for files, text search, buffers, help tags, and more with a powerful filtering interface.

## Leader Key

All Telescope commands use the leader prefix: `,` (comma)

## Quick Reference Table

### File Navigation
| Key | Description |
|-----|-------------|
| `,ff` | Find files |
| `,fF` | Find ALL files (hidden/ignored) |
| `,fr` | Recent files |
| `,fw` | Find word under cursor |

### Text Search
| Key | Description |
|-----|-------------|
| `,fg` | Live grep |
| `,fG` | Live grep (all files, no ignore) |
| `,fs` | Search current buffer |

### Buffer Management
| Key | Description |
|-----|-------------|
| `,fb` | Buffers (press `dd` or `Ctrl-d` to delete) |

### LSP Integration
| Key | Description |
|-----|-------------|
| `,fl` | LSP: Find references |
| `,fd` | LSP: Definitions |
| `,fD` | LSP: Type definitions |
| `,fi` | LSP: Implementations |
| `,fx` | LSP: Diagnostics (all) |
| `,fX` | LSP: Diagnostics (current buffer) |
| `,fo` | LSP: Document symbols |
| `,fO` | LSP: Workspace symbols |

### Git Integration
| Key | Description |
|-----|-------------|
| `,fc` | Git commits |
| `,fC` | Git buffer commits |
| `,ft` | Git status |
| `,fB` | Git branches |
| `,fT` | Git tracked files |

### Vim Internals
| Key | Description |
|-----|-------------|
| `,fh` | Help tags |
| `,fk` | Keymaps |
| `,fm` | Marks |
| `,fj` | Jump list |
| `,fq` | Quickfix list |
| `,fL` | Location list |
| `,fv` | Vim options |
| `,f:` | Command history |
| `,f/` | Search history |
| `,fR` | Registers |
| `,fA` | Autocommands |
| `,fH` | Highlight groups |
| `,fz` | Spelling suggestions |

### Telescope Meta
| Key | Description |
|-----|-------------|
| `,f?` | Telescope pickers |
| `,fp` | Resume previous picker |

## Telescope Interface

### Navigation Keys (in Telescope picker)

**Insert Mode** (while typing):
| Key | Action |
|-----|--------|
| `<C-n>` / `<C-j>` | Next item |
| `<C-p>` / `<C-k>` | Previous item |
| `<C-c>` / `<Esc>` | Close Telescope |
| `<CR>` | Select item (open in current window) |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-u>` | Scroll preview up |
| `<C-d>` | Scroll preview down |
| `<C-/>` | Show key mappings (help) |
| `<Tab>` | Toggle selection (multi-select) |
| `<S-Tab>` | Toggle selection (reverse) |
| `<C-q>` | Send to quickfix list |
| `<M-q>` | Send selected to quickfix list |

**Normal Mode** (press `<Esc>` from insert mode):
| Key | Action |
|-----|--------|
| `j` / `k` | Next/previous item |
| `gg` / `G` | Jump to top/bottom |
| `<CR>` | Select item |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-u>` / `<C-d>` | Scroll preview |
| `?` | Show key mappings (help) |
| `<Esc>` | Close Telescope |

## Common Workflows

### Finding Files
```vim
,ff                      " Open file finder
" Type partial filename
" Use fuzzy matching: "mdcfg" matches "my_deep_config.lua"
<CR>                     " Open selected file
```

### Searching Text Content
```vim
,fg                      " Open live grep
" Type search term
" Results update as you type
<CR>                     " Jump to match
```

### Buffer Navigation
```vim
,fb                      " List open buffers
" Type buffer name or number
<CR>                     " Switch to buffer
```

### Searching Help
```vim
,fh                      " Search help tags
" Type command or topic
" Example: "telescope", "keybinding", "dap"
<CR>                     " Open help document
```

### Multi-File Operations
```vim
,ff                      " Find files
" Navigate to file
<Tab>                    " Mark file (repeat for multiple)
<C-q>                    " Send marked files to quickfix
:cdo %s/old/new/gc      " Operate on all files
```

### Opening in Splits
```vim
,ff                      " Find files
" Navigate to file
<C-x>                    " Open in horizontal split
" Or
<C-v>                    " Open in vertical split
" Or
<C-t>                    " Open in new tab
```

### Preview Navigation
```vim
,ff                      " Find files (or any picker)
" Select a file to preview
<C-d>                    " Scroll preview down
<C-u>                    " Scroll preview up
```

## Advanced Pickers

### LSP Navigation
- `,fl` - Find references to symbol under cursor
- `,fd` - Jump to definitions
- `,fD` - Find type definitions
- `,fi` - Find implementations
- `,fo` - Browse document symbols (outline)
- `,fO` - Browse workspace symbols
- `,fx` - View all diagnostics (workspace)
- `,fX` - View diagnostics (current buffer only)

**Usage example**:
```vim
" Find where a function is used
" 1. Place cursor on function name
,fl                      " Find all references
" Navigate with j/k, preview with C-d/C-u
<CR>                     " Jump to selected location
```

### Git Integration
- `,fc` - Browse commit history (all)
- `,fC` - Browse commit history (current buffer)
- `,ft` - View changed files (git status)
- `,fB` - Switch branches
- `,fT` - Search git-tracked files only

**Usage example**:
```vim
" Review changes
,ft                      " Git status picker
" See all modified files with preview
<CR>                     " Open file

" Browse commit history
,fc                      " All commits
,fC                      " Commits for current file only
```

### File & Search
- `,fF` - Find ALL files (including hidden/ignored)
- `,fG` - Live grep ALL files (no gitignore)
- `,fr` - Recently opened files
- `,fw` - Find word under cursor across project
- `,fs` - Fuzzy search current buffer

**Usage example**:
```vim
" Lost track of a file you were editing?
,fr                      " Recent files picker
" Type partial name
<CR>                     " Reopen
```

### Vim Internals
- `,fk` - Browse all keymaps
- `,fm` - Jump to marks
- `,fj` - Navigate jump list
- `,fq` - Quickfix list
- `,f:` - Command history
- `,f/` - Search history
- `,f?` - List all telescope pickers
- `,fp` - Resume previous picker

**Usage example**:
```vim
" Forgot a keybinding?
,fk                      " Search all keymaps
" Type what you're looking for
<CR>                     " See the mapping
```

## Detailed Command Reference

### Find Files (`,ff`)
**Usage**: Quickly locate files by name

**Features**:
- Searches current working directory recursively
- Respects `.gitignore` by default
- Shows file preview
- Fuzzy matching supports abbreviations

**Tips**:
- Type fragments: "cfg" matches "config.lua"
- Case-insensitive by default
- Use `/` for directory navigation in search

**Example searches**:
- `init` - Finds init.lua, init.vim, etc.
- `tel lua` - Finds telescope.lua
- `maps` - Finds maps.lua

### Live Grep (`,fg`)
**Usage**: Search text content across all files

**Features**:
- Real-time regex search
- Shows context around matches
- Preview highlights matching text
- Searches entire project

**Tips**:
- Use regex patterns: `function.*test`
- Case-sensitive by default in regex
- See file path and line numbers
- Results update as you type

**Example searches**:
- `TODO` - Find all TODO comments
- `function setup` - Find setup functions
- `vim.keymap.set` - Find keybinding definitions

### Buffers (`,fb`)
**Usage**: Quick switch between open buffers

**Features**:
- Shows all loaded buffers
- Preview buffer content
- Shows buffer numbers
- Indicates modified buffers
- Delete buffers directly from picker

**Tips**:
- Type buffer name or number
- `dd` (normal mode) or `<C-d>` (insert mode) to delete buffer
- Works well with many open files
- See which buffers are modified
- Multi-select with `<Tab>` and delete multiple at once

### Help Tags (`,fh`)
**Usage**: Search Neovim documentation

**Features**:
- Searches all help tags
- Preview shows help content
- Includes plugin documentation
- Fast fuzzy matching

**Tips**:
- Search by topic: `telescope`
- Search by command: `:buffers`
- Search by option: `'rnu'`
- Discover new features easily

**Example searches**:
- `telescope` - Telescope documentation
- `lsp` - LSP-related help
- `keymap` - Key mapping help
- `dap` - Debug adapter help

## Tips & Best Practices

### Fuzzy Finding Strategy
1. **Type less**: Fuzzy matching works with abbreviations
   - `tlsc` finds `telescope.lua`
   - `nvdap` finds `nvim-dap.lua`
2. **Use fragments**: Type key parts of filename
   - `open maps` finds `opencode-maps.lua`
3. **Directory hints**: Include directory fragments
   - `plug tel` finds `plugins/telescope.lua`

### Efficient Text Search
1. **Be specific**: Start with unique terms
2. **Use live grep**: Results update instantly
3. **Check preview**: Verify context before opening
4. **Multi-select**: Use `<Tab>` for batch operations

### Buffer Management
1. **Quick switch**: `,fb` faster than `:buffer`
2. **Preview first**: Check buffer content before switching
3. **Clean workflow**: Close unneeded buffers regularly
4. **Number navigation**: Type buffer number for direct access

### Learning Vim Features
1. **Explore help**: `,fh` to discover features
2. **Search commands**: Find documentation for commands
3. **Plugin docs**: Access plugin help easily
4. **Context preview**: Read help without opening

### Multi-Selection Workflow
```vim
,ff                      " Find files
<Tab>                    " Select first file
<Tab>                    " Select second file
<Tab>                    " Select third file
<C-q>                    " Send to quickfix list

" Now operate on all selected files
:cdo {command}           " Run command on each
:cfdo {command}          " Run command on each file once
```

### Split Window Workflow
```vim
" Arrange windows efficiently
,ff                      " Find file
<C-v>                    " Open in vertical split
,ff                      " Find another file
<C-x>                    " Open in horizontal split
<C-w>= " Equalize window sizes
```

## Search Tips

### File Search Patterns
- `*.lua` - Only Lua files (if supported)
- `test` - Any file with "test" in name
- `init` - Configuration files
- `doc` or `docs` - Documentation

### Grep Search Patterns
- `function.*setup` - Functions containing "setup"
- `TODO|FIXME` - Find TODO or FIXME comments
- `vim\.keymap\.set` - Find keybinding definitions
- `require.*dap` - Find DAP-related requires

### Help Search Patterns
- `:command` - Ex commands (`:telescope`)
- `'option'` - Vim options (`'number'`)
- `function()` - Function names
- `concept` - General topics (`motion`, `registers`)

## Performance Tips

1. **File search scope**: Navigate to project root first
2. **Grep performance**: Be specific with search terms
3. **Buffer limit**: Close unused buffers regularly
4. **Preview size**: Toggle preview if slow (`:Telescope preview=false`)

## Integration with Other Tools

### With OpenCode
```vim
" Add files to OpenCode context
,ff                      " Find file
" Then use OpenCode commands
,aF                      " OpenCode file picker (separate feature)
```

### With LSP
```vim
" LSP navigation with keybindings
,fl                      " Find references
,fd                      " Find definitions
,fi                      " Find implementations
,fx                      " Show diagnostics (all)
,fX                      " Show diagnostics (current buffer)
,fo                      " Document symbols (outline)
,fO                      " Workspace symbols

" Or use commands directly
:Telescope lsp_references
:Telescope lsp_definitions
:Telescope diagnostics
```

### With Git
```vim
" Git-specific Telescope commands (if configured)
:Telescope git_files     " Git tracked files only
:Telescope git_commits   " Browse commits
:Telescope git_status    " Show changed files
```

## Performance & Customization

### FZF Native Extension

The configuration loads the FZF native extension for significant performance improvements:
- **Speed**: 20-50x faster on large result sets
- **Fuzzy matching**: True fuzzy search (not just substring)
- **Smart case**: Automatically case-sensitive when uppercase used

The FZF extension is loaded automatically when you first use a Telescope picker. You can verify it's loaded with:
```vim
:lua print(vim.inspect(require('telescope').extensions.fzf))
```

### File Ignores

Configured to skip common directories:
- `.git/`, `node_modules/`, `__pycache__/`
- Binary files: `.o`, `.a`, `.pdf`, `.mkv`, `.mp4`
- Nix build outputs: `result/`, `.direnv/`

Override file ignores for a single search:
```vim
,fF                      " Find ALL files (no ignores)
,fG                      " Grep ALL files (no ignores)
```

### Layout Themes

Different pickers use optimized themes:
- **Dropdown**: Quick selections (files, buffers, git status)
  - Compact layout at top of screen
  - Good for quick file/buffer switching
- **Ivy**: Content-heavy displays (help, commits, diagnostics)
  - Bottom layout with more vertical space
  - Better for reading documentation/logs
- **Horizontal**: Default with balanced preview
  - Split layout with good preview window
  - Best for code navigation

### Buffer Management

In buffers picker (`,fb`):
- Press `Ctrl-d` (insert mode) or `dd` (normal mode) to delete buffer
- Multi-select with `Tab` and delete multiple at once
- Starts in normal mode for quick navigation
- Dropdown theme for fast switching

**Multi-delete workflow**:
```vim
,fb                      " Open buffers
" (already in normal mode)
<Tab>                    " Mark first buffer
j                        " Move down
<Tab>                    " Mark second buffer
dd                       " Delete all marked buffers
```

## Common Workflows

### Multi-File Search & Replace
```vim
" 1. Find all occurrences
,fg                      " Live grep
" Type search term

" 2. Select files
<Tab>                    " Mark files (repeat for multiple)
<C-q>                    " Send to quickfix

" 3. Replace across all files
:cfdo %s/old/new/gc      " Interactive replace
:wa                      " Write all changes
```

### LSP Code Navigation
```vim
" Find where a function is used
" 1. Place cursor on function name
,fl                      " Find all references
" Navigate with j/k, preview with C-d/C-u
<CR>                     " Jump to selected location

" Jump to definition
,fd                      " Telescope LSP definitions
" Or use built-in: gd
```

## Troubleshooting

### Telescope not opening
**Solutions**:
1. Check plugin loaded:
   ```vim
   :Lazy
   " Look for telescope.nvim
   ```
2. Verify keybindings:
   ```vim
   :verbose map ,ff
   ```
3. Check for errors:
   ```vim
   :messages
   ```

### Grep not finding results
**Solutions**:
1. Verify working directory:
   ```vim
   :pwd
   :cd /path/to/project
   ```
2. Check if ripgrep installed:
   ```bash
   which rg
   ```
3. Try different search term
4. Check `.gitignore` isn't hiding files

### Files not showing
**Solutions**:
1. Check if file is ignored by git
2. Verify you're in correct directory (`:pwd`)
3. Try absolute path search
4. Check file actually exists (`:!ls path/to/file`)

### Slow performance
**Solutions**:
1. Navigate to project subdirectory
2. Use more specific search terms
3. Exclude large directories (configure ignore patterns)
4. Disable preview temporarily

### Keybindings conflict
**Solutions**:
1. Check for conflicts:
   ```vim
   :verbose map ,f
   ```
2. Remap in `telescope.lua` if needed
3. Use `:Telescope` command directly

## Command Mode Alternative

If keybindings don't work, use commands directly:
```vim
:Telescope find_files
:Telescope live_grep
:Telescope buffers
:Telescope help_tags
```

## Dependencies

Required:
- `nvim-telescope/telescope.nvim` - Core plugin
- `nvim-lua/plenary.nvim` - Lua utilities

Optional (recommended):
- `ripgrep` (rg) - Fast grep for live_grep
- `fd` - Fast file finder (alternative to find)

Install external tools:
```bash
# Ubuntu/Debian
sudo apt install ripgrep fd-find

# macOS
brew install ripgrep fd

# Arch Linux
sudo pacman -S ripgrep fd
```

## Related Configuration

- **Core keybindings**: `docs/keybindings-core.md`
- **Leader key**: Set in `config/lua/dave-vim/maps.lua`
- **OpenCode integration**: `docs/opencode-usage.md`

## Advanced Features

### Telescope Pickers with Keybindings

Many advanced pickers now have direct keybindings:
```vim
,fk                      " Search key mappings
,fr                      " Recently opened files
,fm                      " Jump to marks
,fR                      " View registers
,fv                      " Search Vim options
,f:                      " Search command history
,f/                      " Search / history
,fA                      " Autocommands
,fH                      " Highlight groups
,f?                      " List all Telescope pickers
```

### Custom Telescope Commands

Use `:Telescope` to access additional pickers without keybindings:
```vim
:Telescope commands      " Search available commands
:Telescope colorscheme   " Change colorscheme
:Telescope filetypes     " Set filetype
```

## Keybinding Mnemonic Guide

- `f` = find
- `ff` = find files
- `fg` = find (with) grep
- `fb` = find buffers
- `fh` = find help
