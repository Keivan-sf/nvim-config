local utils = require("keive.utils")
local is_cmp_available , _cmp = pcall(require , "cmp")
if is_cmp_available then
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local utils = require("keive.utils")
	require("luasnip/loaders/from_vscode").lazy_load()

	vim.opt.completeopt = "menu,menuone,noselect"

	local are_dap_and_cmp_available = function()
		local dap_prompt = utils.is_available("cmp-dap") -- add interoperability with cmp-dap
			and vim.tbl_contains(
				{ "dap-repl", "dapui_watches", "dapui_hover" },
				vim.api.nvim_get_option_value("filetype", { buf = 0 })
			)
		if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" and not dap_prompt then
			return false
		end
		return vim.g.cmp_enabled
	end

	local border_opts = {
		border = "rounded",
		-- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
		winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
	}

	local lspkind_status_ok, lspkind = pcall(require, "lspkind")
	cmp.setup({
		enabled = are_dap_and_cmp_available,
		performance = {
		    debounce = 200,  -- Increase debounce delay to reduce flicker
		    throttle = 50,   -- Reduce update rate
            fetching_timeout = 500, -- Delay fetch to prevent UI lag
		},
		duplicates = {
			nvim_lsp = 1,
			luasnip = 1,
			cmp_tabnine = 1,
			buffer = 1,
			path = 1,
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		window = {
			completion = cmp.config.window.bordered(border_opts),
			documentation = cmp.config.window.bordered(border_opts),
		},
		preselect = cmp.PreselectMode.None,
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = lspkind_status_ok and lspkind.cmp_format(utils.plugin_opts("lspkind.nvim")) or nil,
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			-- ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			-- ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-y>"] = cmp.mapping.confirm({ select = false }),
			["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
			["<CR>"] = cmp.mapping.confirm({ select = false }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp", priority = 1000 },
			{ name = "luasnip", priority = 750 },
			{ name = "buffer", priority = 500 },
			{ name = "path", priority = 250 },
		}),
	})
end
