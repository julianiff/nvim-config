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
                -- null_ls.builtins.diagnostics.phpcs,
                null_ls.builtins.formatting.phpcbf,
			},
		})

        vim.keymap.set("n", "<leader>gf", function ()
            vim.lsp.buf.format()
        end, {})
	end,
}
