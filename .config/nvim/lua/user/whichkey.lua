local M = {}

M.config_which_key = function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  require('which-key').setup({
  })
end


return M
