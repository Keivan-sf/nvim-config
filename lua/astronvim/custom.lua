local null_ls = require "null-ls"
local helpers = require "null-ls.helpers"

vim.opt.guifont = "FiraCode Nerd Font:h12"

local nix_formatter = {
  method = null_ls.methods.FORMATTING,
  filetypes = { "nix" },
  generator = null_ls.generator {
    command = "nixfmt",
    to_stdin = true,
    on_output = function(params, done)
      local output = params.output
      if not output then return done() end
      return done { { text = output } }
    end,
  },
}

local cmd_resolver = require "null-ls.helpers.command_resolver"
local methods = require "null-ls.methods"
local u = require "null-ls.utils"

local sources = {
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.astyle,
  nix_formatter,
}

null_ls.register(sources)

vim.g.c_syntax_for_h = true
-- clangd
-- see https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
-- which reffered to this: https://github.com/neovim/neovim/pull/16694
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = {
--   textDocument = {
--     completion = {
--       editsNearCursor = true,
--     },
--   },
--   offsetEncoding = { 'utf-16' },
-- }

capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup {
  capabilities = capabilities,
}

-- Check https://github.com/neovim/nvim-lspconfig/issues/2184
-- Check /home/keive/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/server_configurations/clangd.lua
-- Which is found by: sudo find / -type f -iname "clangd.lua"
-- local lspconfig = require "lspconfig"
-- lspconfig.clangd.setup {
--   textDocument = {
--     completion = {
--       editsNearCursor = true,
--     },
--   },
--   offsetEncoding = { "utf-8" },
-- }
