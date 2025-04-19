return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    -- This plugin enables using Copilot as a source for nvim-cmp.
    "zbirenbaum/copilot-cmp",
    opts = {},
  },
  {
    -- CodeCompanion
    -- see default config here: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
      "CodeCompanionActions",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "ibhagwan/fzf-lua", -- For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves the default Neovim UI
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4.1",
                -- default = "o4-mini",
                -- default = "claude-3.7-sonnet",
                -- default = "claude-3.7-sonnet-thought",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
              },
            },
          },
        },
      },
      display = {
        chat = {
          show_references = true,
          show_header_separator = false,
          show_settings = true,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    init = function()
      -- vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
