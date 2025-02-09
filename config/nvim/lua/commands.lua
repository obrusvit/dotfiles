vim.api.nvim_create_user_command("Mkses", function(args)
  local session_name = args[1] or "ses_nvim"
  vim.cmd("mksession!" .. session_name)
end, { nargs = "?", desc = "Make session" })
