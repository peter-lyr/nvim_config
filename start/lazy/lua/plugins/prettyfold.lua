return {
  'anuvyklack/pretty-fold.nvim',
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
