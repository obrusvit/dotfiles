-- Debug Adapter
return {
  -- nvim-dap and its extensions
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      "<F4>", "<F5>", "<F9>", "<S-F9>", "<F10>", "<F11>", "<F12>",
      { "<F8>", function() require("dap").run_to_cursor() end, desc = "DAP: Run to Cursor" },
      { "<leader>dm", function() require("dap-python").test_method() end, ft = "python", desc = "[D]ebug Test [M]ethod" },
      { "<leader>dc", function() require("dap-python").test_class() end, ft = "python", desc = "[D]ebug Test [C]lass" },
    },
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

      -- Break on uncaught exceptions ("all" is not a valid debugpy
      -- filter and would be a silent no-op; "raised" is too noisy)
      dap.set_exception_breakpoints({ "uncaught" })

      -- Use the debugpy interpreter installed via mason
      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      dap_python.setup(mason_debugpy)
      dap_python.test_runner = "pytest"

      dap.configurations.python = {
        {
          name = "[Default] Py: Launch current file",
          type = "python",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
          justMyCode = false,
        },
      }

      -- Rust/C/C++ adapter configuration (codelldb)
      local mason_codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"

      dap.adapters.codelldb = {
        type = "executable",
        command = mason_codelldb,
      }

      dap.configurations.rust = {
        {
          name = "[Default] Rust: Launch file",
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
          name = "[Default] Rust: Launch with args",
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
        {
          name = "[Default] Rust: Attach to process",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- C/C++ configurations reuse the codelldb adapter
      local c_launch = {
        name = "[Default] C/C++: Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      }
      dap.configurations.cpp = { c_launch }
      dap.configurations.c = { c_launch }

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
