return {
  'sindrets/diffview.nvim',
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
      { '<leader>gi', function() require('diffview').diffviewfilehistory() end, mode = { 'n', 'v', }, silent = true, desc = 'diffview filehistory' },
      { '<leader>go', function() require('diffview').diffviewopen() end,        mode = { 'n', 'v', }, silent = true, desc = 'diffview open' },
      { '<leader>gq', function() require('diffview').diffviewclose() end,       mode = { 'n', 'v', }, silent = true, desc = 'diffview close' },
      { '<leader>gQ', function() require('diffview').diffviewcloseforce() end,  mode = { 'n', 'v', }, silent = true, desc = 'diffview close force' },

      { '<leader>ge', ':<c-u>DiffviewRefresh<cr>',                              mode = { 'n', 'v', }, silent = true, desc = 'DiffviewRefresh' },
      { '<leader>gl', ':<c-u>DiffviewToggleFiles<cr>',                          mode = { 'n', 'v', }, silent = true, desc = 'DiffviewToggleFiles' },
  },
  config = function()
    require('config.diffview')
  end,
}
