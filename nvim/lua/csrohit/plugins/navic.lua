return {
    "SmiteshP/nvim-navic",
    event = { "BufReadPre", "BufNewFile" },     -- or whichever event you prefer to lazy load
    dependencies = { "neovim/nvim-lspconfig" }, -- navic depends on LSP
    opts = {
        separator = " ",                        -- separator between symbols
        depth_limit = 5,                        -- how many levels of symbols to show
        highlight = true,                       -- enable highlight for symbols
        icons = require("csrohit.icons").kinds, -- optional icons, adapt as needed
        lazy_update_context = true,
    },
    keys = {}, -- you can add keybindings if navic provides any (usually no default keys needed)
    config = function(_, opts)
        local navic = require("nvim-navic")
        navic.setup(opts)

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local bufnr = args.buf
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end,
        })
    end,
}
