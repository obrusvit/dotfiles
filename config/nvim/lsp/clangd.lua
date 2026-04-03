---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "--background-index",
  },
  init_options = {
    highlightInactiveRegions = false,
  },
}
