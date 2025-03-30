return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				custom_highlights = function(colors)
					return {
						-- Make Blink signature popup bright for contrast
						BlinkCmpSignatureHelp = { bg = colors.mantle, fg = colors.text },
						BlinkCmpSignatureHelpBorder = { fg = colors.blue, bg = colors.mantle, style = { "bold" } },
						BlinkCmpSignatureHelpActiveParameter = {
							fg = colors.peach,
							bg = colors.surface1,
							style = { "bold", "italic", "underline" },
						},

						-- Brighter background for better pop
						BlinkSignature = { bg = colors.surface0, fg = colors.text },
						BlinkSignatureBorder = { fg = colors.pink, bg = colors.mantle, style = { "bold" } },

						-- High contrast for important elements
						BlinkCmpSignatureHelpFuncName = { fg = colors.yellow, style = { "bold" } },
						BlinkCmpSignatureHelpType = { fg = colors.green, style = { "italic" } },

						-- Ensure clear separation with bright color
						BlinkCmpSignatureHelpSeparator = { fg = colors.lavender },

						-- Improve documentation with brighter text
						BlinkCmpSignatureHelpDoc = { fg = colors.rosewater, bg = colors.surface0 },
					}
				end,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					treesitter = true,
				},
			})

			-- Add padding settings for Blink signature popup
			-- This needs to be after catppuccin setup but before colorscheme call
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					vim.opt_local.signcolumn = "yes"

					-- Set up padding for Blink signature popup if the plugin exists
					local has_blink, blink = pcall(require, "blink")
					if has_blink then
						blink.setup({
							signature = {
								padding = {
									top = 1,
									bottom = 1,
									left = 2,
									right = 2,
								},
								border = "rounded",
								max_width = 80,
								max_height = 20,
								floating_window = {
									opacity = 1.0,
									relative = "cursor",
								},
							},
						})
					end
				end,
			})

			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
