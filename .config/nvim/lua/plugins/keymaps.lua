local M = {}

M.lsp = function(buffer)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
    { desc = "[LSP] Go To Declarations", buffer = buffer, })
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "[LSP] Hover", buffer = buffer, })
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    { desc = "[LSP] Signature Help", buffer = buffer, })
  vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Actions", buffer = buffer })
  vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LS Info", buffer = buffer })
  vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol", buffer = buffer })
  vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
    { desc = "Format document", buffer = buffer })
end

M.telescope = function()
  local telescope_builtin = require("telescope.builtin")
  local telescope_extensions = require("telescope").extensions

  function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
      return text
    else
      return ''
    end
  end

  return {
    {
      "<leader>ff",
      function() telescope_builtin.find_files({ hidden = false, no_ignore = false }) end,
      desc =
      "Find Files"
    },
    {
      "<leader>fF",
      function()
        telescope_builtin.find_files({
          hidden = vim.fn.input({ prompt = 'hidden (y/n): ', default = 'y' }) == 'y' and true or false,
          no_ignore = vim.fn.input({ prompt = 'no_ignore (y/n): ', default = 'y' }) == 'y' and true or false
        })
      end,
      desc =
      "Find Files - Customize"
    },
    {
      "<leader>fg",
      function() telescope_builtin.live_grep() end,
      desc =
      "Live Grep in Project"
    },
    {
      "<leader>fs",
      function()
        telescope_builtin.live_grep({ default_text = vim.getVisualSelection() })
      end,
      mode = 'v',
      desc =
      "Grep Current in Project"
    },
    {
      "<leader>fG",
      function()
        local isCaseSensitive = vim.fn.input({ prompt = 'case-sensitive (y/n): ' })
        local args = isCaseSensitive == 'y' and { "--case-sensitive" } or {}
        telescope_builtin.live_grep { additional_args = args }
      end,
      desc =
      "Live Grep in Project - Customize"
    },
    {
      "<leader>fu",
      function()
        telescope_builtin.current_buffer_fuzzy_find()
      end,
      desc =
      "Fuzzy in Buffer"
    },
    {
      "<leader>fr",
      function() telescope_builtin.resume() end,
      desc =
      "Resume Previous"
    },
    {
      "<leader>vb",
      function() telescope_builtin.buffers() end,
      desc =
      "Buffers",
    },
    {
      "<leader>vc",
      function() telescope_builtin.commands() end,
      desc =
      "Command List",
    },
    {
      "<leader>vC",
      function() telescope_builtin.command_history() end,
      desc =
      "Command History",
    },
    {
      "<leader>vs",
      function() telescope_builtin.search_history() end,
      desc =
      "Search History",
    },
    {
      "<leader>vr",
      function() telescope_builtin.registers() end,
      desc =
      "Registers",
    },
    {
      "<leader>vq",
      function() telescope_builtin.quickfix() end,
      desc =
      "Quickfix items",
    },
    {
      "<leader>vk",
      function() telescope_builtin.keymaps() end,
      desc =
      "List Normal Mode Keymaps",
    },
    {
      "<leader>gc",
      function() telescope_builtin.git_commits() end,
      desc =
      "Commit History",
    },
    {
      "<leader>gb",
      function() telescope_builtin.git_branches() end,
      desc =
      "Git Branches",
    },
    {
      "<leader>gs",
      function() telescope_builtin.git_status() end,
      desc =
      "Git Status",
    },
    {
      "<leader>gS",
      function() telescope_builtin.git_stash() end,
      desc =
      "Git Stashes",
    },
    {
      "<leader>ls",
      function() telescope_builtin.lsp_document_symbols() end,
      desc =
      "List current buffer symbols"
    },
    {
      "<leader>fp",
      function() telescope_extensions.project.project { display_type = 'full' } end,
      desc =
      "Find Projects"
    },

    {
      "gr",
      function() telescope_builtin.lsp_references() end,
      desc =
      "[LSP] List References"
    },
    {
      "gd",
      function() telescope_builtin.lsp_definitions() end,
      desc =
      "[LSP] Go To Definitions"
    },
    {
      "gI",
      function() telescope_builtin.lsp_implementations() end,
      desc =
      "[LSP] Go To Implementation"
    },
  }
end

M.nvim_spectre = function()
  local spectre = require("spectre")
  return {
    { "<leader>so", spectre.open, desc = "Open Spectre" },
    {
      "<leader>ss",
      function()
        spectre.open_visual({ select_word = true })
      end,
      desc = "Search current string"
    },
  }
end

M.diffview = function()
  return {
    { "<leader>gdo", ":DiffviewOpen ",           desc = "DiffView Open" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>",   desc = "DiffView Close" },
    { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "DiffView Refresh" },
    { "<leader>gdf", ":DiffviewFileHistory ",    desc = "DiffView File History" },
  }
end

M.nvim_tree = function()
  return {
    { "<leader>et", "<cmd>NvimTreeToggle<cr>",   desc = "Toggle Tree" },
    { "<leader>er", "<cmd>NvimTreeRefresh<cr>",  desc = "Refresh Tree" },
    { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal Current Buffer in Tree" },
  }
end

M.trouble = function()
  local trouble = require("trouble")

  return {
    { "<leader>lj", function() trouble.next({ skip_groups = true, jump = true }) end,     desc = "Next diagnostic" },
    { "<leader>lk", function() trouble.previous({ skip_groups = true, jump = true }) end, desc = "Previous diagnostic" },
    {
      "<leader>ll",
      "<cmd>TroubleToggle<cr>",
      desc =
      "List diagnostics in location list"
    }
  }
end

return M
