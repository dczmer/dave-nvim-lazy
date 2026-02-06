# nvim-cmp Reference

Configuration: `config/lua/dave-vim/plugins/cmp-nvim.lua`

## Overview

nvim-cmp provides intelligent autocompletion in Neovim with multiple sources including LSP, snippets, buffers, and file paths. Features VS Code-like pictograms and bordered windows for an enhanced completion experience.

## Key Features
- Performance-optimized with 15-item display limit
- Source priority ranking (LSP > signatures > snippets > buffer > path)
- Intelligent sorting with recently-used preference
- Ghost text for inline suggestions
- Auto-opening documentation window

## Keybindings

### Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Insert | Next item / Jump to next snippet placeholder |
| `<S-Tab>` | Insert | Previous item / Jump to previous snippet placeholder |
| `<Down>` | Insert | Select next completion item |
| `<Up>` | Insert | Select previous completion item |
| `<C-n>` | Insert | Select next completion item |
| `<C-p>` | Insert | Select previous completion item |

### Documentation

| Key | Mode | Action |
|-----|------|--------|
| `<C-d>` | Insert | Scroll documentation down (4 lines) |
| `<C-u>` | Insert | Scroll documentation up (4 lines) |

### Actions

| Key | Mode | Action |
|-----|------|--------|
| `<C-Space>` | Insert | Manually trigger completion menu |
| `<CR>` | Insert | Confirm selected item (only if explicitly selected) |
| `<C-e>` | Insert | Abort completion and close menu |

### Command-Line

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Command | Native Vim completion (mapped to `<C-z>`) |

## Completion Sources

Sources are queried in priority order (highest to lowest):

### 1. nvim_lsp (Priority: 1000)
- **Type**: Language Server Protocol
- **Min length**: 1 character
- **Triggers**: Context-aware suggestions
- **Example**: Function names, variables, imports

### 2. nvim_lsp_signature_help (Priority: 900)
- **Type**: Function signatures
- **Min length**: 1 character
- **Triggers**: Inside function calls
- **Example**: Parameter names and types

### 3. luasnip (Priority: 750)
- **Type**: Code snippets
- **Min length**: 2 characters
- **Triggers**: Snippet keywords
- **Example**: `for`, `func`, `if`, custom snippets

### 4. buffer (Priority: 500)
- **Type**: Current file content
- **Min length**: 3 characters
- **Triggers**: Words in current buffer
- **Example**: Variable names already in file

### 5. path (Priority: 250)
- **Type**: File system paths
- **Min length**: None
- **Triggers**: Path-like patterns
- **Example**: `./src/`, `~/config/`

## Common Use Cases

### Basic Completion
1. Type in insert mode
2. Menu appears automatically after min keyword length
3. Navigate with `<Tab>` or arrow keys
4. Press `<CR>` to accept or `<C-e>` to dismiss

### Snippet Expansion
1. Type snippet trigger (e.g., `for`)
2. Select from completion menu
3. Press `<CR>` to expand
4. Use `<Tab>` to jump between placeholders
5. Use `<S-Tab>` to jump backwards

### Documentation Preview
1. Navigate completion items with `<C-n>`/`<C-p>`
2. Documentation appears in bordered window
3. Scroll long docs with `<C-d>`/`<C-u>`
4. Accept item with `<CR>` or cancel with `<C-e>`

### Manual Trigger
- Press `<C-Space>` anywhere to force completion menu
- Useful when typing doesn't trigger automatically
- Helpful for exploring available completions

### Search Completion
1. Press `/` or `?` to start search
2. Type pattern
3. Buffer text completion suggests matches
4. Use `<Tab>` for standard Vim command completion

## Configuration Details

### Completion Behavior
```lua
completeopt = "menu,menuone,preview,noselect"
```
- Shows menu for single/multiple matches
- Preview window enabled
- No auto-selection of first item

### Window Appearance
- Bordered completion menu
- Bordered documentation window
- Custom NormalFloat/FloatBorder highlighting
- Max width: 50 characters with ellipsis

### Smart Enter Key
Enter key confirms only when item is explicitly selected:
- Menu visible + item selected → Confirm completion
- Menu visible + no selection → Normal newline
- Prevents accidental completions

### Snippet Engine
- Uses LuaSnip for snippet expansion
- Loads SnipMate-style snippets lazily
- Snippet files: Check `~/.config/nvim/snippets/`

## Performance Optimizations

**Max Items**: Limited to 15 visible completions for optimal rendering speed
- Reduces memory usage with large completion lists
- Faster menu display and navigation
- Adjust `performance.max_item_count` in config if needed

**Source Priorities**:
- LSP (1000): Primary completions from language server
- Signature Help (900): Function signatures during calls
- Snippets (750): Code templates and patterns
- Buffer (500): Words from current file
- Path (250): File system paths

## Sorting Strategy

Custom comparators optimize completion order:
1. **Exact matches**: Prioritized first
2. **Recently used**: Items you've selected before
3. **Score**: Relevance to current context
4. **Kind**: Groups similar types (methods, properties, etc.)
5. **Length**: Shorter suggestions when scores equal

## Ghost Text

Experimental inline completion preview:
- **Appearance**: First completion shown as muted text (Comment style)
- **Usage**: See suggestion while typing without opening menu
- **Highlight**: `CmpGhostText` linked to `Comment` group

To disable: Remove `experimental` section from config

## Auto-Opening Documentation

Documentation window appears automatically when navigating completions:
- **Trigger**: Selecting any completion item
- **Size**: Max 20 lines × 80 columns
- **Manual scroll**: Use `<C-d>` (down) and `<C-u>` (up)
- **Disable**: Set `view.docs.auto_open = false` in config

## Dependencies

Required plugins:
- `hrsh7th/nvim-cmp` - Core engine
- `L3MON4D3/LuaSnip` - Snippets
- `onsails/lspkind.nvim` - Icons
- `hrsh7th/cmp-nvim-lsp` - LSP source
- `hrsh7th/cmp-buffer` - Buffer source
- `hrsh7th/cmp-path` - Path source
- `hrsh7th/cmp-nvim-lsp-signature-help` - Signatures
- `saadparwaiz1/cmp_luasnip` - Snippet integration

## Troubleshooting

### Completion not appearing
Check minimum keyword lengths:
- LSP/signatures: 1 char
- Snippets: 2 chars
- Buffer: 3 chars

### Ghost text not visible
Check highlight configuration:
```lua
:hi CmpGhostText
```
Should link to `Comment`. Colorscheme may override.

### Too few/many completion items
Adjust `performance.max_item_count` in `cmp-nvim.lua`:
- Current: 15 (default)
- Increase: More options (slower rendering)
- Decrease: Faster but fewer choices

### Documentation window too intrusive
Disable auto-open in config:
```lua
view = {
    docs = {
        auto_open = false,
    },
},
```
Use `<C-d>` to manually trigger documentation.

### Wrong completion priority
Source priorities in config control order:
- Higher number = higher priority
- LSP should be 1000 (most relevant)
- Adjust individual source `priority` values as needed

### Tab not working in command mode
Fixed at line 101:
```lua
vim.keymap.set("c", "<tab>", "<C-z>", { silent = false })
```

### Snippets not expanding
Verify:
1. LuaSnip installed
2. Snippet files in correct location
3. SnipMate loader working

### Enter creates newline instead of accepting
This is by design - item must be explicitly selected. Use `<Tab>` to select, then `<CR>` to confirm.

## Related Configuration

- **LSP setup**: `config/lua/dave-vim/plugins/lsp/`
- **Snippet files**: Loaded via SnipMate format
- **Icons**: Configured through lspkind.nvim
