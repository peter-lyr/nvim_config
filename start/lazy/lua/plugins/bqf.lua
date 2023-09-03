return {
  'kevinhwang91/nvim-bqf',
  lazy = true,
  event = { 'LspAttach', },
  dependencies = {
    require('plugins.edgy'),
    require('wait.blankline'),
  },
  config = function()
    require('config.bqf')
  end,
}
