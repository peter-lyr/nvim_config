return {
  -- 'nvim-lualine/lualine.nvim',
  -- 'peter-lyr/lualine.nvim',
  'phi-mah/lualine.nvim',
  branch = 'filterbuffers',
  event = "VeryLazy",
  dependencies = {
    require('wait.web-devicons'),
    require('wait.projectroot'),
    {
      "folke/noice.nvim",
      opts = {
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        {
          "rcarriga/nvim-notify",
          opts = {
            -- minimum_width = 20,
            top_down = false,
          },
          config = function()
            vim.keymap.set({ 'n', }, '<esc>', function() require("notify").dismiss() end, { desc = 'dismiss notification' })
          end,
        }
      },
    }
  },
  config = function()
    require('config.lualine')
  end
}
