local M = {}

-- GPU & Performance
local wezterm = require 'wezterm'
local gpus = wezterm.gui.enumerate_gpus()

M.webgpu_preferred_adapter = gpus[0]
M.front_end = "WebGpu"
M.animation_fps = 10
M.max_fps = 240

return M
