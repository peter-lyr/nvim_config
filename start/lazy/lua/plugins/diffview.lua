return {
  'sindrets/diffview.nvim',
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    '<leader>gi',
    '<leader>go',
    '<leader>gq',

    '<leader>gT',
    '<leader>ge',
    '<leader>gl',

    '<leader>xt',
  },
  config = function()
    require('config.diffview')
  end,
}
