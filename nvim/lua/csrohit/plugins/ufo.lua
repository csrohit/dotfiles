-- File: lua/csrohit/plugins/ufo.lua

-- 1. Define the handler function separately
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
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- Padding if truncated
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

-- 2. Plugin Configuration
return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    init = function()
        -- INFO: Disable foldcolumn to save space
        vim.o.foldcolumn = '0' 
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        local ufo = require('ufo')

        -- 3. Setup UFO using the handler defined above
        ufo.setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end,
            fold_virt_text_handler = handler
        })

        -- 4. FORCE SETTINGS: The fix for the auto-folding issue
        vim.api.nvim_create_autocmd({"BufEnter", "BufReadPost", "InsertLeave"}, {
            pattern = "*",
            callback = function()
                vim.opt.foldlevel = 99
                vim.opt.foldenable = true
            end,
        })

        -- 5. Keymaps
        vim.keymap.set('n', 'zR', ufo.openAllFolds)
        vim.keymap.set('n', 'zM', ufo.closeAllFolds)
    end,
}
