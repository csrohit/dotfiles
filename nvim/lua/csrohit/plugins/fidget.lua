--File: lua/csrohit/plugins/fidget.lua
return {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function ()
        require("fidget").setup();
    end
}
