# OpenCode Usage Guide

Practical guide for using OpenCode integration in dave-nvim-lazy.

## Getting Started

### Starting OpenCode
OpenCode runs in a tmux pane. The configuration is already set up in `opencode.lua`.

### Basic Workflow
1. Open Neovim
2. Navigate to code you want to discuss
3. Use `,a` keybindings to interact with OpenCode
4. OpenCode responds in separate tmux pane

## Common Workflows

### Workflow 1: Understanding Code
```vim
" Navigate to unfamiliar code
,ae                    " Explain this code
" Or select specific part:
v (select code)
,ae                    " Explain selection
```

### Workflow 2: Code Review
```vim
" Review current file
,af                    " Find bugs in @this

" Or review specific function
v (select function)
,af                    " Find bugs in selection
```

### Workflow 3: Refactoring
```vim
" Select messy code
V (select lines)
,ar                    " Refactor selection
" OpenCode suggests improvements
```

### Workflow 4: Adding Tests
```vim
" Position cursor in function
,at                    " Write tests for @this
" Or select specific code
v (select)
,at                    " Write tests for selection
```

### Workflow 5: Multi-File Context
```vim
" Use Telescope to add multiple files
,aF                    " Open file picker
" Type to search, press Tab to multi-select
" Press Enter to add to context
" Type your question
```

### Workflow 6: Grep-Based Context
```vim
" Find all authentication code
,aG                    " Open grep
" Type: "authenticate"
" Tab to select matches
" Enter to add files
" Ask: "Explain authentication flow"
```

### Workflow 7: Pre-Commit Review
```vim
" Before committing
,ag                    " Review git diff
" OpenCode analyzes your changes
" Make fixes based on feedback
" Then commit
```

### Workflow 8: Using Specialized Agents

**Nix Help**:
```vim
" In OpenCode TUI:
/agent nix-expert
" Add flake.nix
,aF → select flake.nix
" Ask Nix-specific questions
"How do I add a new package?"
```

**Neovim Plugin Help**:
```vim
/agent neovim-expert
" Ask about plugin configuration
"How do I optimize lazy-loading?"
```

**Code Review**:
```vim
/agent code-reviewer
" Add files to review
,aF → select files
" Request review
"Security review of authentication"
```

## Session Management

### Creating Sessions
```vim
,an                    " New session
" Start fresh conversation
```

### Switching Sessions
```vim
,al                    " List sessions
" Select session from list
```

### Clearing Context
```vim
,ac                    " Clear current session
" Keeps session, removes history
```

## Tips & Best Practices

### Context Management
1. **Be specific**: Add only relevant files to context
2. **Use @this**: Position cursor precisely before `,ae`, etc.
3. **Visual mode**: Select exact code you want to discuss
4. **Multi-select**: Use Telescope for related files

### Agent Usage
1. **Switch early**: Choose agent before adding context
2. **Nix expert**: For flake.nix, derivations, NixOS
3. **Neovim expert**: For plugin configs, Lua code
4. **Code reviewer**: For security, performance reviews

### Performance
1. **Small model**: Used automatically for titles/summaries
2. **Context pruning**: Auto-enabled, old outputs removed
3. **File limits**: Keep selections under 10-15 files
4. **Session clear**: Use `,ac` to free up context

### Safety
1. **Permission prompts**: Review bash/write operations
2. **Undo available**: Use `,au` if needed
3. **Read-only reviewer**: Can't modify files
4. **Git review**: Use `,ag` before committing

## Mode Switching

### Plan Mode
```vim
,ap                    " Switch to Plan mode
" OpenCode analyzes and suggests
" Cannot modify files
" Good for: exploration, learning
```

### Build Mode
```vim
,ab                    " Switch to Build mode
" OpenCode can edit files
" Can run commands
" Good for: implementation
```

## Keyboard Shortcuts

### In Telescope Pickers
- Type: Search/filter
- `<Tab>`: Multi-select files
- `<Enter>`: Confirm selection
- `<Esc>`: Cancel

### In Neo-tree
- Navigate with `j/k`
- `,aa`: Add current node to OpenCode
- Confirms for directories

### In Visual Mode
- `v`: Character-wise selection
- `V`: Line-wise selection
- `Ctrl-v`: Block selection
- Then use `,ae`, `,af`, etc.

## Project-Specific Standards

OpenCode automatically loads project standards from:
- `README.md` - Project overview
- `CONTRIBUTING.md` - Contribution guidelines
- `.opencode/rules/*.md` - Custom rules

Standards are automatically followed without manual reminders.

## Troubleshooting

See `docs/opencode-troubleshooting.md` for common issues and solutions.
