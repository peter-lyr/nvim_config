local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'drag',
  lazy = true,
  dir = opt .. 'drag',
  event = { 'BufReadPre', 'BufNewFile', },
  keys = {
    { '<leader>mU', function() require 'drag_images'.update() end, mode = { 'n', 'v', }, silent = true, desc = 'markdown images update', },
  },
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
