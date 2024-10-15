return {
	"theprimeagen/harpoon",
	config = function()
		require("harpoon").setup()

		local marks = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set(
			"n",
			"<leader>ha",
			marks.add_file,
			{ desc = "Add file to harpoon (Harpoon)", remap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"<leader>hj",
			ui.nav_next,
			{ desc = "Navigate to file up (Harpoon)", remap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"<leader>hk",
			ui.nav_prev,
			{ desc = "Navigate to file down (Harpoon)", remap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"<leader>hl",
			ui.toggle_quick_menu,
			{ desc = "Toggle quick menu (Harpoon)", remap = false, silent = true }
		)

		vim.keymap.set("n", "<leader>1", function()
			ui.nav_file(1)
		end, { desc = "Navigate to file 1 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>2", function()
			ui.nav_file(2)
		end, { desc = "Navigate to file 2 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>3", function()
			ui.nav_file(3)
		end, { desc = "Navigate to file 3 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>4", function()
			ui.nav_file(4)
		end, { desc = "Navigate to file 4 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>5", function()
			ui.nav_file(5)
		end, { desc = "Navigate to file 5 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>6", function()
			ui.nav_file(6)
		end, { desc = "Navigate to file 6 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>7", function()
			ui.nav_file(7)
		end, { desc = "Navigate to file 7 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>8", function()
			ui.nav_file(8)
		end, { desc = "Navigate to file 8 (Harpoon)", remap = false, silent = true })
		vim.keymap.set("n", "<leader>9", function()
			ui.nav_file(9)
		end, { desc = "Navigate to file 9 (Harpoon)", remap = false, silent = true })
	end,
}
