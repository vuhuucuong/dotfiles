local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Default to Ubuntu-24.04 WSL distro
config.default_domain = "WSL:Ubuntu-24.04"

-- Font (covers both Linux "Iosevka Nerd Font" and Windows Nerd Fonts v3 "IosevkaNFM")
config.font = wezterm.font_with_fallback({ "MonaspiceNe Nerd Font Mono", "MonaspiceNeNFM" })
config.font_size = 14.0

-- Theme
config.color_scheme = "Catppuccin Mocha"

-- Scrollbar
config.enable_scroll_bar = true

-- Window padding
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- Dim inactive panes
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }

-- Cursor style
config.default_cursor_style = "BlinkingBlock"

-- Disable close confirmations
config.window_close_confirmation = "NeverPrompt"

-- macOS: treat both opt keys as ALT (no special chars)
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

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

  -- Tab management
  { key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "1", mods = "ALT", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT", action = act.ActivateTab(8) },
  { key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },

  -- Pane management
  { key = "q", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "z", mods = "ALT", action = act.TogglePaneZoomState },

  -- Scroll
  { key = "u", mods = "ALT", action = act.ScrollByPage(-0.5) },
  { key = "d", mods = "ALT", action = act.ScrollByPage(0.5) },
}

return config
