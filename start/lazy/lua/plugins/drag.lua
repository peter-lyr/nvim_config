local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'drag',
  lazy = true,
  dir = opt .. 'drag',
  event = { 'BufReadPre', 'BufNewFile', },
  dependencies = {
    require 'plugins.plenary',
    'peter-lyr/vim-bbye',
    'peter-lyr/sha2',
    require 'plugins.projectroot',
  },
  init = function()
    require 'drag'
  end,
}
