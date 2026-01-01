return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "stevearc/aerial.nvim",
    },
    event = "VeryLazy",
    opts = function()
        local icons = require("csrohit.icons")
        local snacks = require("snacks")

        -- --- CONFIGURATION ---
        local BUFFER_SECTION_WIDTH = "45%" 
        -- ---------------------

        -- THEME FIX: Transparent Middle
        local custom_theme = require("lualine.themes.auto")
        for _, mode in pairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
            if custom_theme[mode] and custom_theme[mode].c then
                custom_theme[mode].c.bg = "NONE"
            end
        end

        -- Helper: Custom Buffer Formatter
        local function buffer_format(name, context)
            local bufnr = context.bufnr
            local current_buf = vim.api.nvim_get_current_buf()
            
            -- Safety check
            if not name then return "" end

            -- If it's the ACTIVE buffer
            if bufnr == current_buf then
                -- Show relative path, truncated (e.g., l/c/p/lualine.lua)
                return vim.fn.pathshorten(name)
            else
                -- If INACTIVE, show only the filename (e.g., lualine.lua)
                return vim.fs.basename(name)
            end
        end

        -- Helper: Get Active LSP Clients
        local function get_lsp_clients()
            local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
            if #buf_clients == 0 then return "" end
            local client_names = {}
            for _, client in pairs(buf_clients) do
                table.insert(client_names, client.name)
            end
            return table.concat(client_names, ", ")
        end

        require("aerial").setup({ dense = true, layout = { min_width = 15 } })

        return {
            options = {
                theme = custom_theme,
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" } },
                component_separators = { left = "", right = "" }, 
                section_separators = { left = icons.separators.right, right = icons.separators.left },
            },
            sections = {
                lualine_a = {
                    { 
                        "mode", 
                        separator = { left = icons.separators.left, right = icons.separators.right }, 
                        padding = { left = 1, right = 1 } 
                    },
                },
                lualine_b = {
                    { "branch", icon = icons.dashboard.git_status },
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                },
                lualine_c = {
                    {
                        "buffers",
                        -- CHANGED: mode 0 shows the name, allowing our fmt function to work
                        mode = 0,
                        -- CHANGED: false gives us the relative path so we can shorten it ourselves
                        show_filename_only = false, 
                        max_length = vim.o.columns * (tonumber(string.match(BUFFER_SECTION_WIDTH, "%d+")) / 100), 
                        
                        fmt = buffer_format,

                        buffers_color = {
                            active = { fg = "#7aa2f7", gui = "bold", bg = "NONE" },
                            inactive = { fg = "#565f89", bg = "NONE" },
                        },
                        symbols = {
                            modified = " ●",
                            alternate_file = "",
                            directory =  "",
                        },
                        section_separators = { left = icons.separators.right, right = icons.separators.left },
                        component_separators = { left = "", right = "" },
                    },
                },
                lualine_x = {
                    -- Breadcrumbs (Aerial)
                    {
                        "aerial",
                        sep = " > ",
                        depth = 5,
                        dense = true,
                        dense_sep = ".",
                        colored = true,
                        color = { fg = "#a9b1d6", bg = "NONE" },
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                    },
                },
                lualine_y = {
                    { get_lsp_clients, color = { gui = "bold" } }, 
                    { "searchcount", maxcount = 999, timeout = 500 },
                    { "progress", padding = { left = 1, right = 1 } },
                },
                lualine_z = {
                    { 
                        "location", 
                        separator = { left = icons.separators.left, right = icons.separators.right }, 
                        padding = { left = 1, right = 1 } 
                    },
                },
            },
            extensions = { "neo-tree", "lazy", "fzf", "aerial" },
        }
    end,
}
