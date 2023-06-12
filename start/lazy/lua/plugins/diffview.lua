return {
  'sindrets/diffview.nvim',
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    '<leader>gi',
    '<leader>go',
  },
  config = function()
    require('config.diffview')
  end,
}
