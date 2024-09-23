return {
    "vim-test/vim-test",
    config = function()
        vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
        vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
        vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
        vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
        vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
        -- Custom Vitest runner function
        local function run_vitest_on_current_file()
            local current_file = vim.fn.expand("%:p")
            vim.cmd("vsplit")
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(0, buf)
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

        -- Function to determine if the current file is a Vitest test
        local function is_vitest_test()
            local file_content = vim.fn.join(vim.fn.readfile(vim.fn.expand("%")), "\n")
            return file_content:match("from%s+'vitest'") ~= nil
        end

        -- Custom strategy that uses the Vitest runner for Vitest tests
        vim.g["test#custom_strategies"] = {
            adaptive = function(cmd)
                if is_vitest_test() then
                    run_vitest_on_current_file()
                else
                    -- Default neovim strategy for non-Vitest tests
                    vim.cmd("botright new")
                    vim.cmd("resize 20")
                    vim.fn.termopen(cmd, {
                        on_exit = function()
                            vim.cmd("bdelete!")
                        end,
                    })
                    vim.cmd("wincmd p")
                    vim.cmd("stopinsert")
                end
            end,
        }

        -- Set the custom strategy as the default
        vim.g["test#strategy"] = "adaptive"

        -- Configure the default Neovim strategy (used for non-Vitest tests)
        vim.g["test#neovim#term_position"] = "vert leftabove"
        vim.g["test#neovim#term_width"] = 80
        -- PHPUnit-specific options
        vim.g["test#php#phpunit#options"] = "--colors=always"

        -- Ensure vim-test uses PHPUnit for PHP files
        vim.g["test#php#runner"] = "phpunit"
    end,
}
