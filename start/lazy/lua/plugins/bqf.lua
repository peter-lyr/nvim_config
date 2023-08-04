return {
  'kevinhwang91/nvim-bqf',
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { 'dm', function() require('config.bqf').toggle() end, mode = { 'n', 'v' }, silent = true, desc = 'bqf toggle' },
  },
  dependencies = {
    require('plugins.edgy'),
    require('wait.blankline'),
  },
  config = function()
    require('config.bqf')
  end,
}
