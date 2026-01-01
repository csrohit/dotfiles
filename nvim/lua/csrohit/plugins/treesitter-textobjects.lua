return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main", -- CRITICAL: You must use the main branch
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj
                keymaps = {
                    -- Your exact old keymaps
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- Set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                    ["<leader>s"] = "@assignment.outer", -- Add this to swap 'left = right' to 'right = left'
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                    ["<leader>S"] = "@assignment.outer", -- Swap back to the left
                },
            },
        })
    end,
}
