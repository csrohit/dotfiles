--File: lua/csrohit/plugins/lualine.lua

-- get lualine nightfly theme
-- lualine_nightfly = require("lualine.themes.nightfly")

--[[ new colors for theme
local new_colors = {
	blue = "#65D1FF",
	green = "#3EFFDC",
	violet = "#FF61EF",
	yellow = "#FFDA7B",
	black = "#000000",
}

-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black, -- black
	},
}
]]
--
return {
	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
        options = {
            icons_enabled = true,
            theme = "kanagawa",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
	},
}
