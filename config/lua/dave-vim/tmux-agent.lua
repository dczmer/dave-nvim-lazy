-- === tmux-agent.lua ===
-- Send file references and prompts to a tmux pane running pi or opencode.
-- Uses tmux send-keys -l (literal mode). No shellescape needed.

local M = {}

local function escape_path(p)
    return (p:gsub(" ", "\\ "))
end

M.find_agent_pane = function(target)
    if not vim.env.TMUX then
        vim.notify("not inside tmux", vim.log.levels.ERROR)
        return nil
    end

    local pattern = "bin/[" .. target:sub(1, 1) .. "]" .. target:sub(2)
    local shell_cmd = string.format(
        "tmux list-panes -a -F '#{pane_id} #{pane_pid}' | while read -r id pid; do pstree \"$pid\" 2>/dev/null | grep -qE '%s' && echo \"$id\"; done",
        pattern
    )

    local output = vim.fn.system(shell_cmd)
    local pane_id = output:match("^%s*(%%?%d+)%s*$")
    if pane_id then
        vim.g.tmux_agent_pane = pane_id
        vim.notify("found agent pane: " .. pane_id, vim.log.levels.INFO)
        return pane_id
    end

    return nil
end

M.ensure_pane = function()
    if vim.g.tmux_agent_pane then
        return vim.g.tmux_agent_pane
    end

    local targets = { "pi", "opencode", "claude" }
    for _, target in ipairs(targets) do
        local pane = M.find_agent_pane(target)
        if pane then
            return pane
        end
    end

    vim.notify("no agent pane found (tried pi, opencode, claude)", vim.log.levels.ERROR)
    return nil
end

M.send_to_agent = function(text, opts)
    opts = opts or {}
    local pane = M.ensure_pane()
    if not pane then
        return
    end

    -- Use list form to bypass shell entirely, no escaping needed.
    vim.fn.system({ "tmux", "send-keys", "-l", "-t", pane, text })
    if opts.submit then
        vim.fn.system({ "tmux", "send-keys", "-t", pane, "Enter" })
    end
end

M.send_buffer = function()
    local filepath = escape_path(vim.fn.expand("%:p"))
    M.send_to_agent("@" .. filepath, { submit = false })
end

M.send_visual = function()
    local filepath = escape_path(vim.fn.expand("%:p"))
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    M.send_to_agent("@" .. filepath .. ":" .. start_line .. ":" .. end_line, { submit = false })
end

M.prompt_send = function()
    local filepath = escape_path(vim.fn.expand("%:p"))
    local cursor_line = vim.fn.line(".")
    local prefix = "@" .. filepath .. ":" .. cursor_line .. " "

    vim.ui.input({ prompt = "Agent: " .. prefix }, function(input)
        if not input or input == "" then
            return
        end
        M.send_to_agent(prefix .. input, { submit = true })
    end)
end

M.setup = function()
    -- === User commands ===

    vim.api.nvim_create_user_command("TmuxAgentFind", function(args)
        local target = args.args ~= "" and args.args or "pi"
        M.find_agent_pane(target)
    end, { nargs = "?", desc = "Find and cache agent tmux pane" })

    vim.api.nvim_create_user_command("TmuxAgentSend", function(args)
        M.send_to_agent(args.args, { submit = false })
    end, { nargs = "+", desc = "Send literal text to agent pane" })

    vim.api.nvim_create_user_command("TmuxAgentSendBuffer", function()
        M.send_buffer()
    end, { desc = "Send @FILE of current buffer to agent" })

    vim.api.nvim_create_user_command("TmuxAgentSendVisual", function()
        M.send_visual()
    end, { range = true, desc = "Send @FILE:START:END for visual selection" })

    vim.api.nvim_create_user_command("TmuxAgentPrompt", function()
        M.prompt_send()
    end, { desc = "Prompt for message, prepend @FILE:LINE, auto-submit" })

    -- === Keymaps ===

    vim.keymap.set("n", "<leader>af", "<cmd>TmuxAgentFind<cr>", { desc = "Find agent tmux pane" })
    vim.keymap.set("n", "<leader>ab", "<cmd>TmuxAgentSendBuffer<cr>", { desc = "Send buffer ref to agent" })
    vim.keymap.set("v", "<leader>av", "<cmd>TmuxAgentSendVisual<cr>", { desc = "Send visual range to agent" })
    vim.keymap.set("n", "<leader>ap", "<cmd>TmuxAgentPrompt<cr>", { desc = "Prompt agent (auto-submit)" })
end

return M
