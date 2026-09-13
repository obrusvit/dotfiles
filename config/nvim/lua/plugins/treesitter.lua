-- Highlight, edit, and navigate code
-- NOTE: uses the rewritten `main` branch of nvim-treesitter (requires
-- Neovim 0.12+ and tree-sitter-cli >= 0.26.1 in PATH)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- the main branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    -- Install parsers (asynchronous no-op if already installed).
    -- There is no auto_install on the main branch, so list explicitly.
    require("nvim-treesitter").install({
      "bash",
      "c",
      "cpp",
      "cmake",
      "diff",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "rust",
      "vim",
      "vimdoc",
    })

    -- Highlighting is provided by Neovim, not the plugin; enable it per
    -- buffer. pcall silently skips filetypes without an installed parser.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("obrusvit-treesitter-start", { clear = true }),
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
      end,
    })
  end,
}
