return {
  'lewis6991/gitsigns.nvim',
  commit = '79127db3b127f5d125f35e0d44ba60715edf2842',
  event = { 'BufReadPre', 'BufNewFile', },
  keys = {
    '<leader>g',

    { 'ig',           ':<C-U>Gitsigns select_hunk<CR>',                                     mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },
    { 'ag',           ':<C-U>Gitsigns select_hunk<CR>',                                     mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },

    { '<leader>j',    desc = 'Gitsigns next_hunk', },
    { '<leader>k',    desc = 'Gitsigns prev_hunk', },

    { '<leader>gd',   function() require 'config.gitsigns'.diffthis() end,                  mode = { 'n', },      silent = true, desc = 'Gitsigns diffthis', },
    { '<leader>gmd',  function() require 'config.gitsigns'.diffthis_l() end,                mode = { 'n', },      silent = true, desc = 'Gitsigns diffthis ~', },
    { '<leader>gr',   function() require 'config.gitsigns'.reset_hunk() end,                mode = { 'v', },      silent = true, desc = 'Gitsigns reset_hunk', },
    { '<leader>gr',   function() require 'config.gitsigns'.reset_hunk_v() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns reset_hunk visual', },
    { '<leader>gmr',  function() require 'config.gitsigns'.reset_buffer() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns reset_buffer', },
    { '<leader>gs',   function() require 'config.gitsigns'.stage_hunk() end,                mode = { 'n', },      silent = true, desc = 'Gitsigns stage_hunk', },
    { '<leader>gs',   function() require 'config.gitsigns'.stage_hunk_v() end,              mode = { 'v', },      silent = true, desc = 'Gitsigns stage_hunk visual', },
    { '<leader>gms',  function() require 'config.gitsigns'.stage_buffer() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns stage_buffer', },
    { '<leader>gu',   function() require 'config.gitsigns'.undo_stage_hunk() end,           mode = { 'n', },      silent = true, desc = 'Gitsigns undo_stage_hunk', },
    { '<leader>gmb',  function() require 'config.gitsigns'.blame_line() end,                mode = { 'n', },      silent = true, desc = 'Gitsigns blame_line', },
    { '<leader>gmp',  function() require 'config.gitsigns'.preview_hunk() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns preview_hunk', },
    { '<leader>gmtb', function() require 'config.gitsigns'.toggle_current_line_blame() end, mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_current_line_blame', },
    { '<leader>gmtd', function() require 'config.gitsigns'.toggle_deleted() end,            mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_deleted', },
    { '<leader>gmtl', function() require 'config.gitsigns'.toggle_linehl() end,             mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_linehl', },
    { '<leader>gmtn', function() require 'config.gitsigns'.toggle_numhl() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_numhl', },
    { '<leader>gmts', function() require 'config.gitsigns'.toggle_signs() end,              mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_signs', },
    { '<leader>gmtw', function() require 'config.gitsigns'.toggle_word_diff() end,          mode = { 'n', },      silent = true, desc = 'Gitsigns toggle_word_diff', },
  },
  lazy = true,
  dependencies = {
    require 'plugins.whichkey',
  },
  init = function()
    require 'config.whichkey'.add { ['<leader>g'] = { name = 'Git', }, }
    require 'config.whichkey'.add { ['<leader>gm'] = { name = 'Gitsigns', }, }
    require 'config.whichkey'.add { ['<leader>gmt'] = { name = 'Gitsigns Toggle', }, }
  end,
  config = function()
    require 'config.gitsigns'
  end,
}
