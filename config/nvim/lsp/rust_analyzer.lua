local function get_rust_analyzer_project_settings()
  local curr_dir = vim.fn.getcwd()
  if curr_dir:find("repos/trezor%-firmware") then
    local cargo_path = curr_dir .. "/core/embed/rust/Cargo.toml"

    if vim.fn.filereadable(cargo_path) == 1 then
      return {
        ["rust-analyzer"] = {
          linkedProjects = { "/home/obrusvit/repos/trezor-firmware/core/embed/rust/Cargo.toml" },
          cargo = {
            buildScripts = {
              enable = true,
              -- overrideCommand = nil, -- Let rust-analyzer use default cargo
            },
            -- enableCargoRunner = true,
            -- features = { },
            allFeatures = true,
            -- noDefaultFeatures = true,
          },
          procMacro = {
            enable = true,
          },
        },
      }
    else
      print("Cargo.toml not found at:", cargo_path)
    end
  else
    -- default rust-analyzer setting
    return {
      ["rust-analyzer"] = {
        linkedProjects = "",
        cargo = {
          buildScripts = {},
          -- features = {},
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
      },
    }
  end
end

---@type vim.lsp.Config
return {
  settings = get_rust_analyzer_project_settings(),
}
