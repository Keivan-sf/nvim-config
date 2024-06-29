local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local nix_formatter = {
  method = null_ls.methods.FORMATTING,
  filetypes = {"nix"},
  generator = null_ls.generator({
    command = "nixfmt",
    to_stdin = true,
    on_output = function(params, done)
        local output = params.output
        if not output then
            return done()
        end
        return done({ { text = output } })
    end
  }),
}


local cmd_resolver = require("null-ls.helpers.command_resolver")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local FORMATTING = methods.internal.FORMATTING
local RANGE_FORMATTING = methods.internal.RANGE_FORMATTING
local prettier_plugin_prisma_path = vim.fn.expand('$HOME/nix-configuration/nodePackages/node_modules/prettier-plugin-prisma/lib/plugin.js')



local prettier = {
    name = "prettier-with-prisma",
    method = { FORMATTING, RANGE_FORMATTING },
    filetypes = {
        "prisma",
    },
    generator = null_ls.generator({
        command = "prettier",
        args = helpers.range_formatting_args_factory({
            "--stdin-filepath",
            "$FILENAME",
            "--plugin",
            prettier_plugin_prisma_path,
        }, "--range-start", "--range-end", { row_offset = -1, col_offset = -1 }),
        to_stdin = true,
        on_output = function(params, done)
          local output = params.output
          if not output then
              return done()
          end
          return done({ { text = output } })
        end,
        dynamic_command = cmd_resolver.from_node_modules(),
    }),
    factory = helpers.formatter_factory,
}

null_ls.register(nix_formatter)
null_ls.register(prettier)
