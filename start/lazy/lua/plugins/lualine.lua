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
      dependencies = {
        "MunifTanjim/nui.nvim",
        {
          "rcarriga/nvim-notify",
          config = function()
            require("notify").setup({
              top_down = false,
            })
            vim.keymap.set({ 'n', }, '<esc>', function() require("notify").dismiss() end, { desc = 'dismiss notification' })
          end,
        },
      },
      config = function()
        require("noice").setup()
      end
    }
  },
  config = function()
    require('config.lualine')
  end
}
