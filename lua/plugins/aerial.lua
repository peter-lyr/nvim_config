local S = require 'startup'

local plugin = 'stevearc/aerial.nvim'

return {
  plugin,
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { ']a', '<cmd>AerialNext<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialNext', },
    { '[a', '<cmd>AerialPrev<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev', },
  },
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, 'Aerial')
    end
  end,
  config = function()
    require 'map.aerial'
  end,
}
