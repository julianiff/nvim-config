return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"lewis6991/async.nvim", -- required since refactoring.nvim 64e10d7
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		opts = {},
		config = function()
			vim.keymap.set("x", "<leader>re", ":Refactor extract ")
			vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
			vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
			vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
			vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
			vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
			vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
		end,
	},
}
