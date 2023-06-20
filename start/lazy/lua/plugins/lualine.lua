return {
  -- 'nvim-lualine/lualine.nvim',
  -- 'peter-lyr/lualine.nvim',
  'phi-mah/lualine.nvim',
  branch = 'filterbuffers',
  event = "VeryLazy",
  dependencies = {
    require('plugins.web-devicons'),
    require('plugins.projectroot'),
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
