return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	event = "BufReadPre",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.phpcbf,
				require("none-ls.diagnostics.eslint_d"),
				null_ls.builtins.diagnostics.golangci_lint,
			},
		})

		-- List of file types that ESLint should run on
		local eslint_filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		}
		local function is_js_format()
			return vim.tbl_contains(eslint_filetypes, vim.bo.filetype)
		end

		local function eslint_fix()
			local file = vim.fn.expand("%:p")
			local cmd = string.format("eslint_d --fix %s", file)
			vim.fn.jobstart(cmd, {
				on_exit = function(_, exit_code)
					if exit_code == 0 then
                    vim.cmd("e")
						print("ESlint fix")
					else
						print("ESLint encountered an error")
						vim.cmd("e")
					end
				end,
			})
		end
		local function organize_imports()
			local params = {
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "Organize Imports",
			}
			vim.lsp.buf_request(0, "workspace/executeCommand", params, function(err)
				if err then
					print("Err organizing Imports")
				end
			end)
		end

		vim.keymap.set("n", "<leader>ff", function()
			if is_js_format() then
				organize_imports()
				eslint_fix()
			end
		end, { desc = "[F]ix Javascript [F]ile" })

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
