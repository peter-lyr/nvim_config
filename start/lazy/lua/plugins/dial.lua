return {
  'monaqa/dial.nvim',
  lazy = true,
  keys = {
    { '<C-a>', function() return require 'dial.map'.inc_normal() end, expr = true, desc = 'Increment', },
    { '<C-x>', function() return require 'dial.map'.dec_normal() end, expr = true, desc = 'Decrement', },
  },
  config = function()
    require 'config.dial'
  end,
}
