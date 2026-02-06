# nvim-dap Reference

Configuration: `config/lua/dave-vim/plugins/nvim-dap.lua`

## Overview

nvim-dap (Debug Adapter Protocol) provides debugging capabilities in Neovim. This configuration includes Python debugging support via dap-python and a custom sidebar UI for viewing debug information.

## Local Leader Key

All DAP commands use the local leader prefix: `\` (backslash)

## Quick Reference Table

### Sidebar Views

| Key | Action | View |
|-----|--------|------|
| `\dst` | Toggle sidebar | Toggle current sidebar on/off |
| `\dss` | Sessions view | Show debug sessions |
| `\dsc` | Scopes view | Show variable scopes |
| `\dsf` | Frames view | Show stack frames |
| `\dsr` | Threads view | Show running threads |
| `\dse` | Expression view | Show expressions |

### Debug Control

| Key | Action |
|-----|--------|
| `\dc` | Continue execution |
| `\dn` | Step over (next line) |
| `\di` | Step into function |
| `\dq` | Terminate debug session |
| `\drc` | Run to cursor |

### Stack Navigation

| Key | Action |
|-----|--------|
| `\d.` | Focus current frame |
| `\dk` | Move up stack frame |
| `\dj` | Move down stack frame |

### Breakpoints

| Key | Action |
|-----|--------|
| `\dbt` | Toggle breakpoint at cursor |
| `\dbl` | List all breakpoints |
| `\dbc` | Clear all breakpoints |

### REPL

| Key | Action |
|-----|--------|
| `\drt` | Toggle debug REPL (below split) |

## Common Workflows

### Starting a Debug Session

#### Python Debugging
```vim
" Open Python file
" Set breakpoints first
\dbt                     " Toggle breakpoint on current line

" Start debugging
:lua require('dap').continue()
" Or use keybinding after setting up launch configuration
\dc
```

### Basic Debugging Flow
```vim
" 1. Set breakpoints
\dbt                     " Set breakpoint at cursor

" 2. Start debugging
\dc                      " Start/continue execution

" 3. View debug information
\dsf                     " Show stack frames
\dsc                     " Show variable scopes

" 4. Step through code
\dn                      " Step over
\di                      " Step into

" 5. End session
\dq                      " Terminate
```

### Breakpoint Management
```vim
" Set breakpoints at key locations
\dbt                     " Toggle on current line
\dbt                     " Toggle again to remove

" Review all breakpoints
\dbl                     " List breakpoints

" Clear all at once
\dbc                     " Clear all breakpoints
```

### Inspecting Variables
```vim
" During debug session
\dsc                     " Show scopes (local/global variables)
\dse                     " Show expression view

" Use REPL for interactive inspection
\drt                     " Open REPL
" Type expressions to evaluate
" Example: print(variable_name)
```

### Stack Frame Navigation
```vim
" When paused at breakpoint
\dsf                     " Show stack frames

" Navigate call stack
\dk                      " Go up one frame (caller)
\dj                      " Go down one frame (callee)
\d.                      " Focus current frame
```

### Conditional Breakpoints
```lua
-- Use REPL or Lua command
:lua require('dap').set_breakpoint(vim.fn.input('Condition: '))
```

### Multiple Debug Sessions
```vim
\dss                     " Show sessions view
" View and switch between active debug sessions
```

## Sidebar Views Details

### Frames View (`\dsf`)
- Shows call stack
- Current function at top
- Parent functions below
- Click or navigate to jump to frame

### Scopes View (`\dsc`)
- Shows variables in current scope
- Local variables
- Global variables
- Expand/collapse nested structures

### Sessions View (`\dss`)
- Lists active debug sessions
- Useful when debugging multiple programs
- Shows session status

### Threads View (`\dsr`)
- Shows running threads
- Useful for multi-threaded applications
- See which thread is active

### Expression View (`\dse`)
- Custom expressions to watch
- Add expressions to monitor values
- Updates as you step through code

### Sidebar Toggle (`\dst`)
- Toggles current sidebar on/off
- Sidebar persists between view changes
- Opens last used view

## Python Debugging

### Setup
Python debugging is pre-configured with:
```lua
require("dap-python").setup("python3")
```

### Debug Python Script
1. Open Python file
2. Set breakpoints with `\dbt`
3. Start debugging with `\dc`
4. Use step commands to navigate

### Common Python Debugging
```vim
" Set breakpoint in function
\dbt

