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
    vim.opt.foldmethod = "indent"
    require('pretty-fold').setup()
  end
}
