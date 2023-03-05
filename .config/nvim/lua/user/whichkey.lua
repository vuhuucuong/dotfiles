vim.o.timeout = true
vim.o.timeoutlen = 500
local wk = require("which-key")

wk.setup {}
wk.register({
  ["<leader>f"] = { name = "Find" },
  ["<leader>v"] = { name = "Vim" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>gd"] = { name = "Git Diff" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>e"] = { name = "Explorer" },
  ["<leader>d"] = { name = "Debugger" },
})
