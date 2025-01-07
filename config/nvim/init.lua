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
vim.keymap.set('n', '<C-t>',':tabnew<CR>')
vim.keymap.set('n','J', ':tabn<CR>')
vim.keymap.set('n','K', ':tabp<CR>')
vim.keymap.set('n', '<C-n>', ':vsplit<CR>')
vim.keymap.set('n', 'H',':wincmd h<CR>')
vim.keymap.set('n', 'L',':wincmd l<CR>')
vim.keymap.set('i','<C-h>','<Left>')
vim.keymap.set('i','<C-l>','<Right>')
vim.keymap.set('i','<C-space>','<ESC>')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'EdenEast/nightfox.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
