local utils = require("utils_obrusvit")
return {
  {
    -- Main LSP Configuration
    "mason-org/mason-lspconfig.nvim",
    enabled = utils.__HAS_NVIM_011,
    dependencies = {
      "neovim/nvim-lspconfig", -- Collection of best-effort configs for LSP servers
      "mason-org/mason.nvim", -- Manage external editor tooling
      "hrsh7th/cmp-nvim-lsp", -- Allows extra capabilities provided by nvim-cmp
      "j-hui/fidget.nvim", -- Show LSP progress
    },
    config = function()
      -- Add the same capabilities to ALL server configurations.
      -- Refer to :h vim.lsp.config() for more information.
      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })

      -- TODO: not sure if these two lines are still needed in nvim 0.11
      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "rust_analyzer",
          "jsonls",
          "lua_ls",
          "pyright",
        },
        automatic_enable = true,
        automatic_installation = false,
      })
    end,
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}
