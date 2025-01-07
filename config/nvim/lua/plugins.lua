require('Comment').setup{
    padding = true,	-- Add a space b/w comment and the line
    sticky = true,	-- Whether the cursor should stay at its position
    ignore = nil,	-- Lines to be ignored while (un)comment
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
        line = 'cc', 	--Line-comment toggle keymap
        block = 'cb', 	-- Block-comment toggle keymap
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        line = 'cc', 	--Line-comment keymap
        block = 'cb',	--Block-comment keymap
    },
}

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

require("neo-tree").setup({
	filesystem = {
		window = {
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
				["zh"] = "toggle_hidden",
				["H"] = "close_all_nodes",
			}
		}
	},
	--Indent Markers
	default_component_configs = {
		indent = {
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			indent_size = 2,
		},
	},
	--Expanders
	default_component_configs = {
		indent = {
			with_expanders = false, --Not active
			expander_collapsed = ">",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
	},

})

require('nvim-autopairs').setup({
	 disable_filetype = { "TelescopePrompt", "spectre_panel", "neo-tree-popup", "conf"},
	 disable_in_macro = true,
	 disable_in_visualblock = false,
	 disable_in_replace_mode = true,
})

--[[ PACKER BOOTSTRAP ]]
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
	use "akinsho/toggleterm.nvim"
	use 'numToStr/Comment.nvim'
	use 'windwp/nvim-autopairs'
	use 'EdenEast/nightfox.nvim'

	if packer_bootstrap then
		require('packer').sync()
	end
end)
