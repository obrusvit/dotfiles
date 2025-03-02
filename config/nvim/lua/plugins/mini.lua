return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    require("mini.ai").setup({ n_lines = 500 }) -- better around/inside textobject
    require("mini.surround").setup()
    require("mini.diff").setup()
    require("mini.sessions").setup()
    require("mini.files").setup({ windows = { preview = true, width_preview = 50 } })
  end,
}
