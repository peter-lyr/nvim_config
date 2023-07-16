return {
  'tpope/vim-fugitive',
  lazy = true,
  keys = {
    { '<leader>q', '<cmd>Git<cr>', mode = { 'n', 'v' }, desc = 'Git' },
  },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    require('plugins.edgy'),
  },
  config = function()
    require('config.fugitive')
  end
}
