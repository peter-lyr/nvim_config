return {
  -- 'nvim-lualine/lualine.nvim',
  -- 'peter-lyr/lualine.nvim',
  'phi-mah/lualine.nvim',
  branch = 'filterbuffers',
  event = 'VeryLazy',
  dependencies = {
    require 'wait.web-devicons',
    require 'wait.projectroot',
    require 'wait.noice',
    require 'wait.plenary',
    require 'wait.bbye',
    {
      'SmiteshP/nvim-navic',
      lazy = true,
      dependencies = {
        'LazyVim/LazyVim',
      },
      init = function()
        vim.g.navic_silence = true
        require 'lazyvim.util'.on_attach(function(client, buffer)
          if client.server_capabilities.documentSymbolProvider then
            require 'nvim-navic'.attach(client, buffer)
          end
        end)
      end,
      opts = function()
        return {
          separator = ' ',
          highlight = true,
          depth_limit = 5,
          icons = require 'lazyvim.config'.icons.kinds,
        }
      end,
    },
  },
  config = function()
    require 'config.lualine'
  end,
}
