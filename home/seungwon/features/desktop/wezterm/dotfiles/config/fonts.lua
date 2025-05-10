local M = {}
local wezterm = require 'wezterm'

-- font config
M.font = wezterm.font_with_fallback {
  {
    family="JetBrains Mono",
    weight='Light',
    scale=1.0,
  },
  {
    family="D2CodingLigature Nerd Font Mono",
    weight='Light',
  },
}

M.font_size    = 16
M.cell_width   = 0.9
M.line_height  = 1.05

return M
