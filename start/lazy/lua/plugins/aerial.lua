return {
  'stevearc/aerial.nvim',
  event = { 'LspAttach', },
  keys = {
    { '<leader>4', function () require('config.aerial').open() end, mode = { 'n', 'v', }, silent = true, desc = 'AerialOpen right' },
    { ']a', ':<c-u>AerialNext<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialNext' },
    { '[a', ':<c-u>AerialPrev<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev' },
  },
  dependencies = {
    require('plugins.treesitter'),
    require('wait.web-devicons'),
  },
  config = function()
    require('config.aerial')
  end
}
