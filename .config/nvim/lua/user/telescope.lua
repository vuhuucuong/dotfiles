local builtin = require("telescope.builtin")
local telescope = require("telescope")
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    mappings = {
    }
  },
  pickers = {
  },
  extensions = {
  }
}

local keymap = vim.keymap.set

-- Mapping to empty function just for displaying prefix in which-key
keymap("n", "<leader>f", function()end, { desc = "Find...", noremap = true, silent = true })
-- File & text
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find file", noremap = true, silent = true })
keymap("n", "<leader>ft", builtin.live_grep, { desc = "Find text", noremap = true, silent = true })
-- vim
keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffer", noremap = true, silent = true })
keymap("n", "<leader>fc", builtin.command_history, { desc = "Command history", noremap = true, silent = true })
keymap("n", "<leader>fs", builtin.search_history, { desc = "Search history", noremap = true, silent = true })
keymap("n", "<leader>fr", builtin.registers, { desc = "List registers", noremap = true, silent = true })
keymap("n", "<leader>fq", builtin.quickfix, { desc = "List quickfix items", noremap = true, silent = true })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "List normal mode keymaps", noremap = true, silent = true })
-- git
keymap("n", "<leader>fgc", builtin.git_commits, { desc = "List git commit history", noremap = true, silent = true })
keymap("n", "<leader>fgb", builtin.git_branches, { desc = "List git branches", noremap = true, silent = true })
keymap("n", "<leader>fgs", builtin.git_status, { desc = "Git status", noremap = true, silent = true })
keymap("n", "<leader>fgS", builtin.git_stash, { desc = "List git stash", noremap = true, silent = true })
