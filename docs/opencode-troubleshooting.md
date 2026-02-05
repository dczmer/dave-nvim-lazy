# OpenCode Troubleshooting Guide

Common issues and solutions for OpenCode integration.

## Installation & Loading

### Issue: OpenCode keybindings don't work
**Symptoms**: Pressing `,ae` or other OpenCode keys does nothing

**Solutions**:
1. Check if OpenCode plugin loaded:
   ```vim
   :Lazy
   " Look for opencode.nvim - should show as loaded
   ```

2. Check for Neovim errors:
   ```vim
   :messages
   " Look for errors mentioning opencode
   ```

3. Verify tmux provider:
   ```bash
   # OpenCode needs tmux
   echo $TMUX
   # Should show tmux session info
   ```

### Issue: Neovim startup errors
**Symptoms**: Errors on startup mentioning opencode.lua

**Solutions**:
1. Check Lua syntax:
   ```bash
   cd /home/dave/source/dave-nvim-lazy
   nvim config/lua/dave-vim/plugins/opencode.lua
   # Look for syntax errors
   ```

2. Check configuration:
   ```vim
   :lua vim.print(vim.g.opencode_opts)
   # Should show configuration table
   ```

## Keybinding Issues

### Issue: Which-key doesn't show OpenCode commands
**Symptoms**: Pressing `,a` doesn't show OpenCode in popup

**Solutions**:
1. Wait a moment after pressing `,a` (which-key has delay)
2. Check which-key is loaded:
   ```vim
   :Lazy
   " Look for which-key.nvim
   ```

### Issue: Visual mode keybindings don't work
**Symptoms**: Selecting code and pressing `,ae` doesn't work

**Solutions**:
1. Ensure you're in visual mode (`v`, `V`, or `Ctrl-v`)
2. Press `,ae` while still in visual mode (before `<Esc>`)
3. Check if @selection is supported in your OpenCode version

## Telescope Integration

### Issue: `,aF` doesn't open file picker
**Symptoms**: Pressing `,aF` shows error or nothing happens

**Solutions**:
1. Check Telescope is installed:
   ```vim
   :Lazy
   " Look for telescope.nvim
   ```

2. Check fd is available:
   ```bash
   which fd
   # Should show path to fd
   ```

3. If fd missing, check flake.nix includes it

### Issue: Multi-select doesn't work in Telescope
**Symptoms**: `<Tab>` doesn't mark files

**Solutions**:
1. Ensure Telescope is fully loaded
2. Try `<Tab>` multiple times (should see checkmarks)
3. Check Telescope version supports multi-select

## Agent Issues

### Issue: Cannot switch agents
**Symptoms**: `/agent nix-expert` doesn't work

**Solutions**:
1. Check agent configuration:
   ```vim
   :lua vim.print(vim.g.opencode_opts.agent)
   # Should show: nix-expert, neovim-expert, code-reviewer
   ```

2. Verify command syntax:
   ```
   /agent nix-expert    (correct)
   /agent:nix-expert    (incorrect)
   ```

3. Check OpenCode server version

### Issue: Code reviewer can still modify files
**Symptoms**: Read-only mode not enforced

**Solutions**:
1. Verify tools configuration:
   ```vim
   :lua vim.print(vim.g.opencode_opts.agent["code-reviewer"].tools)
   # Should show: write = false, edit = false, bash = false
   ```

2. Check OpenCode version supports tool restrictions

## Permission Issues

### Issue: No permission prompts appearing
**Symptoms**: Bash/write commands run without asking

**Solutions**:
1. Check permission configuration:
   ```vim
   :lua vim.print(vim.g.opencode_opts.permission)
   # Should show: bash = "ask", write = "ask"
   ```

2. Verify OpenCode server respects permissions
3. May need to restart OpenCode server

### Issue: Permission prompts are annoying
**Solutions**:
1. Adjust permissions in `opencode.lua`:
   ```lua
   permission = {
       bash = "allow",   -- Change from "ask"
       write = "ask",    -- Keep for safety
   }
   ```

2. Restart Neovim after changes

## Context Management

### Issue: OpenCode forgets context too quickly
**Symptoms**: Has to re-explain things frequently

**Solutions**:
1. Check compaction settings:
   ```vim
   :lua vim.print(vim.g.opencode_opts.compaction)
   # Should show: auto = true, prune = true
   ```

2. Use session management:
   ```vim
   ,al    " List sessions to return to old conversations
   ```

### Issue: "Context full" errors
**Solutions**:
1. Clear session: `,ac`
2. Start new session: `,an`
3. Remove old tool outputs (auto-enabled via prune)
4. Add fewer files at once (< 10-15 files)

## Git Integration

### Issue: `,ag` shows "No git changes"
**Symptoms**: Have uncommitted changes but get this message

**Solutions**:
1. Check git status:
   ```bash
   git status
   ```

2. Ensure in git repository:
   ```bash
   git rev-parse --git-dir
   ```

3. Stage changes first if using `git diff --staged`

## Neo-tree Integration

### Issue: `,aa` doesn't work in Neo-tree
**Symptoms**: Keybinding does nothing

**Solutions**:
1. Ensure you're in Neo-tree buffer:
   ```vim
   ,ft    " Toggle Neo-tree
   ```

2. Navigate to a file/directory in Neo-tree
3. Press `,aa` while in Neo-tree buffer

## Performance Issues

### Issue: Slow responses from OpenCode
**Solutions**:
1. Check model configuration (Haiku for simple tasks)
2. Reduce context size (fewer files)
3. Check network/API connectivity
4. Consider using smaller model

### Issue: Neovim startup slow
**Solutions**:
1. OpenCode loads lazily - shouldn't affect startup
2. Check other plugins: `:Lazy profile`
3. Verify lazy-loading is working

## Configuration Validation

### Check complete configuration:
```vim
:lua vim.print(vim.g.opencode_opts)
```

Should show:
- port: 6999
- provider: { enabled = "tmux" }
- model: "anthropic/claude-sonnet-4-5"
- agent: (3 agents)
- permission: { bash = "ask", write = "ask" }
- And other settings

### Check keybindings loaded:
```vim
:nmap <leader>ae
" Should show: Ask OpenCode to explain
```

## Getting Help

1. **Check messages**: `:messages` for errors
2. **Check config**: `:lua vim.print(vim.g.opencode_opts)`
3. **Check plugins**: `:Lazy` to verify all loaded
4. **Restart Neovim**: Sometimes fixes issues
5. **Check OpenCode server**: Ensure running in tmux

## Common Error Messages

### "OpenCode not available"
- OpenCode server not running or not in tmux
- Start OpenCode server in tmux pane

### "Telescope not available"
- Telescope plugin not loaded
- Check `:Lazy` and ensure telescope.nvim is there

### "No node selected in Neo-tree"
- Not in Neo-tree buffer or no file selected
- Open Neo-tree (`,ft`) and navigate to file

### "No git changes to review"
- No uncommitted changes
- Run `git status` to verify

## Debug Checklist

When something doesn't work:

- [ ] Check `:messages` for errors
- [ ] Verify plugin loaded in `:Lazy`
- [ ] Check configuration with `:lua vim.print(vim.g.opencode_opts)`
- [ ] Restart Neovim
- [ ] Check OpenCode server is running
- [ ] Verify in correct mode (normal/visual)
- [ ] Check which-key shows the keybinding
- [ ] Try basic command (`,as`) first
