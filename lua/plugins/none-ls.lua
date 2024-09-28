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
				require("none-ls.diagnostics.eslint_d"),
				require("none-ls.code_actions.eslint_d"),
                null_ls.builtins.diagnostics.phpcs,
                null_ls.builtins.formatting.phpcbf,
			},
		})

        local function organize_imports()
            local params = {
                command = "_typescript.organizeImports.ts",
                arguments = {vim.api.nvim_buf_get_name(0)},
                title = "Organize Imports"
            }
            vim.lsp.buf.execute_command(params)
        end

        vim.keymap.set("n", "<leader>gf", function ()
            vim.lsp.buf.format()
            organize_imports()
        end, {})
	end,
}
