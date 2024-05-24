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

null_ls.register(nix_formatter)
