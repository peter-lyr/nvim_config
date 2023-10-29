local S = require 'startup'

local plugin = 'tabline'

return {
  name = plugin,
  dir = '',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  init = function()
    vim.opt.tabline = ' ' .. vim.loop.cwd()
    vim.opt.showtabline = 2
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>q', plugin, 'Tabline')
    end
  end,
  config = function()
    require 'map.tabline'
  end,
}
