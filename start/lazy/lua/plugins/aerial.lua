return {
  'stevearc/aerial.nvim',
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { '<leader>vq', function() require('config.aerial').open() end, mode = { 'n', 'v', }, silent = true, desc = 'AerialOpen right' },
    { ']a',        '<cmd>AerialNext<cr>',                          mode = { 'n', 'v', }, silent = true, desc = 'AerialNext' },
    { '[a',        '<cmd>AerialPrev<cr>',                          mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev' },
  },
  dependencies = {
    require('plugins.treesitter'),
    require('wait.web-devicons'),
    require('plugins.edgy'),
  },
  config = function()
    require('config.aerial')
  end
}
