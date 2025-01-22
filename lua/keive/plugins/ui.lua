return {
	{
		"nvim-tree/nvim-web-devicons",
		enabled = vim.g.icons_enabled,
		lazy = true,
		opts = {
			override = {
				default_icon = { icon = require("keive.utils").get_icon("DefaultFile") },
				deb = { icon = "", name = "Deb" },
				lock = { icon = "󰌾", name = "Lock" },
				mp3 = { icon = "󰎆", name = "Mp3" },
				mp4 = { icon = "", name = "Mp4" },
				out = { icon = "", name = "Out" },
				["robots.txt"] = { icon = "󰚩", name = "Robots" },
				ttf = { icon = "", name = "TrueTypeFont" },
				rpm = { icon = "", name = "Rpm" },
				woff = { icon = "", name = "WebOpenFontFormat" },
				woff2 = { icon = "", name = "WebOpenFontFormat2" },
				xz = { icon = "", name = "Xz" },
				zip = { icon = "", name = "Zip" },
			},
		},
	},
	{
		"onsails/lspkind.nvim",
		lazy = true,
		opts = {
			mode = "symbol",
			symbol_map = {
				Array = "󰅪",
				Boolean = "⊨",
				Class = "󰌗",
				Constructor = "",
				Key = "󰌆",
				Namespace = "󰅪",
				Null = "NULL",
				Number = "#",
				Object = "󰀚",
				Package = "󰏗",
				Property = "",
				Reference = "",
				Snippet = "",
				String = "󰀬",
				TypeParameter = "󰊄",
				Unit = "",
			},
			menu = {},
		},
		enabled = vim.g.icons_enabled,
		config = function(_, opts)
			require("lspkind").init(opts)
		end,
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			require("keive.utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" })
		end,
		opts = {
			input = { default_prompt = "➤ " },
			select = { backend = { "telescope", "builtin" } },
		},
	},
}
