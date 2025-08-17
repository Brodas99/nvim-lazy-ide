return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load before other UI plugins
		lazy = false, -- make sure it loads during startup
		opts = {
			flavour = "mocha", -- latte, frappe, macchiato, mocha
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}-- ~/.config/nvim/lua/plugins/colorscheme.lua
