return {
  'rcarriga/nvim-notify',
  lazy = true,
  keys = {
    { '<esc>', function() require 'notify'.dismiss() end, mode = { 'n', }, silent = true, desc = 'dismiss notification', },
  },
  dependencies = {
    require 'plugins.colorscheme',
  },
  config = function()
    require 'notify'.setup {
      top_down = false,
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    }
    vim.notify = require 'notify'
  end,
}
