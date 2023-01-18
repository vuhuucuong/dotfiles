require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local coq = require("coq")

local servers = {
  "cssls",
  "cssmodules_ls",
  "dockerls",
  "dotls",
  "graphql",
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

-- Avoiding LSP formatting conflicts
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


local on_attach = function(client, bufnr)
  avoid_formatter_conflict(client, bufnr)
  lsp_document_highlight(client, bufnr)

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
  keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
  keymap("n", "gf", "<cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
  keymap('n', 'gl', "<cmd>lua vim.diagnostic.setloclist()<CR>", bufopts)
  keymap('n', 'gs', "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
  keymap('n', '<leader>la', "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
  keymap('n', '<leader>li', "<cmd>LspInfo<CR>", bufopts)
  keymap('n', '<leader>lj', "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", bufopts)
  keymap('n', '<leader>lk', "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", bufopts)
  keymap('n', '<leader>lr', "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
  keymap('n', '<leader>lf', "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150,
}

-- setup to work with coq.nvim
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
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      }
    }))
  end,

}
