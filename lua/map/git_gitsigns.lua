local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map_n('<leader>gd', 'diffthis', {})
B.map_n('<leader>gmd', 'diffthis_l', {})
B.map_n('<leader>gr', 'reset_hunk', {})
B.map_v('<leader>gr', 'reset_hunk_v', {})
B.map_n('<leader>gmr', 'reset_buffer', {})
B.map_n('<leader>gs', 'stage_hunk', {})
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
  numhl         = true,
  linehl        = false,
  word_diff     = true,

  signs         = {
    add = { text = '+', },
    change = { text = '~', },
    delete = { text = '_', },
    topdelete = { text = '‾', },
    changedelete = { text = '', },
    untracked = { text = '?', },
  },
  sign_priority = 100,
}

return M
