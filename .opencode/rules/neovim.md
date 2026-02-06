# Neovim Configuration Standards

## API Guidelines

- **Use modern APIs**: Prefer `vim.*` over `vim.fn` where possible
  - Use `vim.keymap.set()` instead of `vim.api.nvim_set_keymap()`
  - Use `vim.diagnostic.*` for diagnostics
  - Use `vim.lsp.*` for LSP operations

- **Avoid deprecated APIs**: 
  - Don't use `vim.lsp.buf_get_clients()` → use `vim.lsp.get_active_clients()`
  - Don't use old vimscript commands when Lua equivalents exist

## Lazy-Loading with lz.n

- Follow the plugin module pattern:
  ```lua
  return {
      lazy = function()
          return {
              "plugin-name",
              after = setup,
              keys = keys,
          }
      end
  }
  ```

- Keep plugin-specific config in separate module files
- Load LSPs by filetype for optimal startup time
- Use `lazy = false` only when necessary (treesitter, cmp)

## Code Style

- **Indentation**: 4 spaces (set in settings.lua)
- **Line length**: No hard limit, but keep readable
- **Comments**: Explain why, not what
- **Organization**: Group related functions, use section headers

## Plugin Configuration

- One file per plugin in `config/lua/dave-vim/plugins/`
- Keep `setup()` function for plugin initialization
- Define `keys` table for lazy-loading keybindings
- Use descriptive keybinding descriptions for which-key

## Performance

- Minimize startup time (current: fast with lazy-loading)
- Lazy-load plugins by event, filetype, or key
- Don't load all language LSPs at startup
- Use `vim.schedule()` for non-critical initialization
