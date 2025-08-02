return {
    -- lazy.nvim
    "folke/noice.nvim",
    event = "VeryLazy",

    opts = {
        -- add any options here
        cmdline = {
            enabled = true,
            view = "cmdline_popup",     -- Use floating popup window for all cmdline input
            opts = {
                position = {
                    row = "10%",     -- Vertical position
                    col = "50%",     -- Horizontal position (centered)
                },
                size = {
                    width = 60,     -- Width of floating window
                },
            },
            format = {
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
            },
        }
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
    },
}
