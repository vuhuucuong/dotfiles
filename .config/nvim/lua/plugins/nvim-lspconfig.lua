local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local mason_servers_to_install = {

  "cssls",
  "cssmodules_ls",
  "dockerls",
  "dotls",
  "html",
  "jsonls",
  "tsserver",
  "lua_ls",
  "marksman",
  "prismals",
  "jedi_language_server",
  "taplo",
  "tailwindcss",
  "terraformls",
  "yamlls",
  "rust_analyzer",
}



local ATTACH = {}
ATTACH.avoid_formatter_conflict = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(c)
            return c.name == "null-ls"
          end,
          bufnr = bufnr,
        })
      end,
    })
  end
end

-- Attach nvim-navic for displaying context status
ATTACH.navic = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

local on_attach = function(client, bufnr)
  ATTACH.avoid_formatter_conflict(client, bufnr)
  ATTACH.navic(client, bufnr)

  require("plugins.keymaps").lsp(bufnr)
  require "lsp_signature".on_attach({
    bind = true,
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
end

local lsp_flags = {
  debounce_text_changes = 150,
 }

mason_lspconfig.setup({
  ensure_installed = mason_servers_to_install,
  automatic_installation = false,
})

mason_lspconfig.setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities
    })
  end,

  -- Next, you can provide a dedicated handler for specific servers.

  -- JSON autocomplete from schema
  ["jsonls"] = function()
    lspconfig["jsonls"].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      }
    })
  end,

  -- neodev
  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    })
  end,

}
