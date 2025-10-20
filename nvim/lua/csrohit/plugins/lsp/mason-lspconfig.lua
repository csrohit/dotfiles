

--File: lua/csrohit/plugins/lsp/mason-lspconfig.lua

return {
     'williamboman/mason-lspconfig.nvim',
    opts = {
        ensure_installed = {
            "clangd",
            "lua_ls",
        }
    },
    config = function(_, opts)
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }) -- custom configuration
        require("mason-lspconfig").setup {
          ensure_installed = opts.ensure_installed,
          automatic_installation = true,
        }
    end
}
