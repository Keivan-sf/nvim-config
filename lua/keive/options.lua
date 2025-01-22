if vim.fn["has"]("unnamedplus") then
	vim.opt.clipboard:append({ "unnamedplus" })
else
	vim.opt.clipboard:append({ "unnamed" })
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.cmdheight = 0
vim.o.winbar = "%f"
vim.g.icons_enabled = true
vim.g.cmp_enabled = true
