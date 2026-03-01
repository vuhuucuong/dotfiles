local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Default to Ubuntu-24.04 WSL distro
config.default_domain = "WSL:Ubuntu-24.04"

-- Font (covers both Linux "Iosevka Nerd Font" and Windows Nerd Fonts v3 "IosevkaNFM")
config.font = wezterm.font_with_fallback({ "MonaspiceNe Nerd Font", "MonaspiceNeNFM" })
config.font_size = 14.0

-- Theme
config.color_scheme = "Catppuccin Mocha"

-- Keybindings
config.keys = {
  -- Split panes (vim hjkl)
  { key = "l", mods = "ALT|SHIFT", action = act.SplitPane({ direction = "Right" }) },
  { key = "j", mods = "ALT|SHIFT", action = act.SplitPane({ direction = "Down" }) },
  { key = "h", mods = "ALT|SHIFT", action = act.SplitPane({ direction = "Left" }) },
  { key = "k", mods = "ALT|SHIFT", action = act.SplitPane({ direction = "Up" }) },

  -- Navigate between panes (vim hjkl)
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
}

return config
