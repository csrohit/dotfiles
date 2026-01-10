-- File: lua/csrohit/plugins/ufo.lua

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' ↙️%d lines '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- Padding if truncated
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        "nvim-treesitter/nvim-treesitter", -- Ensure treesitter is loaded first
    },
    event = "BufReadPost",                 -- Load ufo only when opening a file
    config = function()
        vim.o.foldcolumn = '1' -- '0' is also good if you don't want the fold column
        vim.o.foldlevel = 99   -- Using ufo provider needs a large value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end,
            fold_virt_text_handler = handler
        })
    end,
}
