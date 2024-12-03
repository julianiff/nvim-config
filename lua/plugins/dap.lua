return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Set log level first
			dap.set_log_level("TRACE")

			-- Setup UI before configuring dap-go
			dapui.setup()

			-- Configure dap-go with explicit configuration
			require("dap-go").setup({
				delve = {
					path = "/opt/homebrew/bin/dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					args = { "--check-go-version=false" },
				},
				-- Debug settings
				dap_configurations = {
					{
						type = "go",
						name = "Debug Package",
						request = "launch",
						program = "${workspaceFolder}",
						buildFlags = "-gcflags='all=-N -l'",
					},
				},
			})

			-- Your existing keymaps
			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<space>?", function()
				dapui.eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			-- UI listeners
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
