require("plugins")

vim.g.mapleader = ' '
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
-- vim.opt.list = true            -- Show spaces, tabs, etc.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess:append("I")     -- Disable intro message
vim.opt.wrap = false
vim.cmd.colorscheme("duskfox")

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

-- Remove trailing whitespace on all lines before saving, excluding markdown files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" then
      return
    end
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Disable auto-comment
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Enable spellcheck for certain file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "gitcommit", "markdown", "text", "rst",
    "asciidoc", "org", "norg", "latex", "tex", "mail", "pandoc"
  },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- NOTE: On some terminal emulators, the keybinds
-- <C-j> and <C-k> don't work either in normal or insert mode.

-- Tabs
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<CR>'  , { noremap = true, silent = true })
vim.keymap.set('n', 'J'    , '<cmd>tabn<CR>'    , { noremap = true, silent = true })
vim.keymap.set('n', 'K'    , '<cmd>tabp<CR>'    , { noremap = true, silent = true })

-- Windows
vim.keymap.set('n', '<C-Down>' , '<cmd>split<CR>' , { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', '<cmd>vsplit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>'    , '<C-w>h'         , { noremap = true })
vim.keymap.set('n', '<C-j>'    , '<C-w>j'         , { noremap = true })
vim.keymap.set('n', '<C-k>'    , '<C-w>k'         , { noremap = true })
vim.keymap.set('n', '<C-l>'    , '<C-w>l'         , { noremap = true })

-- Imitate normal mode in insert mode
vim.keymap.set('i', '<C-h>'    , '<Left>' , { noremap = true })
vim.keymap.set('i', '<C-l>'    , '<Right>', { noremap = true })
vim.keymap.set('i', '<C-j>'    , '<Down>' , { noremap = true })
vim.keymap.set('i', '<C-k>'    , '<Up>'   , { noremap = true })
vim.keymap.set('i', '<C-space>', '<ESC>'  , { noremap = true })

-- Plugins
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle right<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>MdEval<CR>'              , { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', '<cmd>MdEvalClean<CR>'         , { noremap = true, silent = true })

-- Other
vim.keymap.set('n', '<leader><leader>', '<cmd>w!<CR>' , { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q'       , '<cmd>wq!<CR>', { noremap = true, silent = true })
