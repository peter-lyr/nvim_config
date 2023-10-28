-- local S = require 'startup'

local plugin = 'tabline'

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
    require 'map.tabline'
  end,
}
