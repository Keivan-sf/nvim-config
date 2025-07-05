local utils = require("keive.utils")
local M = {}


--- Check if a buffer is valid
---@param bufnr number? The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
	if not bufnr then
		bufnr = 0
	end
	return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Close a given buffer
---@param bufnr? number The buffer to close or the current buffer if not provided
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
function M.close(bufnr, force)
	if not bufnr or bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end
	if utils.is_available("mini.bufremove") and M.is_valid(bufnr) and #vim.api.nvim_list_bufs() > 1 then
		if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
			local bufname = vim.fn.expand("%")
			local empty = bufname == ""
			if empty then
				bufname = "Untitled"
			end
			local confirm =
				vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
			if confirm == 1 then
				if empty then
					return
				end
				vim.cmd.write()
			elseif confirm == 2 then
				force = true
			else
				return
			end
		end
		require("mini.bufremove").delete(bufnr, force)
	else
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
		vim.cmd(("silent! %s %d"):format((force or buftype == "terminal") and "bdelete!" or "confirm bdelete", bufnr))
	end
end

return M
