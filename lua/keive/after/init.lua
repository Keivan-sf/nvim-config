local utils = require("keive.utils")
vim.cmd.colorscheme("github_dark_default")
if utils.is_available("treesitter.nvim") then
	vim.cmd("TSEnable 1")
end
require("keive.after.lsp")
require("keive.after.cmp")
require("keive.after.conform")
require("keive.after.lualine")
