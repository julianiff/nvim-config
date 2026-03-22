return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		gh = {
			-- your gh configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		picker = {
			layouts = {
				custom_ivy = {
					layout = {
						box = "vertical",
						backdrop = true,
						row = -1,
						width = 0,
						height = 0.85,
						border = "none",
						title = " {title} {live} {flags} ",
						title_pos = "center",
						{
							win = "input",
							height = 1,
							border = "bottom",
							wo = {
								winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
							},
						},
						{
							box = "horizontal",
							{
								win = "list",
								border = "none",
								wo = {
									winhighlight = "NormalFloat:Normal",
								},
							},
							{
								win = "preview",
								title = "{preview}",
								width = 0.6,
								border = "left",
								wo = {
									winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
								},
							},
						},
					},
				},
			},
			layout = "custom_ivy",
		},
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					indent = 2,
					padding = 1,
					cwd = true,
				},
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			},
		},
		lazygit = {
			configure = false,
		},
		quickfile = {
			enabled = true,
		},
	},
	keys = {
		{
			"<leader>fg",
			function()
				Snacks.picker.grep({
					format = function(item, picker)
						local line = item.line
						item.line = nil
						local ret = require("snacks.picker.format").file(item, picker)
						item.line = line
						return ret
					end,
				})
			end,
			desc = "Live Grep",
		},
		{
			"<leader>s",
			function()
				Snacks.picker.grep_word({
					format = function(item, picker)
						local line = item.line
						item.line = nil
						local ret = require("snacks.picker.format").file(item, picker)
						item.line = line
						return ret
					end,
				})
			end,
			desc = "Word under cursor",
		},
		{
			"<leader>bb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Zen mode",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr({ author = "julianiff" })
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Create some toggle mappings
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.indent():map("<leader>ug")
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions[1].type == "move" then
					Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
				end
			end,
		})
	end,
}
