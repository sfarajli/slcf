require("neo-tree").setup({
	--Setup
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
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
	},

})
