--  Here are low-conf plugins
return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
