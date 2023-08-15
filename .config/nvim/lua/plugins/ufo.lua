local opt          = vim.opt

opt.foldcolumn     = '1'
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldenable     = true
opt.fillchars      = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

require('ufo').setup({
  ---@diagnostic disable-next-line: unused-local
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end
})
