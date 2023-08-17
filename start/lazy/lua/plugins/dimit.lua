return {
  'rosstang/dimit.nvim',
  lazy = true,
  event = { 'CursorHold', 'CursorHoldI', },
  config = function()
    require 'config.dimit'
  end,
  dependencies = {
    require 'plugins.aerial',
  },
}
