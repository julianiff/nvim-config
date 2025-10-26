return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "j-hui/fidget.nvim" },
		config = function()
			require("fidget").setup({})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
			end

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = false,
					underline = true,
					virtual_text = {
						spacing = 4,
						source = "if_many",
					},
					signs = true,
					severity_sort = true,
				})

			vim.lsp.config("vtsls", {
				cmd = { "vtsls", "--stdio" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					typescript = {
						preferences = {
							importModuleSpecifier = "shortest",
							includePackageJsonAutoImports = "off",
						},
						tsserver = {
							maxTsServerMemory = 8192,
							useSyntaxServer = "auto",
						},
						inlayHints = {
							parameterNames = { enabled = "none" },
							parameterTypes = { enabled = false },
							variableTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = false },
							functionLikeReturnTypes = { enabled = false },
						},
						suggest = {
							completeFunctionCalls = false,
						},
					},
					javascript = {
						preferences = {
							importModuleSpecifier = "shortest",
						},
						inlayHints = {
							parameterNames = { enabled = "none" },
							parameterTypes = { enabled = false },
							variableTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = false },
							functionLikeReturnTypes = { enabled = false },
						},
					},
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
					},
				},
			})

			vim.lsp.config("eslint", {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					run = "onSave", -- Only run on save for better performance
					workingDirectory = { mode = "location" },
				},
			})

			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			vim.lsp.config("phpactor", {
				cmd = { "phpactor", "language-server" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.enable("vtsls")
			vim.lsp.enable("eslint")
			vim.lsp.enable("gopls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("phpactor")
			vim.lsp.enable("pyright")

			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				go = { "goimports" },
				lua = { "stylua" },
				python = { "black" },
				php = { "php_cs_fixer" },
			},
			format_on_save = { lsp_fallback = true },
		},
	},
}
