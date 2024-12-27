return {
	"vim-test/vim-test",
	config = function()
		vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
		vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
		vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
		vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
		vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})

		-- Basic test strategy for non-specialized files
		vim.g["test#strategy"] = "neovim"
		vim.g["test#neovim#term_position"] = "vert belowright"
		vim.g["test#neovim#term_width"] = 80
	end,
}
