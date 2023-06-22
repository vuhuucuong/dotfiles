require("mason").setup()
local null_ls = require("null-ls")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local builtin = require("telescope.builtin")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require("luasnip")

require("neodev").setup({})

local servers = {
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

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = false,
})

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
    require("nvim-navic").attach(client, bufnr)
  end
end

local on_attach = function(client, bufnr)
  avoid_formatter_conflict(client, bufnr)
  attach_navic(client, bufnr)

  require("user.keymaps").keymap_set_buffer(bufnr)
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

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- cmp setup
local cmp_setup = function()
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-k>'] = cmp.mapping.scroll_docs(-4),
      ['<C-j>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

cmp_setup()

-- Automatic server setup
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
    null_ls.builtins.formatting.rustywind
  },
})
