-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Keybinds to make buffer navigation easier.
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>h", ":bprev<CR>", { desc = "Prev buffer" })

-- Keybinds for managing tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "[T]ab [N]ew" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "[T]ab close [O]thers" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>tl", ":tabnext<CR>", { desc = "[T]ab next" })
vim.keymap.set("n", "<leader>th", ":tabprev<CR>", { desc = "[T]ab prev" })
vim.keymap.set("n", "<leader>tm", ":tabmove ", { desc = "[T]ab [M]ove" })

-- Open file explorer (Mini.files)
vim.keymap.set("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "[E]xplore (mini.files)" })
