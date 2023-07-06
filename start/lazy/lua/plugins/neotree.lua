return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  tag = '2.66',
  pin = true,
  event = { "BufReadPost", "BufNew", "BufNewFile",  },
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>`', function() require('config.neotree').openall() end,    mode = { 'n', 'v' }, desc = 'NeoTree open all' },
    { '<leader>~', function() require('config.neotree').refreshall() end, mode = { 'n', 'v' }, desc = 'NeoTree refresh all' },
    { '<leader>1', function() require('config.neotree').filesystem() end, mode = { 'n', 'v' }, desc = 'NeoTree open filesystem' },
    { '<leader>2', function() require('config.neotree').buffers() end,    mode = { 'n', 'v' }, desc = 'NeoTree open buffers' },
    { '<leader>3', function() require('config.neotree').git_status() end, mode = { 'n', 'v' }, desc = 'NeoTree open git_status' },
  },
  dependencies = {
    require('plugins.edgy'),
    require('wait.plenary'),
    require('wait.web-devicons'),
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      config = function()
        require('window-picker').setup({
          filter_rules = {
            bo = {
              filetype = { 'aerial', 'neo-tree', 'notify', 'minimap', },
              buftype = { 'terminal' },
            },
            file_path_contains = {
              'edgy://',
            },
          }
        })
      end
    },
    require('wait.bbye'),
    require('wait.asyncrun'),
  },
  config = function()
    require('config.neotree')
  end
}
