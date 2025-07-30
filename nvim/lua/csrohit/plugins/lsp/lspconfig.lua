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

    -- Basic LSP navigation and info keymaps
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

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
        "folke/lazydev.nvim",                -- Lua development plugin
        "hrsh7th/cmp-nvim-lsp",              -- Completion source for nvim-cmp
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
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
