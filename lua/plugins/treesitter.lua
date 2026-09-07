-- nvim-treesitter's `main` branch is a rewrite with no module system: the
-- plugin only installs parsers and ships queries, and every feature
-- (highlighting, indentation, textobjects) is wired up here by hand.
local ensure_installed = {
	"bash",
	"gitcommit",
	"gitignore",
	"go",
	"json",
	"lua",
	"markdown",
	"php",
	"phpdoc",
	"regex",
	"tsx",
	"vim",
	"vimdoc",
	"yaml",
}

-- x/o-mode textobjects, from queries/<lang>/textobjects.scm
local select_keymaps = {
	["af"] = "@function.outer",
	["if"] = "@function.inner",
	["ac"] = "@class.outer",
	["ic"] = "@class.inner",
	["aa"] = "@parameter.outer",
	["ia"] = "@parameter.inner",
	["ab"] = "@block.outer",
	["ib"] = "@block.inner",
	["ai"] = "@conditional.outer",
	["ii"] = "@conditional.inner",
	["al"] = "@loop.outer",
	["il"] = "@loop.inner",
	["a/"] = "@comment.outer",
	["am"] = "@call.outer",
	["im"] = "@call.inner",
	["as"] = "@statement.outer",
	["is"] = "@statement.inner",
	["arh"] = "@assignment.rhs",
	["alh"] = "@assignment.lhs",
	["a="] = "@assignment.outer",
	["i="] = "@assignment.inner",
}

local move_keymaps = {
	goto_next_start = {
		["]f"] = "@function.outer",
		["]c"] = "@class.outer",
		["]i"] = "@conditional.outer",
		["]l"] = "@loop.outer",
		["]a"] = "@parameter.outer",
	},
	goto_next_end = {
		["]F"] = "@function.outer",
		["]C"] = "@class.outer",
		["]I"] = "@conditional.outer",
		["]L"] = "@loop.outer",
	},
	goto_previous_start = {
		["[f"] = "@function.outer",
		["[c"] = "@class.outer",
		["[i"] = "@conditional.outer",
		["[l"] = "@loop.outer",
		["[a"] = "@parameter.outer",
	},
	goto_previous_end = {
		["[F"] = "@function.outer",
		["[C"] = "@class.outer",
		["[I"] = "@conditional.outer",
		["[L"] = "@loop.outer",
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the rewrite does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({})
			ts.install(ensure_installed)

			local available = nil ---@type string[]?

			local function start(buf, lang)
				if not vim.treesitter.language.add(lang) then
					return false
				end
				vim.treesitter.start(buf, lang)
				if vim.treesitter.query.get(lang, "indents") then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
				return true
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or start(args.buf, lang) then
						return
					end

					-- stand-in for the old `auto_install`: pull the parser in,
					-- then highlight the buffer that asked for it
					available = available or ts.get_available()
					if not vim.tbl_contains(available, lang) then
						return
					end
					ts.install(lang):await(function()
						vim.schedule(function()
							if vim.api.nvim_buf_is_valid(args.buf) then
								start(args.buf, lang)
							end
						end)
					end)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true, -- automatically jump forward to textobj
				},
				move = {
					set_jumps = true, -- add to jumplist
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			for lhs, query in pairs(select_keymaps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end, { desc = "Select " .. query })
			end

			local move = require("nvim-treesitter-textobjects.move")
			for fn, keymaps in pairs(move_keymaps) do
				for lhs, query in pairs(keymaps) do
					vim.keymap.set({ "n", "x", "o" }, lhs, function()
						move[fn](query, "textobjects")
					end, { desc = fn:gsub("_", " ") .. " " .. query })
				end
			end

			local swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", "<leader>sa", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap with next parameter" })
			vim.keymap.set("n", "<leader>sA", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap with previous parameter" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		main = "treesitter-context",
		event = "VeryLazy",
		opts = {
			enable = false,
		},
	},
}
