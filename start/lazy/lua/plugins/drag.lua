local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'drag',
  lazy = false,
  dir = opt .. 'drag',
  dependencies = {
    require 'plugins.plenary',
    'peter-lyr/vim-bbye',
    require 'plugins.projectroot',
  },
  init = function()
    require 'drag'
  end,
}
