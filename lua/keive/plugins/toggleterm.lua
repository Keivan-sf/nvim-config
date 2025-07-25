return {
	"akinsho/toggleterm.nvim",
	cmd = { "ToggleTerm", "TermExec" },
	opts = {
		highlights = {
			Normal = { link = "Normal" },
			NormalNC = { link = "NormalNC" },
			-- NormalFloat = { link = "NormalFloat" },
			NormalFloat = { link = "Normal" },
			-- FloatBorder = { link = "FloatBorder" },
			FloatBorder = { link = "Normal" },
			StatusLine = { link = "StatusLine" },
			StatusLineNC = { link = "StatusLineNC" },
			WinBar = { link = "WinBar" },
			WinBarNC = { link = "WinBarNC" },
		},
		size = 10,
		---@param t Terminal
		on_create = function(t)
			vim.opt_local.foldcolumn = "0"
			vim.opt_local.signcolumn = "no"
			if t.hidden then
				local toggle = function()
					t:toggle()
				end
				for _, key in ipairs({ "<C-'>", "<F7>" }) do
					vim.keymap.set({ "n", "t", "i" }, key, toggle, { desc = "Toggle terminal", buffer = t.bufnr })
				end
			end
		end,
		shading_factor = 2,
		direction = "float",
		float_opts = { border = "rounded" },
	},
}
