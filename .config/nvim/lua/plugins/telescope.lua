local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    wrap_results = true,
    layout_strategy = "horizontal",
    layout_config = {
      height = 0.95,
      width = 0.95,
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
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },

    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
    project = {
      hidden_files = true,
      sync_with_nvim_tree = true
    }
  }
}

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("project")
