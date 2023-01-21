local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Left window", noremap = true, })
keymap("n", "<C-j>", "<C-w>j", { desc = "Bottom window", noremap = true, })
keymap("n", "<C-k>", "<C-w>k", { desc = "Top window", noremap = true, })
keymap("n", "<C-l>", "<C-w>l", { desc = "Right window", noremap = true, })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up", noremap = true, })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down", noremap = true, })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left", noremap = true, })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right", noremap = true, })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", noremap = true, })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", noremap = true, })
keymap("n", "<S-j>", ":b#<CR>", { desc = "Last buffer", noremap = true, })

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", { desc = "Move line up", noremap = true, })
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", { desc = "Move line down", noremap = true, })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "Shift indent left", noremap = true, })
keymap("v", ">", ">gv", { desc = "Shift indent right", noremap = true, })

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", { desc = "Move selected line(s) up", noremap = true, })
keymap("v", "<A-k>", ":m .-2<CR>==", { desc = "Move selected line(s) down", noremap = true, })

-- Disable yank when pasting into visually selected text
keymap("v", "p", '"_dP', { desc = "Disable yank when pasting", noremap = true, })

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", { desc = "", noremap = true, })
keymap("x", "K", ":move '<-2<CR>gv-gv", { desc = "", noremap = true, })

-- Delete all buffers except current
vim.api.nvim_create_user_command("Bufo", ":%bd|e#|bd#", { nargs = 0 })
