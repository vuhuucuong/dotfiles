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
