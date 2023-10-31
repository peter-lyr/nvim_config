local S = require 'startup'

return {
  {
    name = 'my_sessions',
    dir = '',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>s', 'sessions', 'My_Sessions')
      end
    end,
    config = function()
      require 'map.my_sessions'
    end,
  },
  {
    name = 'my_window',
    dir = '',
    lazy = true,
    keys = {
      { '<a-s-h>', function() require 'config.my_window'.height_less() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window height_less', },
      { '<a-s-l>', function() require 'config.my_window'.height_more() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window height_more', },
      { '<a-s-j>', function() require 'config.my_window'.width_less() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window width_less', },
      { '<a-s-k>', function() require 'config.my_window'.width_more() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window width_more', },
      { '<c-=>',   function() require 'config.my_window'.fontsize_up() end,   mode = { 'n', 'v', }, silent = true, desc = 'font_size up', },
      { '<c-->',   function() require 'config.my_window'.fontsize_down() end, mode = { 'n', 'v', }, silent = true, desc = 'font_size down', },

      { '<c-`>',   function() require 'config.my_window'.gt() end,            mode = { 'n', 'v', }, silent = true, desc = 'gt', },
      { '<a-`>',   function() require 'config.my_window'.gT() end,            mode = { 'n', 'v', }, silent = true, desc = 'gT', },
      { '<c-tab>', '<esc><c-tab>',                                            mode = { 'v', },      silent = true, desc = 'c-tab', },

    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>w', 'window', 'My_Window')
        require 'my_simple'.add_whichkey('<leader>x', 'window', 'My_Window', 'kill')
        require 'my_simple'.add_whichkey('<c-0>', 'window', 'My_Window', 'Font size')
      end
      require 'my_base'.aucmd('my_window', 'VimLeave', 'VimLeave', {
        callback = function()
          require 'config.my_window'.leave()
        end,
      })
    end,
    config = function()
      require 'map.my_window'
    end,
  },
  {
    name = 'my_test',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<c-s-f4>', 'test', 'My_Test')
      end
    end,
    config = function()
      require 'map.my_test'
    end,
  },
  {
    name = 'my_tabline',
    dir = '',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    init = function()
      vim.opt.tabline = ' ' .. vim.loop.cwd()
      vim.opt.showtabline = 2
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>q', 'tabline', 'My_Tabline')
      end
    end,
    config = function()
      require 'map.my_tabline'
    end,
  },
  {
    name = 'my_drag',
    dir = '',
    lazy = true,
    ft = {
      'markdown',
    },
    event = { 'FocusLost', },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>m', 'drag', 'My_Drag')
      end
    end,
    config = function()
      require 'map.my_drag'
    end,
  },
  {
    name = 'my_info',
    dir = '',
    lazy = true,
    keys = {
      { '<f1>', function() require 'config.my_info'.info() end, mode = { 'n', 'v', }, silent = true, desc = 'Info', },
    },
    dependencies = {
      {
        'itchyny/vim-gitbranch',
        lazy = true,
        keys = {
          { '<c-3>', function() vim.cmd [[call feedkeys("\<c-r>=gitbranch#name()\<cr>")]] end, mode = { 'c', 'i', }, silent = true, desc = 'paste branch name', },
        },
      },
    },
  },
  {
    name = 'my_cmake',
    dir = '',
    lazy = true,
    keys = {
      { '<c-f10>', function() require 'config.my_cmake'.to_cmake() end, mode = { 'n', 'v', }, silent = true, desc = 'c or cbps to cmake', },
      { '<c-s-f10>', function() require 'config.my_cmake'.to_cmake(1) end, mode = { 'n', 'v', }, silent = true, desc = 'c or cbps to cmake', },
    },
    config = function()
      require 'map.my_cmake'
    end,
  },
}
