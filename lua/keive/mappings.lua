local map = vim.keymap.set
local utils = require("keive.utils")

map("n", "|", "<cmd>vsplit<cr>")
map("n", "\\", "<cmd>split<cr>")
-- telescope
if utils.is_available("telescope.nvim") then
	-- Git branches
	map("n", "<leader>gb", function()
		require("telescope.builtin").git_branches({ use_file_path = true })
	end)
	-- Git commits (repository)
	map("n", "<leader>gc", function()
		require("telescope.builtin").git_commits({ use_file_path = true })
	end)
	-- Git commits (current file)
	map("n", "<leader>gC", function()
		require("telescope.builtin").git_bcommits({ use_file_path = true })
	end)
	-- Git status
	map("n", "<leader>gt", function()
		require("telescope.builtin").git_status({ use_file_path = true })
	end)
	-- Resume previous search
	map("n", "<leader>f<CR>", function()
		require("telescope.builtin").resume()
	end)
	--  Find marks
	map("n", "<leader>f'", function()
		require("telescope.builtin").marks()
	end)
	--  Find words in current buffer
	map("n", "<leader>f/", function()
		require("telescope.builtin").current_buffer_fuzzy_find()
	end)
	--  Find buffers
	map("n", "<leader>fb", function()
		require("telescope.builtin").buffers({
			layout_strategy = "vertical",
			layout_config = { width = 0.4, prompt_position = "top", height = 0.3, preview_height = 0 },
		})
	end)
	--  Find word under cursor
	map("n", "<leader>fc", function()
		require("telescope.builtin").grep_string()
	end)
	-- Find commands
	map("n", "<leader>fC", function()
		require("telescope.builtin").commands()
	end)
	--  Find Files
	map("n", "<leader>ff", function()
		require("telescope.builtin").find_files({
			layout_strategy = "vertical",
			layout_config = { width = 0.4, prompt_position = "top", height = 0.3, preview_height = 0 },
		})
	end)
	--  Find Files (no ignored)
	map("n", "<leader>fF", function()
		require("telescope.builtin").find_files({
			hidden = true,
			no_ignore = true,
			layout_strategy = "vertical",
			layout_config = { width = 0.4, prompt_position = "top", height = 0.3, preview_height = 0 },
		})
	end)
	--  Find help
	map("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end)
	--  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
	-- Find keymaps
	map("n", "<leader>fk", function()
		require("telescope.builtin").keymaps()
	end)
	-- Find man
	map("n", "<leader>fm", function()
		require("telescope.builtin").man_pages()
	end)

	--  if is_available "nvim-notify" then
	--    maps.n["<leader>fn"] =
	--      { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
	--    maps.n["<leader>uD"] =
	--      { function() require("notify").dismiss { pending = true, silent = true } end, desc = "Dismiss notifications" }
	--  end
	--
	--  Find history
	map("n", "<leader>fo", function()
		require("telescope.builtin").oldfiles()
	end)
	--  Find registers
	map("n", "<leader>fr", function()
		require("telescope.builtin").registers()
	end)
	-- Find themes
	map("n", "<leader>ft", function()
		require("telescope.builtin").colorscheme({ enable_preview = true })
	end)
	--  Find words
	map("n", "<leader>fw", function()
		require("telescope.builtin").live_grep()
	end)
	--  Find words in all files
	map("n", "<leader>fW", function()
		require("telescope.builtin").live_grep({
			additional_args = function(args)
				return vim.list_extend(args, { "--hidden", "--no-ignore" })
			end,
		})
	end)

	--  maps.n["<leader>ls"] = {
	--    function()
	--      local aerial_avail, _ = pcall(require, "aerial")
	--      if aerial_avail then
	--        require("telescope").extensions.aerial.aerial()
	--      else
	--        require("telescope.builtin").lsp_document_symbols()
	--      end
	--    end,
	--    desc = "Search symbols",
	--  }
end

-- neo-tree
if utils.is_available("neo-tree.nvim") then
	-- Toggle Explorer
	map("n", "<leader>e", "<cmd>Neotree toggle<cr>")

	-- Toggle Explorer Focus
	map("n", "<leader>o", function()
		if vim.bo.filetype == "neo-tree" then
			vim.cmd.wincmd("p")
		else
			vim.cmd.Neotree("focus")
		end
	end)
end

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function()
		-- Displays hover information about the symbol under the cursor
		map("n", "K", function()
			vim.lsp.buf.hover()
		end, { buffer = true })

		-- Jump to the definition
		map("n", "gd", function()
			vim.lsp.buf.definition({
				on_list = function(options)
					vim.fn.setqflist({}, " ", options)
					vim.cmd.cfirst()
				end,
			})
		end, { buffer = true })

		-- Jump to declaration
		map("n", "gD", function()
			vim.lsp.buf.declaration()
		end, { buffer = true })

		-- Lists all the implementations for the symbol under the cursor
		map("n", "gi", function()
			vim.lsp.buf.implementation()
		end, { buffer = true })

		-- Jumps to the definition of the type symbol
		map("n", "go", function()
			vim.lsp.buf.type_definition()
		end, { buffer = true })

		-- Lists all the references
		map("n", "gr", function()
			vim.lsp.buf.references()
		end, { buffer = true })

		-- Displays a function's signature information
		map("n", "gs", function()
			vim.lsp.buf.signature_help()
		end, { buffer = true })

		-- Renames all references to the symbol under the cursor
		map("n", "<leader>lr", function()
			vim.lsp.buf.rename()
		end, { buffer = true })

		-- Search references
		map("n", "<leader>lR", function()
			vim.lsp.buf.references()
		end, { buffer = true })

		-- Selects a code action available at the current cursor position
		map("n", "<leader>la", function()
			vim.lsp.buf.code_action()
		end, { buffer = true })

		-- Show diagnostics in a floating window
		map("n", "<leader>ld", function()
			vim.diagnostic.open_float()
		end, { buffer = true })

		-- Move to the previous diagnostic
		map("n", "[d", function()
			vim.diagnostic.goto_prev()
		end, { buffer = true })

		-- Move to the next diagnostic
		map("n", "]d", function()
			vim.diagnostic.goto_next()
		end, { buffer = true })
	end,
})
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("code_action_sign", { clear = true }),
	callback = function()
		-- do something here
	end,
})

