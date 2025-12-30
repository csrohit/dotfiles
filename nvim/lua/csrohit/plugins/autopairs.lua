return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    -- 1. Setup standard bracket pairs ( () [] {} "" '' )
    npairs.setup({
      check_ts = true, -- use treesitter to check for pairs
      enable_check_bracket_line = false, -- Don't add pair if it already exists on the line
    })

    -- 2. Add custom rule for block comments ( /* -> */ )
    -- This rule triggers when you type '*' if the previous character was '/'
    npairs.add_rules({
      Rule("/*", "*/", { "c", "cpp", "css", "javascript", "typescript", "go" })
        :with_pair(function() return true end)
        :with_move(function(opts) return opts.char == "*" end)
        :with_cr(function() return false end) -- Don't break line on Enter immediately
        :with_del(function(opts)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local context = opts.line:sub(col - 1, col + 2)
          return vim.tbl_contains({ "/**/" }, context)
        end),
    })
  end,
}
