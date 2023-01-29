-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "css",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitignore",
    "graphql",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "prisma",
    "python",
    "regex",
    "rust",
    "scss",
    --"svelte",
    "toml",
    "terraform",
    "typescript",
    "vim",
    "yaml",
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

-- Users of packer.nvim have reported that when using treesitter for folds,
-- they sometimes receive an error "No folds found", or that treesitter highlighting does not apply.
-- A workaround for this is to set the folding options in an autocmd:
vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
  callback = function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
    -- disable fold at startup
    vim.opt.foldlevel  = 99
  end
})
