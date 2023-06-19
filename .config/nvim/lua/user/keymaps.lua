local M = {}

local telescope = require("telescope")
local telescope_extensions = telescope.extensions
local telescope_builtin = require("telescope.builtin")

local keymap_set_fn = vim.keymap.set
M.keymap_set_default = function()
  -- GENERIC KEYMAPS --

  --Remap space as leader key
  keymap_set_fn("", "<Space>", "<Nop>", { noremap = true, })
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
  keymap_set_fn("n", "<C-h>", "<C-w>h", { desc = "Left window", noremap = true, })
  keymap_set_fn("n", "<C-j>", "<C-w>j", { desc = "Bottom window", noremap = true, })
  keymap_set_fn("n", "<C-k>", "<C-w>k", { desc = "Top window", noremap = true, })
  keymap_set_fn("n", "<C-l>", "<C-w>l", { desc = "Right window", noremap = true, })
  -- Resize with arrows
  keymap_set_fn("n", "<C-Up>", ":resize -2<cr>", { desc = "Resize up", noremap = true, })
  keymap_set_fn("n", "<C-Down>", ":resize +2<cr>", { desc = "Resize down", noremap = true, })
  keymap_set_fn("n", "<C-Left>", ":vertical resize -2<cr>", { desc = "Resize left", noremap = true, })
  keymap_set_fn("n", "<C-Right>", ":vertical resize +2<cr>", { desc = "Resize right", noremap = true, })
  -- Navigate buffers
  keymap_set_fn("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer", noremap = true, })
  keymap_set_fn("n", "<S-h>", ":bprevious<cr>", { desc = "Previous buffer", noremap = true, })
  -- Move text up and down
  keymap_set_fn("n", "<A-j>", "<Esc>:m .+1<cr>==", { desc = "Move line up", noremap = true, })
  keymap_set_fn("n", "<A-k>", "<Esc>:m .-2<cr>==", { desc = "Move line down", noremap = true, })
  -- Visual --
  -- Stay in indent mode
  keymap_set_fn("v", "<", "<gv", { desc = "Shift indent left", noremap = true, })
  keymap_set_fn("v", ">", ">gv", { desc = "Shift indent right", noremap = true, })
  -- Move text up and down
  keymap_set_fn("v", "<A-j>", ":m .+1<cr>==", { desc = "Move selected line(s) up", noremap = true, })
  keymap_set_fn("v", "<A-k>", ":m .-2<cr>==", { desc = "Move selected line(s) down", noremap = true, })
  -- Disable yank when pasting into visually selected text
  keymap_set_fn("v", "p", '"_dP', { desc = "Disable yank when pasting", noremap = true, })
  -- Visual Block --
  -- Move text up and down
  keymap_set_fn("x", "J", ":move '>+1<cr>gv-gv", { desc = "", noremap = true, })
  keymap_set_fn("x", "K", ":move '<-2<cr>gv-gv", { desc = "", noremap = true, })
  keymap_set_fn("n", "<S-j>", "<cmd>b#<cr>", { desc = "Last buffer", noremap = true, })
  -- Delete all buffers except current
  vim.api.nvim_create_user_command("Bo", ":%bd|e#|bd#", { nargs = 0, desc = "Close all other buffers" })


  -- PLUGINS KEYMAPS --
  -- Find
  keymap_set_fn("n", "<leader>ff", function() telescope_builtin.find_files({ hidden = true }) end,
    { desc = "Find files", noremap = true, })
  keymap_set_fn("n", "<leader>fF", function() telescope_builtin.find_files({ hidden = true, no_ignore = true }) end,
    { desc = "Find files - include .gitignore", noremap = true, })
  keymap_set_fn("n", "<leader>fs", telescope_builtin.live_grep, { desc = "Live grep", noremap = true, })
  keymap_set_fn("n", "<leader>fr", telescope_builtin.resume, { desc = "Resume previous search", noremap = true, })
  keymap_set_fn("n", "<leader>fS",
    function() telescope_builtin.live_grep { additional_args = { "--case-sensitive" } } end,
    { desc = "Live grep - case sensitive", noremap = true, })
  -- Vim
  keymap_set_fn("n", "<leader>vb", telescope_builtin.buffers, { desc = "Buffers", noremap = true, })
  keymap_set_fn("n", "<leader>vc", telescope_builtin.commands, { desc = "Plugin/User commands list", noremap = true, })
  keymap_set_fn("n", "<leader>vC", telescope_builtin.command_history, { desc = "Command history", noremap = true, })
  keymap_set_fn("n", "<leader>vs", telescope_builtin.search_history, { desc = "Search history", noremap = true, })
  keymap_set_fn("n", "<leader>vr", telescope_builtin.registers, { desc = "Registers", noremap = true, })
  keymap_set_fn("n", "<leader>vq", telescope_builtin.quickfix, { desc = "Quickfix items", noremap = true, })
  keymap_set_fn("n", "<leader>vk", telescope_builtin.keymaps, { desc = "List normal mode keymaps", noremap = true, })
  -- Git
  keymap_set_fn("n", "<leader>gc", telescope_builtin.git_commits, { desc = "Commit history", noremap = true, })
  keymap_set_fn("n", "<leader>gb", telescope_builtin.git_branches, { desc = "Git branches", noremap = true, })
  keymap_set_fn("n", "<leader>gs", telescope_builtin.git_status, { desc = "Git status", noremap = true, })
  keymap_set_fn("n", "<leader>gS", telescope_builtin.git_stash, { desc = "Git stashes", noremap = true, })
  keymap_set_fn("n", "<leader>gdo", ":DiffviewOpen ", { desc = "Git diff open", noremap = true, })
  keymap_set_fn("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", { desc = "Git diff close", noremap = true, })
  keymap_set_fn("n", "<leader>gdc", "<cmd>DiffviewRefresh<cr>", { desc = "Git diff refresh", noremap = true, })
  keymap_set_fn("n", "<leader>gdf", ":DiffviewFileHistory ", { desc = "Git diff file history", noremap = true, })
  -- NvimTree explorer
  keymap_set_fn("n", "<leader>et", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle", noremap = true, })
  keymap_set_fn("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh", noremap = true, })
  keymap_set_fn("n", "<leader>ef", "<cmd>NvimTreeFindFile<cr>", { desc = "Find current buffer", noremap = true, })


  -- Debugger

