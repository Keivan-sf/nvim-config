local map = vim.keymap.set
local utils = require("keive.utils")

-- telescope
if utils.is_available("telescope.nvim") then
    -- Git branches
    map('n' , "<leader>gb" , function() require("telescope.builtin").git_branches({ use_file_path = true }) end)
    -- Git commits (repository)
    map('n' , "<leader>gc" , function() require("telescope.builtin").git_commits({ use_file_path = true }) end)
    -- Git commits (current file)
    map('n' , "<leader>gC" , function() require("telescope.builtin").git_bcommits({ use_file_path = true }) end)
    -- Git status 
    map('n' , "<leader>gt" , function() require("telescope.builtin").git_status({ use_file_path = true }) end)
    -- Resume previous search
    map('n' , "<leader>f<CR>" , function() require("telescope.builtin").resume() end)
    --  Find marks
    map('n' , "<leader>f'" , function() require("telescope.builtin").marks() end)
    --  Find words in current buffer
    map('n' , "<leader>f/" , function() require("telescope.builtin").current_buffer_fuzzy_find() end)
    --  Find buffers
    map('n' , "<leader>fb" , function() require("telescope.builtin").buffers({layout_strategy='vertical',layout_config={ width=0.4, prompt_position='top', height=0.3 , preview_height = 0}}) end)
    --  Find word under cursor
    map('n' , "<leader>fc" , function() require("telescope.builtin").grep_string() end)
    -- Find commands
    map('n' , "<leader>fC" , function() require("telescope.builtin").commands() end)
    --  Find Files
    map('n' , "<leader>ff" , function() require("telescope.builtin").find_files({layout_strategy='vertical',layout_config={ width=0.4, prompt_position='top', height=0.3 , preview_height = 0}}) end)
    --  Find Files (no ignored)
    map('n' , "<leader>fF" , function() require("telescope.builtin").find_files ({ hidden = true, no_ignore = true, layout_strategy='vertical',layout_config={ width=0.4, prompt_position='top', height=0.3 , preview_height = 0} }) end)
    --  Find help
    map('n' , "<leader>fh" , function() require("telescope.builtin").help_tags() end)
--  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
    -- Find keymaps
    map('n' , "<leader>fk" , function() require("telescope.builtin").keymaps() end)
    -- Find man
    map('n' , "<leader>fm" , function() require("telescope.builtin").man_pages() end)

--  if is_available "nvim-notify" then
--    maps.n["<leader>fn"] =
--      { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
--    maps.n["<leader>uD"] =
--      { function() require("notify").dismiss { pending = true, silent = true } end, desc = "Dismiss notifications" }
--  end
--
    --  Find history
    map('n' , "<leader>fo" , function() require("telescope.builtin").oldfiles() end)
    --  Find registers
    map('n' , "<leader>fr" , function() require("telescope.builtin").registers() end)
    -- Find themes
    map('n' , "<leader>ft" , function() require("telescope.builtin").colorscheme({ enable_preview = true }) end)
    --  Find words
    map("n" , "<leader>fw" , function() require("telescope.builtin").live_grep() end)
    --  Find words in all files
    map("n" , "<leader>fW" , function()
      	    require("telescope.builtin").live_grep {
        	additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
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
if utils.is_available ("neo-tree.nvim") then
  -- Toggle Explorer
  map("n" , "<leader>e", "<cmd>Neotree toggle<cr>")

  -- Toggle Explorer Focus
  map("n" , "<leader>o", function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd.Neotree "focus"
      end
    end)
end


-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    -- Displays hover information about the symbol under the cursor
    map('n', 'K', function() vim.lsp.buf.hover() end, {buffer = true})

    -- Jump to the definition
    map('n', 'gd', function() vim.lsp.buf.definition({on_list = function(options)
                vim.fn.setqflist({}, ' ', options)
                vim.cmd.cfirst()
    end
    }) end, {buffer = true })

    -- Jump to declaration
    map('n', 'gD', function() vim.lsp.buf.declaration() end, {buffer = true})

    -- Lists all the implementations for the symbol under the cursor
    map('n', 'gi', function() vim.lsp.buf.implementation() end, {buffer = true})

    -- Jumps to the definition of the type symbol
    map('n', 'go', function() vim.lsp.buf.type_definition() end, {buffer = true})

    -- Lists all the references
    map('n', 'gr', function() vim.lsp.buf.references() end, {buffer = true})

    -- Displays a function's signature information
    map('n', 'gs', function() vim.lsp.buf.signature_help() end, {buffer = true})

    -- Renames all references to the symbol under the cursor
   -- map('n', 'r', function() vim.lsp.buf.rename()end, {buffer = true})

    -- Search references
    map('n', '<leader>lR',function() vim.lsp.buf.references()end, {buffer = true})

    -- Selects a code action available at the current cursor position
    map('n', '<leader>la',function() vim.lsp.buf.code_action()end, {buffer = true})

    -- Show diagnostics in a floating window
    map('n', '<leader>ld',function() vim.diagnostic.open_float()end, {buffer = true})

    -- Move to the previous diagnostic
    map('n', '[d',function() vim.diagnostic.goto_prev()end, {buffer = true})

    -- Move to the next diagnostic
    map('n', ']d',function() vim.diagnostic.goto_next()end, {buffer = true})
  end
})
local a = "12"
a = "sdf"

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  group = vim.api.nvim_create_augroup("code_action_sign", { clear = true }),
  callback = function()
	  -- do something here
  end,
})
