
-- File: lua/csrohit/plugins/blink.lua
-- blink.cmp configuration replicating the existing nvim-cmp setup with dynamic source activation and symbol formatting

return {
    "saghen/blink.cmp",

    -- use a release tag to download pre-built binaries
      version = '1.*',

    dependencies = {
        "rafamadriz/friendly-snippets",         -- snippets collection
        "folke/lazydev.nvim",                    -- optional Lua dev completions source
        "saghen/blink.compat",                   -- compatibility layer for nvim-cmp sources (optional)
    },

    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'enter' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- Completion sources with default and compat groups
        sources = {
            -- Default sources always enabled
            default = { "lsp", "snippets", "path", "buffer", "lazydev" },
            -- Compat sources for nvim-cmp compatibility (required if using nvim-cmp sources)
            compat = {},
            -- Providers table for external source plugins like lazydev
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,  -- higher priority than LSP
                },
            },
        },

        -- Completion menu config: documentation auto popup, ghost text (if you want), signature help enabled
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = true,  -- enable inline ghost text (adjust as needed)
            },
            accept = {
                auto_brackets = {
                    enabled = true,  -- experimental auto-bracket feature similar to nvim-cmp's
                },
            },
            signature = {
                enabled = true,  -- enables experimental builtin signature help popup
            },
        },

        -- Keymap style: "preset" options available: enter, tab, etc.
        -- keymap = {
        --     preset = "insert",    -- use "insert" preset mappings similar to nvim-cmp insert mode
        --     ["<Tab>"] = "select_next",     -- select next completion item
        --     ["<S-Tab>"] = "select_prev",   -- select previous completion item
        --     ["<C-d>"] = "scroll_docs_up",
        --     ["<C-f>"] = "scroll_docs_down",
        --     ["<C-Space>"] = "complete",
        --     ["<CR>"] = "accept",
        --     -- Additional custom mappings can be added here as needed
        -- },
        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

    },
      opts_extend = { "sources.default" },

    config = function(_, opts)
        local cmp = require("blink.cmp")

        -- Dynamically add LazyDev source if plugin is available
        local has_lazydev = pcall(require, "lazydev")
        if has_lazydev then
            table.insert(opts.sources.default, "lazydev")
        end

        -- Load the plugin with configured options
        cmp.setup(opts)
    end,
}
