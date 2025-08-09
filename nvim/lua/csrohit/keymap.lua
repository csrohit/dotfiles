
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
Nmap("<TAB>", ":bn<CR>", { desc = "Next buffer" })
Nmap("<S-TAB>", ":bp<CR>", { desc = "Previous buffer" })
