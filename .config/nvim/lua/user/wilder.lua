local wilder = require('wilder')

wilder.setup({ modes = { ':', '/', '?' } })

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = wilder.basic_highlighter(),
  left = { ' ', wilder.popupmenu_devicons() },
  right = { ' ', wilder.popupmenu_scrollbar() },
}))

wilder.set_option('renderer', wilder.wildmenu_renderer({
  highlighter = wilder.basic_highlighter(),
}))

wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_palette_theme({
    border = 'rounded',
    max_height = '75%', -- max height of the palette
    min_height = 0, -- set to the same as 'max_height' for a fixed height window
    prompt_position = 'bottom', -- 'top' or 'bottom' to set the location of the prompt
    reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
  })
))
