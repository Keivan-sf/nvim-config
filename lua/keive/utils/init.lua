local M = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
	opts = opts or {}
	return default and vim.tbl_deep_extend("force", default, opts) or opts
end

function M.get_icon(kind, padding, no_fallback)
	if not vim.g.icons_enabled and no_fallback then
		return ""
	end
	-- if icons are enabled use nerd_fonts if not use text icons
	local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
	if not M[icon_pack] then
		M.icons = require("keive.icons.nerd_font")
		M.text_icons = require("keive.icons.text")
	end
	local icon = M[icon_pack] and M[icon_pack][kind]
	return icon and icon .. string.rep(" ", padding or 0) or ""
end

-- check if a plugin is available
function M.is_available(plugin)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Resolve the options table for a given plugin with lazy
---@param plugin string The plugin to search for
---@return table opts # The plugin options
function M.plugin_opts(plugin)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")
	local opts = {}
	if lazy_config_avail and lazy_plugin_avail then
		local spec = lazy_config.spec.plugins[plugin]
		if spec then
			opts = lazy_plugin.values(spec, "opts")
		end
	end
	return opts
end

--- A helper function to wrap a module function to require a plugin before running
---@param plugin string The plugin to call `require("lazy").load` with
---@param module table The system module where the functions live (e.g. `vim.ui`)
---@param func_names string|string[] The functions to wrap in the given module (e.g. `{ "ui", "select }`)
function M.load_plugin_with_func(plugin, module, func_names)
	if type(func_names) == "string" then
		func_names = { func_names }
	end
	for _, func in ipairs(func_names) do
		local old_func = module[func]
		module[func] = function(...)
			module[func] = old_func
			require("lazy").load({ plugins = { plugin } })
			module[func](...)
		end
	end
end

--- Toggle a user terminal if it exists, if not then create a new one and save it
---@param opts string|table A terminal command string or a table of options for Terminal:new() (Check toggleterm.nvim documentation for table format)
function M.toggle_term_cmd(opts)
	local terms = main.user_terminals
	-- if a command string is provided, create a basic table for Terminal:new() options
	if type(opts) == "string" then
		opts = { cmd = opts }
	end
	opts = M.extend_tbl({ hidden = true }, opts)
	local num = vim.v.count > 0 and vim.v.count or 1
	-- if terminal doesn't exist yet, create it
	if not terms[opts.cmd] then
		terms[opts.cmd] = {}
	end
	if not terms[opts.cmd][num] then
		if not opts.count then
			opts.count = vim.tbl_count(terms) * 100 + num
		end
		if not opts.on_exit then
			opts.on_exit = function()
				terms[opts.cmd][num] = nil
			end
		end
		terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
	end
	-- toggle the terminal
	terms[opts.cmd][num]:toggle()
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string|string[] The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.cmd(cmd, show_error)
	if type(cmd) == "string" then
		cmd = { cmd }
	end
	if vim.fn.has("win32") == 1 then
		cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
	end
	local result = vim.fn.system(cmd)
	local success = vim.api.nvim_get_vvar("shell_error") == 0
	if not success and (show_error == nil or show_error) then
		vim.api.nvim_err_writeln(
			("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result)
		)
	end
	return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

--- Check if a buffer is valid
---@param bufnr number? The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Close a given buffer
---@param bufnr? number The buffer to close or the current buffer if not provided
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
function M.close(bufnr, force)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if M.is_available "mini.bufremove" and M.is_valid(bufnr) and #vim.t.bufs > 1 then
    if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      local bufname = vim.fn.expand "%"
      local empty = bufname == ""
      if empty then bufname = "Untitled" end
      local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
      if confirm == 1 then
        if empty then return end
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
