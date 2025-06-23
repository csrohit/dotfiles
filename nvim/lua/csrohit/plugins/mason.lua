--File: lua/csrohit/plugins/mason.lua

return {
    'williamboman/mason.nvim',
    dependencies = {},
    opts = {
        ensure_installed = {
            "clangd",
            "clang-format",
            "codelldb",
        }
    },
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }) -- custom configuration
    end
}
