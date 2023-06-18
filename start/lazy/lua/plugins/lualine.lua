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
        {
          "rcarriga/nvim-notify",
          opts = {
            minimum_width = 20,
            timeout = 1000,
            top_down = false,
          },
        }
      },
    }
  },
  config = function()
    require('config.lualine')
  end
}
