return {
  "johmsalas/text-case.nvim",
  config = function()
    require("textcase").setup({})
  end,
  keys = {
    -- 1. Direct Mappings (Fastest)
    -- "ga" = Go Alternate (standard vim prefix for specialized actions)
    -- "c" = camel, "p" = pascal, "s" = snake, "u" = upper/constant
    { "gac", "<cmd>Subs text_case_camel<CR>", mode = { "n", "v" }, desc = "To camelCase" },
    { "gap", "<cmd>Subs text_case_pascal<CR>", mode = { "n", "v" }, desc = "To PascalCase" },
    { "gas", "<cmd>Subs text_case_snake<CR>", mode = { "n", "v" }, desc = "To snake_case" },
    { "gau", "<cmd>Subs text_case_constant<CR>", mode = { "n", "v" }, desc = "To CONSTANT_CASE" },

    -- 2. Snacks.nvim Menu Integration (Replacement for Telescope)
    {
      "ga.",
      function()
        local textcase = require("textcase")
        local plugin = require("textcase.plugin.plugin")
        
        -- List of available conversions
        local options = {
          "to_camel_case",
          "to_pascal_case",
          "to_snake_case",
          "to_dash_case",
          "to_constant_case",
          "to_dot_case",
          "to_phrase_case",
          "to_title_case",
          "to_path_case",
        }

        -- Use Snacks to pick the option
        Snacks.picker.select(options, {
          prompt = "Select Text Case",
        }, function(choice)
          if choice then
            -- Apply the change to the word under cursor
            textcase.current_word(choice)
          end
        end)
      end,
      mode = { "n" },
      desc = "Select Text Case",
    },
  },
}
