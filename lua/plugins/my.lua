local S = require 'startup'

return {
  {
    name = 'sessions',
    dir = '',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>s', 'sessions', 'Sessions')
      end
    end,
    config = function()
      require 'map.sessions'
    end,
  },
  {
    name = 'window',
    dir = '',
    lazy = true,
    keys = {
      { '<a-s-h>', function() require 'config.window'.height_less() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window height_less', },
      { '<a-s-l>', function() require 'config.window'.height_more() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window height_more', },
      { '<a-s-j>', function() require 'config.window'.width_less() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window width_less', },
      { '<a-s-k>', function() require 'config.window'.width_more() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window width_more', },
      { '<c-=>',   function() require 'config.window'.fontsize_up() end,   mode = { 'n', 'v', }, silent = true, desc = 'font_size up', },
      { '<c-->',   function() require 'config.window'.fontsize_down() end, mode = { 'n', 'v', }, silent = true, desc = 'font_size down', },
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>w', 'window', 'Window')
        require 'my_simple'.add_whichkey('<leader>x', 'window', 'Window', 'kill')
        require 'my_simple'.add_whichkey('<c-0>', 'window', 'Window', 'Font size')
      end
    end,
    config = function()
      require 'map.window'
    end,
  },
  {
    name = 'test',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<c-s-f4>', 'test', 'Test')
      end
    end,
    config = function()
      require 'map.test'
    end,
  },
  {
    name = 'tabline',
    dir = '',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    init = function()
      vim.opt.tabline = ' ' .. vim.loop.cwd()
      vim.opt.showtabline = 2
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>q', 'tabline', 'Tabline')
      end
    end,
    config = function()
      require 'map.tabline'
    end,
  },
}
