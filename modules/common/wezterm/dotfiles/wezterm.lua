-- base config settings
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- get configurations from config directory
local gpu_config = require 'config.gpu'
local appearance = require 'config.appearance'
local keybindings = require 'config.keybindings'
local fonts = require 'config.fonts'
local ssh = require 'config.ssh'

for k, v in pairs(gpu_config) do config[k] = v end
for k, v in pairs(appearance) do config[k] = v end
for k, v in pairs(fonts) do config[k] = v end
for k, v in pairs(ssh) do config[k] = v end

-- keybinding configurations
config.keys = keybindings.keys
config.key_tables = keybindings.key_tables
config.leader = keybindings.leader

return config
