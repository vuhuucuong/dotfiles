local M = {}

M.default = function()
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left window", noremap = true, })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Bottom window", noremap = true, })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Top window", noremap = true, })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right window", noremap = true, })

  -- Resize with arrows
  vim.keymap.set("n", "<C-Up>", ":resize -2<cr>", { desc = "Resize up", noremap = true, })
  vim.keymap.set("n", "<C-Down>", ":resize +2<cr>", { desc = "Resize down", noremap = true, })
  vim.keymap.set("n", "<C-Left>", ":vertical resize -2<cr>", { desc = "Resize left", noremap = true, })
  vim.keymap.set("n", "<C-Right>", ":vertical resize +2<cr>", { desc = "Resize right", noremap = true, })

  -- Navigate buffers
  vim.keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer", noremap = true, })
  vim.keymap.set("n", "<S-h>", ":bprevious<cr>", { desc = "Previous buffer", noremap = true, })
  vim.keymap.set("n", "<S-j>", "<cmd>b#<cr>", { desc = "Last buffer", noremap = true, })

  -- Move text up and down
  vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<cr>==", { desc = "Move line up", noremap = true, })
  vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<cr>==", { desc = "Move line down", noremap = true, })

  -- Stay in indent mode
  vim.keymap.set("v", "<", "<gv", { desc = "Shift indent left", noremap = true, })
  vim.keymap.set("v", ">", ">gv", { desc = "Shift indent right", noremap = true, })
  -- Move text up and down
  vim.keymap.set("v", "<A-j>", ":m .+1<cr>==", { desc = "Move selected line(s) up", noremap = true, })
  vim.keymap.set("v", "<A-k>", ":m .-2<cr>==", { desc = "Move selected line(s) down", noremap = true, })
  -- Disable yank when pasting into visually selected text
  vim.keymap.set("v", "p", '"_dP', { desc = "Disable yank when pasting", noremap = true, })
  -- Visual Block --
  -- Move text up and down
  vim.keymap.set("x", "J", ":move '>+1<cr>gv-gv", { desc = "", noremap = true, })
  vim.keymap.set("x", "K", ":move '<-2<cr>gv-gv", { desc = "", noremap = true, })
  -- Delete all buffers except current
  vim.api.nvim_create_user_command("Bo", ":%bd|e#|bd#", { nargs = 0, desc = "Close all other buffers" })
end

return M
