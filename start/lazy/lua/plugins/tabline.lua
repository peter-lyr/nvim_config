local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'tabline',
  lazy = true,
  dir = opt .. 'tabline',
  event = { 'BufReadPost', 'BufNewFile', },
  dependencies = {
    require 'plugins.plenary',
    require 'plugins.projectroot',
  },
  keys = {
    -- { '<c-h>', function() require 'tabline'.buffer 'prev' end, mode = { 'n', 'v', }, silent = true, desc = 'tabline go buffer prev', },
  },
  init = function()
    vim.opt.tabline     = ' ' .. vim.loop.cwd()
    vim.opt.showtabline = 2
  end,
  config = function()
    vim.opt.winbar = '%f'
    require 'tabline'
  end,
}
