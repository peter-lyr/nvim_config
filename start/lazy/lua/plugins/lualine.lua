return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = {
    require('plugins.web-devicons'),
  },
  config = function()
    require('config.lualine')
  end
}
