local catppuccin = "catppuccin-mocha"

require("catppuccin").setup {
  custom_highlights = function(colors)
    return {
      Comment = { fg = colors.flamingo, style = {} },
      ["@comment"] = { fg = colors.flamingo, style = {} },
    }
  end
}
vim.cmd("colorscheme " .. catppuccin)
