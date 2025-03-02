local M = {}

-- window layout config
M.enable_tab_bar = false
M.window_decorations = "RESIZE"
-- M.window_background_opacity = 0.8
M.macos_window_background_blur = 10
M.warn_about_missing_glyphs = false
M.window_close_confirmation = "NeverPrompt"

-- window padding 
M.window_padding = {
  left   = '20px',
  right  = '20px',
  top    = '20px',
  bottom = '50px',
}

-- theme settings
M.color_scheme = 'nightfox'

return M
