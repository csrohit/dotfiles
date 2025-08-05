--File: lua/csrohit/plugins/lualine.lua

-- Function to show a prettier path (customize as you prefer)
local function pretty_path()
    return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            vim.o.statusline = " "
        else
            vim.o.laststatus = 0
        end
    end,
    opts = function()
        vim.o.laststatus = vim.g.lualine_laststatus

        local opts = {
            options = {
                theme = "auto",
                globalstatus = vim.o.laststatus == 3,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            Error = " ",
                            Warn  = " ",
                            Info  = " ",
                            Hint  = " ",
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { pretty_path },
                },
                lualine_x = {
                    {
                        "diff",
                        symbols = {

                            added    = " ",
                            modified = " ",
                            removed  = " ",
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

        -- Trouble.nvim symbols integration (optional, if you use trouble.nvim)
        if vim.g.trouble_lualine and pcall(require, "trouble") then
            local trouble = require("trouble")
            local symbols = trouble.statusline({
                mode = "symbols",
                groups = {},
                title = false,
                filter = { range = true },
                format = "{kind_icon}{symbol.name:Normal}",
                hl_group = "lualine_c_normal",
            })
            table.insert(opts.sections.lualine_c, {
                symbols and symbols.get,
                cond = function()
                    return vim.b.trouble_lualine ~= false and symbols.has()
                end,
            })
        end

        return opts
    end,
}
