vim.g.mapLeader = ","
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<F4>", "<cmd>set paste!<cr>")
vim.keymap.set("n", "<F11>", "<cmd>bprev<cr>")
vim.keymap.set("n", "<F12>", "<cmd>bnext<cr>")

vim.keymap.set("n", "<localleader>rnu", "<cmd>set rnu!<cr>")

-- Create the lsp keymaps only when a language server is active
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set('n', '<F5>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set({ "n", "x" }, "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    end,
})
