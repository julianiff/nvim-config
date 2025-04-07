return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			-- "j-hui/fidget.nvim",
		},
		lazy = false,
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"eslint",
					"phpactor",
				},
				auto_install = true,
				handlers = {
					function(server)
						require("lspconfig")[server].setup({
							capabilities = vim.tbl_deep_extend(
								"force",
								vim.lsp.protocol.make_client_capabilities(),
								require("cmp_nvim_lsp").default_capabilities()
							),
						})
					end,
				},
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- require("fidget").setup({})

			-- Javascript related
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

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
	{ -- optional cmp completion source for require statements and module annotations
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
