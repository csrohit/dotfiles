--File: lua/csrohit/plugin/comment.lua

return {
	"numToStr/Comment.nvim",
	opts = {},
	config = function()
		require("Comment").setup()
	end,
}
