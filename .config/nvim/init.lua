if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  require("user.options")
  require("user.plugins")
  require("user.colorschemes")
  require("user.lsp")
  require("user.treesitter")
  require("user.keymaps").keymap_set_default()
end
