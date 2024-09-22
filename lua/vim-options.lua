vim.cmd("set tabstop=4")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.wo.number = true

vim.cmd("set number relativenumber")

-- Swisskeyboard override
vim.api.nvim_set_keymap("i", "<M-9>", "}", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-8>", "{", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-7>", "|", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-6>", "]", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-5>", "[", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-3>", "#", { noremap = true, silent = true })

-- Autosave after 1000ms (1 second) of inactivity in normal mode
vim.opt.updatetime = 1000
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "silent! update",
})

-- Function to run Vitest on the current file
local function run_vitest_on_current_file()
    -- Get the full path of the current file
    local current_file = vim.fn.expand("%:p")

    -- Create a new split
    vim.cmd("vsplit")

    -- Create a new buffer in the split
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    -- Run Vitest on the current file
    local cmd = string.format("npx vitest %s", vim.fn.shellescape(current_file))

    -- Use termopen to run the command in the new buffer
    vim.fn.termopen(cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                print("Vitest ran successfully")
            else
                print("Vitest encountered an error")
            end
        end,
    })

    -- Switch to normal mode
    vim.cmd("stopinsert")
end

vim.api.nvim_create_user_command("VitestCurrentFile", run_vitest_on_current_file, {})
vim.keymap.set("n", "<leader>vt", run_vitest_on_current_file, { noremap = true, silent = true })
