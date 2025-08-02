-- File: lua/csrohit/plugins/lspconfig.lua
-- LSP Configurations for clangd, lua-language-server, and cmake with formatting support and keymaps

local on_attach = function(client, bufnr)
    -- Helper to easily map keys specific to LSP functionality in the current buffer
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Symbols displayed in Telescope window
    local builtin = require("telescope.builtin")
    nmap("<leader>ds", builtin.lsp_document_symbols, "Document Symbols")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

    -- Basic LSP navigation and info keymaps
    nmap("gI", vim.lsp.buf.implementation, "Goto Implementation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("gd", vim.lsp.buf.definition, "Goto Definition")
    nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
    nmap("gt", vim.lsp.buf.type_definition, "Goto Type Definition")


    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Workspace List Folders")

    -- Keymap for formatting (also create :Format command)
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    nmap("<leader>lf", function()
        vim.lsp.buf.format()
    end, "Format file")
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "j-hui/fidget.nvim",                 -- optional UI for LSP status
        "saghen/blink.cmp",
        -- "hrsh7th/cmp-nvim-lsp",              -- Completion source for nvim-cmp
        "williamboman/mason-lspconfig.nvim", -- External LSP installer mapping
    },
    opts = {},

    config = function()
        local lspconfig = require("lspconfig")
        local util = lspconfig.util

        -- Define diagnostic signs in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- Setup enhanced capabilities from nvim-cmp for completion
        -- local capabilities = require('blink.cmp').get_lsp_capabilities();
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

        -- capabilities = vim.tbl_deep_extend('force', capabilities, {
        --   textDocument = {
        --     foldingRange = {
        --       dynamicRegistration = false,
        --       lineFoldingOnly = true
        --     }
        --   }
        -- })

        -- clangd: C, C++ and Objective-C language server configuration
        lspconfig.clangd.setup({
            capabilities = capabilities,
            on_attach = on_attach,

            -- Command configuration with header insertion disabled
            cmd = { "clangd", "--header-insertion=never" },

            -- Root directory detection for clangd projects
            root_dir = util.root_pattern(
                ".clangd",
                "compile_commands.json",
                "compile_flags.txt",
                ".git"
            ),
        })

        -- lua-language-server (lua_ls) for neovim config Lua support
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        })

        -- cmake-language-server for CMakeLists.txt and cmake files
        lspconfig.cmake.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            -- Root directory detection for CMake projects
            root_dir = util.root_pattern("CMakeLists.txt", ".git"),
        })
    end,
}
