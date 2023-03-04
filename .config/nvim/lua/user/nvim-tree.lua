local tree = require("nvim-tree")
local tree_api = require("nvim-tree.api")
local lib = require("nvim-tree.lib")

-- Fix tab titles when opening file in new tab
local swap_then_open_tab = function()
  local node = lib.get_node_at_cursor()
  vim.cmd("wincmd l")
  tree_api.node.open.tab(node)
end

local open_nvim_tree = function(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

local tree_actions = {
  {
    name = "[File] - Open Preview",
    handler = tree_api.node.open.preview,
  },
  {
    name = "[File] - Open in New Tab",
    handler = tree_api.node.open.tab,
  },
  {
    name = "[File] - Open in Vertical Split",
    handler = tree_api.node.open.vertical,
  },
  {
    name = "[File] - Open in Horizontal Split",
    handler = tree_api.node.open.horizontal,
  },
  {
    name = "[File] - Open with System",
    handler = tree_api.node.run.system,
  },
  {
    name = "[File] - Create",
    handler = tree_api.fs.create,
  },
  {
    name = "[File] - Remove",
    handler = tree_api.fs.remove,
  },
  {
    name = "[File] - Trash",
    handler = tree_api.fs.trash,
  },
  {
    name = "[File] - Rename",
    handler = tree_api.fs.rename_sub,
  },
  {
    name = "[File] - Cut",
    handler = tree_api.fs.cut
  },
  {
    name = "[File] - Copy",
    handler = tree_api.fs.copy.node,
  },
  {
    name = "[File] - Paste",
    handler = tree_api.fs.paste,
  },
  {
    name = "[File] - Copy Absolute Path",
    handler = tree_api.fs.copy.absolute_path,
  },
  {
    name = "[File] - Copy Name",
    handler = tree_api.fs.copy.filename,
  },
  {
    name = "[File] - Copy Relative Path",
    handler = tree_api.fs.copy.relative_path,
  },
  {
    name = "[File] - Info",
    handler = tree_api.node.show_info_popup,
  },
  {
    name = "[Tree] - Refresh",
    handler = tree_api.tree.reload,
  },
  {
    name = "[Tree] - Close",
    handler = tree_api.tree.close,
  },
  {
    name = "[Tree] - Change Root to Parent",
    handler = tree_api.tree.change_root_to_parent,
  },
  {
    name = "[Tree] - Change Root to Node",
    handler = tree_api.tree.change_root_to_node,
  },
  {
    name = "[Tree] - Expand All",
    handler = tree_api.tree.expand_all,
  },
  {
    name = "[Tree] - Collapse All",
    handler = tree_api.tree.collapse_all,
  },
  {
    name = "[Tree] - Filter",
    handler = tree_api.live_filter.start,
  },
  {
    name = "[Tree] - Filter Clear",
    handler = tree_api.live_filter.clear,
  },
  {
    name = "[Tree] - Toggle Hidden Files",
    handler = tree_api.tree.toggle_hidden_filter,
  },
  {
    name = "[Tree] - Toggle Git Ignore Files",
    handler = tree_api.tree.toggle_gitignore_filter,
  },
  {
    name = "[Help]",
    handler = tree_api.tree.toggle_help,
  },
}

local function tree_actions_menu(node)
  local entry_maker = function(menu_item)
    return {
      value = menu_item,
      ordinal = menu_item.name,
      display = menu_item.name,
    }
  end

  local finder = require("telescope.finders").new_table({
    results = tree_actions,
    entry_maker = entry_maker,
  })

  local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

  local default_options = {
    finder = finder,
    sorter = sorter,
    attach_mappings = function(prompt_buffer_number)
      local actions = require("telescope.actions")

      -- On item select
      actions.select_default:replace(function()
        local state = require("telescope.actions.state")
        local selection = state.get_selected_entry()
        -- Closing the picker
        actions.close(prompt_buffer_number)
        -- Executing the callback
        selection.value.handler(node)
      end)

      -- The following actions are disabled in this example
      -- You may want to map them too depending on your needs though
      actions.add_selection:replace(function()
      end)
      actions.remove_selection:replace(function()
      end)
      actions.toggle_selection:replace(function()
      end)
      actions.select_all:replace(function()
      end)
      actions.drop_all:replace(function()
      end)
      actions.toggle_all:replace(function()
      end)

      return true
    end,
  }

  -- Opening the menu
  require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
end



tree.setup {
  view = {
    mappings = {
      list = {
        { key = "t",         action = "swap_then_open_tab", action_cb = swap_then_open_tab },
        { key = "<C-Space>", action = "tree actions",       action_cb = tree_actions_menu }
      }
    },

  },
  filters = {
    dotfiles = true,
    git_clean = false
  }
}

tree_api.events.subscribe(tree_api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)
-- auto open on start up
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
