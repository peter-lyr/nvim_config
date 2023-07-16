return {
  'tpope/vim-fugitive',
  lazy = true,
  keys = {
    { '<leader>gg', '<cmd>Git<cr>', mode = { 'n', 'v' }, desc = 'Git' },
  },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    require('plugins.edgy'),
  },
}
