local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map_n('gd', 'diffthis', {})
B.map_n('<leader>gd', 'diffthis', {})

B.map_n('<leader>gmd', 'diffthis_l', {})

B.map_n('gr', 'reset_hunk', {})
B.map_n('<leader>gr', 'reset_hunk', {})
B.map_v('gr', 'reset_hunk_v', {})
B.map_v('<leader>gr', 'reset_hunk_v', {})
B.map_n('<leader>gmr', 'reset_buffer', {})

B.map_n('gs', 'stage_hunk', {})
B.map_n('<leader>gs', 'stage_hunk', {})
B.map_v('gs', 'stage_hunk_v', {})
B.map_v('<leader>gs', 'stage_hunk_v', {})

B.map_n('<leader>gms', 'stage_buffer', {})
B.map_n('<leader>gu', 'undo_stage_hunk', {})
B.map_n('<leader>gmb', 'blame_line', {})
B.map_n('<leader>gmp', 'preview_hunk', {})

B.map_n('<leader>gmtb', 'toggle_current_line_blame', {})
B.map_n('<leader>gmtd', 'toggle_deleted', {})
B.map_n('<leader>gmtl', 'toggle_linehl', {})
B.map_n('<leader>gmtn', 'toggle_numhl', {})
B.map_n('<leader>gmts', 'toggle_signs', {})
B.map_n('<leader>gmtw', 'toggle_word_diff', {})

B.map_n('gl', 'lazygit', {})
B.map_n('<leader>gl', 'lazygit', {})

------

B.register_whichkey('<leader>gm', 'more')
B.register_whichkey('<leader>gmt', 'Toggle')

B.merge_whichkeys()

-------------------

vim.keymap.set('n', '<leader>j', function()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns next_hunk', })

vim.keymap.set('n', '<leader>k', function()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns prev_hunk', })

require 'gitsigns'.setup {
  signs                        = {
    add = { text = '+', },
    change = { text = '~', },
    delete = { text = '_', },
    topdelete = { text = '‾', },
    changedelete = { text = '', },
    untracked = { text = '?', },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true,
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 100,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  yadm                         = {
    enable = false,
  },
}

return M
