-- Automatically open file upon creation
local tree = require("nvim-tree")
local api = require("nvim-tree.api")
local lib = require("nvim-tree.lib")

-- Fix tab titles when opening file in new tab
local swap_then_open_tab = function()
  local node = lib.get_node_at_cursor()
  vim.cmd("wincmd l")
  api.node.open.tab(node)
end

tree.setup {
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  },
  view = {
    mappings = {
      custom_only = false,
      list = {
        { key = "t", action = "swap_then_open_tab", action_cb = swap_then_open_tab },
      }
    },
  },
}

api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)
