---@type vim.lsp.Config
return {
  -- TODO: move this to some project specific function like rust
  settings = {
    python = {
      analysis = {
        extraPaths = {
          "core/mocks",
          "core/mocks/generated",
        },
      },
    },
  },
}
