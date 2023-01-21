local builtin = require("telescope.builtin")
local telescope = require("telescope")
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.95,
      width = 0.95,
      preview_width = 0.5
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
  pickers = {
  },
  extensions = {
  }
}

local keymap = vim.keymap.set

-- Find
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find file", noremap = true, })
keymap("n", "<leader>fs", builtin.live_grep, { desc = "Grep string", noremap = true, })
-- Vim
keymap("n", "<leader>vb", builtin.buffers, { desc = "Buffers", noremap = true, })
keymap("n", "<leader>vc", builtin.command_history, { desc = "Command history", noremap = true, })
keymap("n", "<leader>vs", builtin.search_history, { desc = "Search history", noremap = true, })
keymap("n", "<leader>vr", builtin.registers, { desc = "Registers", noremap = true, })
keymap("n", "<leader>vq", builtin.quickfix, { desc = "Quickfix items", noremap = true, })
keymap("n", "<leader>vk", builtin.keymaps, { desc = "List normal mode keymaps", noremap = true, })
-- Git
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Commit history", noremap = true, })
keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git branches", noremap = true, })
keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status", noremap = true, })
keymap("n", "<leader>gS", builtin.git_stash, { desc = "Git stashes", noremap = true, })
