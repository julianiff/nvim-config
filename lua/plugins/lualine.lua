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
			lualine_c = {
				{
					"filename",
					path = 1,
					fmt = function(str)
						local parts = {}
						for part in string.gmatch(str, "[^/]+") do
							table.insert(parts, part)
						end

						if #parts <= 2 then
							return str
						end

						local last_three = {
							parts[#parts - 1],
							parts[#parts],
						}

						local shortened_parts = {}
						for i = 1, #parts - 2 do
							-- Get first letter of the part
							local first_letter = string.sub(parts[i], 1, 1)
							table.insert(shortened_parts, first_letter)
						end

						local abbreviated_prefix = table.concat(shortened_parts, "/")
						local full_suffix = table.concat(last_three, "/")

						if abbreviated_prefix ~= "" then
							return abbreviated_prefix .. "/" .. full_suffix
						else
							return full_suffix
						end
					end,
				},
			},
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
