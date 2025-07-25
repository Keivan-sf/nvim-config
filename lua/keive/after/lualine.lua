local utils = require("keive.utils")
if utils.is_available("lualine.nvim") then
	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "ayu_dark",
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {
					"cmp_docs",
					"cmp_menu",
				},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			-- lualine_c = { },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			-- lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

local default_refresh_events = {
  'WinEnter',
  'BufEnter',
  'BufWritePost',
  'SessionLoadPost',
  'FileChangedShellPost',
  'VimResized',
  'Filetype',
  'CursorMoved',
  'CursorMovedI',
  'ModeChanged',
}
vim.api.nvim_create_autocmd(default_refresh_events, {
  group = vim.api.nvim_create_augroup('LualineRefreshEvents', { clear = true }),
  callback = function()
    vim.schedule(function()
      require('lualine').refresh()
    end)
  end,
})
