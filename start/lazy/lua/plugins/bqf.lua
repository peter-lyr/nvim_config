return {
  'kevinhwang91/nvim-bqf',
  lazy = true,
  event = { 'LspAttach', },
  config = function()
    require 'config.bqf'
  end,
}
