return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	---@module "quicker"
	---@type
	opts = {},
	config = function()
		local quicker = require("quicker")
		quicker.setup({
			max_filename_width = function()
				return math.floor(math.min(45, vim.o.columns / 2))
			end,
		})
	end,
}
