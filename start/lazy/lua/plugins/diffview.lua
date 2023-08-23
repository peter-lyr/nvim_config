return {
  'sindrets/diffview.nvim',
  lazy = true,
  cmd = {
    'DiffviewClose',
    'DiffviewFileHistory',
    'DiffviewFocusFiles',
    'DiffviewLog',
    'DiffviewOpen',
    'DiffviewRefresh',
    'DiffviewToggleFiles',
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'paopaol/telescope-git-diffs.nvim',
    require 'wait.telescope',
    require 'wait.plenary',
    require 'plugins.treesitter',
    require 'plugins.minimap', -- diffviewclose minimap
    require 'plugins.whichkey',
  },
  keys = {
    '<leader>g',

    { '<leader>gv1', function() require 'config.diffview'.diffviewfilehistory(0) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory 16', },
    { '<leader>gv2', function() require 'config.diffview'.diffviewfilehistory(1) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory 64', },
    { '<leader>gv3', function() require 'config.diffview'.diffviewfilehistory(2) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory finite', },
    { '<leader>gvs', function() require 'config.diffview'.diffviewfilehistory(3) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory stash', },
    { '<leader>gvb', function() require 'config.diffview'.diffviewfilehistory(4) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory base', },
    { '<leader>gvr', function() require 'config.diffview'.diffviewfilehistory(5) end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory range', },
    { '<leader>gvo', function() require 'config.diffview'.diffviewopen() end,         mode = { 'n', 'v', }, silent = true, desc = 'Diffview open', },
    { '<leader>gvl', ':<c-u>DiffviewRefresh<cr>',                                     mode = { 'n', 'v', }, silent = true, desc = 'Diffview refresh', },
    { '<leader>gvq', function() require 'config.diffview'.diffviewclose() end,        mode = { 'n', 'v', }, silent = true, desc = 'Diffview close', },
    { '<leader>gvw', ':<c-u>Telescope git_diffs diff_commits<cr>',                    mode = { 'n', 'v', }, silent = true, desc = 'Diffview Telescope git_diffs diff_commits', },
  },
  config = function()
    require 'config.diffview'
    require 'telescope'.load_extension 'git_diffs'
  end,
}
