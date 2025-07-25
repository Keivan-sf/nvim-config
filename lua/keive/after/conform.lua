local utils = require("keive.utils")
if utils.is_available("conform.nvim") then
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			c = { "astyle" },
			h = { "astyle" },
			cpp = { "astyle" },
			hpp = { "astyle" },
			nix = { "nixfmt" },
			go = { "gofmt" },
		},
		-- If this is set, Conform will run the formatter on save.
		-- It will pass the table to conform.format().
		-- This can also be a function that returns the table.
		--  format_on_save = {
		--    lsp_format = "fallback",
		--    timeout_ms = 500,
		--  },
	})

	vim.api.nvim_create_user_command("Format", function(args)
		local range = nil
		if args.count ~= -1 then
			local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
			range = {
				start = { args.line1, 0 },
				["end"] = { args.line2, end_line:len() },
			}
		end
		require("conform").format({ async = true, lsp_format = "fallback", range = range })
	end, { range = true })
end
