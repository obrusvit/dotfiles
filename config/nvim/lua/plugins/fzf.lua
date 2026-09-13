local function get_visual_selection()
  -- Save the current unnamed register so we don't overwrite it
  local saved_reg = vim.fn.getreg('"')
  local saved_regtype = vim.fn.getregtype('"')

  -- Yank the visual selection into the unnamed register
  vim.cmd('noau normal! ""y')

  -- Get the yanked text from the unnamed register
  local selection = vim.fn.getreg('"')

  -- Restore the unnamed register to its previous state
  vim.fn.setreg('"', saved_reg, saved_regtype)

  return selection
end

-- Fuzzy Finder (files, lsp, etc)
return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    "telescope",
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    -- Use fzf-lua as the vim.ui.select handler (replaces telescope-ui-select)
    fzf.register_ui_select()

    -- See `:help fzf-lua` and `:FzfLua` for the list of pickers
    vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", fzf.builtin, { desc = "[S]earch [S]elect FzfLua" })
    vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>/", function()
      fzf.blines({
        winopts = {
          winblend = 10,
          preview = { hidden = "hidden" },
        },
      })
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- Fuzzily search lines of all open buffers
    vim.keymap.set("n", "<leader>s/", fzf.lines, { desc = "[S]earch [/] in Open Files" })

    -- Fuzzily search what's in visual selection
    vim.keymap.set("v", "<leader>sg", fzf.grep_visual, { desc = "[S]earch by [G]rep Visual Selection" })

    -- Fuzzily search filename of what's in visual selection
    vim.keymap.set("v", "<leader>sf", function()
      local text = get_visual_selection()
      fzf.files({ query = text })
    end, { desc = "[S]earch [F]ile in Visual Selection" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })
  end,
}
