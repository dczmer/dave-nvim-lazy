# OpenCode Keybinding Reference

Quick reference for all OpenCode keybindings in dave-nvim-lazy.

## Leader Key
- Leader: `,` (comma)
- All OpenCode commands use `<leader>a` prefix

## Quick Reference Table

### Context-Aware Prompts (Normal Mode)

| Keybinding | Description | Context |
|------------|-------------|---------|
| `,as` | Ask OpenCode with context | Uses @this |
| `,ae` | Explain code | Uses @this |
| `,af` | Find bugs | Uses @this |
| `,ar` | Refactor code | Uses @this |
| `,at` | Write tests | Uses @this |
| `,ad` | Add documentation | Uses @this |
| `,ai` | Improve/optimize code | Uses @this |

### Visual Mode Prompts

| Keybinding | Description | Context |
|------------|-------------|---------|
| `,ae` (visual) | Explain selection | Uses @selection |
| `,af` (visual) | Find bugs in selection | Uses @selection |
| `,ar` (visual) | Refactor selection | Uses @selection |
| `,at` (visual) | Write tests for selection | Uses @selection |
| `,ad` (visual) | Document selection | Uses @selection |

### File & Context Management

| Keybinding | Description | Tool |
|------------|-------------|------|
| `,aF` | Search files to add | Telescope |
| `,aG` | Grep code to add | Telescope |
| `,aB` | Select buffers to add | Telescope |
| `,aa` | Add Neo-tree node | Neo-tree |
| `,ao` | Add range operator | Text operator |
| `,aoo` | Add current line | Text operator |

### Session Management

| Keybinding | Description |
|------------|-------------|
| `,an` | New session |
| `,al` | List sessions |
| `,ac` | Clear session |

### Mode Switching

| Keybinding | Description |
|------------|-------------|
| `,ab` | Switch to Build mode |
| `,ap` | Switch to Plan mode |

### Utilities

| Keybinding | Description |
|------------|-------------|
| `,ax` | Select operation menu |
| `,au` | Undo last change |
| `,ah` | Show help |
| `,ag` | Review git diff |

### Navigation

| Keybinding | Description |
|------------|-------------|
| `,ak` | Scroll up |
| `,aj` | Scroll down |

## Total Keybindings
- **Normal Mode**: 24 keybindings
- **Visual Mode**: 5 keybindings
- **Neo-tree**: 1 keybinding
- **Total**: 30 keybindings

## Specialized Agents

Switch agents in OpenCode TUI:
- `/agent nix-expert` - Nix and NixOS specialist
- `/agent neovim-expert` - Neovim and Lua specialist
- `/agent code-reviewer` - Read-only code reviewer
- `/agent build` - Default build agent

## Tips

1. **Multi-select in Telescope**: Press `<Tab>` to mark multiple files
2. **Visual Mode**: Select code with `v`, `V`, or `Ctrl-v`, then use prompts
3. **Context operators**: Use `,ao` like any vim operator (e.g., `,ao3j` for 3 lines)
4. **Which-key**: Press `,a` and wait to see all available commands
5. **Git workflow**: Use `,ag` before committing to review changes
