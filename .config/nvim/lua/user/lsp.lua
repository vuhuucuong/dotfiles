require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local coq = require("coq")
local builtin = require("telescope.builtin")

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

  local keymap = vim.keymap.set

  -- go to keymapping
  keymap("n", "gr", builtin.lsp_references,
    { desc = "[LSP] List references", buffer = bufnr, noremap = true })
  keymap("n", "gd", builtin.lsp_definitions,
    { desc = "[LSP] Go to definitions", buffer = bufnr, noremap = true })
  keymap("n", "gI", builtin.lsp_implementations,
    { desc = "[LSP] Go to implementation", buffer = bufnr, noremap = true })
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",
    { desc = "[LSP] Go to declarations", buffer = bufnr, noremap = true })
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "[LSP] Hover", buffer = bufnr, noremap = true })
  keymap("n", "gl", builtin.diagnostics, { desc = "[LSP] List diagnostics", buffer = bufnr, noremap = true })
  keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    { desc = "[LSP] Signature help", buffer = bufnr, noremap = true })

  -- <leader>l prefix LSP keymapping
  keymap("n", "<leader>ll", "<cmd>lua vim.diagnostic.setloclist()<CR>",
    { desc = "List diagnostics in location list", buffer = bufnr, noremap = true })
  keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { desc = "Code actions", buffer = bufnr, noremap = true })
  keymap("n", "<leader>li", "<cmd>LspInfo<CR>",
    { desc = "LSP Info", buffer = bufnr, noremap = true })
  keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>",
    { desc = "Next diagnostic", buffer = bufnr, noremap = true })
  keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>",
    { desc = "Previous diagnostic", buffer = bufnr, noremap = true })
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>",
    { desc = "Rename symbol", buffer = bufnr, noremap = true })
  keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>",
    { desc = "Format document", buffer = bufnr, noremap = true })

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
