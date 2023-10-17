local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'maps',
  dir = opt .. 'maps',
  lazy = true,
  event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
  dependencies = {
    require 'plugins.asyncrun',
    require 'plugins.notify',
    require 'plugins.projectroot',
    require 'plugins.whichkey',
    require 'plugins.plenary',
  },
  keys = {

    -- record
    { 'q',                   '<cmd>WhichKey q<cr>',                           mode = { 'n', 'v', }, silent = true,  desc = 'nop', },
    { 'Q',                   'q',                                             mode = { 'n', 'v', }, silent = true,  desc = 'record', },

    -- undo
    { 'U',                   '<c-r>',                                         mode = { 'n', },      silent = true,  desc = 'redo', },

    -- go cmdline
    { '<leader>;',           ':',                                             mode = { 'n', 'v', }, silent = false, desc = 'go cmdline', },

    -- scroll horizontally
    { '<S-ScrollWheelDown>', '10zl',                                          mode = { 'n', 'v', }, silent = false, desc = 'scroll right horizontally', },
    { '<S-ScrollWheelUp>',   '10zh',                                          mode = { 'n', 'v', }, silent = false, desc = 'scroll left horizontally', },

    -- f5
    { '<f5>',                '<cmd>e!<cr>',                                   mode = { 'n', 'v', }, silent = true,  desc = 'e!', },

    -- cursor
    { '<c-j>',               '5j',                                            mode = { 'n', 'v', }, silent = true,  desc = '5j', },
    { '<c-k>',               '5k',                                            mode = { 'n', 'v', }, silent = true,  desc = '5k', },

    -- copy_paste
    { '<a-y>',               '"+y',                                           mode = { 'n', 'v', }, silent = true,  desc = '"+y', },
    { 'yii',                 '"+yi',                                          mode = { 'n', },      silent = true,  desc = '"+yi', },
    { 'yaa',                 '"+ya',                                          mode = { 'n', },      silent = true,  desc = '"+ya', },
    { '<a-d>',               '"+d',                                           mode = { 'n', 'v', }, silent = true,  desc = '"+d', },
    { 'dii',                 '"+di',                                          mode = { 'n', },      silent = true,  desc = '"+di', },
    { 'daa',                 '"+da',                                          mode = { 'n', },      silent = true,  desc = '"+da', },
    { '<a-c>',               '"+c',                                           mode = { 'n', 'v', }, silent = true,  desc = '"+c', },
    { 'cii',                 '"+ci',                                          mode = { 'n', },      silent = true,  desc = '"+ci', },
    { 'caa',                 '"+ca',                                          mode = { 'n', },      silent = true,  desc = '"+ca', },
    { '<a-p>',               '"+p',                                           mode = { 'n', 'v', }, silent = true,  desc = '"+p', },
    { '<a-s-p>',             '"+P',                                           mode = { 'n', 'v', }, silent = true,  desc = '"+P', },

    -- yank.lua
    { '<leader>y<leader>',   function() require 'yank'.fname() end,           mode = { 'n', 'v', }, silent = true,  desc = 'copy %:t to +', },
    { '<leader>yg',          function() require 'yank'.absfname() end,        mode = { 'n', 'v', }, silent = true,  desc = 'copy fullpath to +', },
    { '<leader>yw',          function() require 'yank'.cwd() end,             mode = { 'n', 'v', }, silent = true,  desc = 'copy cwd to +', },

    -- change_dir.lua
    { 'c.',                  function() require 'change_dir'.cur() end,       mode = { 'n', },      silent = true,  desc = 'cd %:h', },
    { 'cu',                  function() require 'change_dir'.up() end,        mode = { 'n', },      silent = true,  desc = 'cd ..', },
    { 'c<leader>',           function() require 'change_dir'.cwd() end,       mode = { 'n', },      silent = true,  desc = 'cd cwd', },

    -- font_size.lua
    { '<c-=>',               function() require 'font_size'.up() end,         mode = { 'n', 'v', }, silent = true,  desc = 'font_size up', },
    { '<c-->',               function() require 'font_size'.down() end,       mode = { 'n', 'v', }, silent = true,  desc = 'font_size down', },
    { '<c-0><c-0>',          function() require 'font_size'.normal() end,     mode = { 'n', 'v', }, silent = true,  desc = 'font_size normal', },
    { '<c-0>_',              function() require 'font_size'.min() end,        mode = { 'n', 'v', }, silent = true,  desc = 'font_size min', },
    { '<c-0><c-->',          function() require 'font_size'.frameless() end,  mode = { 'n', 'v', }, silent = true,  desc = 'font_size frameless', },
    { '<c-0><c-=>',          function() require 'font_size'.fullscreen() end, mode = { 'n', 'v', }, silent = true,  desc = 'font_size fullscreen', },

    -- start.lua
    { 'cs.',                 function() require 'start'.explorer_cur() end,   mode = { 'n', },      silent = true,  desc = 'start explorer_cur', },
    { 'csu',                 function() require 'start'.explorer_up() end,    mode = { 'n', },      silent = true,  desc = 'start explorer_up', },
    { 'csw',                 function() require 'start'.explorer_cwd() end,   mode = { 'n', },      silent = true,  desc = 'start explorer_cwd', },
    { 'csc',                 function() require 'start'.system_cur() end,     mode = { 'n', },      silent = true,  desc = 'start system_cur', },
    { '<leader>s.',          function() require 'start'.source_lua_vim() end, mode = { 'n', 'v', }, silent = true,  desc = 'source vim or lua', },

    -- git_push.lua
    '<leader>gg',
    { '<leader>ga',     function() require 'git_push'.addcommitpush() end,    mode = { 'n', 'v', }, silent = true, desc = 'Git Push add all commit and push', },
    { '<leader>gc',     function() require 'git_push'.commitpush() end,       mode = { 'n', 'v', }, silent = true, desc = 'Git Push commit and push', },
    { '<leader>ggc',    function() require 'git_push'.commit() end,           mode = { 'n', 'v', }, silent = true, desc = 'Git Push just commit', },
    { '<leader>ggs',    function() require 'git_push'.push() end,             mode = { 'n', 'v', }, silent = true, desc = 'Git Push just push', },
    { '<leader>ggg',    function() require 'git_push'.graph() end,            mode = { 'n', 'v', }, silent = true, desc = 'Git Push graph', },
    { '<leader>ggv',    function() require 'git_push'.init() end,             mode = { 'n', 'v', }, silent = true, desc = 'Git Push init', },
    { '<leader>ggf',    function() require 'git_push'.pull() end,             mode = { 'n', 'v', }, silent = true, desc = 'Git Push pull', },
    { '<leader>gga',    function() require 'git_push'.addall() end,           mode = { 'n', 'v', }, silent = true, desc = 'Git Push add -A', },
    { '<leader>ggr',    function() require 'git_push'.reset_hard() end,       mode = { 'n', 'v', }, silent = true, desc = 'Git Push reset --hard', },
    { '<leader>ggd',    function() require 'git_push'.reset_hard_clean() end, mode = { 'n', 'v', }, silent = true, desc = 'Git Push reset --hard && git clean -fd', },
    { '<leader>ggC',    function() require 'git_push'.clone() end,            mode = { 'n', 'v', }, silent = true, desc = 'Git Clone', },

    -- window.lua
    { '<a-s-h>',        function() require 'window'.height_less() end,        mode = { 'n', 'v', }, silent = true, desc = 'Window height_less', },
    { '<a-s-l>',        function() require 'window'.height_more() end,        mode = { 'n', 'v', }, silent = true, desc = 'Window height_more', },
    { '<a-s-j>',        function() require 'window'.width_less() end,         mode = { 'n', 'v', }, silent = true, desc = 'Window width_less', },
    { '<a-s-k>',        function() require 'window'.width_more() end,         mode = { 'n', 'v', }, silent = true, desc = 'Window width_more', },
    { '<leader>w<c-i>', function() require 'window'.copy_tab() end,           mode = { 'n', 'v', }, silent = true, desc = 'Window copy_tab', },
    { '<leader>w<c-h>', function() require 'window'.copy_left() end,          mode = { 'n', 'v', }, silent = true, desc = 'Window copy_left', },
    { '<leader>w<c-j>', function() require 'window'.copy_down() end,          mode = { 'n', 'v', }, silent = true, desc = 'Window copy_down', },
    { '<leader>w<c-k>', function() require 'window'.copy_up() end,            mode = { 'n', 'v', }, silent = true, desc = 'Window copy_up', },
    { '<leader>w<c-l>', function() require 'window'.copy_right() end,         mode = { 'n', 'v', }, silent = true, desc = 'Window copy_right', },
    { '<leader>w<a-i>', function() require 'window'.new_tab() end,            mode = { 'n', 'v', }, silent = true, desc = 'Window new_tab', },
    { '<leader>w<a-h>', function() require 'window'.new_left() end,           mode = { 'n', 'v', }, silent = true, desc = 'Window new_left', },
    { '<leader>w<a-j>', function() require 'window'.new_down() end,           mode = { 'n', 'v', }, silent = true, desc = 'Window new_down', },
    { '<leader>w<a-k>', function() require 'window'.new_up() end,             mode = { 'n', 'v', }, silent = true, desc = 'Window new_up', },
    { '<leader>w<a-l>', function() require 'window'.new_right() end,          mode = { 'n', 'v', }, silent = true, desc = 'Window new_right', },

    -- change win around
    { '<leader>wh',     function() require 'window'.change_around 'h' end,    mode = { 'n', 'v', }, silent = true, desc = 'Window change win to left', },
    { '<leader>wj',     function() require 'window'.change_around 'j' end,    mode = { 'n', 'v', }, silent = true, desc = 'Window change win to down', },
    { '<leader>wk',     function() require 'window'.change_around 'k' end,    mode = { 'n', 'v', }, silent = true, desc = 'Window change win to up', },
    { '<leader>wl',     function() require 'window'.change_around 'l' end,    mode = { 'n', 'v', }, silent = true, desc = 'Window change win to right', },
    { '<leader>wL',     function() require 'window'.change_around_last() end, mode = { 'n', 'v', }, silent = true, desc = 'Window change win use last', },

    -- stack full filename
    { '<leader>w=',     function() require 'window'.stack_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'Window stack_cur', },
    { '<leader>w+',     function() require 'window'.stack_open_txt() end,     mode = { 'n', 'v', }, silent = true, desc = 'Window stack_open_txt', },
    { '<leader>w-',     function() require 'window'.stack_open_sel() end,     mode = { 'n', 'v', }, silent = true, desc = 'Window stack_open_sel', },

    -- close around
    { '<leader>xh',     function() require 'window'.close_win_left() end,     mode = { 'n', 'v', }, silent = true, desc = 'Window close_win_left', },
    { '<leader>xj',     function() require 'window'.close_win_down() end,     mode = { 'n', 'v', }, silent = true, desc = 'Window close_win_down', },
    { '<leader>xk',     function() require 'window'.close_win_up() end,       mode = { 'n', 'v', }, silent = true, desc = 'Window close_win_up', },
    { '<leader>xl',     function() require 'window'.close_win_right() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window close_win_right', },

    -- close cur
    { '<leader>xt',     function() require 'window'.close_cur_tab() end,      mode = { 'n', 'v', }, silent = true, desc = 'Window close_cur_tab', },
    { '<leader>xw',     function() require 'window'.bwipeout_cur() end,       mode = { 'n', 'v', }, silent = true, desc = 'Window bwipeout_cur', },
    { '<leader>xd',     function() require 'window'.bdelete_cur() end,        mode = { 'n', 'v', }, silent = true, desc = 'Window bdelete_cur', },
    { '<leader>xc',     function() require 'window'.close_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'Window close_cur', },

    -- close cur proj
    { '<leader>xp',     function() require 'window'.bdelete_cur_proj() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window bdelete_cur_proj', },
    { '<leader>xP',     function() require 'window'.bwipeout_cur_proj() end,  mode = { 'n', 'v', }, silent = true, desc = 'Window bwipeout_cur_proj', },

    -- quit
    { '<leader>xa',     '<cmd>qa!<cr>',                                       mode = { 'n', 'v', }, silent = true, desc = 'Window quit all', },
    { '<leader>xA',     function() require 'window'.restart_nvim_qt() end,    mode = { 'n', 'v', }, silent = true, desc = 'Window restart nvim-qt', },
    { '<leader>xS',     function() require 'window'.start_new_nvim_qt() end,  mode = { 'n', 'v', }, silent = true, desc = 'Window restart nvim-qt', },

    -- bwipeout deleted
    { '<leader>x<del>', function() require 'window'.bwipeout_deleted() end,   mode = { 'n', 'v', }, silent = true, desc = 'Window bwipeout_deleted', },
    { '<leader>x<cr>',  function() require 'window'.reopen_deleted() end,     mode = { 'n', 'v', }, silent = true, desc = 'Window reopen_deleted', },

    -- lazygit
    { '<leader>gl',     '<cmd>silent !start lazygit<cr>',                     mode = { 'n', 'v', }, silent = true, desc = 'lazygit', },

    -- info.lua
    { '<F1>',           function() require 'info'.statusline() end,           mode = { 'n', 'v', }, silent = true, desc = 'info statusline', },

    -- message
    { '<c-F1>',         function() require 'info'.message() end,              mode = { 'n', 'v', }, silent = true, desc = 'info message', },

    -- quickfix.lua
    { 'd<leader>',      function() require 'quickfix'.toggle() end,           mode = { 'n', 'v', }, silent = true, desc = 'quickfix open', },

    -- all_git_repos.lua
    { '<leader>sg',     function() require 'all_git_repos'.sel() end,         mode = { 'n', 'v', }, silent = true, desc = 'all_git_repos sel', },
    { '<leader>sG',     function() require 'all_git_repos'.update() end,      mode = { 'n', 'v', }, silent = true, desc = 'all_git_repos update', },

    -- toggle.lua
    -- diff
    { '<leader>td',     function() require 'toggle'.diff(1) end,              mode = { 'n', 'v', }, silent = true, desc = 'toggle diffthis', },
    { '<leader>tD',     function() require 'toggle'.diff() end,               mode = { 'n', 'v', }, silent = true, desc = 'toggle diffoff', },

    -- wrap
    { '<leader>tw',     function() require 'toggle'.wrap(1) end,              mode = { 'n', 'v', }, silent = true, desc = 'toggle wrap', },
    { '<leader>tW',     function() require 'toggle'.wrap() end,               mode = { 'n', 'v', }, silent = true, desc = 'toggle nowrap', },

    -- norenu
    { '<leader>tr',     function() require 'toggle'.norenu(1) end,            mode = { 'n', 'v', }, silent = true, desc = 'toggle norenu', },
    { '<leader>tR',     function() require 'toggle'.norenu() end,             mode = { 'n', 'v', }, silent = true, desc = 'toggle renu', },

    -- signcolumn
    { '<leader>ts',     function() require 'toggle'.signcolumn(1) end,        mode = { 'n', 'v', }, silent = true, desc = 'toggle signcolumn=auto:1', },
    { '<leader>tS',     function() require 'toggle'.signcolumn() end,         mode = { 'n', 'v', }, silent = true, desc = 'toggle signcolumn=no', },

    -- sessions.lua
    { '<leader>s<cr>',  function() require 'sessions'.load() end,             mode = { 'n', 'v', }, silent = true, desc = 'sessions load', },

    -- Others

    -- bcomp.lua
    { "<leader>'<tab>", function() require 'bcomp'.diff1() end,               mode = { 'n', 'v', }, silent = true, desc = 'bcomp diff1', },
    { "<leader>'`",     function() require 'bcomp'.diff2() end,               mode = { 'n', 'v', }, silent = true, desc = 'bcomp diff2', },
    { "<leader>'l",     function() require 'bcomp'.diff_last() end,           mode = { 'n', 'v', }, silent = true, desc = 'bcomp last', },

    -- Work
    -- upload
    { "<leader>'u",     function() require 'work.upload'.upload() end,        mode = { 'n', 'v', }, silent = true, desc = 'work upload file', },

    -- tortoisesvn
    { '<leader>vo',     '<cmd>TortoiseSVN settings cur yes<cr>',              mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN settings cur yes<cr>', },
    { '<leader>vd',     '<cmd>TortoiseSVN diff cur yes<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff cur yes<cr>', },
    { '<leader>vD',     '<cmd>TortoiseSVN diff root yes<cr>',                 mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff root yes<cr>', },
    { '<leader>vb',     '<cmd>TortoiseSVN blame cur yes<cr>',                 mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN blame cur yes<cr>', },
    { '<leader>vw',     '<cmd>TortoiseSVN repobrowser cur yes<cr>',           mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser cur yes<cr>', },
    { '<leader>vW',     '<cmd>TortoiseSVN repobrowser root yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser root yes<cr>', },
    { '<leader>vs',     '<cmd>TortoiseSVN repostatus cur yes<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repostatus cur yes<cr>', },
    { '<leader>vS',     '<cmd>TortoiseSVN repostatus root yes<cr>',           mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repostatus root yes<cr>', },
    { '<leader>vr',     '<cmd>TortoiseSVN rename cur yes<cr>',                mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN rename cur yes<cr>', },
    { '<leader>vR',     '<cmd>TortoiseSVN remove cur yes<cr>',                mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN remove cur yes<cr>', },
    { '<leader>vv',     '<cmd>TortoiseSVN revert cur yes<cr>',                mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN revert cur yes<cr>', },
    { '<leader>vV',     '<cmd>TortoiseSVN revert root yes<cr>',               mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN revert root yes<cr>', },
    { '<leader>va',     '<cmd>TortoiseSVN add cur yes<cr>',                   mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN add cur yes<cr>', },
    { '<leader>vA',     '<cmd>TortoiseSVN add root yes<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN add root yes<cr>', },
    { '<leader>vc',     '<cmd>TortoiseSVN commit cur yes<cr>',                mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN commit cur yes<cr>', },
    { '<leader>vC',     '<cmd>TortoiseSVN commit root yes<cr>',               mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN commit root yes<cr>', },
    { '<leader>vu',     '<cmd>TortoiseSVN update root no<cr>',                mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN update root no<cr>', },
    { '<leader>vU',     '<cmd>TortoiseSVN update /rev root yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN update /rev root yes<cr>', },
    { '<leader>vl',     '<cmd>TortoiseSVN log cur yes<cr>',                   mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log cur yes<cr>', },
    { '<leader>vL',     '<cmd>TortoiseSVN log root yes<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log root yes<cr>', },
    { '<leader>vk',     '<cmd>TortoiseSVN checkout root yes<cr>',             mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN checkout root yes<cr>', },

  },
  init = function()
    require 'config.whichkey'.add { ['<leader>a'] = { name = 'Side Panel', }, }
    require 'config.whichkey'.add { ['<leader>gg'] = { name = 'Git Push', }, }
    require 'config.whichkey'.add { ['<leader>y'] = { name = 'Yank', }, }
    require 'config.whichkey'.add { ['<leader>w'] = { name = 'Window', }, }
    require 'config.whichkey'.add { ['<leader>t'] = { name = 'Toggle Set', }, }
    require 'config.whichkey'.add { ['<leader>x'] = { name = 'Close Buffers', }, }
    require 'config.whichkey'.add { ["<leader>'"] = { name = 'Others', }, }
    require 'config.whichkey'.add { ['<leader>s'] = { name = 'Sessions', }, }
    -- work
    require 'config.whichkey'.add { ['<leader>v'] = { name = 'TortoiseSVN', }, }
  end,
  config = function()
    require 'work.tortoisesvn'
  end,
}
