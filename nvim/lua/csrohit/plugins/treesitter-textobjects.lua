return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        -- Directly require the functional modules
        local select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "lua", "python", "javascript" },
            callback = function(args)
                local bufnr = args.buf
                local opts = { buffer = bufnr, silent = true }

                -- Check if parser is ready to avoid the E5108 crash
                local ok, _ = pcall(vim.treesitter.get_parser, bufnr)
                if not ok then return end

                ---------------------------------------------------------
                -- SELECTION (if/af/ic/ac)
                ---------------------------------------------------------
                vim.keymap.set({ "x", "o" }, "af", function()
                    select.select_textobject("@function.outer", "textobjects")
                end, opts)

                vim.keymap.set({ "x", "o" }, "if", function()
                    select.select_textobject("@function.inner", "textobjects")
                end, opts)

                ---------------------------------------------------------
                -- NAVIGATION ([f / ]f)
                ---------------------------------------------------------
                -- Buffer-local mappings override global plugin defaults
                vim.keymap.set({ "n", "x", "o" }, "[f", function()
                    move.goto_previous_start("@function.outer", "textobjects")
                end, opts)

                vim.keymap.set({ "n", "x", "o" }, "]f", function()
                    move.goto_next_start("@function.outer", "textobjects")
                end, opts)
                
                -- End of function
                vim.keymap.set({ "n", "x", "o" }, "[F", function()
                    move.goto_previous_end("@function.outer", "textobjects")
                end, opts)

                vim.keymap.set({ "n", "x", "o" }, "]F", function()
                    move.goto_next_end("@function.outer", "textobjects")
                end, opts)
            end,
        })
    end,
}
