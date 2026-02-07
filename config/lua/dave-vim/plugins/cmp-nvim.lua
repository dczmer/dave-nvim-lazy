local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
require("luasnip.loaders.from_snipmate").lazy_load()

local select_opts = { behavior = cmp.SelectBehavior.Select }

local performance = {
    max_item_count = 15,
}

local completion = {
    completeopt = "menu,menuone,preview,noselect",
}

local sources = {
    { name = "nvim_lsp", keyword_length = 1, priority = 1000 },
    { name = "nvim_lsp_signature_help", keyword_length = 1, priority = 900 },
    { name = "luasnip", keyword_length = 2, priority = 750 },
    { name = "buffer", keyword_length = 3, priority = 500 },
    { name = "path", priority = 250 },
}

local mappings = function(cmp, select_opts)
    return {
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ select = true })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = true }),
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
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

local formatting = {
    format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "...",
    }),
}

local sorting = {
    comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
    },
}

local experimental = {
    ghost_text = {
        hl_group = "CmpGhostText",
    },
}

-- Define ghost text highlight (muted, like a comment)
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

cmp.setup({
    completion = completion,
    snippet = snippet,
    mapping = cmp.mapping.preset.insert(mappings(cmp, select_opts)),
    -- sources for autocompletion
    sources = cmp.config.sources(sources),
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            max_height = 20,
            max_width = 80,
        }),
    },
    view = {
        entries = { name = "custom", selection_order = "near_cursor" },
        docs = {
            auto_open = true,
        },
    },
    -- configure lspkind for vs-code like pictograms in completion menu
    formatting = formatting,
    performance = performance,
    sorting = sorting,
    experimental = experimental,
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- fix issue where cmp breaks tab-completion in vim command prompt
vim.keymap.set("c", "<tab>", "<C-z>", { silent = false })
