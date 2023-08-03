local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- code actions
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.code_actions.gitsigns,
    require("typescript.extensions.null-ls.code-actions"),
    -- diagnostics
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.diagnostics.tsc,
    -- formattings
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.rustywind,
    null_ls.builtins.formatting.lua_format
  },
})
