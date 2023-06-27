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
