local wk = require("which-key")

wk.register({
  ["<leader>f"] = { name = "Find" },
  ["<leader>s"] = { name = "Search and Replace" },
  ["<leader>v"] = { name = "Vim" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>gd"] = { name = "Git Diff" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>e"] = { name = "Explorer" },
  ["<leader>d"] = { name = "Debugger" },
})
