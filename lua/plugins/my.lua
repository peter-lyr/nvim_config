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

      { '<c-1>',   function() require 'config.my_window'.gt() end,            mode = { 'n', 'v', }, silent = true, desc = 'gt', },
      { '<c-`>',   function() require 'config.my_window'.gT() end,            mode = { 'n', 'v', }, silent = true, desc = 'gT', },
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
        require 'my_simple'.add_whichkey('<a-t>', 'test', 'My_Test')
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
        require 'my_simple'.add_whichkey('<leader>x', 'tabline', 'My_Tabline', 'Delete')
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
          { '<c-b>', function() vim.cmd [[call feedkeys("\<c-r>=gitbranch#name()\<cr>")]] end, mode = { 'c', 'i', }, silent = true, desc = 'paste branch name', },
        },
      },
    },
  },
  {
    name = 'my_cmake',
    dir = '',
    lazy = true,
    keys = {
      { '<c-f10>',   function() require 'config.my_cmake'.to_cmake() end,  mode = { 'n', 'v', }, silent = true, desc = 'c or cbps to cmake', },
      { '<c-s-f10>', function() require 'config.my_cmake'.to_cmake(1) end, mode = { 'n', 'v', }, silent = true, desc = 'c or cbps to cmake', },
    },
  },
  {
    name = 'my_make',
    dir = '',
    lazy = true,
    keys = {
      { '<c-f9>', function() require 'config.my_make'.make() end, mode = { 'n', 'v', }, silent = true, desc = 'mingw32-make asyncrun', },
      { '<c-s-f9>', function() require 'config.my_make'.make('start') end, mode = { 'n', 'v', }, silent = true, desc = 'mingw32-make start', },
    },
  },
  {
    name = 'my_toggle',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>t', 'toggle', 'My_Toggle')
      end
    end,
    config = function()
      require 'map.my_toggle'
    end,
  },
  {
    name = 'my_hili',
    dir = '',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    keys = {
      { '*',       function() require 'config.my_hili'.search() end,          mode = { 'v', },      silent = true, desc = 'hili multiline search', },
      -- windo cursorword
      { '<a-7>',   function() require 'config.my_hili'.cursorword() end,      mode = { 'n', },      silent = true, desc = 'hili cursor word', },
      { '<a-8>',   function() require 'config.my_hili'.windocursorword() end, mode = { 'n', },      silent = true, desc = 'hili windo cursor word', },
      -- cword hili
      { '<c-8>',   function() require 'config.my_hili'.hili_n() end,          mode = { 'n', },      silent = true, desc = 'hili cword', },
      { '<c-8>',   function() require 'config.my_hili'.hili_v() end,          mode = { 'v', },      silent = true, desc = 'hili cword', },
      -- cword hili rm
      { '<c-s-8>', function() require 'config.my_hili'.rmhili_v() end,        mode = { 'v', },      silent = true, desc = 'hili rm v', },
      { '<c-s-8>', function() require 'config.my_hili'.rmhili_n() end,        mode = { 'n', },      silent = true, desc = 'hili rm n', },
      -- select hili
      { '<c-7>',   function() require 'config.my_hili'.selnexthili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili sel next', },
      { '<c-s-7>', function() require 'config.my_hili'.selprevhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili sel prev', },
      -- go hili
      { '<c-n>',   function() require 'config.my_hili'.prevhili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili go prev', },
      { '<c-m>',   function() require 'config.my_hili'.nexthili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili go next', },
      -- go cur hili
      { '<c-s-n>', function() require 'config.my_hili'.prevcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili go cur prev', },
      { '<c-s-m>', function() require 'config.my_hili'.nextcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili go cur next', },
    },
    config = function()
      vim.o.updatetime = 10
      require 'map.my_hili'
    end,
  },
  {
    name = 'my_yank',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>y', 'yank', 'My_Yank')
      end
    end,
    config = function()
      require 'map.my_yank'
    end,
  },
  {
    name = 'my_svn',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>v', 'svn', 'My_Svn')
      end
    end,
    config = function()
      require 'map.my_svn'
    end,
  },
}
