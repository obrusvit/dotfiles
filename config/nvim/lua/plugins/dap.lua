-- Debug Adapter
return {
  -- nvim-dap and its extensions
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Python adapter for nvim-dap
      "mfussenegger/nvim-dap-python",
      -- Optional UI for nvim-dap
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui", -- dependent on nvim-nio
      -- Optional virtual text support
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Set up a breakpoint for exceptions
      dap.set_exception_breakpoints({ "all" })

      -- Use the path to your virtual environment's Python interpreter
      local path_to_py = vim.fn.getcwd() .. "/.venv/bin/python"

      dap_python.setup(path_to_py)
      dap_python.test_runner = "pytest"

      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_debugpy)

      dap.configurations.python = {
        {
          name = "Python: Launch pytest",
          type = "python",
          request = "launch",
          -- program = vim.fn.getcwd() .. "/.venv/bin/pytest",
          module = "pytest",
          args = {
            "-vs",
            "tests/click_tests/test_reset_slip39_basic.py",
            -- "-k",
            -- ""
            -- "--lang=cs",
          },
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          -- python = path_to_py,
          console = "integratedTerminal",
          justMyCode = false,
          redirectOutput = true,
        },
      }

      -- Rust/C/C++ adapter configuration (codelldb)
      local mason_codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_codelldb,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Try to find the binary in target/debug
            local cwd = vim.fn.getcwd()
            local default_path = cwd .. "/target/debug/"
            -- Get package name from Cargo.toml if it exists
            local cargo_toml = cwd .. "/Cargo.toml"
            if vim.fn.filereadable(cargo_toml) == 1 then
              local lines = vim.fn.readfile(cargo_toml)
              for _, line in ipairs(lines) do
                local name = line:match('^name%s*=%s*"([^"]+)"')
                if name then
                  default_path = default_path .. name
                  break
                end
              end
            end

            return vim.fn.input("Path to executable: ", default_path, "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Launch with arguments",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
        },
      }

      -- Key mappings for nvim-dap
      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<F4>", function()
        dap.terminate()
        dapui.close()
      end, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Terminate & Close UI" }))
      vim.keymap.set("n", "<F5>", dap.continue, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Continue" }))
      vim.keymap.set(
        "n",
        "<F9>",
        dap.toggle_breakpoint,
        vim.tbl_extend("force", keymap_opts, { desc = "DAP: Toggle Breakpoint" })
      )
      vim.keymap.set("n", "<S-F9>", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Conditional Breakpoint" }))
      vim.keymap.set("n", "<F10>", dap.step_over, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Step Over" }))
      vim.keymap.set("n", "<F11>", dap.step_into, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Step Into" }))
      vim.keymap.set("n", "<F12>", dap.step_out, vim.tbl_extend("force", keymap_opts, { desc = "DAP: Step Out" }))

      -- Key mappings for dap-python test helpers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(ev)
          vim.keymap.set("n", "<Leader>dm", function()
            require("dap-python").test_method()
          end, vim.tbl_extend("force", keymap_opts, { buffer = ev.buf, desc = "[D]ebug Test [M]ethod" }))

          vim.keymap.set("n", "<Leader>dc", function()
            require("dap-python").test_class()
          end, vim.tbl_extend("force", keymap_opts, { buffer = ev.buf, desc = "[D]ebug Test [C]lass" }))
        end,
      })

      -- Change how the breakpoint signs look
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "🔶", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      -- Automatically open and close the UI when debugging starts/stops
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dapui.setup()

      -- Virtual text setup
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
      })
    end,
  },
}
