--File: lua/csrohit/plugins/git-signs.lua
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- add configuration after loading
        local gs = require("gitsigns")
        gs.setup({
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,  -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        })
        Map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
        Map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")

        Nmap("<leader>hS", gs.stage_buffer, { desc = "Git Signs: stage buffer" })
        Nmap("<leader>ha", gs.stage_hunk, { desc = "Git Signs: stage hunk" })
        Nmap("<leader>hR", gs.reset_buffer, { desc = "Git Signs: reset buffer" })
        Nmap("<leader>hp", gs.preview_hunk, { desc = "Git Signs: stage hunk" })
        Nmap("<leader>hb", function()
            gs.blame_line({ full = true })
        end, { desc = "Git Signs: toggle blame line" })
        Nmap("<leader>tb", gs.toggle_current_line_blame, { desc = "Git Signs: toggle line blame" })
        Nmap("<leader>hd", gs.diffthis, { desc = "Git Signs: Diff hunk" })
        Nmap("<leader>hD", function()
            gs.diffthis("~")
        end, { desc = "Git Signs: diff file" })
        Nmap("<leader>td", gs.preview_hunk_inline, { desc = "Git Signs: toggle deleted" })

        -- Text object
        Map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
}
