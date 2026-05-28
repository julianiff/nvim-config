return {
	{
		"mcchrish/zenbones.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
		lazy = false,
		config = function()
			local function shift(n, amount)
				local r = math.min(255, math.max(0, math.floor(n / 65536) + amount))
				local g = math.min(255, math.max(0, math.floor(n / 256) % 256 + amount))
				local b = math.min(255, math.max(0, n % 256 + amount))
				return string.format("#%02x%02x%02x", r, g, b)
			end

			local function brighten_floats()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				if not normal.bg then
					return
				end
				local amount = vim.o.background == "dark" and 14 or -10
				local lifted = shift(normal.bg, amount)
				local border_fg = shift(normal.bg, amount + 20)
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = lifted })
				vim.api.nvim_set_hl(0, "Pmenu", { bg = lifted })
				vim.api.nvim_set_hl(0, "FloatBorder", { bg = lifted, fg = border_fg })
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = brighten_floats,
			})

			vim.o.background = "dark"
			vim.cmd.colorscheme("rosebones")

			local toggle_background = function()
				vim.o.background = vim.o.background == "dark" and "light" or "dark"
				brighten_floats()
			end

			vim.keymap.set("n", "<f12>", toggle_background, { desc = "Colors" })
		end,
	},
}
