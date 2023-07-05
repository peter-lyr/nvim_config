return {
  'kevinhwang91/nvim-bqf',
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { '<leader>m', function() require('config.bqf').toggle() end, mode = { 'n', 'v' }, silent = true, desc = 'bqf toggle' },
  },
  dependencies = {
    require('plugins.edgy'),
  },
  config = function()
    require('config.bqf')
  end,
}
