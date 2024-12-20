if vim.bo.filetype ~= "php" then
	return
end

-- PHP-specific test strategy
vim.g["test#custom_strategies"] = {
	php_split = function(cmd)
		vim.cmd("vsplit")
		vim.cmd("vertical resize " .. math.floor(vim.o.columns / 3))
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(0, buf)
		vim.fn.termopen(cmd, {
			on_exit = function()
				vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
				print("Press Enter to close this window")
			end,
		})
		vim.cmd("stopinsert")
	end,
}

-- PHPUnit configuration
vim.g["test#php#phpunit#options"] = "--colors=always"
vim.g["test#php#runner"] = "phpunit"
vim.g["test#strategy"] = "php_split"
