return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		init = function()
			-- there are others, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			-- vim.cmd.colorscheme("tokyonight-day")
			vim.cmd.colorscheme("tokyonight-night")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
	-- {
	-- 	"Tsuzat/NeoSolarized.nvim",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		-- vim.cmd([[ colorscheme NeoSolarized ]])
	-- 	end,
	-- },
	{
		"overcache/NeoSolarized",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("NeoSolarized")
		end,
	},
	-- {
	-- 	"maxmx03/solarized.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	init = function()
	-- 		-- vim.o.termguicolors = true
	-- 		-- vim.o.background = "dark"
	-- 		-- vim.cmd.colorscheme("solarized")
	-- 	end,
	-- },
	{
		"shaunsingh/solarized.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("solarized")
		end,

	},
}
