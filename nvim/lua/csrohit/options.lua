--File: lua/csrohit/options.lua

-- Disable the builtin file explorer plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable cursorline (highlight current line)
vim.opt.cursorline = true

-- Highlight only the line number of the current line
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", {
  bold = true,
  -- You can also set a specific color if you want, for example:
  -- fg = "#FFD700",  -- gold/yellow foreground color
})
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- line numbers
vim.o.relativenumber = true
vim.wo.number = true

-- Left option key to act as Alt key
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

-- tabs and spacing
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.softtabstop = 4

-- Enable break indent
vim.o.breakindent = true

-- display spaces
vim.o.listchars = "eol:¬,tab:>␣,trail:~,extends:>,precedes:<,space:·"
-- vim.o.list=true

-- disable line wrapping
vim.o.wrap = false

-- appearance
vim.o.background = "dark"
vim.o.signcolumn = "yes"

-- window splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Save undo history
vim.o.undofile = true

-- Set highlight on search
vim.o.hlsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