-- git signs
if utils.is_available("gitsigns.nvim") then
	map("n", "]g", function()
		require("gitsigns").next_hunk()
	end)
	map("n", "[g", function()
		require("gitsigns").prev_hunk()
	end)
	map("n", "<leader>gl", function()
		require("gitsigns").blame_line()
	end)
	map("n", "<leader>gL", function()
		require("gitsigns").blame_line({ full = true })
	end)
	map("n", "<leader>gp", function()
		require("gitsigns").preview_hunk()
	end)
	map("n", "<leader>gh", function()
		require("gitsigns").reset_hunk()
	end)
	map("n", "<leader>gr", function()
		require("gitsigns").reset_buffer()
	end)
	map("n", "<leader>gs", function()
		require("gitsigns").stage_hunk()
	end)
	map("n", "<leader>gS", function()
		require("gitsigns").stage_buffer()
	end)
	map("n", "<leader>gu", function()
		require("gitsigns").undo_stage_hunk()
	end)
	map("n", "<leader>gd", function()
		require("gitsigns").diffthis()
	end)
end

-- lazygit
if utils.is_available("toggleterm.nvim") and vim.fn.executable("lazygit") == 1 then
	map("n", "<leader>gg", function()
		local worktree = require("keive.utils.git").file_worktree()
		local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
		utils.toggle_term_cmd("lazygit " .. flags)
	end)
end

-- formatting
if utils.is_available("conform.nvim") then
	map("n", "<leader>lf", function()
		require("conform").format()
		vim.cmd("w")
	end)
	map("n", "<leader>lF", function()
		vim.cmd("Format")
	end)
end

-- center search result
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- scroll offset
vim.opt.scrolloff = 8

-- move stuff around in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
