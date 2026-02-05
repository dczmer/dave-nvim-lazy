# Core Keybindings Reference

Configuration: `config/lua/dave-vim/maps.lua`

Quick reference for core Neovim keybindings in dave-nvim-lazy.

## Leader Keys

- **Leader**: `,` (comma)
- **Local Leader**: `\` (backslash)

## Quick Reference Table

### Function Keys

| Key | Mode | Action |
|-----|------|---------|
| `<F4>` | Normal | Toggle paste mode |
| `<F11>` | Normal | Previous buffer |
| `<F12>` | Normal | Next buffer |

### Function Keys (LSP - Active in LSP buffers only)

| Key | Mode | Action |
|-----|------|---------|
| `<F2>` | Normal | Rename symbol |
| `<F3>` | Normal, Visual | Format code |
| `<F5>` | Normal | Code actions |

### Local Leader Commands

| Key | Mode | Action |
|-----|------|---------|
| `\rnu` | Normal | Toggle relative line numbers |

### LSP Navigation (Active when LSP attached)

| Key | Mode | Action |
|-----|------|---------|
| `K` | Normal | Show hover documentation |
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `go` | Normal | Go to type definition |
| `gr` | Normal | Show references |
| `gs` | Normal | Show signature help |

### LSP Diagnostics (Active when LSP attached)

| Key | Mode | Action |
|-----|------|---------|
| `gl` | Normal, Visual | Open diagnostic float |
| `[d` | Normal, Visual | Go to previous diagnostic |
| `]d` | Normal, Visual | Go to next diagnostic |

### Terminal Mode

| Key | Mode | Action |
|-----|------|---------|
| `<ESC>` | Terminal | Exit to normal mode |
| `<C-h>` | Terminal | Navigate to left window |
| `<C-j>` | Terminal | Navigate to down window |
| `<C-k>` | Terminal | Navigate to up window |
| `<C-l>` | Terminal | Navigate to right window |

## Common Workflows

### Buffer Navigation
```vim
<F11>                    " Previous buffer
<F12>                    " Next buffer
```

### LSP Code Navigation
```vim
" Place cursor on symbol
gd                       " Jump to definition
gD                       " Jump to declaration
gi                       " Jump to implementation
gr                       " List all references
```

### LSP Documentation
```vim
" Place cursor on symbol
K                        " Show hover documentation
gs                       " Show function signature
```

### Code Editing with LSP
```vim
" Place cursor on symbol
<F2>                     " Rename across project

" Select code or place cursor
<F3>                     " Format code

" Place cursor on error/warning
<F5>                     " Show available code actions
```

### Diagnostic Navigation
```vim
gl                       " Show diagnostic details
[d                       " Jump to previous diagnostic
]d                       " Jump to next diagnostic
```

### Terminal Window Usage
```vim
:terminal                " Open terminal
<ESC>                    " Exit insert mode in terminal
<C-h/j/k/l>             " Navigate between windows from terminal
```

## LSP Keybindings Details

### Automatic Activation
LSP keybindings are automatically enabled when:
1. A language server attaches to a buffer
2. The file type is supported by an LSP server
3. LSP server successfully starts

### Buffer-Local Bindings
LSP keybindings are buffer-local, meaning:
- Only active in buffers with attached LSP
- Different buffers may have different LSP servers
- No conflicts with non-LSP buffers

### Supported Languages
LSP keybindings work with any configured language server:
- See `config/lua/dave-vim/plugins/lsp/` for server configs
- Commonly: Python, JavaScript, TypeScript, Lua, Rust, Go, etc.

## Tips & Best Practices

### Buffer Management
1. Use `<F11>`/`<F12>` for quick buffer switching
2. Combine with `:ls` to see all buffers
3. Use `:bd` to close unwanted buffers

### LSP Navigation
1. **Jump and return**: Use `<C-o>` to jump back after `gd`
2. **References workflow**: `gr` → review list → `<CR>` to jump
3. **Hover docs**: Press `K` twice to enter floating window

### Code Formatting
1. **Visual selection**: Select code, then `<F3>` to format selection
2. **Whole file**: Use `<F3>` in normal mode to format entire file
3. **Auto-format**: Some LSPs format on save automatically

### Diagnostics
1. **Quick review**: Use `[d` and `]d` to cycle through issues
2. **Details**: Press `gl` to see full diagnostic message
3. **Fix issues**: Use `<F5>` on diagnostics to see fix options

### Terminal Integration
1. Open terminal with `:terminal` or `:split | terminal`
2. Use `<ESC>` to exit insert mode
3. Navigate between terminal and editor with `<C-h/j/k/l>`
4. Use `:q` to close terminal window

## Paste Mode

### Usage
```vim
<F4>                     " Toggle paste mode
```

### When to Use
- Pasting code from external sources
- Prevents auto-indentation issues
- Disables auto-completion temporarily
- Press `<F4>` again to disable after pasting

## Relative Line Numbers

### Usage
```vim
\rnu                     " Toggle relative line numbers
```

### Benefits
- Easier to use motion commands (`10j`, `5k`)
- See distance to target lines
- Helpful for quick navigation

## Related Configuration

- **Plugin keybindings**: See individual plugin configs in `config/lua/dave-vim/plugins/`
- **LSP servers**: `config/lua/dave-vim/plugins/lsp/`
- **OpenCode bindings**: `docs/opencode-keybindings.md`
- **Which-key**: Press `,` or `\` and wait to see available commands
