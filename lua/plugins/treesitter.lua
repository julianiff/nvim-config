return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("treesitter-context").setup({
				enable = false,
			})

			local config = require("nvim-treesitter.configs")
			config.setup({
				modules = {},
				auto_install = true,
				sync_install = true,
				ignore_install = {},
				ensure_installed = {
					"bash",
					"gitcommit",
					"gitignore",
					"json",
					"lua",
					"markdown",
					"php",
					"vim",
					"vimdoc",
					"yaml",
					"go",
					"tsx",
				},
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					lsp_interop = {
						enable = true,
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>df"] = "@function.outer",
							["<leader>dF"] = "@class.outer",
						},
					},
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj
						keymaps = {
							-- Functions
							["af"] = "@function.outer", -- Around function
							["if"] = "@function.inner", -- Inside function

							-- Classes/structures
							["ac"] = "@class.outer", -- Around class
							["ic"] = "@class.inner", -- Inside class

							-- Arguments/parameters
							["aa"] = "@parameter.outer", -- Around argument
							["ia"] = "@parameter.inner", -- Inside argument

							-- Code blocks
							["ab"] = "@block.outer", -- Around block
							["ib"] = "@block.inner", -- Inside block

							-- Conditionals
							["ai"] = "@conditional.outer", -- Around if
							["ii"] = "@conditional.inner", -- Inside if

							-- Loops
							["al"] = "@loop.outer", -- Around loop
							["il"] = "@loop.inner", -- Inside loop

							-- Comments
							["a/"] = "@comment.outer", -- Around comment

							-- Function calls
							["am"] = "@call.outer", -- Around method call
							["im"] = "@call.inner", -- Inside method call

							-- Statements
							["as"] = "@statement.outer", -- Around statement
							["is"] = "@statement.inner",

							-- Assignments
							["ar"] = "@assignment.rhs", -- Around assignment
							["alh"] = "@assignment.lhs", -- Around assignment
							["a="] = "@assignment.outer", -- Around assignment
							["i="] = "@assignment.inner", -- Inside assignment
						},
					},

					move = {
						enable = true,
						set_jumps = true, -- Add to jumplist
						goto_next_start = {
							["]f"] = "@function.outer", -- Next function start
							["]c"] = "@class.outer", -- Next class start
							["]i"] = "@conditional.outer", -- Next if statement start
							["]l"] = "@loop.outer", -- Next loop start
							["]a"] = "@parameter.outer", -- Next parameter start
						},
						goto_next_end = {
							["]F"] = "@function.outer", -- Next function end
							["]C"] = "@class.outer", -- Next class end
							["]I"] = "@conditional.outer", -- Next if statement end
							["]L"] = "@loop.outer", -- Next loop end
						},
						goto_previous_start = {
							["[f"] = "@function.outer", -- Previous function start
							["[c"] = "@class.outer", -- Previous class start
							["[i"] = "@conditional.outer", -- Previous if statement start
							["[l"] = "@loop.outer", -- Previous loop start
							["[a"] = "@parameter.outer", -- Previous parameter start
						},
						goto_previous_end = {
							["[F"] = "@function.outer", -- Previous function end
							["[C"] = "@class.outer", -- Previous class end
							["[I"] = "@conditional.outer", -- Previous if statement end
							["[L"] = "@loop.outer", -- Previous loop end
						},
					},

					-- Swap elements (rearranging code)
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = "@parameter.inner", -- Swap with next parameter
						},
						swap_previous = {
							["<leader>sA"] = "@parameter.inner", -- Swap with previous parameter
						},
					},
				},
			})
		end,
	},
}
