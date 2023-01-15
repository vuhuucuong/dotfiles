require("catppuccin").setup {
  custom_highlights = function(colors)
    return {
      Comment = { fg = colors.flamingo },
      ["@comment"] = { fg = colors.flamingo, style = { "italic" } },
    }
  end
}

local colorscheme = "catppuccin-mocha"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
