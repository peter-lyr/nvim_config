return {
  'anuvyklack/pretty-fold.nvim',
  lazy = true,
  keys = {
    'zm',
    'zM',
    'zc',
    'zf',
  },
  config = function()
    require('pretty-fold').setup()
  end
}
