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
vim.o.showmode = false
-- vim.o.shortmess = vim.o.shortmess .. 'c'
-- vim.o.lazyredraw = true
vim.g.icons_enabled = true
vim.g.cmp_enabled = true
vim.g.noswapfile = true
vim.cmd [[
  augroup LualineUpdate
    autocmd!
    autocmd InsertEnter * lua vim.defer_fn(function() require('lualine').refresh() end, 100)
  augroup END
]]
