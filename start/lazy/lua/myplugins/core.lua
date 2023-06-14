local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\testnvim2\\opt\\'

-- %s/.*{\s*\([^ ]\+\) *\(.\+,\) *\(mode = {[ 'nvtic,]\+},\) *\(.\+\) *},/\=printf("      { %-21s %-72s %-25s %s },", submatch(1), submatch(2), submatch(3), substitute(trim(submatch(4)), ' \+', ' ' ,'g'))

return {
  {
    name = 'options',
    dir = opt .. 'options',
  },
  {
    name = 'maps',
    lazy = true,
    dir = opt .. 'maps',
    event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
    keys = {

      -- maps.lua

      -- change_cwd

      { 'c.',                 '<cmd>try|cd %:h|ec getcwd()|catch|endtry<cr>',                          mode = { 'n', 'v' },      silent = true, desc = 'cd %:h' },
      { 'cu',                 '<cmd>try|cd ..|ec getcwd()|catch|endtry<cr>',                           mode = { 'n', 'v' },      silent = true, desc = 'cd ..' },
      { 'c-',                 '<cmd>try|cd -|ec getcwd()|catch|endtry<cr>',                            mode = { 'n', 'v' },      silent = true, desc = 'cd -' },

      -- copy_paste

      { '<a-y>',              '"+y',                                                                   mode = { 'n', 'v' },      silent = true, desc = '"+y' },
      { '<a-p>',              '"+p',                                                                   mode = { 'n', 'v' },      silent = true, desc = '"+p' },
      { '<a-s-p>',            '"+P',                                                                   mode = { 'n', 'v' },      silent = true, desc = '"+P' },

      { '<leader>y',          '<esc>:let @+ = expand("%:t")<cr>',                                      mode = { 'n', 'v' },      silent = true, desc = 'copy %:t to +' },
      { '<leader>gy',         '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', mode = { 'n', 'v' },      silent = true, desc = 'copy fullpath to +' },
      { '<leader><leader>gy', '<esc>:let @+ = substitute(getcwd(), "/", "\\\\", "g")<cr>',             mode = { 'n', 'v' },      silent = true, desc = 'copy cwd to +' },

      -- cursor

      { '<c-j>',              '5j',                                                                    mode = { 'n', 'v', },     silent = true, desc = '5j' },
      { '<c-k>',              '5k',                                                                    mode = { 'n', 'v', },     silent = true, desc = '5k' },

      -- f5

      { '<f5>',               '<cmd>e!<cr>',                                                           mode = { 'n', 'v' },      silent = true, desc = 'e!' },

      -- mouse

      { '<rightmouse>',       '<leftmouse>',                                                           mode = { 'n', 'v', 'i' }, silent = true, desc = 'leftmouse' },
      { '<rightrelease>',     '<nop>',                                                                 mode = { 'n', 'v', 'i' }, silent = true, desc = 'nop' },
      { '<middlemouse>',      '<nop>',                                                                 mode = { 'n', 'v', 'i' }, silent = true, desc = 'nop' },

      -- record

      { 'Q',                  'q',                                                                     mode = { 'n', 'v' },      silent = true, desc = 'record' },

      -- source

      { '<leader>f.',         '<cmd>if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>',       mode = { 'n', 'v' },      silent = true, desc = 'source vim or lua' },

      -- undo

      { 'U',                  '<c-r>',                                                                 mode = { 'n', },          silent = true, desc = 'redo' },

      -- bufferjump.lua

      { '<leader>wp',         '<c-w>p',                                                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd p' },

      { '<leader>wk',         function() require('bufferjump').k() end,                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd k' },
      { '<leader>wj',         function() require('bufferjump').j() end,                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd j' },
      { '<leader>wh',         '<c-w>h',                                                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd h' },
      { '<leader>wl',         '<c-w>l',                                                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd l' },

      { '<leader>wo',         '<c-w>_',                                                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd _' },
      { '<leader>wu',         '<c-w>|',                                                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd |' },
      { '<leader>wi',         function() require('bufferjump').i() end,                                mode = { 'n', 'v' },      silent = true, desc = 'wincmd =' },

      { '<leader><leader>wi', function() require('bufferjump').ii() end,                               mode = { 'n', 'v' },      silent = true, desc = 'win height auto max disable' },
      { '<leader><leader>wo', function() require('bufferjump').oo() end,                               mode = { 'n', 'v' },      silent = true, desc = 'win height auto max enable' },

      { '<leader><leader>wh', function() require('bufferjump').hh() end,                               mode = { 'n', 'v' },      silent = true, desc = 'set winfixwidth' },
      { '<leader><leader>wj', function() require('bufferjump').jj() end,                               mode = { 'n', 'v' },      silent = true, desc = 'set nowinfixheight' },
      { '<leader><leader>wk', function() require('bufferjump').kk() end,                               mode = { 'n', 'v' },      silent = true, desc = 'set winfixheight' },
      { '<leader><leader>wl', function() require('bufferjump').ll() end,                               mode = { 'n', 'v' },      silent = true, desc = 'set nowinfixwidth' },
    },
  },
}
