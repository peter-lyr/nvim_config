return {
  'tpope/vim-fugitive',
  lazy = true,
  cmd = { 'Git', },
  keys = {
    { '<leader>g<leader>', function() require 'config.fugitive'.toggle() end, mode = { 'n', 'v', }, silent = true, desc = 'Git toggle', },
  },
  config = function()
    require 'config.fugitive'
  end,
}
