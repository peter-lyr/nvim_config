return {
  'sindrets/diffview.nvim',
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'paopaol/telescope-git-diffs.nvim',
    require 'wait.telescope',
    require 'wait.plenary',
    require 'plugins.treesitter',
    require 'plugins.minimap', -- diffviewclose minimap
  },
  keys = {
    { '<leader>gi',  function() require 'config.diffview'.diffviewfilehistory() end, mode = { 'n', 'v', }, silent = true, desc = 'diffview filehistory', },
    { '<leader>go',  function() require 'config.diffview'.diffviewopen() end,        mode = { 'n', 'v', }, silent = true, desc = 'diffview open', },
    { '<leader>gq',  function() require 'config.diffview'.diffviewclose() end,       mode = { 'n', 'v', }, silent = true, desc = 'diffview close', },
    { '<leader>gtc', function() require 'config.diffview'.toggle_cnt() end,          mode = { 'n', 'v', }, silent = true, desc = 'diffview toggle_cnt', },
    { '<leader>ge',  ':<c-u>DiffviewRefresh<cr>',                                    mode = { 'n', 'v', }, silent = true, desc = 'DiffviewRefresh', },
    { '<leader>gl',  ':<c-u>DiffviewToggleFiles<cr>',                                mode = { 'n', 'v', }, silent = true, desc = 'DiffviewToggleFiles', },
    { '<leader>gw',  ':<c-u>Telescope git_diffs diff_commits<cr>',                   mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_diffs diff_commits', },
  },
  config = function()
    require 'config.diffview'
    require 'telescope'.load_extension 'git_diffs'
  end,
}
