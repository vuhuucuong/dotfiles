local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- set default clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp-
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in --[[ neovim ]]
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (--[[ most terminals support this ]])
  timeoutlen = 500, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  updatetime = 300, -- faster completion (4000ms default)
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = true, -- display lines as one long line
  linebreak = true, -- companion to wrap, don't split words
  scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = "monospace:h17", -- the font used in graphical neovim applications
  whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
  laststatus = 3 -- single global statusline for the current window
}

local vim_opt = vim.opt

for k, v in pairs(options) do
  vim_opt[k] = v
end


-- WSL fix for clipboard
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end
vim_opt.shortmess:append "c"

vim_opt.whichwrap:append("<,>,[,],h,l")
vim_opt.iskeyword:append("-")
vim_opt.formatoptions:remove("cro")
