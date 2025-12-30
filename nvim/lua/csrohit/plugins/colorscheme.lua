-- ColorScheme
return {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        -- 1. Configure the theme first
        require('kanagawa').setup({
            transparent = false,          -- Enable transparency
            terminal_colors = true,      -- Define vim.g.terminal_color_{0,17}
            overrides = function(colors) -- Optional: ensure floating windows are also transparent
                return {
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                }
            end
        })

        -- 2. Load the colorscheme
        vim.cmd.colorscheme 'kanagawa'
    end
}
