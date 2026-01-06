-- Create the path if it doesn't exist
local parser_path = vim.fn.stdpath("data") .. "/tree-sitter"
vim.fn.mkdir(parser_path, "p")

-- Prepend to runtimepath so Neovim looks here first for .so files
vim.opt.runtimepath:prepend(parser_path)
require("csrohit")

