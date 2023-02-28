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
  filters = {
    dotfiles = true,
  },
}

api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)
