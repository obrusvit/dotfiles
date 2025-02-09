return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    lazygit = { enabled = true },
    dashboard = { enabled = true },
  },
  keys = {
    -- stylua: ignore
    {
      "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit",
    },
  },
}
