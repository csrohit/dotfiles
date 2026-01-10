-- File: lua/csrohit/plugins/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local ts = require("nvim-treesitter")

        -- 1. Install parsers (Imperative approach for 'main' branch)
        ts.install({
            "bash", "c", "cpp", "diff", "html", "javascript", "json",
            "lua", "luadoc", "luap", "markdown", "markdown_inline",
            "python", "query", "vim", "vimdoc", "yaml",
        })

        -- 2. Enable Highlighting natively
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local bufnr = args.buf
                -- Check if parser is available before starting
                local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
                if lang then
                    pcall(vim.treesitter.start, bufnr, lang)

                    -- Setup Folding
                end
            end,
        })
    end,
}
