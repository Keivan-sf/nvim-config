local is_cmp_available, _cmp = pcall(require, "cmp_nvim_lsp")
local is_lsp_available, _lsp = pcall(require, "lspconfig")

if is_lsp_available and is_cmp_available then
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local utils = require("keive.utils")
	local get_icon = utils.get_icon
	local signs = {
		{ name = "DiagnosticSignError", text = get_icon("DiagnosticError"), texthl = "DiagnosticSignError" },
		{ name = "DiagnosticSignWarn", text = get_icon("DiagnosticWarn"), texthl = "DiagnosticSignWarn" },
		{ name = "DiagnosticSignHint", text = get_icon("DiagnosticHint"), texthl = "DiagnosticSignHint" },
		{ name = "DiagnosticSignInfo", text = get_icon("DiagnosticInfo"), texthl = "DiagnosticSignInfo" },
		{ name = "DapStopped", text = get_icon("DapStopped"), texthl = "DiagnosticWarn" },
		{ name = "DapBreakpoint", text = get_icon("DapBreakpoint"), texthl = "DiagnosticInfo" },
		{ name = "DapBreakpointRejected", text = get_icon("DapBreakpointRejected"), texthl = "DiagnosticError" },
		{ name = "DapBreakpointCondition", text = get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
		{ name = "DapLogPoint", text = get_icon("DapLogPoint"), texthl = "DiagnosticInfo" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, sign)
	end
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = utils.get_icon("DiagnosticError"),
				[vim.diagnostic.severity.HINT] = utils.get_icon("DiagnosticHint"),
				[vim.diagnostic.severity.WARN] = utils.get_icon("DiagnosticWarn"),
				[vim.diagnostic.severity.INFO] = utils.get_icon("DiagnosticInfo"),
			},
			active = signs,
		},
	})

	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						-- "${3rd}/luv/library"
						-- "${3rd}/busted/library",
					},
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
					-- library = vim.api.nvim_get_runtime_file("", true)
				},
			})
		end,
		settings = {
			Lua = {},
		},
	})

	require("lspconfig").pyright.setup({})
	require("lspconfig").tsserver.setup({})

	require("lspconfig").emmet_ls.setup({})
	require("lspconfig").html.setup({
		capabilities = capabilities,
	})
	require("lspconfig").cssls.setup({
		capabilities = capabilities,
	})
	require("lspconfig").css_variables.setup({})
end
