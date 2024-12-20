if vim.bo.filetype ~= "typescript" and vim.bo.filetype ~= "typescriptreact" then
	return
end

-- Function to check if current file is a Vitest test
local function is_vitest_test()
	local file_content = vim.fn.join(vim.fn.readfile(vim.fn.expand("%")), "\n")
	return file_content:match("from%s+'vitest'") ~= nil
end

-- Custom Vitest runner function
local function run_vitest_on_current_file()
	local current_file = vim.fn.expand("%:p")
	vim.cmd("vsplit")
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Auto-scroll setup
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		buffer = buf,
		callback = function()
			vim.schedule(function()
				vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
			end)
		end,
	})

	local cmd = string.format("npx vitest --coverage=false %s", vim.fn.shellescape(current_file))
	vim.fn.termopen(cmd, {
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				print("Vitest ran successfully")
			else
				print("Vitest encountered an error")
			end
		end,
	})
	vim.cmd("stopinsert")
end

-- Set up TypeScript-specific test strategy
if is_vitest_test() then
	vim.g["test#custom_strategies"] = {
		typescript_vitest = function(_)
			run_vitest_on_current_file()
		end,
	}
	vim.g["test#strategy"] = "typescript_vitest"
end
