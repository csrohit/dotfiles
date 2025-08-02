--File: lua/csrohit/plugins/neogen.lua

return {
    "danymat/neogen",
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}