--   keymap_set_fn("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
--   keymap_set_fn("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step over" })
--   keymap_set_fn("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
--   keymap_set_fn("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step out" })
--   keymap_set_fn("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Step out" })
--   keymap_set_fn("n", "<Leader>dB", function() require("dap").set_breakpoint() end, { desc = "Step " })
--   keymap_set_fn("n", "<Leader>dl",
--     function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { desc = "Log point" })
--   keymap_set_fn("n", "<Leader>dr", function() require("dap").repl.open() end, { desc = "REPL Open" })
--   keymap_set_fn({ "n", "v" }, "<Leader>dh", function()
--     require("dap.ui.widgets").hover()
--   end, { desc = "Hover" })
--   keymap_set_fn({ "n", "v" }, "<Leader>dp", function()
--     require("dap.ui.widgets").preview()
--   end, { desc = "Preview" })
--   keymap_set_fn("n", "<Leader>df", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.frames)
--   end, { desc = "Float" })
--   keymap_set_fn("n", "<Leader>ds", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.scopes)
--   end, { desc = "Center Float" })
end

M.keymap_set_buffer = function(buffer)
  -- go to keymapping
  keymap_set_fn("n", "gr", telescope_builtin.lsp_references,
    { desc = "[LSP] List references", buffer = buffer, noremap = true })
  keymap_set_fn("n", "gd", telescope_builtin.lsp_definitions,
    { desc = "[LSP] Go to definitions", buffer = buffer, noremap = true })
  keymap_set_fn("n", "gI", telescope_builtin.lsp_implementations,
    { desc = "[LSP] Go to implementation", buffer = buffer, noremap = true })
  keymap_set_fn("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
    { desc = "[LSP] Go to declarations", buffer = buffer, noremap = true })
  keymap_set_fn("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "[LSP] Hover", buffer = buffer, noremap = true })
  keymap_set_fn("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    { desc = "[LSP] Signature help", buffer = buffer, noremap = true })

  -- <leader>l prefix LSP keymapping
  keymap_set_fn("n", "<leader>ll", "<cmd>TroubleToggle<cr>",
    { desc = "List diagnostics in location list", buffer = buffer, noremap = true })
  keymap_set_fn("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",
    { desc = "Code actions", buffer = buffer, noremap = true })
  keymap_set_fn("n", "<leader>li", "<cmd>LspInfo<cr>",
    { desc = "LSP Info", buffer = buffer, noremap = true })
  -- keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>",
  --   { desc = "Next diagnostic", buffer = bufnr, noremap = true })
  -- keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>",
  --   { desc = "Previous diagnostic", buffer = bufnr, noremap = true })
  keymap_set_fn("n", "<leader>ls", telescope_builtin.lsp_document_symbols,
    { desc = "List current buffer symbols", buffer = buffer, noremap = true })
  keymap_set_fn("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",
    { desc = "Rename symbol", buffer = buffer, noremap = true })
  keymap_set_fn("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
    { desc = "Format document", buffer = buffer, noremap = true })
end

return M
