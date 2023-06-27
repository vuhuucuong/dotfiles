local catppuccin = "catppuccin-mocha"

require("catppuccin").setup {
  custom_highlights = function(colors)
    return {
      Comment = { fg = colors.flamingo },
      ["@comment"] = { fg = colors.flamingo, style = { "italic" } },
    }
  end
}
vim.cmd("colorscheme " .. catppuccin)
