vim.api.nvim_create_user_command("GBlame", "Gitsigns blame", {})

vim.api.nvim_create_user_command("CopyPathRel", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyPathAbs", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
