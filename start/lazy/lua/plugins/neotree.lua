return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  event = {
    'CursorMoved'
  },
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>q',                     function() require('config.neotree').filesystem_open() end,           mode = { 'n', 'v' }, desc = 'NeoTree open filesystem' },
    { '<leader><leader>q',             function() require('config.neotree').filesystem_min_width() end,      mode = { 'n', 'v' }, desc = 'NeoTree filesystem min width' },
    { '<leader><leader><leader>q',     function() require('config.neotree').filesystem_close() end,          mode = { 'n', 'v' }, desc = 'NeoTree filesystem close' },

    { '<leader><tab>',                 function() require('config.neotree').git_status_buffers_toggle() end, mode = { 'n', 'v' }, desc = 'NeoTree git_status buffers toggle' },
    { '<leader><leader><tab>',         function() require('config.neotree').git_status_buffers_close() end,  mode = { 'n', 'v' }, desc = 'NeoTree git_status buffers close' },

    { '<rightmouse>',                  function() require('config.neotree').open() end,                      mode = { 'n', 'v' }, desc = 'NeoTree open' },
    { '<middlemouse>',                 function() require('config.neotree').close() end,                     mode = { 'n', 'v' }, desc = 'NeoTree close' },

    { '<leader><leader><leader><tab>', function() require('config.neotree').close() end,                     mode = { 'n', 'v' }, desc = 'NeoTree filesystem close' },
  },
  dependencies = {
    require('plugins.plenary'),
    require('plugins.web-devicons'),
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  config = function()
    require('config.neotree')
  end
}
