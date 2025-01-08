require("plugins")

vim.cmd("let mapleader = ' '")
vim.cmd("set relativenumber")
vim.cmd("set number")
vim.cmd("colorscheme duskfox")
vim.cmd("set nowrap")
vim.cmd("set clipboard=unnamedplus") -- Use system clipboard
vim.cmd("set background=dark")
vim.cmd("set shm+=I")	-- Disable intro message
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o") -- Disable auto-comment
-- vim.cmd("set list")	-- Show spaces tabs etc.

vim.opt.fillchars = {
    vert = "|",
    fold = " ",
    eob = " ",
    diff = "/",
    msgsep = "-",
    foldopen = "▾",
    foldsep = "|",
    foldclose = ">",
}

vim.keymap.set('n', '<leader><leader>', ':w!<CR>')
vim.keymap.set('n', '<leader>q', ':wq!<CR>')
vim.keymap.set('n', '<C-t>', ':tabnew<CR>')
vim.keymap.set('n', 'J', ':tabn<CR>')
vim.keymap.set('n', 'K', ':tabp<CR>')
vim.keymap.set('n', '<C-n>', ':vsplit<CR>')
vim.keymap.set('n', 'H', ':wincmd h<CR>')
vim.keymap.set('n', 'L', ':wincmd l<CR>')
vim.keymap.set('n', '<leader>e', ':Neotree toggle right<CR>')
vim.keymap.set('n', '<leader>o', '<C-W>w')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('i', '<C-space>', '<ESC>')
