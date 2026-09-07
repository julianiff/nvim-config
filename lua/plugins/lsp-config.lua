return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "j-hui/fidget.nvim" },
		config = function()
			require("fidget").setup({})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, _)
				client.server_capabilities.documentFormattingProvider = false
			end

			vim.diagnostic.config({
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

			local oxlint_on_attach = vim.lsp.config.oxlint.on_attach
			vim.lsp.config("oxlint", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if oxlint_on_attach then
						oxlint_on_attach(client, bufnr)
					end
					on_attach(client, bufnr)
				end,
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
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = true,
					["prophecy.enabled"] = true,
					["phpunit.enabled"] = true,
					["language_server_completion.trim_leading_dollar"] = true,
				},
				settings = {
					phpactor = {
						completion = {
							insertUseDeclaration = false,
						},
						codeTransform = {
							refactor = {
								generateAccessor = {
									prefix = "",
									upperCaseFirst = false,
								},
							},
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.enable("vtsls")
			vim.lsp.enable("oxlint")
			vim.lsp.enable("gopls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("phpactor")
			vim.lsp.enable("pyright")
			vim.lsp.enable("gleam")

			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				javascript = { "oxfmt", "prettierd", stop_after_first = true },
				javascriptreact = { "oxfmt", "prettierd", stop_after_first = true },
				typescript = { "oxfmt", "prettierd", stop_after_first = true },
				typescriptreact = { "oxfmt", "prettierd", stop_after_first = true },
				json = { "oxfmt", "prettierd", stop_after_first = true },
				html = { "oxfmt", "prettierd", stop_after_first = true },
				css = { "oxfmt", "prettierd", stop_after_first = true },
				yaml = { "oxfmt", "prettierd", stop_after_first = true },
				markdown = { "prettierd" },
				go = { "goimports" },
				lua = { "stylua" },
				python = { "black" },
				php = { "php_cs_fixer" },
			},
			format_on_save = nil,
			format_after_save = {
				lsp_format = "fallback",
			},
		},
	},
}
