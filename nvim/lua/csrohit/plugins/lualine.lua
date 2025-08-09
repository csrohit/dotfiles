return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = function()
        -- PERF: we don't need this lualine require madness 🤷
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local icons = require("csrohit.icons")

        vim.o.laststatus = vim.g.lualine_laststatus

        local opts = {
            options = {
                theme = "auto",
                globalstatus = vim.o.laststatus == 3,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                icons_enabled = true
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },

                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 0 },
                    { "navic" }
                },
                lualine_x = {
                    Snacks.profiler.status(),
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.command.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        color = function() return { fg = Snacks.util.color("Statement") } end,
                    },
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.mode.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        color = function() return { fg = Snacks.util.color("Constant") } end,
                    },
                    -- stylua: ignore
                    {
                        function() return "  " .. require("dap").status() end,
                        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                        color = function() return { fg = Snacks.util.color("Debug") } end,
                    },
                    -- stylua: ignore
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = function() return { fg = Snacks.util.color("Special") } end,
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                    },
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 1 } },
                },
                lualine_z = {
                    { "location", padding = { left = 0, right = 1 } },
                },
            },
            extensions = { "neo-tree", "lazy", "fzf" },
        }

        return opts
    end,
}
