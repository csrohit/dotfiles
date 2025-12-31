return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- CRITICAL: Use the new rewrite branch
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    config = function()
        local ts = require("nvim-treesitter")

        -- 1. Setup Parsers (Replaces ensure_installed)
        ts.install({
            "bash", "c", "diff", "html", "javascript", "json", "jsonc",
            "lua", "luadoc", "luap", "markdown", "markdown_inline",
            "printf", "python", "query", "regex", "toml", "vim",
            "vimdoc", "xml", "yaml",
        })

        -- 2. Enable Highlighting (Replaces highlight = { enable = true })
        -- The new branch requires using Neovim's native Treesitter API
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                pcall(vim.treesitter.start, buf)

                local ok, _ = pcall(vim.treesitter.get_parser)
                if ok then
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                else
                    vim.wo.foldmethod = "indent" -- Fallback to indent folding
                end
            end,
        })

        -- When opening a file unfold all
        vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
            pattern = "*",
            callback = function()
                vim.opt_local.foldlevel = 99
            end,
        })

        -- 3. Setup Indentation (Replaces indent = { enable = true })
        -- Note: Indentation is still evolving on the main branch
        vim.opt.smartindent = false -- Often recommended to let TS handle it
    end,
}
