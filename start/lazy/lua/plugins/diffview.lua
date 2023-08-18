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
    require 'plugins.whichkey',
  },
  keys = {
    { '<leader>gvi', function() require 'config.diffview'.diffviewfilehistory() end, mode = { 'n', 'v', }, silent = true, desc = 'Diffview filehistory', },
    { '<leader>gvo', function() require 'config.diffview'.diffviewopen() end,        mode = { 'n', 'v', }, silent = true, desc = 'Diffview open', },
    { '<leader>gvq', function() require 'config.diffview'.diffviewclose() end,       mode = { 'n', 'v', }, silent = true, desc = 'Diffview close', },
    { '<leader>gvc', function() require 'config.diffview'.toggle_cnt() end,          mode = { 'n', 'v', }, silent = true, desc = 'Diffview toggle_cnt', },
    -- { '<leader>gve',  ':<c-u>DiffviewRefresh<cr>',                                    mode = { 'n', 'v', }, silent = true, desc = 'DiffviewRefresh', },
    -- { '<leader>gvl',  ':<c-u>DiffviewToggleFiles<cr>',                                mode = { 'n', 'v', }, silent = true, desc = 'DiffviewToggleFiles', },
    { '<leader>gvw', ':<c-u>Telescope git_diffs diff_commits<cr>',                   mode = { 'n', 'v', }, silent = true, desc = 'Diffview Telescope git_diffs diff_commits', },
  },
  config = function()
    require 'config.diffview'
    require 'telescope'.load_extension 'git_diffs'
  end,
}
