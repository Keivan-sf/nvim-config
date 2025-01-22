return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local actions = require("telescope.actions")
		return {
			git_worktrees = vim.g.git_worktrees,
			--prompt_prefix = get_icon("Selected", 1),
			--selection_caret = get_icon("Selected", 1),
			path_display = { "truncate" },
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = { prompt_position = "top", preview_width = 0.55 },
				vertical = { mirror = false },
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
			defaults = {
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
					n = { q = actions.close },
				},
			},
		}
	end,
}
