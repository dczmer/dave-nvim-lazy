# Neo-Tree Reference

## Overview

Neo-tree is a modern file explorer plugin for Neovim that provides tree-style navigation of files, git status, and buffers. This configuration is optimized for:

- **Git integration**: Visual git status indicators and git commands
- **Nix-aware filtering**: Automatically hides Nix build artifacts (.direnv, result)
- **Performance**: Lazy-loaded on first use, file watcher for auto-refresh
- **Workflow efficiency**: Expanded mappings for common file operations

### Lazy Loading

Neo-tree is lazy-loaded and triggered by the `,tt` keybinding. This means it has no impact on Neovim startup time and only loads when you first open the file explorer.

### Integration

- **Git**: Displays git status symbols next to files, provides git commands
- **Filesystem**: Auto-refresh on external changes, follows current file
- **OpenCode**: Custom mapping (`,aa`) to add files/directories to OpenCode context

## Quick Reference

### Global Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `,tt` | Toggle Neo-tree | Open/close file explorer |
| `,aa` | Add to OpenCode | Add file/directory to OpenCode (inside neo-tree) |

### Navigation (inside neo-tree)

| Key | Action |
|-----|--------|
| `j` / `k` | Move down/up |
| `<space>` | Toggle node (expand/collapse) |
| `<cr>` | Open file/directory |
| `P` | Toggle floating preview |

### File Operations

| Key | Action |
|-----|--------|
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |

### Splits & Windows

| Key | Action |
|-----|--------|
| `s` | Open in horizontal split |
| `v` | Open in vertical split |
| `t` | Open in new tab |
| `C` | Close node |
| `z` | Close all nodes |
| `Z` | Expand all nodes |
| `q` | Close neo-tree window |

### Display Controls

| Key | Action |
|-----|--------|
| `H` | Toggle hidden files |
| `I` | Toggle gitignored files |
| `/` | Fuzzy finder |
| `R` | Refresh tree |
| `.` | Set root to current directory |
| `i` | Show file details |
| `?` | Show help |

### Git Commands (in git_status view)

| Key | Action |
|-----|--------|
| `A` | Git add all |
| `ga` | Git add file |
| `gu` | Git unstage file |
| `gr` | Git revert file |
| `gc` | Git commit |
| `gp` | Git push |

## Configuration Details

### Filesystem Filtering

**Hidden by name**:
- `node_modules` - Node.js dependencies
- `__pycache__` - Python bytecode cache
- `.git` - Git repository metadata
- `.DS_Store` - macOS metadata files

**Never shown** (Nix-specific):
- `.direnv` - Nix direnv cache directory
- `result` - Nix build output symlinks

**Behavior**:
- Dotfiles are visible by default (toggle with `H`)
- Git-ignored files are visible by default (toggle with `I`)
- Filtered items can be made visible but never_show items are always hidden

### Git Integration

**Visual Indicators**:
- ✚ Added (new files staged)
-  Modified (changes in working tree)
- ✖ Deleted (files removed)
- 󰁕 Renamed (files moved/renamed)
-  Untracked (new files not staged)
-  Ignored (gitignored files)
- 󰄱 Unstaged (modified but not staged)
-  Staged (changes ready to commit)
-  Conflict (merge conflicts)

**Git Status View**:
- Opens in floating window (`:Neotree git_status`)
- Shows all changed files grouped by status
- Provides direct git operation mappings

### Auto-Follow Current File

When `follow_current_file` is enabled (default):
- Opening a file automatically expands tree to show it
- Tree updates to track the current buffer
- Previous directories are collapsed to reduce clutter

### File Watcher

Uses `libuv` file watcher to automatically refresh the tree when:
- Files are created/deleted externally
- Directories are added/removed
- Git status changes

## Common Workflows

### Navigate and Open File

```
,tt           → Toggle neo-tree
j/k           → Navigate to file
<cr>          → Open file
q             → Close neo-tree
```

### Create and Rename File

```
,tt           → Open neo-tree
a             → Add new file
<type name>   → Enter filename
<cr>          → Confirm
r             → Rename (if needed)
<new name>    → Enter new name
```

### Open File in Split

```
,tt           → Open neo-tree
j/k           → Navigate to file
s             → Open in horizontal split
  or
v             → Open in vertical split
  or
t             → Open in new tab
```

### Git Status Workflow

```
,tt           → Open neo-tree
                (Git symbols show next to files with changes)
ga            → Stage specific file
A             → Stage all changes
gc            → Commit (opens commit message prompt)
gp            → Push to remote
```

### View Git Changes

```
:Neotree git_status
                → Open floating git status view
j/k           → Navigate changed files
<cr>          → Open file to review changes
ga            → Stage file
gu            → Unstage file
```

### Filter and Search

```
,tt           → Open neo-tree
H             → Toggle hidden files visibility
I             → Toggle gitignored files visibility
/             → Fuzzy finder (search files by name)
<type query>  → Enter search term
<cr>          → Jump to result
```

### Refresh and Navigate

```
,tt           → Open neo-tree
R             → Refresh tree (rescan filesystem)
.             → Set current directory as tree root
z             → Collapse all nodes
Z             → Expand all nodes
```

### Copy/Move Operations

```
,tt           → Open neo-tree
j/k           → Navigate to file
y             → Copy to clipboard (yank)
j/k           → Navigate to destination
p             → Paste from clipboard
  or
c             → Copy (internal)
j/k           → Navigate to destination
p             → Paste
  or
m             → Move (prompts for destination)
```

### OpenCode Integration

```
,tt           → Open neo-tree
j/k           → Navigate to file or directory
,aa           → Add to OpenCode context
                (For directories, shows confirmation prompt)
```

## Performance Notes

### Lazy Loading
- Neo-tree is not loaded at Neovim startup
- First invocation (`,tt`) loads the plugin (~100-200ms)
- Subsequent toggles are instant

### File Watching
- Automatically refreshes on external file changes
- No manual refresh needed in most cases
- Can be disabled if causing performance issues on large trees

### Filtering Impact
- `never_show` patterns reduce tree size
- Nix-specific filters prevent scanning large cache directories
- Hidden and gitignored filters are toggleable for flexibility

### Tree Size Optimization
- Auto-collapse previous directories reduces visual clutter
- Lazy loading of directory contents (expanded on demand)
- Git status computed only for visible items

## Troubleshooting

### Tree Not Updating
```
R             → Manual refresh
```

### Git Symbols Not Showing
Verify you're in a git repository:
```bash
git status    # Should show repository info
```

### Hidden Files Not Visible
```
H             → Toggle hidden files
```

### Can't Find File
Use fuzzy finder:
```
/             → Open fuzzy finder
<type name>   → Search
```

### Performance Issues on Large Directories
Consider:
1. Setting tree root to deeper directory: Navigate to dir and press `.`
2. Using gitignored filter: Press `I` to hide ignored files
3. Closing unused nodes: Press `z` to collapse all

## Configuration Location

**Plugin module**: `config/lua/dave-vim/plugins/neo-tree.lua`
**Lazy loader registry**: `config/lua/dave-vim/lz-n.lua`
**Global keybindings**: `config/lua/dave-vim/maps.lua` (if any)

## Related Documentation

- **Master keybindings**: `docs/keybindings-master.md`
- **Neo-tree upstream docs**: https://github.com/nvim-neo-tree/neo-tree.nvim
- **Nix patterns**: `CLAUDE.md` (architecture overview)

## See Also

- Telescope: Fuzzy file finding (`,ff`, `,fg`)
- Oil.nvim: Alternative file explorer (if configured)
- Tagbar: Code structure navigation (`\tt`)
