local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\testnvim2\\opt\\'

-- %s/.*{\s*\([^ ]\+\) *\(.\+,\) *\(mode = {[ 'nvtic,]\+},\) *\(.\+\) *},/\=printf("      { %-30s %-72s %-20s %s },", submatch(1), submatch(2), submatch(3), substitute(trim(submatch(4)), ' \+', ' ' ,'g'))

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
    dependencies = {
      require('wait.plenary'),
      require('wait.asyncrun'),
      require('wait.projectroot'),
    },
    keys = {

      ------------------------
      -- maps.lua
      ------------------------

      -- change_cwd

      { 'c.',                 '<cmd>try|cd %:h|ec getcwd()|catch|endtry<cr>',                          mode = { 'n', 'v' },  silent = true, desc = 'cd %:h' },
      { 'cu',                 '<cmd>try|cd ..|ec getcwd()|catch|endtry<cr>',                           mode = { 'n', 'v' },  silent = true, desc = 'cd ..' },
      { 'c-',                 '<cmd>try|cd -|ec getcwd()|catch|endtry<cr>',                            mode = { 'n', 'v' },  silent = true, desc = 'cd -' },
      { 'c=',                 '<cmd>ProjectRootCD<cr>',                                                mode = { 'n', 'v' },  silent = true, desc = 'ProjectRootCD' },

      -- copy_paste

      { '<a-y>',              '"+y',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+y' },
      { '<a-p>',              '"+p',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+p' },
      { '<a-s-p>',            '"+P',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+P' },

      { '<leader>y',          '<esc>:let @+ = expand("%:t")<cr>',                                      mode = { 'n', 'v' },  silent = true, desc = 'copy %:t to +' },
      { '<leader>gy',         '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', mode = { 'n', 'v' },  silent = true, desc = 'copy fullpath to +' },
      { '<leader><leader>gy', '<esc>:let @+ = substitute(getcwd(), "/", "\\\\", "g")<cr>',             mode = { 'n', 'v' },  silent = true, desc = 'copy cwd to +' },

      -- cursor

      { '<c-j>',              '5j',                                                                    mode = { 'n', 'v', }, silent = true, desc = '5j' },
      { '<c-k>',              '5k',                                                                    mode = { 'n', 'v', }, silent = true, desc = '5k' },

      -- f5

      { '<f5>',               '<cmd>e!<cr>',                                                           mode = { 'n', 'v' },  silent = true, desc = 'e!' },

      -- record

      { 'q',                  '<nop>',                                                                 mode = { 'n', 'v' },  silent = true, desc = 'nop' },
      { 'Q',                  'q',                                                                     mode = { 'n', 'v' },  silent = true, desc = 'record' },

      -- source

      { '<leader>f.',         '<cmd>if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>',       mode = { 'n', 'v' },  silent = true, desc = 'source vim or lua' },

      -- undo

      { 'U',                  '<c-r>',                                                                 mode = { 'n', },      silent = true, desc = 'redo' },

      -- go cmdline

      { '<leader>;',          ':',                                                                     mode = { 'n', 'v', }, silent = false, desc = 'go cmdline' },

      -- scroll horizontally

      { '<S-ScrollWheelDown>',  '10zl',                                                                mode = { 'n', 'v', }, silent = false, desc = 'scroll right horizontally' },
      { '<S-ScrollWheelUp>',    '10zh',                                                                mode = { 'n', 'v', }, silent = false, desc = 'scroll left horizontally' },

      ------------------------
      -- bufferjump.lua
      ------------------------

      -- jump prev buffer

      { '<leader>wp',         '<c-w>p',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd p' },

      -- jump buffer beside

      { '<leader>ww',         function() require('bufferjump').k() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd k' },
      { '<leader>ws',         function() require('bufferjump').j() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd j' },
      { '<leader>a',          '<c-w>h',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd h' },
      { '<leader>d',          '<c-w>l',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd l' },

      -- win max min equal width height

      { '<leader>wo',         '<c-w>_',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd _' },
      { '<leader>wu',         '<c-w>|',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd |' },
      { '<leader>wi',         function() require('bufferjump').i() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd =' },

      -- toggle win height auto max

      { '<leader><leader>wi', function() require('bufferjump').ii() end, mode = { 'n', 'v' }, silent = true, desc = 'win height auto max disable' },
      { '<leader><leader>wo', function() require('bufferjump').oo() end, mode = { 'n', 'v' }, silent = true, desc = 'win height auto max enable' },

      -- toggle winfix width height

      { '<leader><leader>wh', function() require('bufferjump').hh() end, mode = { 'n', 'v' }, silent = true, desc = 'set winfixwidth' },
      { '<leader><leader>wj', function() require('bufferjump').jj() end, mode = { 'n', 'v' }, silent = true, desc = 'set nowinfixheight' },
      { '<leader><leader>wk', function() require('bufferjump').kk() end, mode = { 'n', 'v' }, silent = true, desc = 'set winfixheight' },
      { '<leader><leader>wl', function() require('bufferjump').ll() end, mode = { 'n', 'v' }, silent = true, desc = 'set nowinfixwidth' },

      ------------------------
      -- buffernew.lua
      ------------------------

      -- create new empty buffer

      { '<leader>bq',         '<cmd>tabnew<cr>',                                             mode = { 'n', 'v' }, silent = true, desc = 'tabnew' },
      { '<leader>bw',         '<cmd>leftabove new<cr>',                                      mode = { 'n', 'v' }, silent = true, desc = 'leftabove new' },
      { '<leader>ba',         '<cmd>leftabove vnew<cr>',                                     mode = { 'n', 'v' }, silent = true, desc = 'leftabove vnew' },
      { '<leader>bs',         '<cmd>new<cr>',                                                mode = { 'n', 'v' }, silent = true, desc = 'new' },
      { '<leader>bd',         '<cmd>vnew<cr>',                                               mode = { 'n', 'v' }, silent = true, desc = 'vnew' },

      -- clone cur buffer beside

      { '<leader>bI',         '<c-w>s<c-w>T',                                                mode = { 'n', 'v' }, silent = true, desc = 'wincmd T' },
      { '<leader>bH',         '<cmd>leftabove vsplit<cr>',                                   mode = { 'n', 'v' }, silent = true, desc = 'leftabove vsplit' },
      { '<leader>bJ',         '<cmd>split<cr>',                                              mode = { 'n', 'v' }, silent = true, desc = 'split' },
      { '<leader>bK',         '<cmd>leftabove split<cr>',                                    mode = { 'n', 'v' }, silent = true, desc = 'leftabove split' },
      { '<leader>bL',         '<cmd>vsplit<cr>',                                             mode = { 'n', 'v' }, silent = true, desc = 'vsplit' },

      -- clone cur buffer and open somewhere

      { '<leader>bc',         function() require('buffernew').stack_cur_bufname() end,       mode = { 'n', 'v' }, silent = true, desc = 'stack_cur_bufname' },

      { '<leader>bg',         function() require('buffernew').pop_last_bufname('tab') end,   mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname tab' },
      { '<leader>b;',         function() require('buffernew').pop_last_bufname('here') end,  mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname here' },
      { '<leader>bk',         function() require('buffernew').pop_last_bufname('up') end,    mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname up' },
      { '<leader>bj',         function() require('buffernew').pop_last_bufname('down') end,  mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname down' },
      { '<leader>bh',         function() require('buffernew').pop_last_bufname('left') end,  mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname left' },
      { '<leader>bl',         function() require('buffernew').pop_last_bufname('right') end, mode = { 'n', 'v' }, silent = true, desc = 'pop_last_bufname right' },

      -- hide or bw one or more buffers

      { '<leader>xc',         function() require('buffernew').hide() end,                    mode = { 'n', 'v' }, silent = true, desc = 'hide cur buffer' },
      { '<leader>xx',         '<cmd>Bwipeout!<cr>',                                          mode = { 'n', 'v' }, silent = true, desc = 'Bwipeout!' },
      { '<leader>x.',         '<cmd>bw!<cr>',                                                mode = { 'n', 'v' }, silent = true, desc = 'bw!' },
      { '<leader>xt',         '<cmd>tabclose<cr>',                                           mode = { 'n', 'v' }, silent = true, desc = 'tabclose' },
      { '<leader><del>',      function() require('buffernew').bw_unlisted_buffers() end,     mode = { 'n', 'v' }, silent = true, desc = 'bw_unlisted_buffers' },
      { '<leader>x<bs>',      '<cmd>qa!<cr>',                                                mode = { 'n', 'v' }, silent = true, desc = 'qa!' },

      ------------------------
      -- fontsize.lua
      ------------------------

      { '<c-=>',              function() require('fontsize').sizeup() end,                   mode = { 'n', 'v' }, silent = true, desc = 'fontsize up' },
      { '<c-->',              function() require('fontsize').sizedown() end,                 mode = { 'n', 'v' }, silent = true, desc = 'fontsize down' },
      { '<c-0><c-0>',         function() require('fontsize').sizenormal() end,               mode = { 'n', 'v' }, silent = true, desc = 'fontsize normal' },
      { '<c-0>_',             function() require('fontsize').sizemin() end,                  mode = { 'n', 'v' }, silent = true, desc = 'fontsize min' },

      ------------------------
      -- gitpushinit.lua
      ------------------------

      { '<leader>g1',         function() require('gitpushinit').addcommitpush() end,         mode = { 'n', 'v' }, silent = true, desc = 'git add all commit and push' },
      { '<leader>g2',         function() require('gitpushinit').push() end,                  mode = { 'n', 'v' }, silent = true, desc = 'git add all commit and push' },
      { '<leader>gI',         function() require('gitpushinit').init() end,                  mode = { 'n', 'v' }, silent = true, desc = 'git init' },

    },
  },
}
