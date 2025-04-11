return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("treesitter-context").setup({
				enable = false,
			})

			local config = require("nvim-treesitter.configs")
			config.setup({
				modules = {},
				auto_install = true,
				sync_install = true,
				ignore_install = {},
				ensure_installed = {
					"bash",
					"gitcommit",
					"gitignore",
					"json",
					"lua",
					"markdown",
					"php",
					"vim",
					"vimdoc",
					"yaml",
					"go",
					"tsx",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
