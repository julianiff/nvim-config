return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()

		-- Key mappings
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon", remap = false, silent = true })

		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon quick menu", remap = false, silent = true })

		-- Navigate to next/previous
		vim.keymap.set("n", "<leader>hj", function()
			harpoon:list():next()
		end, { desc = "Navigate to next harpoon file", remap = false, silent = true })

		vim.keymap.set("n", "<leader>hk", function()
			harpoon:list():prev()
		end, { desc = "Navigate to previous harpoon file", remap = false, silent = true })

		-- Navigate to specific files by index
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Navigate to harpoon file 1", remap = false, silent = true })

		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Navigate to harpoon file 2", remap = false, silent = true })

		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Navigate to harpoon file 3", remap = false, silent = true })

		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Navigate to harpoon file 4", remap = false, silent = true })

		vim.keymap.set("n", "<leader>5", function()
			harpoon:list():select(5)
		end, { desc = "Navigate to harpoon file 5", remap = false, silent = true })

		vim.keymap.set("n", "<leader>6", function()
			harpoon:list():select(6)
		end, { desc = "Navigate to harpoon file 6", remap = false, silent = true })

		vim.keymap.set("n", "<leader>7", function()
			harpoon:list():select(7)
		end, { desc = "Navigate to harpoon file 7", remap = false, silent = true })

		vim.keymap.set("n", "<leader>8", function()
			harpoon:list():select(8)
		end, { desc = "Navigate to harpoon file 8", remap = false, silent = true })

		vim.keymap.set("n", "<leader>9", function()
			harpoon:list():select(9)
		end, { desc = "Navigate to harpoon file 9", remap = false, silent = true })
	end,
}
