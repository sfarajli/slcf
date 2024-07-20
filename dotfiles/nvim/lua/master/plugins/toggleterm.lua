require("toggleterm").setup{
	size = 6,
	open_mapping = [[<c-f>]],
	hide_numbers = true,
	shade_terminals = true,
	direction = "float",

	float_opts = {
		border = 'curved',
		winblend = 10, --transparency
	}

}
