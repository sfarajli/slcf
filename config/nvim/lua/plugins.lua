-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("config").."/lazy/lazy.nvim" -- FIXME: Might be a problem in some systems

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setups
require("lazy").setup({
	spec = {
		"akinsho/toggleterm.nvim",
		"numToStr/Comment.nvim",
		"windwp/nvim-autopairs",
		"EdenEast/nightfox.nvim",
		"nvim-orgmode/orgmode",
		"jubnzv/mdeval.nvim",
	},
})

require("Comment").setup{
	padding = true,   -- Add a space b/w comment and the line
	sticky = true,    -- Whether the cursor should stay at its position
	ignore = nil,     -- Lines to be ignored while (un)comment
	-- LHS of toggle mappings in NORMAL mode
	toggler = {
		line = 'cc',  --Line-comment toggle keymap
		block = 'cb', -- Block-comment toggle keymap
	},
	-- LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		line = 'cc',  --Line-comment keymap
		block = 'cb', --Block-comment keymap
	},
}

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "spectre_panel", "neo-tree-popup", "conf"},
	disable_in_macro = true,
	disable_in_visualblock = false,
	disable_in_replace_mode = true,
})

require('orgmode').setup({
	org_agenda_files = '~/orgfiles/**/*',
	org_default_notes_file = '~/orgfiles/refile.org',
	org_startup_folded = 'showeverything'
})

require 'mdeval'.setup({
	require_confirmation=false
})

require("toggleterm").setup{
	size = 10,
	open_mapping = [[<c-f>]],
	hide_numbers = true,
	shade_terminals = true,
	direction = "float",
	float_opts = {
		-- border = 'curved',
		winblend = 0, --transparency
	}
}
