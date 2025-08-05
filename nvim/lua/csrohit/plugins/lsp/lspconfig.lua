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
    nmap("gI", vim.lsp.buf.implementation, "Goto Implementation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("gd", vim.lsp.buf.definition, "Goto Definition")
    nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
    nmap("gt", vim.lsp.buf.type_definition, "Goto Type Definition")
    nmap("ca", vim.lsp.buf.code_action, "Code Action")


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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "j-hui/fidget.nvim", -- optional UI for LSP status
        "saghen/blink.cmp",
    },
    opts = {

        signs = {
            -- Define the text symbols for each diagnostic severity level
            text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.INFO]  = " ",
                [vim.diagnostic.severity.HINT]  = " ",
            },
        },
    },

    config = function()
        local lspconfig = require("lspconfig")
        local util = lspconfig.util

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
                    diagnostics = {
                        globals = { "vim", "Snacks" }
                    }
                },
            },
        })

        lspconfig.cmake.setup({
            cmd = { "cmake-language-server" }, -- command to start the server; ensure it's in your PATH
            filetypes = { "cmake" },           -- recognizes *.cmake and CMakeLists.txt files
            root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git", "build", "cmake"),
            -- root_dir determines the project root by detecting any of these files/directories upward from the opened file

            init_options = {
                buildDirectory = "build", -- relative build directory for CMake's file API (adjust to your project)
            },

            single_file_support = true, -- enable for single cmake files outside a project root
        })

        -- python-language-server (pylsp) setup
        lspconfig.pylsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                pylsp = {
                    plugins = {
                        -- Enable/Disable pylsp plugins as you like
                        pycodestyle = { enabled = true, maxLineLength = 120 },
                        flake8 = { enabled = false }, -- you can enable if you prefer
                        mccabe = { enabled = false },
                        pyflakes = { enabled = true },
                        pylint = { enabled = false },
                        yapf = { enabled = false },
                        black = { enabled = false },
                        rope_autoimport = { enabled = false },
                        rope_completion = { enabled = false },
                        pylsp_mypy = { enabled = false },
                        isort = { enabled = true },
                    },
                },
            },
        })

        -- rust-analyzer: Rust language server configuration
        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                    },
                    checkOnSave = {
                        command = "clippy",
                    },
                },
            },
        })
    end,
}
