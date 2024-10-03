return {
	"github/copilot.vim",
	enabled = false,
	config = function()
		vim.g.copilot_no_tab_map = true
		-- vim.g.copilot_assume_mapped = true
		-- vim.g.copilot_tab_fallback = ""

		-- Map manual suggestion triggering to <C-J>
		vim.api.nvim_set_keymap("i", "<C-J>", "copilot#Accept('<CR>')", { silent = true, expr = true })

		-- Optionally map manual acceptance to <C-L>
		vim.api.nvim_set_keymap("i", "<C-L>", "<Plug>(copilot-accept)", { silent = true })

		-- vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
		-- 	expr = true,
		-- 	replace_keycodes = false,
		-- })
	end,
}
