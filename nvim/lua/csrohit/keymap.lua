---@module keymap
---@author Rohit Nimkar
---@license The GPLv3 License (GPLv3)
--File: lua/csrohit/keymap.lua

--[[
The GPLv3 License (GPLv3)

Copyright (c) 2023 Rohit Nimkar

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- mapping for normal mode
function Nmap(lhs, rhs, opts)
    Map("n", lhs, rhs, opts)
end

-- mapping for visual mode
function Vmap(lhs, rhs, opts)
    Map("v", lhs, rhs, opts)
end

-- set leader key
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- remove highlighted search results
Nmap("<leader>nh", ":nohlsearch<CR>", { desc = "[NH] Disable search highlights" })
Nmap("<leader>e", ":NvimTreeToggle<CR>", { desc = "[E] Toggle file manager" })

-- navigating between buffers
Nmap("<TAB>", ":bn<CR>", { desc = "Next buffer" })
Nmap("<S-TAB>", ":bp<CR>", { desc = "Previous buffer" })
Nmap("<leader>bd", ":bd<CR>", { desc = "Close current buffer" })
Nmap("<leader>ba", ":%bd<CR>", { desc = "Close all buffers" })

-- navigating between window splits
Nmap("<C-h>", "<C-\\><C-N><C-w>h", { desc = "Left pane" })
Nmap("<C-j>", "<C-\\><C-N><C-w>j", { desc = "Bottom pane" })
Nmap("<C-k>", "<C-\\><C-N><C-w>k", { desc = "Top pane" })
Nmap("<C-l>", "<C-\\><C-N><C-w>l", { desc = "Right pane" })

-- toggle current split window maximize
Nmap("<leader>tm", ":MaximizerToggle<CR>", { desc = "[TM] Toggle maximize current buffer" })

-- indentation
Vmap("<", "<gv")
Vmap(">", ">gv")

Nmap("<A-k>", ":m -2<CR>", { desc = "Move line up" })
Nmap("<A-j>", ":m +1<CR>", { desc = "Move line down" })

-- restart lsp server (not on youtube nvim video)
Nmap("<leader>rs", ":LspRestart<CR>", { desc = "[R] Restart LSP server" }) -- mapping to restart lsp if necessary
--terminal
Nmap("<C-`>", ":vsplit term://zsh<CR>", { desc = "Open terminal" })
Map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
Nmap("<leader>ng", "<cmd>Neogen<CR>", { desc = "Generate annotations" })


function create_new_file(filename)
    local cwd = vim.fn.getcwd() -- get current working directory
    local filepath = cwd .. "/" .. filename

    local file, err = io.open(filepath, "w") -- open file for writing (creates or clears)
    if not file then
        print("Error creating file: " .. err)
        return
    end
    file:close()
    print("File created: " .. filepath)
end

-- Create a floating window
local function create_floating_window()
    -- local Snacks = require("snacks") -- load the snacks module
    ---@type snacks.input.Opts: snacks.input.Config,{}
    local opts = {
        prompt = "Filename",
        backdrop = false,
        position = "float",
        border = "rounded",
        title_pos = "center",
        height = 1,
        width = 60,
        relative = "editor",
        noautocmd = true,
        row = 2,
        -- relative = "cursor",
        -- row = -3,
        -- col = 0,
        wo = {
            winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
            cursorline = false,
        },
        bo = {
            filetype = "snacks_input",
            buftype = "prompt",
            modifiable = true
        },
        --- buffer local variables
        b = {
            completion = true, -- disable blink completions in input
        },
        keys = {
            n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
            i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
            i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
            i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
            i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
            i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
            i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
            q = "cancel",
        },
        default = vim.fn.getcwd() .. "/",
        sources = { "path" }
    }

    local on_confirm = function(value)
        if value == nil or value == "" then
            print("Input cancelled (Escape pressed or empty input)")
        else
            local file = io.open(value, "r")
            if file then
                -- File exists, close the handle and just open it in Neovim
                file:close()
                print("File exists: " .. value)
            else
                -- File does not exist, create it
                file, err = io.open(value, "w")
                if not file then
                    print("Error creating file: " .. err)
                    return
                end
                file:close()
                print("File created: " .. value)
            end
            -- Open the file in Neovim
            vim.cmd("edit " .. vim.fn.fnameescape(value))
        end
    end

    Snacks.input.input(opts, on_confirm)
end


Nmap("<leader>rr", create_floating_window, { desc = "Rohit function" })
