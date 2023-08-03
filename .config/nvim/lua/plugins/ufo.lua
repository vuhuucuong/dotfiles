local opts = {
  foldcolumn = '1',
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end
