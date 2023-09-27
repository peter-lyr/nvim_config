return {
  'stevearc/aerial.nvim',
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { '<leader>aa', function() require 'config.aerial'.open() end, mode = { 'n', 'v', }, silent = true, desc = 'AerialOpen right', },
    { ']a',         '<cmd>AerialNext<cr>',                         mode = { 'n', 'v', }, silent = true, desc = 'AerialNext', },
    { '[a',         '<cmd>AerialPrev<cr>',                         mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev', },
  },
  dependencies = {
    require 'plugins.treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require 'config.aerial'
  end,
}
