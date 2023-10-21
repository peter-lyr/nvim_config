return {
  name = 'tabline',
  dir = require 'my_simple'.get_opt_dir 'tabline',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  dependencies = {
    require 'plugins.plenary',
    require 'plugins.projectroot',
    'peter-lyr/vim-bbye',
  },
  keys = {
    { '<c-h>',             function() require 'tabline'.b_prev_buf() end,                      mode = { 'n', 'v', }, silent = true, desc = 'tabline b prev buffer', },
    { '<c-l>',             function() require 'tabline'.b_next_buf() end,                      mode = { 'n', 'v', }, silent = true, desc = 'tabline b next buffer', },
    { '<c-s-h>',           function() require 'tabline'.bd_prev_buf() end,                     mode = { 'n', 'v', }, silent = true, desc = 'tabline bd prev buffer', },
    { '<c-s-l>',           function() require 'tabline'.bd_next_buf() end,                     mode = { 'n', 'v', }, silent = true, desc = 'tabline bd next buffer', },
    { '<leader>qw',        function() require 'tabline'.only_cur_buffer() end,                 mode = { 'n', 'v', }, silent = true, desc = 'tabline only cur buffer', },
    { '<leader>qt',        function() require 'tabline'.restore_hidden_tabs() end,             mode = { 'n', 'v', }, silent = true, desc = 'tabline restore hidden tabs', },
    { '<leader>qo',        function() require 'tabline'.append_one_proj_right_down() end,      mode = { 'n', 'v', }, silent = true, desc = 'tabline append one proj right down', },
    { '<leader>qn',        function() require 'tabline'.append_one_proj_new_tab() end,         mode = { 'n', 'v', }, silent = true, desc = 'tabline append one proj new tab', },
    { '<leader>qm',        function() require 'tabline'.append_one_proj_new_tab_no_dupl() end, mode = { 'n', 'v', }, silent = true, desc = 'tabline append one proj new tab no dupl', },
    { '<leader>q<leader>', function() require 'tabline'.simple_statusline_toggle() end,        mode = { 'n', 'v', }, silent = true, desc = 'tabline simple statusline toggle', },
    { '<leader>qq',        function() require 'tabline'.only_tabs_toggle() end,                mode = { 'n', 'v', }, silent = true, desc = 'tabline show only tabs toggle', },
  },
  init = function()
    vim.opt.tabline     = ' ' .. vim.loop.cwd()
    vim.opt.showtabline = 2
    require 'config.whichkey'.add { ['<leader>q'] = { name = 'Tabline', }, }
  end,
  config = function()
    require 'tabline'
  end,
}
