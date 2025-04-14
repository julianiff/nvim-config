return {
	{
		"mcchrish/zenbones.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
		lazy = false,
		config = function()
			vim.o.background = "dark"
			vim.cmd.colorscheme("rosebones")

			local toggle_background = function()
				vim.o.background = vim.o.background == "dark" and "light" or "dark"
			end

			vim.keymap.set("n", "<f12>", toggle_background, { desc = "Colors" })
		end,
	},
}
