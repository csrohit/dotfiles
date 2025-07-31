--File: lua/csrohit/plugins/telescope.lua

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
       "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    opts = {
        extensions = {
            fzf = {
                fuzzy = true,       -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        },
    },
    config = function()
        pcall(require("telescope").load_extension, "mapper")
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "file_browser")

        local builtin = require("telescope.builtin")
        -- See `:help telescope.builtin`
        Nmap("<leader>fr", builtin.oldfiles, { desc = "Find recently opened files" })
        Nmap("<leader>fb", builtin.buffers, { desc = "Find existing buffers" })
        Nmap("<leader>ff", builtin.find_files, { desc = "Find files" })
        Nmap("<leader>fg", builtin.live_grep, { desc = "Find in workspace" })
        Nmap("<leader>fw", builtin.grep_string, { desc = "Find current word in workspace" })
        Nmap("<leader>f?", builtin.help_tags, { desc = "Find help" })
        Nmap("<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
        Nmap("<leader>fc", builtin.commands, { desc = "Find commands" })
        Nmap("<leader><space>", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })

        -- telescope git commands (not on youtube nvim video)
        Nmap("<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "List git commits" })               -- list all git commits (use <cr> to checkout) ["gc" for git commits]
        Nmap("<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = "List git commits for current file" }) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
        Nmap("<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "List git branches" })             -- list git branches (use <cr> to checkout) ["gb" for git branch]
        Nmap("<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Show git status" })                 -- list current changes per file with diff preview ["gs" for git status]

        Nmap("<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "Fuzzily search in current buffer" })
    end,
}
