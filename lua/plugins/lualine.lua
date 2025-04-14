return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	opts = {
		options = {
			component_separators = "|",
			section_separators = "",
			icons_enabled = false,
			theme = "zenbones",
		},
		sections = {
			lualine_c = { { "filename", path = 1 } },
			-- Add this section to show macro recording status
			lualine_x = {
				{
					function()
						local recording_register = vim.fn.reg_recording()
						if recording_register ~= "" then
							return "📹 @" .. recording_register
						end
						return ""
					end,
					color = { fg = "#f6c177" }, -- Red text for visibility
				},
			},
		},
	},
}
