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


local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 't', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
  end, opts('swap_then_open_tab'))

  vim.keymap.set("n", "<C-Space>", tree_actions_menu, { buffer = bufnr, noremap = true, silent = true })

end

tree.setup {
  on_attach = on_attach,
  filters = {
    dotfiles = false,
    git_clean = false
  },
  git = {
    ignore = false
  },
}

tree_api.events.subscribe(tree_api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)
-- auto open on start up
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