" Start script
\dc

" View local variables
\dsc

" Check expressions
\drt
>>> variable_name
>>> len(my_list)
```

## REPL Usage

### Opening REPL
```vim
\drt                     " Toggle REPL in bottom split
```

### REPL Features
- Evaluate expressions in current context
- Access variables at current breakpoint
- Execute Python code interactively
- View output immediately

### REPL Examples
```python
# In REPL during debug session
>>> variable_name              # View variable
>>> type(my_var)              # Check type
>>> dir(object)               # Inspect object
>>> my_function(test_data)    # Call functions
```

## Tips & Best Practices

### Breakpoint Strategy
1. Set breakpoints at function entry points
2. Add breakpoints before suspicious code
3. Use conditional breakpoints for loops
4. Review breakpoints with `\dbl` before running

### Efficient Debugging
1. **Step Over** (`\dn`): Skip function internals
2. **Step Into** (`\di`): Investigate function behavior
3. **Run to Cursor** (`\drc`): Skip to specific line
4. **Continue** (`\dc`): Run to next breakpoint

### Variable Inspection
1. Use Scopes view (`\dsc`) for overview
2. Use REPL (`\drt`) for complex expressions
3. Navigate stack (`\dk`/`\dj`) to check caller context
4. Add custom watches in Expression view (`\dse`)

### Sidebar Management
1. Start with Frames view (`\dsf`) for context
2. Switch to Scopes (`\dsc`) to check variables
3. Toggle off (`\dst`) to see more code
4. Keep REPL open for quick checks

### Multi-File Debugging
1. Set breakpoints in multiple files
2. Use `\dbl` to review all breakpoints
3. Use Frames view to track execution flow
4. Navigate stack to see caller context

## Troubleshooting

### Breakpoints not hitting
**Solutions**:
1. Verify file is being executed:
   ```vim
   \dss                  " Check sessions
   ```
2. Check breakpoint is set:
   ```vim
   \dbl                  " List breakpoints
   ```
3. Ensure debug session started:
   ```vim
   \dc                   " Start/continue
   ```

### Variables not showing
**Solutions**:
1. Check correct scope view:
   ```vim
   \dsc                  " Scopes view
   ```
2. Verify execution is paused:
   - Should be stopped at breakpoint
3. Navigate to correct frame:
   ```vim
   \dsf                  " Check frames
   \d.                   " Focus frame
   ```

### REPL not working
**Solutions**:
1. Ensure debug session is active
2. Toggle REPL:
   ```vim
   \drt                  " Close and reopen
   ```
3. Check you're at a breakpoint (not running)

### Python debugger not starting
**Solutions**:
1. Verify python3 is available:
   ```bash
   which python3
   ```
2. Check dap-python is installed:
   ```vim
   :Lazy
   " Look for nvim-dap-python
   ```
3. Ensure debugpy is installed:
   ```bash
   pip install debugpy
   ```

## Dependencies

Required plugins:
- `mfussenegger/nvim-dap` - Core DAP client
- `mfussenegger/nvim-dap-python` - Python debugging support

Python requirements:
- `debugpy` - Python debug adapter

Install debugpy:
```bash
pip install debugpy
```

## Advanced Configuration

### Custom Launch Configurations

Add to init.lua or separate config:
```lua
local dap = require('dap')

-- Example: Python with arguments
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file with args",
    program = "${file}",
    args = {"arg1", "arg2"},
  },
}
```

### Additional Languages

To add more languages, install appropriate debug adapters:
- JavaScript/TypeScript: nvim-dap-vscode-js
- Go: delve
- C/C++/Rust: codelldb

## Related Configuration

- **Core keybindings**: `docs/keybindings-core.md`
- **Local leader**: Set in `config/lua/dave-vim/maps.lua`
- **Plugin management**: Lazy.nvim specification in nvim-dap.lua

## Keybinding Mnemonic Guide

- `d` = debug
- `s` = sidebar
- `t` = toggle
- `c` = continue/clear/scopes
- `n` = next
- `i` = into
- `q` = quit
- `b` = breakpoint
- `r` = run/repl/threads
- `e` = expression
- `f` = frames
- `k`/`j` = up/down (Vim motion)
