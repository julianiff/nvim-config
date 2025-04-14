return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	opts = {
		options = {
			component_separators = "|",
			section_separators = "",
			icons_enabled = false,
			theme = "rosebones",
		},
		sections = {
			lualine_c = { { "filename", path = 1 } },
			lualine_x = {
				{
					function()
						local recording_register = vim.fn.reg_recording()
						if recording_register ~= "" then
							return "📹 @" .. recording_register
						end
						return ""
					end,
					color = { fg = "#9ccfd8" },
				},
			},
		},
	},
}
