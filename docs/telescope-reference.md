# Telescope Reference

Configuration: `config/lua/dave-vim/plugins/telescope.lua`

## Overview

Telescope is a highly extendable fuzzy finder for Neovim. It provides quick navigation for files, text search, buffers, help tags, and more with a powerful filtering interface.

## Leader Key

All Telescope commands use the leader prefix: `,` (comma)

## Quick Reference Table

| Key | Action | Description |
|-----|--------|-------------|
| `,ff` | Find files | Search files by name in project |
| `,fg` | Live grep | Search text content across files |
| `,fb` | Buffers | List and switch between open buffers |
| `,fh` | Help tags | Search Neovim help documentation |

## Telescope Interface

### Navigation Keys (in Telescope picker)

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
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

**Tips**:
- Type buffer name or number
- `<C-d>` to delete buffer (if configured)
- Works well with many open files
- See which buffers are modified

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
" Find references via Telescope
:Telescope lsp_references

" Find definitions
:Telescope lsp_definitions

" Show diagnostics
:Telescope diagnostics
```

### With Git
```vim
" Git-specific Telescope commands (if configured)
:Telescope git_files     " Git tracked files only
:Telescope git_commits   " Browse commits
:Telescope git_status    " Show changed files
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

### Custom Telescope Commands

Use `:Telescope` to access additional pickers:
```vim
:Telescope commands      " Search available commands
:Telescope keymaps      " Search key mappings
:Telescope oldfiles     " Recently opened files
:Telescope marks        " Jump to marks
:Telescope registers    " View registers
:Telescope colorscheme  " Change colorscheme
:Telescope vim_options  " Search Vim options
```

### Command History
```vim
:Telescope command_history   " Search command history
:Telescope search_history    " Search / history
```

## Keybinding Mnemonic Guide

- `f` = find
- `ff` = find files
- `fg` = find (with) grep
- `fb` = find buffers
- `fh` = find help
