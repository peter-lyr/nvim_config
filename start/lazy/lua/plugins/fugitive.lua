return {
  'tpope/vim-fugitive',
  lazy = true,
  keys = {
    { '<leader>g<leader>', function() require 'config.fugitive'.toggle() end, mode = { 'n', 'v', }, silent = true, desc = 'Git toggle', },
  },
  config = function()
    require 'config.fugitive'
  end,
}
