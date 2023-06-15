return {
  'romgrk/barbar.nvim',
  event = "VeryLazy",
  version = '^1.0.0',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    require('plugins.web-devicons'),
  },
  opts = {
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  config = function()
    require('config.barbar')
  end,
}
