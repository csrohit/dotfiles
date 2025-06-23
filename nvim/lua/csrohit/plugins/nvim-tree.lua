-- File: lua/csrohit/plugins/nvim-tree.lua


return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
        vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
		require("nvim-tree").setup({
		    sort_by = "case_sensitive",
		    renderer = {
                group_empty = true,
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "", -- arrow when folder is closed
                            arrow_open = "", -- arrow when folder is open
                        },
                    },
                },
            },
            filters = {
                dotfiles = true,
		    },

            -- disable window_picker for
            -- explorer to work well with
            -- window splits
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
		})
	end
}

