-- local S = require 'startup'

local plugin = 'tabline'
local map = 'Tabline'

return {
  name = plugin,
  dir = '',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  init = function()
    vim.opt.tabline = ' ' .. vim.loop.cwd()
    vim.opt.showtabline = 2
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
