local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

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
      require('wait.notify'),
      require('wait.telescope_ui_select'),
      require('plugins.minimap'), -- tabclose minimap
      require('plugins.coderunner'),
      'peter-lyr/sha2',
    },
    keys = {

      ------------------------
      -- maps.lua
      ------------------------

      -- change_cwd

      {
        'q.',
        function()
          local dir = vim.fn.expand('%:p:h')
          if #dir == 0 then
            return
          end
          vim.cmd(string.format('cd %s|cd %s', string.sub(dir, 1, 2), dir))
          require('notify').dismiss()
          vim.notify(vim.loop.cwd(), 'info', {
            animate = false,
            on_open = function(win)
              local buf = vim.api.nvim_win_get_buf(win)
              vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            end,
          })
        end,
        mode = { 'n', 'v' },
        silent = true,
        desc = 'cd %:h'
      },
      {
        'qu',
        function()
          local dir = vim.fn.expand('%:p:h')
          if #dir == 0 then
            return
          end
          vim.cmd('cd ..')
          require('notify').dismiss()
          vim.notify(vim.loop.cwd(), 'info', {
            animate = false,
            on_open = function(win)
              local buf = vim.api.nvim_win_get_buf(win)
              vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            end,
          })
        end,
        mode = { 'n', 'v' },
        silent = true,
        desc = 'cd ..'
      },
      { 'qw',
        function()
          local dir = vim.fn.expand('%:p:h')
          if #dir == 0 then
            return
          end
          vim.cmd('ProjectRootCD')
          require('notify').dismiss()
          vim.notify(vim.loop.cwd(), 'info', {
            animate = false,
            on_open = function(win)
              local buf = vim.api.nvim_win_get_buf(win)
              vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            end,
          })
        end,
        mode = { 'n', 'v' },
        silent = true,
        desc = 'ProjectRootCD'
      },

      -- start explorer

      { 'cs.',                function() vim.fn.system( string.format([[start /b cmd /c "explorer "%s""]], vim.fn.substitute(vim.fn.fnamemodify( vim.api.nvim_buf_get_name(0), ":h"), "/", "\\\\", "g"))) end, mode = { 'n', 'v' },  silent = true, desc = 'start %:h' },
      { 'csu',                function() vim.fn.system([[start /b cmd /c "explorer .."]]) end, mode = { 'n', 'v' },  silent = true, desc = 'start ..' },
      { 'csw',                function() vim.fn.system(string.format([[start /b cmd /c "explorer "%s""]], vim.call('ProjectRootGet'))) end, mode = { 'n', 'v' },  silent = true, desc = 'start ProjectRootGet' },
      { 'csc',                function() vim.fn.system(string.format([[chcp 65001 && start /min cmd /c "%s"]], vim.api.nvim_buf_get_name(0))) end, mode = { 'n', 'v' },  silent = true, desc = 'system open %:h' },

      -- replace

      { '<c-r>',              ':<c-u>%s/<c-r><c-w>/<c-r><c-w>/g', mode = { 'n', 'v' },  silent = false, desc = 'replace' },

      -- copy_paste

      { '<a-y>',              '"+y',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+y' },
      { '<a-p>',              '"+p',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+p' },
      { '<a-s-p>',            '"+P',                                                                   mode = { 'n', 'v' },  silent = true, desc = '"+P' },

      { '<leader>y',          '<esc>:let @+ = expand("%:t")<cr>',                                      mode = { 'n', 'v' },  silent = true, desc = 'copy %:t to +' },
      { '<leader>gy',         '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', mode = { 'n', 'v' },  silent = true, desc = 'copy fullpath to +' },
      { '<leader>gvy', '<esc>:let @+ = substitute(getcwd(), "/", "\\\\", "g")<cr>',                    mode = { 'n', 'v' },  silent = true, desc = 'copy cwd to +' },

      -- cursor

      { '<c-j>',              '5j',                                                                    mode = { 'n', 'v', }, silent = true, desc = '5j' },
      { '<c-k>',              '5k',                                                                    mode = { 'n', 'v', }, silent = true, desc = '5k' },

      -- f5

      { '<f5>',               function() vim.cmd('e!') end,                                            mode = { 'n', 'v' },  silent = true, desc = 'e!' },

      -- record

      { 'q',                  '<cmd>WhichKey q<cr>',                                                   mode = { 'n', 'v' },  silent = true, desc = 'nop' },
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

      -- jump window

      { '<leader><leader>`', function() require('bufferjump').hjkl_toggle() end, mode = { 'n', 'v' }, silent = true, desc = 'toggle map 1 2 3 4 h j k l' },
      { '<leader>`', '<c-w>p',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd p' },
      { '<leader>3', function() require('bufferjump').k() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd k' },
      { '<leader>2', function() require('bufferjump').j() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd j' },
      { '<leader>1', '<c-w>h',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd h' },
      { '<leader>4', '<c-w>l',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd l' },

      -- win max min equal width height

      { '<leader>wo',         '<c-w>_',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd _' },
      { '<leader>wu',         '<c-w>|',                                  mode = { 'n', 'v' }, silent = true, desc = 'wincmd |' },
      { '<leader>wi',         function() require('bufferjump').i() end,  mode = { 'n', 'v' }, silent = true, desc = 'wincmd =' },

      -- toggle win height auto max

      { '<leader>wvi', function() require('bufferjump').ii() end, mode = { 'n', 'v' }, silent = true, desc = 'win height auto max disable' },
      { '<leader>wvo', function() require('bufferjump').oo() end, mode = { 'n', 'v' }, silent = true, desc = 'win height auto max enable' },

      -- toggle winfix width height

      { '<leader>wvh', function() require('bufferjump').hh() end, mode = { 'n', 'v' }, silent = true, desc = 'set winfixwidth' },
      { '<leader>wvj', function() require('bufferjump').jj() end, mode = { 'n', 'v' }, silent = true, desc = 'set nowinfixheight' },
      { '<leader>wvk', function() require('bufferjump').kk() end, mode = { 'n', 'v' }, silent = true, desc = 'set winfixheight' },
      { '<leader>wvl', function() require('bufferjump').ll() end, mode = { 'n', 'v' }, silent = true, desc = 'set nowinfixwidth' },

      ------------------------
      -- buffernew.lua
      ------------------------

      -- create new empty buffer

      { '<leader>bq',         '<cmd>tabnew<cr>',                                             mode = { 'n', 'v' }, silent = true, desc = 'tabnew' },
      { '<leader>bw',         '<cmd>leftabove new<cr>',                                      mode = { 'n', 'v' }, silent = true, desc = 'leftabove new' },
      { '<leader>ba',         '<cmd>leftabove vnew<cr>',                                     mode = { 'n', 'v' }, silent = true, desc = 'leftabove vnew' },
      { '<leader>bs',         '<cmd>new<cr>',                                                mode = { 'n', 'v' }, silent = true, desc = 'new' },
      { '<leader>bd',         '<cmd>vnew<cr>',                                               mode = { 'n', 'v' }, silent = true, desc = 'vnew' },
      { '<leader>bm',         '<cmd>wincmd T<cr>',                                           mode = { 'n', 'v' }, silent = true, desc = 'wincmd T' },

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

      { '<leader>xc',         function() require('buffernew').close() end,                   mode = { 'n', 'v' }, silent = true, desc = 'hide cur buffer' },
      { '<leader>xd',         function() require('buffernew').delete() end,                  mode = { 'n', 'v' }, silent = true, desc = 'Bwipeout!' },
      { '<leader>xw',         function() require('buffernew').wipeout() end,                 mode = { 'n', 'v' }, silent = true, desc = 'bw!' },
      { '<leader>xt',         function() require('buffernew').tabclose() end,                mode = { 'n', 'v' }, silent = true, desc = 'tabclose' },
      { '<leader>xvt',        function() require('buffernew').tabbwipeout() end,             mode = { 'n', 'v' }, silent = true, desc = 'tabbwipeout' },
      { '<leader><del>',      function() require('buffernew').bw_unlisted_buffers() end,     mode = { 'n', 'v' }, silent = true, desc = 'bw_unlisted_buffers' },
      { '<leader>x<bs>',      '<cmd>qa!<cr>',                                                mode = { 'n', 'v' }, silent = true, desc = 'qa!' },

      -- close win around

      { '<leader>xh',         function() require('buffernew').close_win_around('h') end,     mode = { 'n', 'v' }, silent = true, desc = 'close win around h' },
      { '<leader>xj',         function() require('buffernew').close_win_around('j') end,     mode = { 'n', 'v' }, silent = true, desc = 'close win around j' },
      { '<leader>xk',         function() require('buffernew').close_win_around('k') end,     mode = { 'n', 'v' }, silent = true, desc = 'close win around k' },
      { '<leader>xl',         function() require('buffernew').close_win_around('l') end,     mode = { 'n', 'v' }, silent = true, desc = 'close win around l' },

      ------------------------
      -- fontsize.lua
      ------------------------

      { '<c-=>',              function() require('fontsize').sizeup() end,                   mode = { 'n', 'v' }, silent = true, desc = 'fontsize up' },
      { '<c-->',              function() require('fontsize').sizedown() end,                 mode = { 'n', 'v' }, silent = true, desc = 'fontsize down' },
      { '<c-0><c-0>',         function() require('fontsize').sizenormal() end,               mode = { 'n', 'v' }, silent = true, desc = 'fontsize normal' },
      { '<c-0>_',             function() require('fontsize').sizemin() end,                  mode = { 'n', 'v' }, silent = true, desc = 'fontsize min' },
      { '<c-0><c-->',         function() require('fontsize').frameless() end,                mode = { 'n', 'v' }, silent = true, desc = 'frameless' },
      { '<c-0><c-=>',         function() require('fontsize').fullscreen() end,               mode = { 'n', 'v' }, silent = true, desc = 'fullscreen' },

      ------------------------
      -- gitpushinit.lua
      ------------------------

      { '<leader>gva',        function() require('gitpushinit').addcommitpush() end,         mode = { 'n', 'v' }, silent = true, desc = 'git add all commit and push' },
      { '<leader>gvc',        function() require('gitpushinit').commitpush() end,            mode = { 'n', 'v' }, silent = true, desc = 'git commit and push' },
      { '<leader>gvvc',       function() require('gitpushinit').commit() end,                mode = { 'n', 'v' }, silent = true, desc = 'git just commit' },
      { '<leader>gvp',        function() require('gitpushinit').push() end,                  mode = { 'n', 'v' }, silent = true, desc = 'git just push' },
      { '<leader>gvg',        [[<c-u>:silent exe '!start cmd /c "git log --all --graph --decorate --oneline && pause"'<cr>]], mode = { 'n', 'v' }, silent = true, desc = 'git graph' },
      { '<leader>gvi',        function() require('gitpushinit').init() end,                  mode = { 'n', 'v' }, silent = true, desc = 'git init' },
      { '<leader>gvu',        function() require('gitpushinit').pull() end,                  mode = { 'n', 'v' }, silent = true, desc = 'git pull' },
      { '<leader>gA',         function() require('gitpushinit').addall() end,                mode = { 'n', 'v' }, silent = true, desc = 'git add -A' },

      ------------------------
      -- terminal.lua
      ------------------------

      -- toggle

      { '<leader><f1><f1>', function() require('terminal').toggle('cmd') end,                           mode = { 'n', 'v' }, silent = true, desc = 'toggle cmd' },
      { '<leader><f2><f2>', function() require('terminal').toggle('ipython') end,                       mode = { 'n', 'v' }, silent = true, desc = 'toggle ipython' },
      { '<leader><f3><f3>', function() require('terminal').toggle('bash') end,                          mode = { 'n', 'v' }, silent = true, desc = 'toggle bash' },
      { '<leader><f4><f4>', function() require('terminal').toggle('powershell') end,                    mode = { 'n', 'v' }, silent = true, desc = 'toggle powershell' },

      -- cd

      { '<leader><f1>w',    function() require('terminal').toggle('cmd',        'cwd') end,             mode = { 'n', 'v' }, silent = true, desc = 'toggle cd cwd [cmd]' },
      { '<leader><f2>w',    function() require('terminal').toggle('ipython',    'cwd') end,             mode = { 'n', 'v' }, silent = true, desc = 'toggle cd cwd [ipython]' },
      { '<leader><f3>w',    function() require('terminal').toggle('bash',       'cwd') end,             mode = { 'n', 'v' }, silent = true, desc = 'toggle cd cwd [bash]' },
      { '<leader><f4>w',    function() require('terminal').toggle('powershell', 'cwd') end,             mode = { 'n', 'v' }, silent = true, desc = 'toggle cd cwd [powershell]' },

      { '<leader><f1>.',    function() require('terminal').toggle('cmd',        '.') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd . [cmd]' },
      { '<leader><f2>.',    function() require('terminal').toggle('ipython',    '.') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd . [ipython]' },
      { '<leader><f3>.',    function() require('terminal').toggle('bash',       '.') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd . [bash]' },
      { '<leader><f4>.',    function() require('terminal').toggle('powershell', '.') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd . [powershell]' },

      { '<leader><f1>u',    function() require('terminal').toggle('cmd',        'u') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd u [cmd]' },
      { '<leader><f2>u',    function() require('terminal').toggle('ipython',    'u') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd u [ipython]' },
      { '<leader><f3>u',    function() require('terminal').toggle('bash',       'u') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd u [bash]' },
      { '<leader><f4>u',    function() require('terminal').toggle('powershell', 'u') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd u [powershell]' },

      { '<leader><f1>-',    function() require('terminal').toggle('cmd',        '-') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd - [cmd]' },
      { '<leader><f2>-',    function() require('terminal').toggle('ipython',    '-') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd - [ipython]' },
      { '<leader><f3>-',    function() require('terminal').toggle('bash',       '-') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd - [bash]' },
      { '<leader><f4>-',    function() require('terminal').toggle('powershell', '-') end,               mode = { 'n', 'v' }, silent = true, desc = 'toggle cd - [powershell]' },

      -- send and show

      { '<leader><f1>s.',   function() require('terminal').send('cmd',        'curline',   'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline show [cmd]' },
      { '<leader><f2>s.',   function() require('terminal').send('ipython',    'curline',   'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline show [ipython]' },
      { '<leader><f3>s.',   function() require('terminal').send('bash',       'curline',   'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline show [bash]' },
      { '<leader><f4>s.',   function() require('terminal').send('powershell', 'curline',   'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline show [powershell]' },

      { '<leader><f1>sp',   function() require('terminal').send('cmd',        'paragraph', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph show [cmd]' },
      { '<leader><f2>sp',   function() require('terminal').send('ipython',    'paragraph', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph show [ipython]' },
      { '<leader><f3>sp',   function() require('terminal').send('bash',       'paragraph', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph show [bash]' },
      { '<leader><f4>sp',   function() require('terminal').send('powershell', 'paragraph', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph show [powershell]' },

      { '<leader><f1>sc',   function() require('terminal').send('cmd',        'clipboard', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard show [cmd]' },
      { '<leader><f2>sc',   function() require('terminal').send('ipython',    'clipboard', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard show [ipython]' },
      { '<leader><f3>sc',   function() require('terminal').send('bash',       'clipboard', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard show [bash]' },
      { '<leader><f4>sc',   function() require('terminal').send('powershell', 'clipboard', 'show') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard show [powershell]' },

      -- send and hide

      { '<leader><f1>S.',   function() require('terminal').send('cmd',        'curline',   'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline hide [cmd]' },
      { '<leader><f2>S.',   function() require('terminal').send('ipython',    'curline',   'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline hide [ipython]' },
      { '<leader><f3>S.',   function() require('terminal').send('bash',       'curline',   'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline hide [bash]' },
      { '<leader><f4>S.',   function() require('terminal').send('powershell', 'curline',   'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send curline hide [powershell]' },

      { '<leader><f1>Sp',   function() require('terminal').send('cmd',        'paragraph', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph hide [cmd]' },
      { '<leader><f2>Sp',   function() require('terminal').send('ipython',    'paragraph', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph hide [ipython]' },
      { '<leader><f3>Sp',   function() require('terminal').send('bash',       'paragraph', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph hide [bash]' },
      { '<leader><f4>Sp',   function() require('terminal').send('powershell', 'paragraph', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send paragraph hide [powershell]' },

      { '<leader><f1>Sc',   function() require('terminal').send('cmd',        'clipboard', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard hide [cmd]' },
      { '<leader><f2>Sc',   function() require('terminal').send('ipython',    'clipboard', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard hide [ipython]' },
      { '<leader><f3>Sc',   function() require('terminal').send('bash',       'clipboard', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard hide [bash]' },
      { '<leader><f4>Sc',   function() require('terminal').send('powershell', 'clipboard', 'hide') end, mode = { 'n', 'v' }, silent = true, desc = 'send clipboard hide [powershell]' },

      -- hideall

      { '<leader><f5>',     function() require('terminal').hideall()                               end, mode = { 'n', 'v' }, silent = true, desc = 'terminal hide all' },

      ------------------------
      -- multihili.lua
      ------------------------

      -- multiline hili

      { '*',                function() require('multihili').search() end,          mode = { 'v' },      silent = true, desc = 'multiline search' },

      -- windo cursorword

      { '<a-7>',            function() require('multihili').cursorword() end,      mode = { 'n' },      silent = true, desc = 'cursor word' },
      { '<a-8>',            function() require('multihili').windocursorword() end, mode = { 'n' },      silent = true, desc = 'windo cursor word' },

      -- cword hili

      { '<c-8>',            function() require('multihili').hili_n() end,          mode = { 'n', },     silent = true, desc = 'hili cword' },
      { '<c-8>',            function() require('multihili').hili_v() end,          mode = { 'v', },     silent = true, desc = 'hili cword' },

      -- cword hili rm

      { '<c-s-8>',          function() require('multihili').rmhili_v() end,        mode = { 'v', },     silent = true, desc = 'rm hili v' },
      { '<c-s-8>',          function() require('multihili').rmhili_n() end,        mode = { 'n', },     silent = true, desc = 'rm hili n' },

      -- select hili

      { '<c-7>',            function() require('multihili').selnexthili() end,     mode = { 'n', 'v', }, silent = true, desc = 'sel next hili' },
      { '<c-s-7>',          function() require('multihili').selprevhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'sel prev hili' },

      -- go hili

      { '<c-n>',            function() require('multihili').prevhili() end,        mode = { 'n', 'v', }, silent = true, desc = 'go prev hili' },
      { '<c-m>',            function() require('multihili').nexthili() end,        mode = { 'n', 'v', }, silent = true, desc = 'go next hili' },

      -- go cur hili

      { '<c-s-n>',          function() require('multihili').prevcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'go cur prev hili' },
      { '<c-s-m>',          function() require('multihili').nextcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'go cur next hili' },

      ------------------------
      -- config.lua
      ------------------------

      -- nvim_config

      { '<a-s-f12>',        function() require('config').nvim_config() end, mode = { 'n', 'v', }, silent = true, desc = 'open nvim_config' },

      ------------------------
      -- session.lua
      ------------------------

      -- last all
      { '<leader>bi',       function() require('session').save() end,            mode = { 'n', 'v', }, silent = true, desc = 'save session' },
      { '<leader>bo',       function() require('session').open_last_all() end,   mode = { 'n', 'v', }, silent = true, desc = 'open session: last all' },
      { '<leader>bu',       function() require('session').open_branches() end,   mode = { 'n', 'v', }, silent = true, desc = 'open session: branches' },
      { '<leader>bI',       function() require('session').delete_branches() end, mode = { 'n', 'v', }, silent = true, desc = 'del session: branches' },

      ------------------------
      -- oftenfiles.lua
      ------------------------

      -- open
      { '<leader>bf',       function() require('oftenfiles').open() end, mode = { 'n', 'v', }, silent = true, desc = 'oftenfiles open' },

      ------------------------
      -- bcomp.lua
      ------------------------

      -- open
      { '<leader>b<tab>',   function() require('bcomp').diff1() end, mode = { 'n', 'v', }, silent = true, desc = 'diff1' },
      { '<leader>b`',   function() require('bcomp').diff2() end, mode = { 'n', 'v', }, silent = true, desc = 'diff2' },

    },
  },
}
