-- File: lua/csrohit/plugins/lspconfig.lua
-- LSP Configurations for clangd, lua-language-server, and cmake with formatting support and keymaps

local icons = require("csrohit.icons")

local on_attach = function(client, bufnr)
    local keymaps = {
        { "<leader>cl", function() Snacks.picker.lsp_config() end,  desc = "Lsp Info" },
        { "gd",         vim.lsp.buf.definition,                     desc = "Goto Definition",            has = "definition" },
        -- Handled by snacks picker
        -- { "gr",         vim.lsp.buf.references,                     desc = "References",                 nowait = true },
        -- { "gI",         vim.lsp.buf.implementation,                 desc = "Goto Implementation" },
        { "gy",         vim.lsp.buf.type_definition,                desc = "Goto T[y]pe Definition" },
        { "gD",         vim.lsp.buf.declaration,                    desc = "Goto Declaration" },
        { "K",          vim.lsp.buf.hover,                          desc = "Hover" },
        { "gK",         vim.lsp.buf.signature_help,                 desc = "Signature Help",             has = "signatureHelp" },
        { "<c-k>",      vim.lsp.buf.signature_help,                 mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action,                    desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
        { "<leader>cc", vim.lsp.codelens.run,                       desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
        { "<leader>cC", vim.lsp.codelens.refresh,                   desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
        { "<leader>cr", vim.lsp.buf.rename,                         desc = "Rename",                     has = "rename" },
        {
            "<leader>lf",
            function()
                vim.lsp.buf.format()
            end,
            desc = "Format file"
        },
        {
            "]]",
            function() Snacks.words.jump(vim.v.count1) end,
            has = "documentHighlight",
            desc = "Next Reference",
            cond = function() return Snacks.words.is_enabled() end
        },
        {
            "[[",
            function() Snacks.words.jump(-vim.v.count1) end,
            has = "documentHighlight",
            desc = "Prev Reference",
            cond = function() return Snacks.words.is_enabled() end
        },
        {
            "<a-n>",
            function() Snacks.words.jump(vim.v.count1, true) end,
            has = "documentHighlight",
            desc = "Next Reference",
            cond = function() return Snacks.words.is_enabled() end
        },
        {
            "<a-p>",
            function() Snacks.words.jump(-vim.v.count1, true) end,
            has = "documentHighlight",
            desc = "Prev Reference",
            cond = function() return Snacks.words.is_enabled() end
        },
    }

    local nmap = function(entry)
        -- Unpack entry fields
        local keys = entry[1] or entry.keys
        local func = entry[2] or entry.func
        local desc = entry.desc
        local mode = entry.mode or "n" -- default to normal mode
        local has = entry.has          -- capability check, optional
        local cond = entry.cond        -- condition callback, optional
        local nowait = entry.nowait    -- optional

        -- Check condition function, if any
        if cond and not cond() then
            return
        end

        -- Check 'has' capabilities if you want (you'd need client info)
        -- For demo, skipped here -- add your own checks if needed

        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc, nowait = nowait })
    end

    -- Driver code to set all keymaps from keys[]
    for _, entry in ipairs(keymaps) do
        nmap(entry)
    end
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "j-hui/fidget.nvim", -- optional UI for LSP status
        "saghen/blink.cmp",  -- autocompletion
    },
    opts = {
        diagnostics = {
            underline = true,
            update_in_insert = false,
            severity_sort = true,

            virtual_text = {
                spacing = 4,
                source = "if_many",
                -- this will set prefix to the diagnostics virtual text
                prefix = function(diagnostic)
                    local temp_icons = {
                        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN]  = icons.diagnostics.Warn,
                        [vim.diagnostic.severity.INFO]  = icons.diagnostics.Info,
                        [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint,
                    }
                    return temp_icons[diagnostic.severity] or "●"
                end,
            },
            signs = {
                -- Define the text symbols for each diagnostic severity level
                -- This is displayed in sign_buffer
                text = {
                    [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                    [vim.diagnostic.severity.WARN]  = icons.diagnostics.Warn,
                    [vim.diagnostic.severity.INFO]  = icons.diagnostics.Info,
                    [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint,
                },
            },
        },

        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
            enabled = true,
            exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
            enabled = false,
        },

        capabilities = {
            workspace = {
                fileOperations = {
                    didRename = true,
                    willRename = true,
                },
            },
        },
    },

    config = function(_, opts)
        local lspconfig = require("lspconfig")
        -- local util = lspconfig.util

        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require('blink.cmp').get_lsp_capabilities({}, false) or {},
            opts.capabilities or {}
        )

        -- clangd: C, C++ and Objective-C language server configuration
        vim.lsp.config('clangd', {
            capabilities = capabilities,
            on_attach = on_attach,

            -- Command configuration with header insertion disabled
            cmd = { "clangd", "--header-insertion=never", "--log=verbose" },

            -- Root directory detection for clangd projects
            -- root_dir = util.root_pattern(
            --     ".clangd",
            --     "compile_commands.json",
            --     "compile_flags.txt",
            --     ".git"
            -- ),
        })

        -- lua-language-server (lua_ls) for neovim config Lua support
        vim.lsp.config('lua_ls', {
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

        vim.lsp.config('cmake', {
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
        vim.lsp.config('pylsp', {
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
        vim.lsp.config('rust_analyzer', {
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


        -- Minimal support for method event handling
        local supports_method = {}

        local function on_supports_method(method, fn)
            supports_method[method] = true
            return vim.api.nvim_create_autocmd("User", {
                pattern = "LspSupportsMethod",
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local buffer = args.data.buffer
                    if client and args.data.method == method then
                        fn(client, buffer)
                    end
                end,
            })
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local bufnr = args.buf
                if client then
                    for method in pairs(supports_method) do
                        if client:supports_method(method) then
                            vim.api.nvim_exec_autocmds("User", {
                                pattern = "LspSupportsMethod",
                                data = { client_id = client.id, buffer = bufnr, method = method },
                                modeline = false,
                            })
                        end
                    end
                end
            end,
        })

        -- Assuming opts is defined elsewhere with inlay_hints.enabled and exclude
        on_supports_method("textDocument/inlayHint", function(_, buffer)
            if
                vim.api.nvim_buf_is_valid(buffer)
                and vim.bo[buffer].buftype == ""
                and not vim.tbl_contains(opts.inlay_hints.exclude or {}, vim.bo[buffer].filetype)
            then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
        end)
        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

        -- configure highlight group colors
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#c53b53" })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffc777" })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0db9d7" })
        vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#4fd6be" })
        vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "NvimLightGreen" })

        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "#322633", fg = "#c53b53", italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "#38343d", fg = "#ffc777", italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "#203346", fg = "#0db9d7", italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "#273644", fg = "#4fd6be", italic = true })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { link = "DiagnosticOk" })

        vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "DiagnosticError" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "DiagnosticHint" })
        vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { link = "DiagnosticOk" })

        vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
        vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
        vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint" })
        vim.api.nvim_set_hl(0, "DiagnosticSignOk", { link = "DiagnosticOk" })
    end,
}
