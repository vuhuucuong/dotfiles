require("mason").setup()
local null_ls = require("null-ls")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local coq = require("coq")
local builtin = require("telescope.builtin")
local navic = require("nvim-navic")
require("neodev").setup({})

local servers = {
  "cssls",
  "cssmodules_ls",
  "dockerls",
  "dotls",
  "html",
  "jsonls",
  "tsserver",
  "sumneko_lua",
  "marksman",
  "prismals",
  "jedi_language_server",
  "taplo",
  "tailwindcss",
  "terraformls",
  "yamlls",
  "rust_analyzer"
}

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = false,
})

-- highlight keywords under cursor, powered by LSP
local lsp_document_highlight = function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end
end

-- Avoiding LSP formatting conflictslsp
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local avoid_formatter_conflict = function(client, bufnr)
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

local attach_navic = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local on_attach = function(client, bufnr)
  avoid_formatter_conflict(client, bufnr)
  lsp_document_highlight(client, bufnr)
  attach_navic(client, bufnr)

  require("user.keymaps").keymap_set_buffer(bufnr)
end

local lsp_flags = {
  debounce_text_changes = 150,
}

-- Automatic server setup to work with coq.nvim
mason_lspconfig.setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
      flags = lsp_flags,
    }))
  end,

  -- Next, you can provide a dedicated handler for specific servers.

  -- JSON autocomplete from schema
  ["jsonls"] = function()
    lspconfig["jsonls"].setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
      flags = lsp_flags,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      }
    }))
  end,

  -- neodev
  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
      flags = lsp_flags,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    }))
  end,

}

null_ls.setup({
  sources = {
    -- code actions
    null_ls.builtins.code_actions.eslint,
    -- diagnostics
    null_ls.builtins.diagnostics.tidy,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.diagnostics.tsc,
    -- formattings
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.rustywind
  },
})
