return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"williamboman/mason.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
		},
		lazy = false,
		config = function()
			-- Setup fidget first
			require("fidget").setup({})

			-- Setup mason
			require("mason").setup()

			-- Get capabilities for LSP
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Javascript organize imports function
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

			-- Manual server configurations
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})
			-- Go Language Server setup
			lspconfig.gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						-- Enable all analyses
						analyses = {
							unusedparams = true,
							shadow = true,
							fieldalignment = true,
							nilness = true,
							unusedwrite = true,
							useany = true,
						},
						-- Enable experimental features
						experimentalPostfixCompletions = true,
						-- Use gofumpt for formatting
						gofumpt = true,
						-- Enable staticcheck
						staticcheck = true,
						-- Enable vulncheck
						vulncheck = "Imports",
						-- Semantic tokens
						semanticTokens = true,
						-- Codelenses
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						-- Hints
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
				on_attach = function(client, bufnr)
					-- Auto-format on save for Go files
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							-- Organize imports
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.organizeImports" } }
							local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
							for _, res in pairs(result or {}) do
								for _, r in pairs(res.result or {}) do
									if r.edit then
										vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
									else
										vim.lsp.buf.execute_command(r.command)
									end
								end
							end
							-- Format
							vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
						end,
					})
				end,
			})
			-- Zig Language Server setup
			lspconfig.zls.setup({
				capabilities = capabilities,
				settings = {
					zls = {
						-- Enable semantic tokens for better syntax highlighting
						enable_semantic_tokens = true,
						-- Enable snippets completion
						enable_snippets = true,
						-- Enable argument placeholders
						enable_argument_placeholders = true,
						-- Enable auto-fixing of imports
						enable_autofix = true,
						-- Enable inlay hints
						enable_inlay_hints = true,
						-- Warn about style issues
						warn_style = true,
						-- Highlight global variables
						highlight_global_var_declarations = true,
					},
				},
				on_attach = function(client, bufnr)
					-- Optional: Add auto-formatting on save for Zig files
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
						end,
					})
				end,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.cmd("EslintFixAll")
							vim.cmd("OrganizeImports")
							vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
						end,
					})
				end,
			})

			lspconfig.phpactor.setup({
				capabilities = capabilities,
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

			-- LSP keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
		end,
	},
	{
		"folke/lazydev.nvim",
		dependencies = {
			"bilal2453/luvit-meta",
		},
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
}
