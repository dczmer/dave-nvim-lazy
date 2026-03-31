local after = function()
    require("davewiki").setup({
        wiki_root = "~/davewiki",
        highlight_tags = true,
        show_tag_backlinks = true,
        telescope = {
            enabled = true,
        },
        journal = {
            enabled = true,
        },
        cmp = {
            enabled = true,
        },
    })

    -- bind `jump_to_tag` to `<CR>` for navigation
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.keymap.set("n", "<CR>", function()
                -- Try tag first, then link
                if not davewiki.tags.jump_to_tag() then
                    davewiki.markdown.jump_to_link()
                end
            end, { buffer = true, desc = "Jump to tag or link under cursor" })
        end,
    })

    -- davewiki view keymaps
    vim.keymap.set(
        "n",
        "<leader>wv",
        "<cmd>DavewikiGenerateViewFromCursor<CR>",
        { desc = "Generate tag view from cursor" }
    )

    vim.keymap.set("n", "<leader>wV", "<cmd>DavewikiGenerateView<CR>", { desc = "Pick tag and generate view" })

    vim.keymap.set(
        "n",
        "<leader>wvf",
        "<cmd>DavewikiGenerateViewFromTagFile<CR>",
        { desc = "Generate view from current tag file" }
    )

    -- davewiki telescope keymaps
    vim.keymap.set("n", "<leader>wt", function()
        require("davewiki").telescope.tags()
    end, { desc = "Open davewiki tags picker" })

    vim.keymap.set("n", "<leader>wT", function()
        require("davewiki").telescope.tag_references()
    end, { desc = "Search davewiki tag references" })

    vim.keymap.set("n", "<leader>wh", function()
        require("davewiki").telescope.headings()
    end, { desc = "Search davewiki headings" })

    vim.keymap.set("n", "<leader>wl", function()
        require("davewiki").telescope.insert_link()
    end, { desc = "Insert markdown link to wiki file" })

    vim.keymap.set("n", "<leader>wjp", function()
        require("davewiki").telescope.jump_to_journal()
    end, { desc = "Browse journal files with telescope" })

    -- davewiki journal keymaps
    vim.keymap.set("n", "<leader>wjt", "<cmd>DavewikiJournalToday<CR>", { desc = "Open today's journal" })

    vim.keymap.set("n", "<leader>wjy", "<cmd>DavewikiJournalYesterday<CR>", { desc = "Open yesterday's journal" })

    vim.keymap.set("n", "<leader>wjT", "<cmd>DavewikiJournalTomorrow<CR>", { desc = "Open tomorrow's journal" })

    vim.keymap.set("n", "<leader>wjo", "<cmd>DavewikiJournalOpen<CR>", { desc = "Open journal for specific date" })
end

return {
    lazy = function()
        return {
            "davewiki2",
            after = after,
            ft = { "markdown" },
        }
    end,
}
