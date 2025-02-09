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
			local dap_python = require("dap-python")

			-- Set up a breakpoint for exceptions
			dap.set_exception_breakpoints({ "all" })

			-- Use the path to your virtual environment's Python interpreter
			local path_to_py = vim.fn.getcwd() .. "/.venv/bin/python"
			dap_python.setup(path_to_py)
			dap_python.test_runner = "pytest"

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
						"--lang=cs"
					},
					cwd = vim.fn.getcwd(),
					stopOnEntry = false,
					-- python = path_to_py,
					console = "integratedTerminal",
					justMyCode = false,
					redirectOutput = true,
				},
			}

			-- Key mappings for nvim-dap
			vim.api.nvim_set_keymap("n", "<F4>", "<cmd>lua require'dap'.terminate()<CR>", {})
			vim.api.nvim_set_keymap('n', '<F4>', "<cmd>lua require('dap').terminate(); require('dapui').close()<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", {})
			vim.api.nvim_set_keymap("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", {})
			vim.api.nvim_set_keymap("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", {})
			vim.api.nvim_set_keymap("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", {})
			vim.api.nvim_set_keymap("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", {})

			-- Key mappings for dap-python test helpers

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"<Leader>dm",
						"<cmd>lua require('dap-python').test_method({})<CR>",
						{ desc = "[D]ebug Test [M]ethod" }
					)
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"<Leader>dc",
						"<cmd>lua require('dap-python').test_class()<CR>",
						{ desc = "[D]ebug Test [C]lass" }
					)
				end,
			})

			-- Change how the breakpoint signs look
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

			-- Automatically open and close the UI when debugging starts/stops
			local dapui = require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				-- dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				-- dapui.close()
			end
			dapui.setup()
		end,
	},
}
