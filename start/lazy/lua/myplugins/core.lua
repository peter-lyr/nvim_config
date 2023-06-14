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

      '<leader>wp',

      '<leader>wk',
      '<leader>wj',
      '<leader>wh',
      '<leader>wl',

      '<leader>wo',
      '<leader>wu',
      '<leader>wi',

      '<leader><leader>wi',
      '<leader><leader>wo',

      '<leader><leader>wh',
      '<leader><leader>wj',
      '<leader><leader>wk',
      '<leader><leader>wl',
    },
  },
}
