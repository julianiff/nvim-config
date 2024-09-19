vim.cmd("set tabstop=4")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
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