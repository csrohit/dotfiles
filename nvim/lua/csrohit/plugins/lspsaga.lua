--File: lua/csrohit/plugins/lspsaga.lua

return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
        local saga = require("lspsaga")
        saga.setup({})

        -- LSP finder - Find the symbol's definition
        -- If there is no definition, it will instead be hidden
        -- When you use an action in finder like "open vsplit",
        -- you can use <C-t> to jump back
        Nmap("gh", "<cmd>Lspsaga finder<CR>", { desc = "LspSaga finder" })

        -- Code action
        Map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LspSaga Code Action" })

        -- Rename all occurrences of the hovered word for the entire file
        Nmap("gr", "<cmd>Lspsaga rename<CR>", { desc = "LspSaga rename symbol" })

        -- Rename all occurrences of the hovered word for the selected files
        Nmap("gR", "<cmd>Lspsaga rename ++project<CR>")

        -- Peek definition
        -- You can edit the file containing the definition in the floating window
        -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
        -- It also supports tagstack
        -- Use <C-t> to jump back
        Nmap("gp", "<cmd>Lspsaga peek_definition<CR>")

        -- Go to definition
        Nmap("gd", "<cmd>Lspsaga goto_definition<CR>")

        -- Peek type definition
        -- You can edit the file containing the type definition in the floating window
        -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
        -- It also supports tagstack
        -- Use <C-t> to jump back
        Nmap("<leader>gt", "<cmd>Lspsaga peek_type_definition<CR>")

        -- Go to type definition
        Nmap("gt", "<cmd>Lspsaga goto_type_definition<CR>")

        -- Show line diagnostics
        -- You can pass argument ++unfocus to
        -- unfocus the show_line_diagnostics floating window
        -- Nmap("<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>")

        -- Show cursor diagnostics
        -- Like show_line_diagnostics, it supports passing the ++unfocus argument
        -- Nmap("<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

        -- Show buffer diagnostics
        -- Nmap("<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>")

        -- Diagnostic jump
        -- You can use <C-o> to jump back to your previous location
        Nmap("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        Nmap("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")

        -- Diagnostic jump with filters such as only jumping to an error
        Nmap("[D", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end)
        Nmap("]D", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)

        -- Toggle outline
        Nmap("<leader>o", "<cmd>Lspsaga outline<CR>")

        -- Hover Doc
        -- If there is no hover doc,
        -- there will be a notification stating that
        -- there is no information available.
        -- To disable it just use ":Lspsaga hover_doc ++quiet"
        -- Pressing the key twice will enter the hover window
        Nmap("K", "<cmd>Lspsaga hover_doc<CR>")

        -- If you want to keep the hover window in the top right hand corner,
        -- you can pass the ++keep argument
        -- Note that if you use hover with ++keep, pressing this key again will
        -- close the hover window. If you want to jump to the hover window
        -- you should use the wincmd command "<C-w>w"
        -- Nmap("K", "<cmd>Lspsaga hover_doc ++keep<CR>")

        -- Call hierarchy
        Nmap("<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
        Nmap("<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

        -- Floating terminal
        Map({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
    end,
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        --Please make sure you install markdown and markdown_inline parser
        { "nvim-treesitter/nvim-treesitter" },
    },
}
