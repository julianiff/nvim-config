return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
		config = function()
			require("telescope").setup({
				defaults = require("telescope.themes").get_ivy({
					path_display = { "shorten" },
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					layout_config = {
						height = 40,
					},
				}),
				pickers = {
					oldfiles = {
						cwd_only = true,
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			local find_files = function()
				builtin.find_files({
					hidden = true,
					no_ignore = true,
				})
			end
			local diagnostics = function()
				builtin.diagnostics({
					line_width = 2,
					bufnr = 0,
					path_display = { "hidden" },
				})
			end

			vim.keymap.set("n", "<C-p>", find_files, { desc = "Telescope - Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope - Content" })
			vim.keymap.set("n", "<leader>s", builtin.grep_string, { desc = "Telescope - Word under cursor" })
			vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "Telescope - Buffers" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Telescope - recently opened files" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fd", diagnostics, { desc = "Telescope - diagnostics" })
		end,
	},
}
