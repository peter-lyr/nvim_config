local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'maps',
  dir = opt .. 'maps',
  lazy = true,
  event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
  keys = {

    -- record
    { 'q',                   '<cmd>WhichKey q<cr>',                                             mode = { 'n', 'v', }, silent = true,  desc = 'nop', },
    { 'Q',                   'q',                                                               mode = { 'n', 'v', }, silent = true,  desc = 'record', },

    -- source
    { '<leader>s.',          '<cmd>if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>', mode = { 'n', 'v', }, silent = true,  desc = 'source vim or lua', },

    -- undo
    { 'U',                   '<c-r>',                                                           mode = { 'n', },      silent = true,  desc = 'redo', },

    -- go cmdline
    { '<leader>;',           ':',                                                               mode = { 'n', 'v', }, silent = false, desc = 'go cmdline', },

    -- scroll horizontally
    { '<S-ScrollWheelDown>', '10zl',                                                            mode = { 'n', 'v', }, silent = false, desc = 'scroll right horizontally', },
    { '<S-ScrollWheelUp>',   '10zh',                                                            mode = { 'n', 'v', }, silent = false, desc = 'scroll left horizontally', },

    -- f5
    { '<f5>',                '<cmd>e!<cr>',                                                     mode = { 'n', 'v', }, silent = true,  desc = 'e!', },

    -- cursor
    { '<c-j>',               '5j',                                                              mode = { 'n', 'v', }, silent = true,  desc = '5j', },
    { '<c-k>',               '5k',                                                              mode = { 'n', 'v', }, silent = true,  desc = '5k', },

    -- copy_paste
    { '<a-y>',               '"+y',                                                             mode = { 'v', },      silent = true,  desc = '"+y', },
    { 'yii',                 '"+yi',                                                            mode = { 'n', },      silent = true,  desc = '"+yi', },
    { 'yaa',                 '"+ya',                                                            mode = { 'n', },      silent = true,  desc = '"+ya', },
    { '<a-d>',               '"+d',                                                             mode = { 'v', },      silent = true,  desc = '"+d', },
    { 'dii',                 '"+di',                                                            mode = { 'n', },      silent = true,  desc = '"+di', },
    { 'daa',                 '"+da',                                                            mode = { 'n', },      silent = true,  desc = '"+da', },
    { '<a-c>',               '"+c',                                                             mode = { 'v', },      silent = true,  desc = '"+c', },
    { 'cii',                 '"+ci',                                                            mode = { 'n', },      silent = true,  desc = '"+ci', },
    { 'caa',                 '"+ca',                                                            mode = { 'n', },      silent = true,  desc = '"+ca', },
    { '<a-p>',               '"+p',                                                             mode = { 'n', 'v', }, silent = true,  desc = '"+p', },
    { '<a-s-p>',             '"+P',                                                             mode = { 'n', 'v', }, silent = true,  desc = '"+P', },

  },
}
