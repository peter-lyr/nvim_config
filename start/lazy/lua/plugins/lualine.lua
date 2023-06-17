return {
  -- 'nvim-lualine/lualine.nvim',
  'peter-lyr/lualine.nvim',
  event = "VeryLazy",
  dependencies = {
    require('plugins.web-devicons'),
    {
      "folke/noice.nvim",
      opts = {
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    }
  },
  config = function()
    require('config.lualine')
  end
}
