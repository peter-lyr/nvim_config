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
    { '<c-h>',      function() require 'tabline'.b_prev_buf() end,   mode = { 'n', 'v', }, silent = true, desc = 'tabline b prev buffer', },
    { '<c-l>',      function() require 'tabline'.b_next_buf() end,   mode = { 'n', 'v', }, silent = true, desc = 'tabline b next buffer', },
    { '<c-q><c-t>', function() require 'tabline'.restore_hidden_tabs() end, mode = { 'n', 'v', }, silent = true, desc = 'tabline restore hidden tabs', },
    { '<c-q>t',     function() require 'tabline'.restore_hidden_tabs() end, mode = { 'n', 'v', }, silent = true, desc = 'tabline restore hidden tabs', },
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
