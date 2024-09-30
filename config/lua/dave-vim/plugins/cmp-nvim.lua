local lspkind = require("lspkind")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local event = "InsertEnter"

local completion = {
    completeopt = "menu,menuone,preview,noselect",
}

local sources = {
    { name = "path" }, -- file system paths
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "buffer", keyword_length = 3 }, -- text within current buffer
    { name = "luasnip", keyword_length = 2 }, -- snippets
    { name = "nvim_lsp_signature_help", keyword_length = 1 }, -- snippets
}

local mappings = function(cmp, select_opts)
    return {
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }
end

local snippet = {
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end,
}

local window = function(cmp)
    return {
        documentation = cmp.config.window.bordered(),
    }
end

local formatting = {
    format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "...",
    }),
}

local setup = function()
    local cmp = require("cmp")
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
        completion = completion,
        snippet = snippet,
        mapping = cmp.mapping.preset.insert(mappings(cmp, select_opts)),
        -- sources for autocompletion
        sources = cmp.config.sources(sources),
        windw = window(cmp),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = formatting,
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- fix issue where cmp breaks tab-completion in vim command prompt
    vim.keymap.set("c", "<tab>", "<C-z>", { silent = false })
end

local lazy = function()
    return {
        "cmp-nvim",
        after = setup,
        event = event,
    }
end

return {
    lazy = lazy,
}
