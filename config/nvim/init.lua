require("plugins")

local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
-- vim.opt.list = true            -- Show spaces, tabs, etc.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess:append("I")     -- Disable intro message
vim.opt.wrap = false
vim.cmd.colorscheme("duskfox")

-- Tree
vim.g.netrw_banner       = 0       -- Hide top banner
vim.g.netrw_liststyle    = 3       -- Tree-style listing
vim.g.netrw_browse_split = 4       -- Open in previous window
vim.g.netrw_altv         = 1       -- Put vertical splits to the right
vim.g.netrw_winsize      = 25      -- Width of netrw window
vim.g.netrw_keepdir      = 0       -- Don't keep cwd synced with netrw

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

-- Open Vexplore if the first argument is a directory
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
	-- Delete the default empty buffer
	vim.cmd("enew")       -- create a new empty buffer
	vim.cmd("bdelete #")  -- delete the previous buffer (the auto Ex buffer)
	-- Open vertical explorer for the directory
	vim.cmd("Vexplore " .. vim.fn.fnameescape(vim.fn.argv(0)))
end

-- Function to toggle vertical netrw explorer
local function toggle_vexplore()
	-- Check if a netrw buffer already exists
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local ft = vim.api.nvim_buf_get_option(buf, "filetype")
			if ft == "netrw" then
				-- If found, close the window
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_buf(win) == buf then
						vim.api.nvim_win_close(win, true)
						return
					end
				end
			end
		end
	end
	-- If no netrw buffer found, open vertical explorer
	vim.cmd("Vexplore")
end

-- Map 'l' and 'l' to open file/dir in netrw buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "l", "<CR>", { silent = true })
		vim.api.nvim_buf_set_keymap(0, "n", "h", "<CR>", { silent = true })
	end,
})

-- Make netrw buffers read-only and unlisted
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        -- Prevent any writing
        vim.bo.buflisted = false        -- hide from buffer list
        vim.bo.readonly = true          -- normal :w prevented
        vim.bo.modifiable = false       -- prevent edits
        vim.bo.buftype = "nofile"       -- treat as scratch buffer
        vim.bo.swapfile = false         -- no swap
    end,
})

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

-- Macros
vim.fn.setreg('p', "i# %% py\027o##\027O") -- Insert python cell

-- Tabs
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<CR>', opts)
vim.keymap.set('n', 'J'    , '<cmd>tabn<CR>'  , opts)
vim.keymap.set('n', 'K'    , '<cmd>tabp<CR>'  , opts)

-- Windows
vim.keymap.set('n', '<C-Down>' , '<cmd>split<CR>' , opts)
vim.keymap.set('n', '<C-Right>', '<cmd>vsplit<CR>', opts)
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
vim.keymap.set('n', '<leader>w', '<cmd>MdEval<CR>'         , opts)
vim.keymap.set('n', '<leader>c', '<cmd>MdEvalClean<CR>'    , opts)

-- Other
vim.keymap.set('n', '<leader><leader>', '<cmd>w!<CR>'   , opts)
vim.keymap.set('n', '<leader>q'       , '<cmd>wq!<CR>'  , opts)
vim.keymap.set('n', '<leader>m'       , '<cmd>make<CR>' , opts)
vim.keymap.set('n', '<leader>e'       , toggle_vexplore , opts)
